[#ftl]
[#include "head.ftl"/]
  <div class="wrapper">
    [#include "nav.ftl"/]

        <div class="con_area m_t_30">
          <div class="border p_lr_30 p_t_5 p_b_25" style="background:url(${b.static_url('local','edu-course-indexapp/images/slogan-bg.jpg')}) #fff right top no-repeat;">
                <div class="title_con"><span class="title_text"><i class="quan"></i>课程类别</span></div>
                <div class="m_t_30">
                  [@b.form name="courseProfileSearchForm"  action="!search?pageSize=25" target="courseProfileList" title="ui.searchForm" theme="html" ]
                    <div class="kclb_cx_tj">
                      <select name="courseProfile.course.department.id"  style="width:230px; height:36px; border:1px solid #e1e1e1; margin-right:15px;  padding:-left:10px;">
                        <option value="">请选择课程开课院系</option>
                        [#list departments as department]
                          <option value="${(department.id)!}" [#if (courseProfile.course.department.id)?? && (courseProfile.course.department.id==department.id)]selected[/#if]>${(department.name)!}</option>
                        [/#list]
                        <option value="else">其他</option>
                      </select>
                    </div>
                    <div class="aaa clearfix">
                      <div class="select_item">
                        <div class="select_title">请选择</div>
                        <select class="select_zk" size="6" name="courseGroup" id="courseGroupId" style="height:200px;">
                          <option value="">请选择</option>
                          [#list courseGroups as courseGroup]
                            <option value="${courseGroup.id}">${courseGroup.name}</option>
                          [/#list]
                        </select>
                      </div>
                      <div class="select_item">
                        <div class="select_title">请选择</div>
                        <select class="select_zk" size="6" name="courseGroup_child"  style="height:200px;">
                        </select>
                      </div>
                      <div class="select_item">
                        <div class="select_title">请选择</div>
                        <select class="select_zk" size="6" name="courseGroup_child_child" style="height:200px;">
                        </select>
                      </div>
                    </div>
                  [/@]
                </div>
            [@b.div id="courseProfileList" style="margin-top:20px;" href="!search?nameOrCode=${Parameters['nameOrCode']!}&pageSize=25"/]
            </div>
        </div>
        [#include "foot.ftl"/]
    </div>

<script>
  $(".aaa").css({"margin-top":"15px"})
  function setSearchParams(form) {
    jQuery('input[name=params]', form).remove();
    var params = jQuery(form).serialize();
    bg.form.addInput(form, 'params', params);
  }

  beangle.load(["jquery-ui", "jquery-chosen", "jquery-colorbox"], function () {
    var formObj = $("form[name=courseProfileSearchForm]");
    formObj.find("select[name='courseProfile.course.department.id']").val("${(choosedDepartment.id)!}");
    formObj.find("select[name='courseGroup']").val("${(choosedCourseGroup.id)!}");

    formObj.find("select[name='courseProfile.course.department.id']").change(function () {
      var form = document.courseProfileSearchForm;
      setSearchParams(document.courseProfileSearchForm);
      bg.form.submit(form);
    })

    formObj.find("select[name='courseGroup']").change(function () {
      var form = document.courseProfileSearchForm;
      setSearchParams(document.courseProfileSearchForm);
      bg.form.submit(form);
    })

    formObj.find("select[name='courseGroup_child']").change(function () {
      var form = document.courseProfileSearchForm;
      setSearchParams(document.courseProfileSearchForm);
      bg.form.submit(form);
    })

    formObj.find("select[name='courseGroup_child_child']").change(function () {
      var form = document.courseProfileSearchForm;
      setSearchParams(document.courseProfileSearchForm);
      bg.form.submit(form);
    })

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

          secondObj.append("<option value=''>请选择</option>");
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

                  thirdObj.append("<option value=''>请选择</option>");
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
[@b.foot/]
