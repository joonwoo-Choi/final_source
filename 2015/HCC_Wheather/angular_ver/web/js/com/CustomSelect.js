/*

$('select').customStyle();

// css 설정 예시

.magazine{position:absolute; top:39px; right:13px; width:219px; height:33px; text-indent:0;} 
.magazine select{top:0; left:0; width:219px; height:33px; padding:0 5px 0 5px; background-color:#fff; color:#000;}
.magazine option{height:219px; line-height:33px; padding:0px;}
.magazine span.customStyleSelectBox{width:209px; height:33px; padding:0 5px 0 5px; font-size:12px; line-height:31px; color:#000;
    background:url('http://cdn.hanwhafireworks.com/web/images/magazine/common/img_select_bg.png') 0 0 no-repeat; vertical-align:middle;}
.magazine span.customStyleSelectBox.changed{ }
.magazine .customStyleSelectBoxInner{ font-size:12px; padding:0 5px 0 5px; white-space:nowrap; color:#fff; }
.magazine .customStyleSelectBorderStrong{ background-color:#fff; border:1px solid red; }

*/


(function($){
	$.fn.extend({
		customStyle : function(options) {
//			if(!$.browser.msie || ($.browser.msie&&$.browser.version>6)){
				return this.each(function() {
					var currentSelected = $(this).find(':selected');
					$(this).after('<span class="customStyleSelectBox"><span class="customStyleSelectBoxInner">'+currentSelected.text()+'</span></span>').css({position:'absolute', opacity:0,fontSize:$(this).next().css('font-size')});
					var selectBoxSpan = $(this).next();
					var selectBoxWidth = parseInt($(this).width()) - parseInt(selectBoxSpan.css('padding-left')) -parseInt(selectBoxSpan.css('padding-right'));
					var selectBoxSpanInner = selectBoxSpan.find(':first-child');
					selectBoxSpan.css({display:'inline-block'});
					selectBoxSpanInner.css({width:selectBoxWidth, display:'inline-block'});
					var selectBoxHeight = parseInt(selectBoxSpan.height()) + parseInt(selectBoxSpan.css('padding-top')) + parseInt(selectBoxSpan.css('padding-bottom'));
					$(this).height(selectBoxHeight).change(function(){
						selectBoxSpanInner.text($(this).find(':selected').text()).parent().addClass('changed');
					});
				});
//			}
		}
	});
})(jQuery);

