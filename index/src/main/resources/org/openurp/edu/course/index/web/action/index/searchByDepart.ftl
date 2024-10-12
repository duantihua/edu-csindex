[#ftl]
[#include "head.ftl"/]
<div class="wrapper">
<style>
  .yx_bt_kc{ width: 700px;}
  .color_sm{ background:#fdf9f8; padding:20px; margin-top:10px; font-size:14px;}
  .color_sm ul li{ float:right; position:relative; margin-left:50px; color:#666; cursor:pointer;}
  .color_sm ul li .sk{ height:8px ; width:8px; display:inline-block; margin-right:5px; vertical-align:middle;}
</style>

  [#include "nav.ftl"/]

  <div class="con_area m_t_30">
    <div class="clearfix">
      <div class="left_yx fl">
        <div class="left_title" style="background: url(${b.static_url('local','edu-course-indexapp/images/lnav_tbg.png')}) no-repeat;">院系</div>
        <div class="yx_nav">
          <ul>
            [#list departments as department]
              <li [#if choosedDepartment?? && choosedDepartment==department]class="yx_navon bold"[/#if]>
                [@b.a href="!searchByDepart?id="+department.id]${department.name}[/@b.a]
              </li>
            [/#list]
            <li [#if !choosedDepartment??]class="yx_navon bold"[/#if]>
              [@b.a href="!searchByDepart?id=0"]其他[/@b.a]
            </li>
          </ul>
        </div>
      </div>
      <div class="right_yxcon fr bg_white">
        <div class="title_con"><span class="title_text"><i class="quan"></i>${(choosedDepartment.name)?default("其他")}</span></div>
        <div class="color_sm">
          <ul class="clearfix">
            [#list roots?sort_by("indexno")?reverse as root]
              [#if root.color??]
                <li><span class="sk" style="background: ${root.color!}"></span>${root.name!}</li>
              [/#if]
            [/#list]
          </ul>
        </div>

        <div class="yxb_con">
          [#list metaMap?keys?sort_by("indexno") as courseGroup]
            <div class="yxb_list" style="background: ${(rootMap.get(courseGroup).color)!}">
              <div class="yxb_title" >${courseGroup.name}</div>
              <ul class="yxb_item">
                [#list metaMap.get(courseGroup)! as profile]
                  <li>
                      [@b.a href="index!detail?id=${profile.id}" target="_blank"]
                        <span style="color: #0b54b0">${profile.course.name}</span>
                      [/@]
                  </li>
                [/#list]
              </ul>
            </div>
          [/#list]
        </div>
      </div>
    </div>
  </div>

  [#include "foot.ftl"/]

</div>

[@b.foot/]
