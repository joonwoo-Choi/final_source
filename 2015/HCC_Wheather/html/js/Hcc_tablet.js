"use strict"

/** 콘솔 설정   */
try{
    var console = window.console || {log:function(){  }};
}catch(e){}

/** 트위닝 체크  */
var isTweening = false,
/** 섹션 체크 타이머  */
    sectionCheckTimer,
/** 섹션 번호   */
    sectionIdx = 0,
/** 섹션 배열   */
    sectionArr = [],
/** 팝업 오픈   */
    isPopup = false

/** DOM 로드 완료   */
$(function(){
    
    /** 이벤트 설정  */
    sectionArr = $(".section1, .section2, .section3, .section4, .section5, .section6");
    $(window).bind("scroll", scrollHandler);
    $("html, body").bind("mousewheel", function(e){
        if(e.preventDefault) e.preventDefault();
        else e.returnValue = false;
        if(isTweening) return;
        
        if(e.deltaY == -1) moveSectionCheck("down");
        else if(e.deltaY == 1) moveSectionCheck("up");
    });
    $(window).bind("orientationchange", function(e) {
        viewportCheck();
    });
    $(window).bind("touchmove",function(e){
        if(isPopup) e.preventDefault();
    })
    
    viewportCheck();
    changeMenu(0);
});

/** 리소스로드 완료    */
$(window).load(function () {
    
    resizeHandler();
});

/** 윈도우 리사이즈    */
$(window).resize(function () {
    resizeHandler();
});

/** 뷰포트 체크, 변경  */
function viewportCheck(){
    if(screen.width <= 1024) $('meta[name=viewport]').attr("content","width=1024, user-scalable=no");
    else $('meta[name=viewport]').attr("content","width=device-width, user-scalable=no");
}

/** 섹션 이동 방향 체크 */
function moveSectionCheck(dir){
    isTweening = true;
    if(dir == "down") {
        if(sectionIdx >= sectionArr.length - 1){
            isTweening = false;
            changeSection(sectionArr.length - 1);
            return;
        }
        sectionIdx++;
    }
    else if(dir == "up"){
        if(sectionIdx <= 0){
            isTweening = false;
            changeSection(0);
            return;
        }
        sectionIdx--;
    }
    
    changeSection(sectionIdx);
}

/** 스크롤 핸들러 */
function scrollHandler(e){
    var scrollTop = $(window).scrollTop();
    sectionIdx = sectionIdxCheck();
    
    if(sectionIdx == 0) $(".btn_section_up").css({"display":"none"});
    else $(".btn_section_up").css({"background-position":"0 "+(-20*sectionIdx)+"px", "display":"block"});
    if(sectionIdx == 5) $(".btn_section_down").css({"display":"none"});
    else $(".btn_section_down").css({"background-position":"0 "+(-20*sectionIdx)+"px", "display":"block"});
    
    /** GNB 설정  */
    if(scrollTop < $(".section2").offset().top - 78){
        $("#header").css({"position":"absolute", "height":"78px", "border":"0px", "background":"url(images/tablet/img_navibg.png) 0 0 repeat-x"});
        $("#header .navigation h1 .title_eng").css({"display":"block"});
        $("#header .navigation h1 .title_kor").css({"margin":"22px 0 0", "color":"#fff"});
        $("#header .navigation .gnb").css({"top":"50px", "background":"url(images/tablet/img_gnbbg.png) 0 0 no-repeat"});
    }else{
        $("#header").css({"position":"fixed", "height":"42px", "border-bottom":"1px solid #f3f3f3", "background":"#fff url('') 0 0 no-repeat"});
        $("#header .navigation h1 .title_eng").css({"display":"none"});
        $("#header .navigation h1 .title_kor").css({"margin":"12px 0 0", "color":"#333"});
        $("#header .navigation .gnb").css({"top":"14px", "background":"url(images/tablet/img_gnbbg2.png) 0 0 no-repeat"});
    }
    /** 메뉴 활성화  */
    if(scrollTop < ($(".section2").offset().top-$("#header").height())){
        changeMenu(0);
    }else if(scrollTop >= $(".section2").offset().top-$("#header").height() && 
             scrollTop < $(".section6").offset().top-$(window).height()+$(".section6").height()){
        changeMenu(1);
    }else{
        changeMenu(2);
    }
}

/** 섹션 번호 검사    */
function sectionIdxCheck(){
    var scrollTop = $(window).scrollTop();
    var windowHeight = screenHeight();
    if(scrollTop < $(".section2").offset().top-windowHeight+$(".section1").height()/2){
        return 0;
    }else if(scrollTop >= $(".section2").offset().top-windowHeight+$(".section1").height()/2 && 
             scrollTop < $(".section3").offset().top-windowHeight+$(".section2").height()/2){
        return 1;
    }else if(scrollTop >= $(".section3").offset().top-windowHeight+$(".section2").height()/2 && 
             scrollTop < $(".section4").offset().top-windowHeight+$(".section3").height()/2){
        return 2;
    }else if(scrollTop >= $(".section4").offset().top-windowHeight+$(".section3").height()/2 && 
             scrollTop < $(".section5").offset().top-windowHeight+$(".section4").height()/2){
        return 3;
    }else if($(".section5").offset().top-windowHeight+$(".section4").height()/2 && 
             scrollTop < $(".section6").offset().top-windowHeight+$(".section6").height()/2){
        return 4;
    }else if(scrollTop >= $(".section6").offset().top-windowHeight+$(".section6").height()/2){
        return 5;
    }
}


/** gnb 활성화 */
function gnbActivation(idx){
    sectionIdx = idx;
    changeSection(idx);
}
/** gnb 메뉴 변경   */
function changeMenu(idx){
    if(idx == 0){
        $("#header .navigation .gnb li").find("p").css({"color":"#fff"});
    }else{
        $("#header .navigation .gnb li").find("p").css({"color":"#333"});
        $("#header .navigation .gnb li").eq(idx).find("p").css({"color":"#f56565"});
    }
}
/** 섹션 이동   */
function changeSection(idx){
    isTweening = true;
    switch(idx){
        case 0 : 
            $("html, body").stop().animate({"scrollTop":0}, 1000, function(){ isTweening = false; });
            break;
        case 1 : 
        case 2 : 
        case 3 : 
        case 4 : 
            var movY = $(sectionArr[idx]).offset().top;
            $("html, body").stop().animate({"scrollTop":movY+"px"}, 1000, function(){ isTweening = false; });
            break;
        case 5 : 
            var moveY = $(".section6").offset().top;
            $("html, body").stop().animate({"scrollTop":moveY+"px"}, 1000, function(){ isTweening = false; });
            break;
    }
}

/** URL카피 팝업 열기 닫기    */
function showHideCopyPopup(){
    if($(".popup_copyurl").css("display") == "none"){
        isPopup = true;
        $(".popup_copyurl").css({"display":"block"});
    }else{
        isPopup = false;
        $(".popup_copyurl").css({"display":"none"});
    }
}
/** SNS 공유 열기 닫기    */
function utilMenuShowHide(){
    if($(".util_menu ul").css("display") == "none") {
		$(".util_menu ul").css({"display":"block"});
		$(".toggle a").addClass("on");
	} else {
		$(".util_menu ul").css({"display":"none"});
		$(".toggle a").removeClass("on");
	}
}
/** SNS 공유  */
function utilMenuActivation(idx){
    switch(idx){
        case 0 : 
            Social.shareOnFacebook("http://weather.hyundaicard.com/", "현대카드 웨더\nweather.hyundaicard.com/\n새로운 방법으로 날씨를 표현하는 현대카드의 날씨 정보서비스. 위트 있는 날씨 멘트와 감각적인 표현으로 현대카드만의 차별화된 날씨 정보를 제공합니다."); break;
        case 1 : 
            Social.shareOnTwitter("http://weather.hyundaicard.com/", "현대카드 웨더 – 새로운 방법으로 날씨를 표현하는 현대카드의 날씨 정보서비스. 위트 있는 날씨 멘트와 감각적인 표현으로 현대카드만의 차별화된 날씨 정보를 제공합니다.\n"); break;
        case 2 : 
            Social.kakao.shareOnStory("http://weather.hyundaicard.com/", "현대카드 웨더", "새로운 방법으로 날씨를 표현하는 현대카드의 날씨 정보서비스. 위트 있는 날씨 멘트와 감각적인 표현으로 현대카드만의 차별화된 날씨 정보를 제공합니다.", ["http://weather.hyundaicard.com/images/img_scrap_122_v1.png"], function(){
                alert("카카오스토리에 게시되었습니다.");
            });
            break;
        case 3 : 
            Social.shareOnBand("weather.hyundaicard.com/", "현대카드 웨더\n새로운 방법으로 날씨를 표현하는 현대카드의 날씨 정보서비스. 위트 있는 날씨 멘트와 감각적인 표현으로 현대카드만의 차별화된 날씨 정보를 제공합니다.\nweather.hyundaicard.com"); break;
        case 4 : 
            Social.kakao.shareOnTalk("weather.hyundaicard.com", "현대카드 웨더\n새로운 방법으로 날씨를 표현하는 현대카드의 날씨 정보서비스. 위트 있는 날씨 멘트와 감각적인 표현으로 현대카드만의 차별화된 날씨 정보를 제공합니다.", "weather.hyundaicard.com", "", 80, 80, "현대카드 웨더 다운받기");
            break;
        case 5 : 
            Social.shareOnLine("weather.hyundaicard.com", "현대카드 웨더\n새로운 방법으로 날씨를 표현하는 현대카드의 날씨 정보서비스. 위트 있는 날씨 멘트와 감각적인 표현으로 현대카드만의 차별화된 날씨 정보를 제공합니다.\n"); break;
        case 6 : 
            Social.shareOnMail("", "", "현대카드 웨더\n새로운 방법으로 날씨를 표현하는 현대카드의 날씨 정보서비스. \n위트 있는 날씨 멘트와 감각적인 표현으로 현대카드만의 차별화된 날씨 정보를 제공합니다. \nweather.hyundaicard.com"); break;  
        case 7 : 
            Social.shareOnSMS("", "현대카드 웨더\n새로운 방법으로 날씨를 표현하는 현대카드의 날씨 정보서비스. 위트 있는 날씨 멘트와 감각적인 표현으로 현대카드만의 차별화된 날씨 정보를 제공합니다.\nweather.hyundaicard.com"); break;
        case 8 : 
            showHideCopyPopup(); break;
    }
}

/** 리사이즈    */
function resizeHandler(){
    var windowHeight = screenHeight();
    var windowWidth = $(window).width();
    
    /** 섹션 높이값 변경   */
    if(windowHeight <= 600) $(".section1, .section2, .section3, .section4, .section5").css({"height":"600px"});
    else $(".section1, .section2, .section3, .section4, .section5").css({"height":windowHeight+"px"});
    
}

/** 윈도우 높이값 */
function screenHeight(){
    var zoomLevel = document.documentElement.clientWidth / window.innerWidth;
    var wHeight = window.innerHeight * zoomLevel;
    return wHeight;
}



























