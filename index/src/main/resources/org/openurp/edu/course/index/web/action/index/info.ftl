[#ftl/]
[@b.head/]
<div class="tk_title">${profile.course.name!} <a href="javascript:;"><span class="iconfont icon-guanbi"></span></a></div>
<div class="tk_con">
  <table class="tk_table">
    <tr>
      <td style="width:90px;"><span class="tk_table_title">课程代码：</span></td>
      <td>${profile.course.code!}</td>
    </tr>
    <tr>
      <td><span class="tk_table_title">课程名称：</span></td>
      <td>${profile.course.name!}</td>
    </tr>
    <tr>
      <td><span class="tk_table_title">中文简介：</span></td>
      <td id="description">
        [#if profile.description!="--"]
          [#if Transform.getResultsFromHtml(profile.description)?length>150]${Transform.getResultsFromHtml(profile.description)?substring(0,149)!}...
          [#else ]${Transform.getResultsFromHtml(profile.description)!}
          [/#if]
        [/#if]
      </td>
    </tr>
    <tr>
      <td><span class="tk_table_title">英文简介：</span></td>
      <td id="enDescription">
        [#if profile.enDescription!="--"]
          [#if Transform.getResultsFromHtml(profile.enDescription)?length>300]${Transform.getResultsFromHtml(profile.enDescription)?substring(0,299)!}...
          [#else ]${Transform.getResultsFromHtml(profile.enDescription)!}
          [/#if]
        [/#if]
      </td>
    </tr>
    <tr>
      <td><span class="tk_table_title">总学分：</span></td>
      <td>${(profile.course.defaultCredits)!}</td>
    </tr>
    <tr>
      <td><span class="tk_table_title">总学时：</span></td>
      <td>${(profile.course.creditHours)!}</td>
    </tr>
  </table>
  <div class="text_center">
    <a class="jrkc" href="${b.url('!detail?id='+profile.id!)}" style="box-sizing: content-box;" target="_blank">进入课程</a>
  </div>
</div>
<style>
  .tk_con{ padding:10px 10px;}
  .tk_table td{ padding:5px; line-height:18px; color:#826d4c;}
</style>
[@b.foot/]
