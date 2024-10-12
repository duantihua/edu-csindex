/*
 * Copyright (C) 2014, The OpenURP Software.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package org.openurp.edu.course.index.web.action

import org.beangle.commons.bean.Initializing
import org.beangle.commons.collection.Collections
import org.beangle.commons.collection.page.PageLimit
import org.beangle.commons.lang.{Locales, Numbers}
import org.beangle.data.dao.{EntityDao, OqlBuilder}
import org.beangle.data.model.Entity
import org.beangle.data.model.util.Hierarchicals
import org.beangle.ems.app.{Ems, EmsApp}
import org.beangle.security.realm.cas.CasConfig
import org.beangle.web.action.annotation.param
import org.beangle.web.action.support.{ActionSupport, ServletSupport}
import org.beangle.web.action.view.{Status, View}
import org.beangle.webmvc.support.helper.QueryHelper
import org.openurp.base.edu.model.{CourseAward, CourseProfile}
import org.openurp.base.model.{Department, Project}
import org.openurp.code.Code
import org.openurp.code.edu.model.{CourseAwardCategory, CourseAwardType, CourseCategory, CourseCategoryDimension}
import org.openurp.edu.course.index.web.helper.Transform
import org.openurp.edu.course.model.SyllabusDoc

import java.time.LocalDate

class IndexAction extends ActionSupport, ServletSupport, Initializing {

  var dimension: CourseCategoryDimension = _
  var entityDao: EntityDao = _
  var casConfig: CasConfig = _

  override def init(): Unit = {
    dimension = entityDao.getAll(classOf[CourseCategoryDimension]).find(_.name.contains("信息网")).head
  }

  def nav(): Unit = {
    val school = getProject.school
    val departBuilder = OqlBuilder.from(classOf[Department], "department")
    departBuilder.where("department.school=:school", school)
    departBuilder.where("department.endOn is null")
    departBuilder.where("department.teaching is true")
    departBuilder.orderBy("department.code")
    val departments = entityDao.search(departBuilder.cacheable())
    put("departments", departments)
    put("firstDepartment", departments.head)
    put("awardCategories", getCodes(classOf[CourseAwardCategory]))
    put("school", school)
  }

  def index(): View = {
    nav()
    put("portal", Ems.portal)
    put("Ems", Ems)
    put("casConfig", casConfig)
    // 没有父类的分组
    var courseGroups = Collections.newBuffer[CourseCategory]
    val folderBuilder = OqlBuilder.from(classOf[CourseCategory], "c")
    folderBuilder.where("c.dimension = :dimension", dimension)
    folderBuilder.orderBy("c.indexno")
    folderBuilder.cacheable()
    val rs = entityDao.search(folderBuilder)
    rs.foreach(courseGroup => {
      if (courseGroup.parent.isEmpty) {
        courseGroups += courseGroup
      }
    })
    put("courseGroups", courseGroups)
    forward()
  }

  def search(): View = {
    try {
      val profiles = entityDao.search(getQueryBuilder)
      put("profiles", profiles)
      forward()
    } catch {
      case e: Exception =>
        logger.info("无效字符", e)
        redirect("index", null)
    }
  }

  def getQueryBuilder: OqlBuilder[CourseProfile] = {
    val metaBuilder = OqlBuilder.from(classOf[CourseProfile], "p")
    get("nameOrCode").foreach(nameOrCode => {
      metaBuilder.where("(p.course.name like :name or p.course.code like :code)", s"%$nameOrCode%", s"%$nameOrCode%")
    })
    metaBuilder.where(s"not exists(from ${classOf[CourseProfile].getName} as p2 where p2.course=p.course and p2.beginOn > p.beginOn)")

    val first = getInt("courseGroup")
    val second = getInt("courseGroup_child")
    val third = getInt("courseGroup_child_child")
    val groups = Collections.newSet[CourseCategory]
    if (third != None && third != null) {
      groups ++= getCourseGroups(third.get)
    } else if (second != None && second != null) {
      groups ++= getCourseGroups(second.get)
    } else if (first != None && first != null) {
      groups ++= getCourseGroups(first.get)
    }
    if (groups.nonEmpty) {
      metaBuilder.where("p.category in :groups", groups)
    }
    get("courseProfile.course.department.id").foreach {
      case "0" => metaBuilder.where("p.course.department.teaching is false ")
      case "" =>
      case depart =>
        val departId = if (Numbers.isDigits(depart)) depart.toInt else 0
        metaBuilder.where("p.course.department.id=:id", departId)
    }
    metaBuilder.limit(QueryHelper.pageLimit)
    metaBuilder.orderBy("p.course.code")
  }

  def getCourseGroups(id: Int): Set[CourseCategory] = {
    Hierarchicals.getFamily(entityDao.get(classOf[CourseCategory], id))
  }

  def info(@param("id") id: String): View = {
    if (!Numbers.isDigits(id)) return Status.NotFound
    try {
      val profile = entityDao.get(classOf[CourseProfile], id.toLong)
      put("profile", profile)
      put("Transform", Transform)
      forward()
    } catch {
      case e: Exception =>
        logger.info("无效字符", e)
        redirect("index", null)
    }
  }

  def detail(@param("id") id: String): View = {
    if (!Numbers.isDigits(id)) return Status.NotFound
    nav()
    val blobQuery = OqlBuilder.from(classOf[CourseProfile], "cb").where("cb.id=:id", id.toLong).cacheable()
    val profile = entityDao.search(blobQuery).head
    put("courseProfile", profile)

    val q = OqlBuilder.from(classOf[CourseProfile], "profile")
    q.where("profile.course=:course", profile.course)
    q.where("profile.beginOn < :beginOn", profile.beginOn)
    q.cacheable()
    put("hisProfiles", entityDao.search(q))

    val syllabusDocQuery = OqlBuilder.from(classOf[SyllabusDoc], "doc")
    syllabusDocQuery.where("doc.course=:course and doc.semester=:semester", profile.course, profile.semester)
    syllabusDocQuery.cacheable()
    put("syllabusDocs", entityDao.search(syllabusDocQuery))
    put("locales", Map(Locales.chinese -> "中文", Locales.us -> "English"))

    val awardQuery = OqlBuilder.from(classOf[CourseAward], "award")
    awardQuery.where("award.course=:course", profile.course)
    awardQuery.where("award.schoolYear <= :year", profile.semester.endOn.getYear)
    awardQuery.cacheable()
    put("awards", entityDao.search(awardQuery))
    forward()
  }

  /* 院系页 */
  def searchByDepart(@param("id") id: String): View = {
    if (!Numbers.isDigits(id)) return Status.NotFound
    val departId = id.toInt
    nav()
    if (departId != 0) {
      try {
        put("choosedDepartment", entityDao.get(classOf[Department], departId))
      } catch {
        case e: Exception =>
      }
    }
    val metaBuilder = OqlBuilder.from(classOf[CourseProfile], "profile")
    metaBuilder.where(s"not exists(from ${classOf[CourseProfile].getName} as p2 where p2.course=profile.course and p2.beginOn > profile.beginOn)")
    metaBuilder.where("profile.category is not null")
    metaBuilder.orderBy("profile.course.code")
    metaBuilder.cacheable()
    id match {
      case "0" => metaBuilder.where("profile.course.department.teaching is false")
      case _ =>
        try {
          metaBuilder.where("profile.course.department.id=:id", departId)
        } catch {
          case e: Exception => metaBuilder.where("profile.course.department.teaching is false")
        }
    }
    val profiles = entityDao.search(metaBuilder)
    val metaMap = profiles.groupBy(_.category.get)
    put("metaMap", metaMap)
    val courseGroups = getCodes(classOf[CourseCategory]).filter(_.dimension == dimension)
    val rootMap = courseGroups.map(x => (x, getRoot(x))).toMap
    val roots = courseGroups.filter(a => a.parent.isEmpty)
    put("roots", roots)
    put("rootMap", rootMap)
    forward()
  }

  def getRoot(courseGroup: CourseCategory): CourseCategory = {
    if (courseGroup.parent.nonEmpty) {
      getRoot(courseGroup.parent.get)
    } else courseGroup
  }

  /*
  课策类别页面
   */
  def searchByCategory(): View = {
    nav()
    // 没有父类的分组
    var courseGroups = Collections.newBuffer[CourseCategory]
    val folderBuilder = OqlBuilder.from(classOf[CourseCategory], "category")
    folderBuilder.where("category.dimension = :dimension", dimension)
    folderBuilder.orderBy("category.indexno")
    val rs = entityDao.search(folderBuilder)
    rs.foreach(courseGroup => {
      if (courseGroup.parent.isEmpty) {
        courseGroups += courseGroup
      }
    })
    put("courseGroups", courseGroups)
    forward()
  }

  /*
  代码名称查询界面
   */
  def searchByName(): View = {
    nav()
    val profiles = entityDao.search(getQueryBuilder)
    put("profiles", profiles)
    forward()
  }

  /*
  获奖分类页
   */
  def awards(): View = {
    nav()
    val metaBuilder = OqlBuilder.from(classOf[CourseProfile], "profile")
    metaBuilder.where(s"not exists(from ${classOf[CourseProfile].getName} as p2 where p2.course=profile.course and p2.beginOn > profile.beginOn)")
    getInt("categoryId").foreach { categoryId =>
      metaBuilder.where(s"exists(from ${classOf[CourseAward].getName} a where a.awardType.category.id = :categoryId and a.course=profile.course)", categoryId)
      put("categoryId", categoryId)
      put("category", entityDao.get(classOf[CourseAwardCategory], categoryId))
      val awardTypes = entityDao.findBy(classOf[CourseAwardType], "category.id", List(categoryId))
      put("awardTypes", awardTypes)
    }
    getInt("typeId").foreach { typeId =>
      val choosedAwardType = entityDao.get(classOf[CourseAwardType], typeId)
      put("choosedAwardType", choosedAwardType)
      metaBuilder.where(s"exists(from ${classOf[CourseAward].getName} a where a.awardType.id=:labelId and a.course=profile.course)", typeId)
      val categoryId = choosedAwardType.category.id
      put("categoryId", categoryId)
      put("category", choosedAwardType.category)
      val awardTypes = entityDao.findBy(classOf[CourseAwardType], "category", choosedAwardType.category)
      put("awardTypes", awardTypes)
    }
    metaBuilder.limit(PageLimit(1, 25))
    put("profiles", entityDao.search(metaBuilder))
    forward()
  }

  def awardMap(): View = {
    nav()
    val awardMap = Collections.newMap[CourseAwardCategory, Seq[CourseProfile]]
    val awardCategories = getCodes(classOf[CourseAwardCategory])
    val metaBuilder = OqlBuilder.from(classOf[CourseProfile], "profile")
    metaBuilder.where(s"not exists(from ${classOf[CourseProfile].getName} as p2 where p2.course=profile.course and p2.beginOn > profile.beginOn)")
    awardCategories.foreach(c => {
      metaBuilder.where(s"exists(from ${classOf[CourseAward].getName} a where a.awardType.category=:category and a.course=profile.course)", c)
      val profiles = entityDao.search(metaBuilder)
      awardMap.put(c, profiles)
    })
    put("awardMap", awardMap)
    forward()
  }

  def getDatas[T <: Entity[_]](clazz: Class[T], profile: CourseProfile): Seq[T] = {
    val builder = OqlBuilder.from(clazz, "aa")
    builder.where("aa.course=:course", profile.course)
    builder.cacheable()
    entityDao.search(builder)
  }

  def childrenAjax(): View = {
    getInt("courseGroupId").foreach(courseGroupId => {
      val courseGroup = entityDao.get(classOf[CourseCategory], courseGroupId)
      val courseGroupChildren = courseGroup.children
      put("courseGroups", courseGroupChildren)
    })
    forward("childrenJSON")
  }

  def getProject: Project = {
    val builder = OqlBuilder.from(classOf[Project], "project")
    builder.where("project.endOn is null")
    builder.cacheable()
    val projects = entityDao.search(builder)
    if (projects.isEmpty) {
      null
    } else {
      projects.head
    }
  }

  def getCodes[T](clazz: Class[T]): Seq[T] = {
    val query = OqlBuilder.from(clazz, "c")
    if (classOf[Code].isAssignableFrom(clazz)) {
      query.where("c.endOn is null or :now between c.beginOn and c.endOn", LocalDate.now)
    }
    query.cacheable()
    entityDao.search(query)
  }

  def notice(@param("id") id: String): View = {
    nav()
    put("Ems", Ems)
    put("id", id)
    forward()
  }

  def notices(): View = {
    nav()
    put("Ems", Ems)
    forward()
  }

  def viewSyllabus(@param("id") id: Long): View = {
    val doc = entityDao.get(classOf[SyllabusDoc], id)
    put("syllabus", doc)
    val path = EmsApp.getBlobRepository(true).path(doc.docPath)
    put("url", path.get)
    forward()
  }
}
