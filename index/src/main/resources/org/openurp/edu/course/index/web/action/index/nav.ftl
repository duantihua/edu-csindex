
<div class="con_area">
  <div class="clearfix">
    <div class="logo fl"><img alt="logo" src="${b.static_url('local','edu-course-indexapp/images/nav-logo.png')}"></div>
      [@b.form name="blogSearchForm"  action="!searchByName"  title="ui.searchForm" theme="html" ]
        <div class="search_con fr">
          <input class="secar_input" type="text" name="nameOrCode" value="${(Parameters['nameOrCode']?html)!}" placeholder="输入课程代码，名称"><button class="secar_btn" type="button" onclick="searchByName()"><span class="iconfont icon-search01"></span>查询</button>
        </div>
      [/@]
  </div>
</div>

[#assign requestURI = request.requestURI/]
[#assign activeNavIndex=0/]
[#if requestURI?contains("search")]
[#assign activeNavIndex=1/]
[#elseif requestURI?contains("award")]
[#assign activeNavIndex=2/]
[/#if]
<div class="nav_con">
  <div class="con_area">
    <ul class="nav_list clearfix">
      <li [#if activeNavIndex==0] class="nav_on"[/#if]><a href="${b.url('index')}">首页</a></li>
      <li [#if activeNavIndex==1] class="nav_on"[/#if]><a href="#">课程查询</a>
        <ul class="subnav">
          <li>[@b.a href="!searchByCategory"]课程类别[/@]</li>
          <li>[@b.a href="!searchByDepart?id="+firstDepartment.id]院系[/@]
            <ul class="trlnav">
              [#list departments as department]
                <li>[@b.a href="!searchByDepart?id="+department.id]${department.name}[/@]</li>
              [/#list]
              <li>[@b.a href="!searchByDepart?id=0"]其他[/@b.a]</li>
            </ul>
          </li>
        </ul>
      </li>
      <li [#if activeNavIndex==2] class="nav_on"[/#if]>[@b.a href="!awardMap"]优质课程[/@b.a]
        <ul class="subnav">
          [#list awardCategories?sort_by("code") as c]
            <li>
                [@b.a href="!awards?categoryId="+c.id]${c.name}[/@]
            </li>
          [/#list]
        </ul>
      </li>
    </ul>
  </div>
</div>

<script>
  function searchByName() {
    var form = document.blogSearchForm;
    setSearchParams(form);
    bg.form.submit(form);
  }

  function setSearchParams(form) {
    jQuery('input[name=params]', form).remove();
    var params = jQuery(form).serialize();
    bg.form.addInput(form, 'params', params);
  }
</script>
