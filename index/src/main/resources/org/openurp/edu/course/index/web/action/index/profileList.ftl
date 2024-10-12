[#ftl]
<div class="title_con m_t_30"><span class="title_text"><i class="quan"></i>历史课程资料</span></div>
<div class=" bg_white m_t_20 p_lr_30">
  <table class="kc_table">
    <thead>
    <tr>
      <th>修订学期</th>
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
    [#list hisProfiles?sort_by('beginOn')?reverse as profile]
      <tr>
        <td width="15%" >${profile.semester.schoolYear}学年${profile.semester.name}学期</td>
        <td width="10%" >${(profile.course.code)!}</td>
        <td width="30%" >
            [@b.a href="index!detail?id=${profile.id!}" target="_blank"]
              ${profile.course.name}
            [/@]
        </td>
        <td width="15%" >${(profile.department.name)!}</td>
        <td width="5%" >${(profile.course.defaultCredits)!}</td>
        <td width="5%" >${(profile.course.creditHours)!}</td>
        <td width="10%" >${(profile.category.name)!}</td>
        <td width="10%" >${(profile.writer.name)!}</td>
      </tr>
    [/#list]
    </tbody>
  </table>
</div>
