[#ftl]
[@b.head title="课程信息网"]
  <!-- 针对360浏览器的内核调用,强制调用极速模式 -->
  <meta name="renderer" content="webkit">
  <link rel="stylesheet" href="${b.static_url('openurp-edu-course','css/style.css')}">
  <link rel="shortcut icon" href="${b.static_url('local','icons/fav.ico')}">
[/@]

  <div class="wrapper">
    [#include "nav.ftl"/]
    <div class="con_area"><img src="${b.static_url('local','edu-course-indexapp/images/banner.jpg')}" alt="banner"></div>

    <div class="con_area m_t_20">
      <div class="clearfix">
          <div class="index_l fl">
                <div class="module_bg kclb m_t_20" style="padding: 10px 10px;margin-top: 0px;">
                  [@b.form name="courseProfileSearchForm"  action="!search?pageSize=25" target="courseProfileList" title="ui.searchForm" theme="html" ]
                     <div class="kclb_cx_tj">
                       <select  name="courseProfile.course.department.id"  style="width:230px; height:36px; border:1px solid #e1e1e1; margin-right:15px;  padding:-left:10px;">
                         <option value="">请选择课程开课院系</option>
                         [#list departments as department]
                           <option value="${(department.id)!}">${(department.name)!}</option>
                         [/#list]
                         <option value="else">其他</option>
                       </select>
                     </div>
                     <div class="kclb_list clearfix">
                      <div class="select_item">
                          <div class="select_title">请选择</div>
                            <select class="select_zk" size="4" name="courseGroup" id="courseGroupId" style="height:150px;">
                              <option value="">全部</option>
                              [#list courseGroups as courseGroup]
                                <option value="${courseGroup.id}">${courseGroup.name}</option>
                              [/#list]
                            </select>
                        </div>
                        <div class="select_item">
                          <div class="select_title">请选择</div>
                            <select class="select_zk" size="4" name="courseGroup_child"  style="height:150px;">
                            </select>
                        </div>
                        <div class="select_item">
                          <div class="select_title">请选择</div>
                            <select class="select_zk" size="4" name="courseGroup_child_child" style="height:150px;">
                            </select>
                        </div>
                     </div>
                  [/@]
                </div>
                [@b.div id="courseProfileList" style="margin-top:20px;" href="!search?pageSize=25"/]

            </div>
            <div class="index_r fr">
              [@b.form name="loginForm" action="${casConfig.loginUrl}" target="_blank" method="post"]
                <input type="hidden" name="sid_name" value="URP_SID">
                <input type="hidden" name="isService" value="1">
                <input type="hidden" name="service" value="${portal}">
                <div class="login">
                  <div class="login_title">课程负责人和管理员入口：</div>
                  <div class="login_con">
                    <div class="login_text">用户名：</div>
                    <div><input name="username" id="username" style="width:94%; padding:0 3%; border:1px solid #ccc; height:34px; line-height:34px; outline:none;" type="text" placeholder="请输入用户名"></div>
                    <div class="login_text">密码：</div>
                    <div><input id="password" name="password" style="width:94%; padding:0 3%; border:1px solid #ccc; height:34px; line-height:34px; outline:none;"  type="password" placeholder="请输入密码"></div>
                    <div class="text_center"><button class="login_btn" type="button" onclick="checkLogin(this.form)" >登录<span class="iconfont icon-denglu-circle-xian"></span></button></div>
                  </div>
                </div>
              [/@]

                <div class="yxlb m_t_20">
                  <div class="module_title"><img src="${b.static_url('openurp-edu-course','images/tiao.png')}"><span>院系列表</span><img src="${b.static_url('openurp-edu-course','images/tiao.png')}"><a class="gd" href="${b.url('!searchByDepart?id='+firstDepartment.id)}">+MORE</a></div>
                    <div class="yxlb_con">
                      <ul class="clearfix">
                        [#list departments as department]
                          <li>[@b.a href="!searchByDepart?id="+department.id]${department.name}[/@]</li>
                        [/#list]
                        </ul>
                    </div>
                </div>

                <div class="jpkc m_t_20">
                  <div class="module_title"><img src="${b.static_url('openurp-edu-course','images/tiao.png')}"><span>精品资源</span><img src="${b.static_url('openurp-edu-course','images/tiao.png')}"></div>
                    <div class="jpkc_con">
                      <ul class="clearfix">
                        [#list awardCategories as c]
                          <li>
                            [@b.a href="!awards?categoryId="+c.id]${c.name}[/@]
                          </li>
                        [/#list]
                      </ul>
                    </div>
                </div>

                <div class="kstd m_t_20">
                  <div class="module_title"><img src="${b.static_url('openurp-edu-course','images/tiao.png')}"><span>快速通道</span><img src="${b.static_url('openurp-edu-course','images/tiao.png')}"></div>
                    <div class="kstd_con">
                      <ul>
                          <li><a href="https://xxb.lixin.edu.cn/yhgg/88988.htm" target="_blank">网络教学平台</a></li>
                            <li><a href="http://lxjw.lixin.edu.cn/cas/login" target="_blank">教务管理系统</a></li>
                            <li><a href="https://jwc.lixin.edu.cn/" target="_blank">教务处</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    [#include "foot.ftl"/]
  </div>

  <div class="tk_box" style=" width:500px;"/>
[@b.foot/]
<style>
  .kclb_list{ border:0px; padding:0px; margin-top:15px;background:#ffffff}
  .select_zk option { padding: 5px 5px; }
  .kc_table tbody td {padding: 10px 5px;}
  </style>
<script>

  $.ajax({
    "type": "get",
    "url": "${Ems.base}/api/platform/oa/notices/edu-course-indexapp/3.json",
    "dataType": "json",
    "async": false,
    "success": function (data) {
      data.forEach(function(item, index){
        if (index > 5) return;
        var date = new Date(item.createdAt);
        var month = date.getMonth() + 1;
        if (month < 10) month = "0" + month;
        var day = date.getDate()
        if (day < 10) day = "0" + day
        var dateString = date.getFullYear() + "-" + month + "-" + day;
        var url = "${b.base}/index/notice?id=" + item.id;
        $("#tzgg").append("<li><span class=\"yuan\"></span><a href=\"" + url + "\">"+item.title+"</a><span class=\"gg_time\">"+dateString+"</span></li>");
      })
    }
  });

  function checkLogin(form) {
    var form  = document.loginForm;
    if (!form['username'].value) {
      alert("用户名称不能为空");
      return;
    }
    if (!form['password'].value) {
      alert("密码不能为空");
      return;
    }
    setSearchParams(form);
    bg.form.submit(form);
  };

  function setSearchParams(form) {
    jQuery('input[name=params]', form).remove();
    var params = jQuery(form).serialize();
    bg.form.addInput(form, 'params', params);
  };

  beangle.load(["jquery-ui", "jquery-chosen", "jquery-colorbox"], function () {
    var formObj = $("form[name=courseProfileSearchForm]");
    formObj.find("select[name='courseProfile.course.department.id']").val("${(choosedDepartment.id)!}");
    formObj.find("select[name='courseGroup']").val("${(choosedCourseGroup.id)!}");

    formObj.find("select[name='courseProfile.course.department.id']").change(function () {
      var form = document.courseProfileSearchForm;
      setSearchParams(document.courseProfileSearchForm);
      bg.form.submit(form);
    });

    formObj.find("select[name='courseGroup']").change(function () {
      var form = document.courseProfileSearchForm;
      setSearchParams(document.courseProfileSearchForm);
      bg.form.submit(form);
    });

    formObj.find("select[name='courseGroup_child']").change(function () {
      var form = document.courseProfileSearchForm;
      setSearchParams(document.courseProfileSearchForm);
      bg.form.submit(form);
    });

    formObj.find("select[name='courseGroup_child_child']").change(function () {
      var form = document.courseProfileSearchForm;
      setSearchParams(document.courseProfileSearchForm);
      bg.form.submit(form);
    });

    formObj.find("select[name='courseGroup']").children("option").click(function () {
      var secondObj = formObj.find("[name='courseGroup_child']");
      secondObj.empty();
      var thirdObj = formObj.find("[name='courseGroup_child_child']");
      thirdObj.empty();

      $.ajax({
        "type": "post",
        "url": "${b.url("index!childrenAjax")}",
        "dataType": "json",
        "data": {
          "courseGroupId": $(this).val()
        },
        "async": false,
        "success": function (data) {

          secondObj.append("<option value=''>全部</option>");
          for (var i = 0; i < data.courseGroups.length; i++) {
            var optionObj = $("<option>");
            optionObj.val(data.courseGroups[i].id);
            optionObj.text(data.courseGroups[i].name);
            optionObj.click(function () {
              var thirdVal = formObj.find("[name='courseGroup_child_child']").val();
              var courseGroupId = $(this).val();
              var thirdObj = formObj.find("[name='courseGroup_child_child']");
              thirdObj.empty();

              $.ajax({
                "type": "post",
                "url": "${b.url("index!childrenAjax")}",
                "dataType": "json",
                "data": {
                  "courseGroupId": courseGroupId
                },
                "async": false,
                "success": function (data) {

                  thirdObj.append("<option value=''>全部</option>");
                  for (var i = 0; i < data.courseGroups.length; i++) {
                    var optionObj = $("<option>");
                    optionObj.val(data.courseGroups[i].id);
                    optionObj.text(data.courseGroups[i].name);
                    thirdObj.append(optionObj);
                  }
                }
              });
            });
            secondObj.append(optionObj);
          }
        }
      });
    });
  });
</script>
