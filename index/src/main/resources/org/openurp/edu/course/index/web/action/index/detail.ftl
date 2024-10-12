[#ftl]
[#assign title="${courseProfile.course.name}"/]
[#include "head.ftl"/]
[#macro multi_line_p contents=""]
  [#assign cnts]${contents!}[#nested/][/#assign]
  [#if cnts?length>0]
    [#assign ps = cnts?split("\n")]
    [#list ps as p]
    <p style="white-space: preserve;" class="mb-0">${p}</p>
    [/#list]
  [/#if]
[/#macro]

  <div class="wrapper">
    [#include "nav.ftl"/]
    <div class="con_area m_t_30">
      <div class="p_lr_30 p_t_5 p_b_25" style="background:url(${b.static_url('local','edu-course-indexapp/images/slogan-bg.jpg')}) #fff right top no-repeat;">
        <div class="title_con"><span class="title_text"><i class="quan"></i>${(courseProfile.course.name)!}</span></div>
        <div class="xq_list m_t_20">
          <table style="background: none;width: 1065px">
            <tr>
              <td style="background:#faf4eb; color:#333; font-weight:bold;width:150px;">修订学期：</td>
              <td style="width: 205px" >${(courseProfile.semester.schoolYear)!}学年${(courseProfile.semester.name)!}学期</td>
              <td style="background:#faf4eb; color:#333; font-weight:bold;width:150px;">课程代码：</td>
              <td style="width: 205px">${(courseProfile.course.code)!}</td>
              <td style="background:#faf4eb; color:#333; font-weight:bold;width:150px;">开课院系：</td>
              <td style="width: 205px">${(courseProfile.department.name)!}</td>
            </tr>
            <tr>
              <td style="background:#faf4eb; color:#333; font-weight:bold;width:150px;">课程名称：</td>
              <td style="width: 205px">${(courseProfile.course.name)!}</td>
              <td style="background:#faf4eb; color:#333; font-weight:bold;width:150px;">课程英文名称：</td>
              <td style="width: 205px">${(courseProfile.course.enName)!}</td>
              <td style="background:#faf4eb; color:#333; font-weight:bold;width:150px;">修订人：</td>
              <td style="width: 205px">${(courseProfile.writer.name)!}</td>
            </tr>
            <tr>
              <td style="width: 150px">中文简介：</td>
              <td colspan="5" style="width: 915px"><div style="width: 900px">[#if courseProfile.description!="--"]${courseProfile.description!}[/#if]</div></td>
            </tr>
            <tr>
              <td style="width: 150px">英文简介：</td>
              <td colspan="5" style="width: 915px"><div style="width: 900px">[#if courseProfile.enDescription!="--"]${courseProfile.enDescription!}[/#if]</div></td>
            </tr>
            <tr>
              <td style="background:#faf4eb; color:#333; font-weight:bold;width:150px;">教学大纲：</td>
              <td colspan="5">
                [#list syllabusDocs as doc]
                    <a class="m_l_35 yulan" target="_blank" href="${b.url('!viewSyllabus?id='+doc.id)}"><span class="iconfont icon-yulan"></span>预览(${locales.get(doc.docLocale)})</a>
                [/#list]
              </td>
            </tr>
            <tr>
              <td style="width: 150px">预修课程：</td>
              <td colspan="5" style="width: 915px">[#if courseProfile.prerequisites!="--"]${courseProfile.prerequisites!}[/#if]</td>
            </tr>
            <tr>
              <td style="width: 150px">教材和参考书目：</td>
              <td colspan="5" style="width: 915px">[#if (courseProfile.textbooks!'') !="--"][@multi_line_p courseProfile.textbooks/][/#if]</td>
            </tr>
            <tr>
              <td style="width: 150px">课程网站地址：</td>
              <td colspan="5" style="width: 915px"><a href="${courseProfile.website!}" target="_blank">${courseProfile.website!}</a></td>
            </tr>
            <tr>
              <td style="width: 150px">获奖情况：</td>
              <td colspan="5" style="width: 915px">
                  [#list awards?sort_by('schoolYear') as award]
                    ${award.schoolYear}年 ${award.awardType.name} [#if award_has_next]<br>[/#if]
                  [/#list]
              </td>
            </tr>
            <tr>
              <td style="width: 150px;">备注：</td>
              <td colspan="5" style="width: 915px">${courseProfile.remark!}</td>
            </tr>
          </table>
        </div>

        [#include "profileList.ftl" /]
      </div>
    </div>
    [#include "foot.ftl"/]
  </div>

<style>
  .xq_list{ padding:0 30px;}
  .xq_list table{ border:1px solid #e1e1e1; background:#fff;}
  .xq_list table tr td{ padding:8px; color:#826d4c; line-height:24px; word-break: break-all}
  .xq_list table tr td:first-child{ background:#faf4eb; color:#333; font-weight:bold;}
  .xq_list table tr{ border-bottom:1px solid #e1e1e1;}
  .xq_list table tr td p {color: #826d4c;}
</style>
[@b.foot/]
