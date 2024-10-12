[#ftl]
[#include "head.ftl"/]
  <div class="wrapper">

    [#include "nav.ftl"/]

        <div class="con_area m_t_30">
          <div class="bg_white p_lr_10">
                <div class="title_con"><span class="title_text"><i class="quan"></i>优质课程</span></div>
                    <div class="jkc_con m_t_20">
                      [#list awardMap?keys?sort_by("code") as category]
                        <div class="jkc_list" style="background: url(${b.static_url('local','edu-course-indexapp/images/kc_tbg.png')}) no-repeat;">
                            <div class="jkc_title"><img alt="${category.name}" src="${b.static_url('openurp-edu-course','images/jpzy_${category.code}_t.png')}"></div>
                            <ul class="jkc_item clearfix">
                              [#list awardMap.get(category) as profile]
                                [#if profile_index<20]
                                <li>
                                    [@b.a href="index!detail?id=${profile.id!}" target="_blank"]
                                      ${profile.course.name}
                                    [/@]
                                </li>
                                [/#if]
                              [/#list]
                              [#if awardMap.get(category)?? && awardMap.get(category)?size>0]
                              <li>[@b.a class="more" href="!awards?categoryId="+category.id]更多<span class="iconfont icon-gengduo1"></span>[/@]</li>
                              [/#if]
                            </ul>
                        </div>
                      [/#list]
                    </div>
                </div>
            </div>
        </div>

  [#include "foot.ftl"/]

    </div>
    <script>
      $(function(){
        $(".jkc_item li:last-child").css({"width":"865px","padding-left":"0","text-align":"right"});
      })
    </script>
[@b.foot/]
