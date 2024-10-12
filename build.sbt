import org.openurp.parent.Dependencies.*
import org.openurp.parent.Settings.*

ThisBuild / organization := "org.openurp.edu.course"
ThisBuild / version := "0.1.0"

ThisBuild / scmInfo := Some(
  ScmInfo(
    url("https://github.com/openurp/edu-curricula"),
    "scm:git@github.com:openurp/edu-curricula.git"
  )
)

ThisBuild / developers := List(
  Developer(
    id = "chaostone",
    name = "Tihua Duan",
    email = "duantihua@gmail.com",
    url = url("http://github.com/duantihua")
  )
)

ThisBuild / description := "OpenURP Edu Curricula"
ThisBuild / homepage := Some(url("http://openurp.github.io/edu-curricula/index.html"))

val apiVer = "0.41.9"
val starterVer = "0.3.43"
val baseVer = "0.4.41"
val eduCoreVer = "0.3.3"

val openurp_edu_api = "org.openurp.edu" % "openurp-edu-api" % apiVer
val openurp_stater_web = "org.openurp.starter" % "openurp-starter-web" % starterVer
val openurp_stater_ws = "org.openurp.starter" % "openurp-starter-ws" % starterVer
val openurp_base_tag = "org.openurp.base" % "openurp-base-tag" % baseVer
val openurp_edu_core = "org.openurp.edu" % "openurp-edu-core" % eduCoreVer
lazy val root = (project in file("."))
  .settings()
  .aggregate( static, index)

lazy val static = (project in file("static"))
  .settings(
    name := "openurp-edu-course-static",
    common
  )

lazy val index = (project in file("index"))
  .enablePlugins(WarPlugin, UndertowPlugin, TomcatPlugin)
  .settings(
    name := "openurp-edu-course-indexapp",
    common,
    libraryDependencies ++= Seq(openurp_stater_web, openurp_edu_core)
  )

publish / skip := true
