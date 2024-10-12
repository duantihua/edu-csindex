[#ftl]
[#include "head.ftl"/]

<body>
  <div class="wrapper">

    [#include "nav.ftl"/]

        <div class="con_area m_t_30">
          <div class="border p_lr_30 p_t_5 p_b_25" style="background:url(${b.static_url('local','edu-course-indexapp/images/slogan-bg.jpg')}) #fff right top no-repeat;">
                <div class="title_con"><span class="title_text"><i class="quan"></i>查询结果</span></div>
            <table class="kc_table">
              <thead>
              <tr>
                <th>课程代码</th>
                <th>课程名称</th>
                <th>开课院系</th>
                <th>学分</th>
                <th>学时</th>
                <th>课程类别</th>
                <th>修订人</th>
              </tr>
              </thead>
              <tbody>
              [#list profiles as profile]
                <tr>
                  <td width="10%" >${(profile.course.code)!}</td>
                  <td width="40%" >
                      [@b.a href="index!detail?id=${profile.id}" target="_blank"]
                        <span style="text-decoration:underline;">${profile.course.name}</span>
                      [/@]
                  </td>
                  <td width="15%" >${(profile.course.department.name)!}</td>
                  <td width="5%" >${(profile.course.defaultCredits)!}</td>
                  <td width="5%" >${(profile.course.creditHours)!}</td>
                  <td width="15%" >${(profile.category.name)!}</td>
                  <td width="10%" >
                      ${(profile.writer.name)!}
                  </td>
                </tr>
              [/#list]
              </tbody>
            </table>
            [#if profiles?size>0]
              [#assign param = "&nameOrCode=${Parameters['nameOrCode']!}"]
              [#assign pageIndex = profiles.pageIndex]
              [#assign totalPages = profiles.totalPages]
              [#if pageIndex-2>0]
                [#assign start = pageIndex-2]
              [#else]
                [#assign start = pageIndex]
              [/#if]

              [#if pageIndex+2 < totalPages]
                [#assign end = pageIndex+2]
              [#else]
                [#assign end = totalPages]
              [/#if]
              <div class="text_center m_t_20">
                <div class="page">
                  <ul class="clearfix">
                    <li>
                      [@b.a href="!searchByName?pageIndex=1&pageSize=25"+param target="courseProfileList"]
                        <span aria-hidden="true">首页</span>
                      [/@]
                    </li>
                    [#if pageIndex>1]
                      <li>
                        [@b.a href="!searchByName?pageIndex=${pageIndex-1}&pageSize=25"+param target="courseProfileList"]
                          <span aria-hidden="true">上一页</span>
                        [/@]
                      </li>
                    [/#if]
                    [#list start..end as i]
                      <li>[@b.a href="!searchByName?pageIndex=${i}&pageSize=25"+param  target="courseProfileList"]${i}[/@]</li>
                    [/#list]
                    [#if pageIndex!=totalPages]
                      <li>
                        [@b.a href="!searchByName?pageIndex=${pageIndex+1}&pageSize=25"+param  target="courseProfileList"]
                          <span aria-hidden="true">下一页</span>
                        [/@]
                      </li>
                    [/#if]
                    <li>
                      [@b.a href="!searchByName?pageIndex=${totalPages}&pageSize=25"+param target="courseProfileList"]
                        <span aria-hidden="true">尾页</span>
                      [/@]
                    </li>
                  </ul>
                </div>
              </div>
            [/#if]
            </div>
        </div>
    <div class="tk_box"/>
    [#include "foot.ftl"/]
    </div>


<script>
  $(".kc_table tbody tr:odd").css({"background":"#eeebea"});
</script>
[@b.foot/]
