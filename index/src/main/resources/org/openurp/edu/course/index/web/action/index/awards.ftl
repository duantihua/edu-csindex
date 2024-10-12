[#ftl]
[#include "head.ftl"/]
<div class="wrapper">

    [#include "nav.ftl"/]

  <div class="con_area m_t_30">
    <div class="clearfix">
      <div class="left_yx fl">
        <div class="left_title" style="background: url(${b.static_url('local','edu-course-indexapp/images/lnav_tbg.png')}) no-repeat;">${category.name}</div>
        <div class="yx_nav">
          <ul>
            <li [#if !choosedAwardType??]class="yx_navon bold"[/#if]>[@b.a href="!awards?categoryId=${categoryId!}"]全部[/@b.a]</li>
              [#list awardTypes as awardType]
                <li [#if choosedAwardType?? && choosedAwardType==awardType]class="yx_navon bold"[/#if]>
                    [@b.a href="!awards?typeId="+awardType.id]${awardType.name}[/@b.a]
                </li>
              [/#list]
          </ul>
        </div>
      </div>
      <div class="right_yxcon fr bg_white">
        <div class="title_con">
          <span class="title_text"><i class="quan"></i>${(choosedAwardType.name)?default("全部")}</span>
          <a class="fanhui fr" href=""></a></div>
        <div class=" bg_white m_t_20">
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
                <td width="35%" >
                  [@b.a href="index!detail?id=${profile.id!}" target="_blank"]
                    <span style="text-decoration:underline;">${profile.course.name}</span>
                  [/@]
                </td>
                <td width="20%" >${(profile.course.department.name)!}</td>
                <td width="5%" >${(profile.course.defaultCredits)!}</td>
                <td width="5%" >${(profile.course.creditHours)!}</td>
                <td width="15%" >${(profile.category.name)!}</td>
                <td width="10%" >${(profile.writer.name)!}</td>
              </tr>
            [/#list]
            </tbody>
          </table>
          <div class="text_right m_t_20 ptn_relative">
            <div class="kcs_num">课程总数：<span>${profiles.totalItems}</span></div>

              [#if profiles?size>0]
                  [#assign param = "&categoryId=${categoryId!}&typeId=${Parameters['typeId']!}"]
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
                <div class="page">
                    <ul class="clearfix">
                      <li>
                          [@b.a href="!awards?pageIndex=1&pageSize=25"+param ]
                            <span aria-hidden="true">首页</span>
                          [/@]
                      </li>
                        [#if pageIndex>1]
                          <li>
                              [@b.a href="!awards?pageIndex=${pageIndex-1}&pageSize=25"+param ]
                                <span aria-hidden="true">«</span>
                              [/@]
                          </li>
                        [/#if]
                        [#list start..end as i]
                          <li>[@b.a href="!awards?pageIndex=${i}&pageSize=25"+param ]${i}[/@]</li>
                        [/#list]
                        [#if pageIndex!=totalPages]
                          <li>
                              [@b.a href="!awards?pageIndex=${pageIndex+1}&pageSize=25"+param]
                                <span aria-hidden="true">»</span>
                              [/@]
                          </li>
                        [/#if]
                      <li>
                          [@b.a href="!awards?pageIndex=${totalPages}&pageSize=25"+param ]
                            <span aria-hidden="true">尾页</span>
                          [/@]
                      </li>
                    </ul>
                </div>
              [/#if]
          </div>
        </div>
      </div>
    </div>
  </div>
    [#include "foot.ftl"/]

</div>

[@b.foot/]
