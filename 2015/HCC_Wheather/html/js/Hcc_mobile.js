"use strict"

/** 콘솔 설정   */
try{
    var console = window.console || {log:function(){  }};
}catch(e){}

/** 스크린 타입  */
var screenType = "",
/** gnb */
    gnbArr = [],
/** 섹션 배열   */
    sectionArr = [],
/** 팝업 오픈   */
    isPopup = false,
/** 시퀀스 경로   */
    sequencePath = "images/mobile/sequence/video0/img_seq_",
    sequencePathAndroid = "images/mobile/sequence_android/video0/img_seq_",
/** 시퀀스 배열  */
    isSeqLoaded = false,
    seqArr = [],
/** 비디오 플레이 체크  */
    fps = 111,
    videoPlayCheck = true,
    playVideoNum = -1,
    videoPlayInterval,
    playFrame = 0,
    seqTotalFrames = 28,
    played = [false, false, false, false, false],
    resourceLoaded = false


/** DOM 로드 완료   */
$(function(){
    if (navigator.userAgent.match(/(iphone)|(ipod)|(ipad)/i)){
        $('meta[name=viewport]').attr("content","width=640, user-scalable=no");
        $(".section6 .btn_store_wrap .btn_down1").parent().css({"display":"block"});
        $(".section6 .btn_store_wrap .btn_down2").parent().css({"display":"none"});
        $(".section1 .btn_store_wrap .btn_down1").parent().css({"display":"block"});
        $(".section1 .btn_store_wrap .btn_down2").parent().css({"display":"none"});
        $(".section6 .btn_store_wrap p").text("iOS 6.0 버전 이상 지원");
        $(".sms").css({"display":"none"});
    }else{
        $(".section6 .btn_store_wrap .btn_down1").parent().css({"display":"none"});
        $(".section6 .btn_store_wrap .btn_down2").parent().css({"display":"block"});
        $(".section1 .btn_store_wrap .btn_down1").parent().css({"display":"none"});
        $(".section1 .btn_store_wrap .btn_down2").parent().css({"display":"block"});
        $(".section6 .btn_store_wrap p").text("Android 버전 출시예정");
        $(".seq_m").css({"height":"700px"});
        sequencePath = sequencePathAndroid;
    }
    
    /** 이벤트 설정  */
    sectionArr = $(".section1, .section2, .section3, .section4, .section5, .section6");
    $(window).bind("scroll", scrollHandler);
    $(window).trigger("scroll");
    $(window).bind("orientationchange", function(e) {
        mainTitleSetting();
    });
    $(window).bind("touchmove",function(e){
        if(isPopup) e.preventDefault();
    });
    
    mainTitleSetting();
    resetDeviceMotion();
});

/** 리소스로드 완료    */
$(window).load(function () {
    resourceLoaded = true;
    initSequenceMovie(0);
    videoTogglePlay();
});

/** 윈도우 리사이즈    */
$(window).resize(function () {
    
});

/** 메인 타이틀 & 화살표 버튼 위치  */
function mainTitleSetting(){
    var zoomLevel = document.documentElement.clientWidth / window.innerWidth;
    var wHeight = window.innerHeight * zoomLevel;
    var contentsHeight = $(".section1 .contents").height();
    if(wHeight > 665){
        $("#container .section1 .btn_arrow").css({"bottom":"auto", "top":wHeight-80+"px"});
    }else{
        $("#container .section1 .btn_arrow").css({"top":"auto", "bottom":"40px"});
    }
}

/** 시퀀스 로드 재귀 함수    */
function initSequenceMovie(){
    var sequenceLoadedCount = 0;
    sequenceLoad(sequencePath, seqTotalFrames, function(e){
        $(e.currentTarget).unbind("load");
        sequenceLoadedCount++;
        if(sequenceLoadedCount == seqTotalFrames){
            isSeqLoaded = true;
            videoTogglePlay();
        }
    });
}
/** 시퀀스 로드  */
function sequenceLoad(src, totalFrames, _complete){
    var loadedCnt = 0;
    while(loadedCnt < totalFrames){
        var img = new Image();
        seqArr[loadedCnt] = img;
        $(img).bind("load", _complete);
        img.src = src+(loadedCnt+1)+".jpg";
        loadedCnt++;
    }
}

/**  시퀀스 영상 재생  */
function videoTogglePlay(){
    if(!resourceLoaded) return;
    var nowSection = sectionIdxCheck();
    
    /** 같은 섹션인지 체크, 리턴 or 리셋    */
    if(playVideoNum == nowSection) return;
    
    playVideoNum = nowSection;
    /** 서브 한번 재생된 경우 리턴 */
    if(played[playVideoNum] == true) return;
    if(playVideoNum != 0) played[playVideoNum] = true;
    
    switch (playVideoNum){
        case 0 : startDeviceMotion(playVideoNum); break;  
        case 1 : startDeviceMotion(playVideoNum); break;  
        case 2 : startDeviceMotion(playVideoNum); break;  
        case 3 : 
            /** 비디오 준비가 안된 경우 리턴    */
            if(!isSeqLoaded) return;
            
            videoPlayInterval = setInterval(function(){
                playFrame++;
                $(".section4 .viewer").attr("src", $(seqArr[playFrame]).attr("src"));
                if(playFrame >= seqTotalFrames){
                    clearInterval(videoPlayInterval);
                    playFrame = 0;
                    return;
                }
            },fps);
            break;  
        case 4 : startDeviceMotion(playVideoNum); break;  
    }
}
/** 비디오 리셋  */
function resetVideo(){
    clearTimeout(videoPlayInterval);
    playFrame = 0;
    $(".section4 .viewer").attr("src", $(seqArr[0]).attr("src"));
    resetDeviceMotion();
}

/** 서브 섹션 디바이스 모션    */
function startDeviceMotion(idx){
    switch(idx){
        case 1 : 
            TweenMax.to($(".balloon1"), 1.25, {delay:0.5, opacity:1, ease:"Cubic.easeOut"});
            TweenMax.to($(".balloon1 img"), 1.25, {delay:0.5, height:"100%", ease:"Elastic.easeOut", onStart:function(){
                TweenMax.to($(".balloon1 .txt1"), 0.5, {delay:0.65, opacity:1, "margin-top":23, ease:"Cubic.easeOut", onStart:function(){
                    setTimeout(function(){
                        if(playVideoNum == 1) RandomText.single(".balloon1 .txt3", "바람 강함", 25, false, 2);
                        else $(".balloon1 .txt3").text("바람 강함");
                    },500);
                }});
                TweenMax.to($(".balloon1 .txt2"), 0.5, {delay:0.75, opacity:1, "margin-top":0, ease:"Cubic.easeOut"});
            }});
            TweenMax.to($(".balloon2"), 1.25, {delay:2, opacity:1, ease:"Cubic.easeOut"});
            TweenMax.to($(".balloon2 img"), 1.25, {delay:2, height:"100%", ease:"Elastic.easeOut", onStart:function(){
                TweenMax.to($(".balloon2 .txt1"), 0.5, {delay:0.65, opacity:1, "margin-top":61, ease:"Cubic.easeOut", onStart:function(){
                    setTimeout(function(){
                        if(playVideoNum == 1) RandomText.single(".balloon2 .txt2", "미세먼지 나쁨", 25, false, 2);
                        else $(".balloon2 .txt2").text("미세먼지 나쁨");
                    },250);
                }});
            }});
            break;
        case 2 : 
            TweenMax.to($(".indicator1 div"), 0.75, {delay:0.5, height:$(".indicator1 img").height(), ease:"Cubic.easeOut", onComplete:function(){
                if(playVideoNum == 2) RandomText.single(".indicator1 p", "기념일 정보", 45, false, 2);
                else $(".indicator1 p").text("기념일 정보");
            }});
            TweenMax.to($(".indicator2 div"), 0.75, {delay:2.5, height:$(".indicator2 img").height(), ease:"Cubic.easeOut", onComplete:function(){
                if(playVideoNum == 2) RandomText.single(".indicator2 p", "축제 정보", 45, false, 2);
                else $(".indicator2 p").text("축제 정보");
            }});
            break;
        case 4 : 
            TweenMax.to($(".section5 .device2"), 0.75, {delay:0.5, opacity:1, rotation:0, ease:"Cubic.easeOut"});
            TweenMax.to($(".section5 .device3"), 0.75, {delay:0.75, opacity:1, rotation:0, ease:"Cubic.easeOut"});
            break;
    }
    
}
function resetDeviceMotion(){
    RandomText.stop();
    TweenMax.killTweensOf($(".indicator1 div, .indicator2 div, .balloon1, .balloon1 img, .balloon1 p, .balloon2, .balloon2 img, .balloon2 p, .section5 .device2, .section5 .device3"));
    $(".balloon1 img, .balloon2 img").css({"height":"80%"});
    $(".balloon1, .balloon1 .txt1, .balloon1 .txt2, .balloon2, .balloon2 .txt1, .section5 .device2, .section5 .device3").css({"opacity":"0"});
    $(".balloon1 .txt1").css({"margin-top":"28px"});
    $(".balloon1 .txt2").css({"margin-top":"5px"});
    $(".balloon2 .txt1").css({"margin-top":"66px"});
    $(".indicator1 div, .indicator2 div").css({"height":"0"});
    $(".indicator1 p, .indicator2 p, .balloon1 .txt3, .balloon2 .txt2").text("");
    TweenMax.set($(".section5 .device2"), {"rotation":"15"});
    TweenMax.set($(".section5 .device3"), {"rotation":"20"});
}

/** 스크롤 핸들러 */
function scrollHandler(e){
    var scrollTop = $(window).scrollTop();
    var wHeight = screenHeight();
    if(scrollTop > wHeight) $(".btn_top").css({"display":"inline-block"});
    else $(".btn_top").css({"display":"none"});
    
    /** 영상 처리   */
    if(videoPlayCheck) videoTogglePlay();
}

/** 섹션 이동   */
function changeSection(idx){
    videoPlayCheck = false;
    switch(idx){
        case 0 : 
            $("html, body").stop().animate({"scrollTop":0}, 1000, function(){ videoPlayCheck = true; });
            break;
        case 1 : 
        case 2 : 
        case 3 : 
        case 4 : 
            var movY = $(sectionArr[idx]).offset().top;
            $("html, body").stop().animate({"scrollTop":movY+"px"}, 1000, function(){ videoPlayCheck = true; });
            break;
        case 5 : 
            var moveY = $(".section6").offset().top;
            $("html, body").stop().animate({"scrollTop":moveY+"px"}, 1000, function(){ videoPlayCheck = true; });
            break;
    }
}

/** URL카피 팝업 열기 닫기    */
function showHideCopyPopup(){
    if($(".popup_copyurl").css("display") == "none") $(".popup_copyurl").css({"display":"block"});
    else $(".popup_copyurl").css({"display":"none"});
}
/** SNS 공유 열기 닫기    */
function showHideSnsPopup(){
    if($(".popup_sns").css("display") == "none"){
        isPopup = true;
        $(".popup_sns").css({"display":"block"});
    }else{
        isPopup = false;
        $(".popup_sns").css({"display":"none"});
    }
}
/** SNS 공유  */
function utilMenuActivation(idx){
    switch(idx){
        case 0 : 
            Social.shareOnFacebook("http://weather.hyundaicard.com/", "현대카드 웨더\nweather.hyundaicard.com/\n새로운 방법으로 날씨를 표현하는 현대카드의 날씨 정보서비스. 위트 있는 날씨 멘트와 감각적인 표현으로 현대카드만의 차별화된 날씨 정보를 제공합니다."); break;
        case 1 : 
            Social.shareOnTwitter("http://weather.hyundaicard.com/", "현대카드 웨더 – 새로운 방법으로 날씨를 표현하는 현대카드의 날씨 정보서비스. 위트 있는 날씨 멘트와 감각적인 표현으로 현대카드만의 차별화된 날씨 정보를 제공합니다."); break;
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

/** 윈도우 높이값 */
function screenHeight(){
    var zoomLevel = document.documentElement.clientWidth / window.innerWidth;
    var wHeight = window.innerHeight * zoomLevel;
    return wHeight;
}

























