"use strict";

/** 콘솔 설정   */
try{
    var console = window.console || {log:function(){  }};
}catch(e){}

/** 브라우저 체크  */
var isSequenceMovie = false,
    isIe8 = false,
/** 트위닝 체크  */
    isTweening = false,
/** 섹션 체크 타이머  */
    sectionCheckTimer,
/** 섹션 번호   */
    sectionIdx = 0,
/** 섹션 배열   */
    sectionArr = [],
/** 비디오 관련  */
    video0,
    video1,
    isVideo0Loaded = false,
    isVideo1Loaded = false,
    playVideoNum = -1,
    videoArr = [],
    flashVer = 0,
    notSupportVideo = false,
/** 시퀀스 경로 배열   */
    sequencePathArr = ["images/web/sequence/video0/img_seq_", "images/web/sequence/video1/img_seq_"],
/** 시퀀스 플레이 체크  */
    fps = 83,
    videoPlayCheck = true,
    videoPlayInterval,
    playFrame = 0,
    seqTotalFramesArr = [241, 37],
/** main    */
    seqArr0 = [],
/** App Card    */
    seqArr1 = [],
/** 재생 여부   */
    played = [false, false, false, false, false]

/** DOM 로드 완료   */
$(function(){
    var browser = NetUtil.getBrowser();
    browser = browser.toLowerCase();
    
    /** 브라우저 검사    */
    if(browser.match("safari") != null || browser.match("chrome") != null) isSequenceMovie = true;
    if(browser.match("msie 7") != null || browser.match("msie 8") != null){
        isIe8 = true;
        played = [false, true, true, false, true];
        $(".section3 .indicator1 div").css({"height":"153px"});
        $(".section3 .indicator2 div").css({"height":"170px"});
    }else{
        $(".title h2, .title h3, .title p, .btn_store_wrap li, .list_description li.list1, .list_description li.list2, .list_description li.list3, .btn_arrow").css({"visibility":"hidden", "opacity":"0", "filter":"alpha(opacity=0)"});
        resetDeviceMotion();
    }
    
    if(browser.match("firefox") != null){
        $("#video0, #video1").css({
            "filter":"brightness(104%)"
        });
    }
    
    initEventHandler();
    if(!isSequenceMovie) initVideo();
    resizeHandler();
    changeMenu(0);
});

/** 리소스로드 완료    */
$(window).load(function () {
    if(isSequenceMovie){
        $(".section1 .list_img, .section4 .list_img").empty();
        $(".section1 .list_img").html("<img id='video0' style='psition:relative;' />");
        $(".section4 .list_img").html("<img id='video1' style='psition:relative;' />");
        $(".list_img").css({"display":"block"});
        initSequenceMovie(0);
    }
    resizeHandler();
    showSectionMotion();
});

/** 윈도우 리사이즈    */
$(window).resize(function () {
    sectionCheck();
    resizeHandler();
    showSectionMotion();
});

/** 이벤트 설정  */
function initEventHandler(){
    sectionArr = $(".section1, .section2, .section3, .section4, .section5, .section6");
    $(window).bind("scroll", scrollHandler);
    $("html, body").bind("mousewheel", function(e){
        if(e.preventDefault) e.preventDefault();
        else e.returnValue = false;
        if(isTweening) return;
        
        if(e.deltaY == -1) moveSectionCheck("down");
        else if(e.deltaY == 1) moveSectionCheck("up");
    });
    $(window).bind("keydown", function(e){
        if(e.keyCode != 40 && e.keyCode != 38) return;
        if(e.preventDefault) e.preventDefault();
        else e.returnValue = false;
        if(isTweening) return;

        if(e.keyCode == 40) moveSectionCheck("down");
        else if(e.keyCode == 38) moveSectionCheck("up");
    });
}
/** 비디오 설정  */
function initVideo(){
    /** 비디오태그 지원X & 플래시 플레이어 설치X 대체 문구 표시   */
    notSupportVideo = (typeof(document.createElement('video').canPlayType) == 'undefined');
    flashVer = swfobject.getFlashPlayerVersion().major;
    if(notSupportVideo && flashVer <= 0){
        $(".none_flash").css({"display":"block"});
        return;
    }
    var params = { "controls":false, "autoplay":false, "preload":"auto", "bgcolor":"#70c0ac" };
    videojs.options.flash.params = params;
    videojs.options.flash.swf = "js/libs/video/video-js.swf"
    video0 = videojs("video0", { "controls":false, "autoplay":false, "preload":"auto" }, function(){
        this.on('loadedmetadata', function() {
            isVideo0Loaded = true;
            showSectionMotion();
        });
    });
    params.bgcolor = "#faf4e8";
    videojs.options.flash.params = params;
    video1 = videojs("video1", { "controls":false, "autoplay":false, "preload":"auto" }, function(){
        this.on('loadedmetadata', function() {
            isVideo1Loaded = true;
            showSectionMotion();
        });
    });
    videoArr = [video0, video1];
    $("video").css({"width":"auto"});
    $(".list_img").css({"display":"block"});
}

/** 시퀀스 로드 재귀 함수    */
function initSequenceMovie(currentVideoIdx){
    var sequenceLoadedCount = 0;
    sequenceLoad(currentVideoIdx, sequencePathArr[currentVideoIdx], seqTotalFramesArr[currentVideoIdx], function(e){
        $(e.currentTarget).unbind("load");
        sequenceLoadedCount++;
        if(sequenceLoadedCount == seqTotalFramesArr[currentVideoIdx]){
            switch(currentVideoIdx){
                case 0 : isVideo0Loaded = true; break;
                case 1 : isVideo1Loaded = true; break;
            }
            showSectionMotion();
            if(currentVideoIdx < 1) initSequenceMovie(currentVideoIdx+1);
        }
    });
}
/** 시퀀스 로드  */
function sequenceLoad(videoIdx, src, totalFrames, _complete){
    var loadedCnt = 0;
    var currentvideo = [];
    switch(videoIdx){
        case 0 : currentvideo = seqArr0; break;
        case 1 : currentvideo = seqArr1; break;
    }
    while(loadedCnt < totalFrames){
        var img = new Image();
        currentvideo[loadedCnt] = img;
        $(img).bind("load", _complete);
        img.src = src+(loadedCnt+1)+".jpg";
        loadedCnt++;
    }
}

/**  시퀀스 영상 재생  */
function sequenceTogglePlay(){
    if(isTweening) return;
    var nowSection = sectionIdxCheck();
    
    /** 같은 섹션인지 체크, 리턴 or 리셋    */
    if(playVideoNum == nowSection) return;
    else resetSequence();
    /** 영상 섹션이 아닌 경우 리턴 */
    if(nowSection > 4){ playVideoNum = -1; return; }
    /** 비디오 준비가 안된 경우 리턴    */
    if(nowSection == 0 && !isVideo0Loaded) return;
    if(nowSection == 3 && !isVideo1Loaded) return;
    
    playVideoNum = nowSection;
    /** 서브 한번 재생된 경우 리턴 */
    if(played[playVideoNum] == true) return;
    if(playVideoNum != 0) played[playVideoNum] = true;
    
    var currentSeqArr = [];
    switch (playVideoNum){
        case 0 : currentSeqArr = seqArr0; break;
        case 1 : startDeviceMotion(playVideoNum); break;
        case 2 : startDeviceMotion(playVideoNum); break;
        case 3 : currentSeqArr = seqArr1; break;
        case 4 : startDeviceMotion(playVideoNum); break;
    }
    
    if(playVideoNum == 0 || playVideoNum == 3){
        var videoIdx = playVideoNum;
        if(videoIdx == 3) videoIdx = 1;
        videoPlayInterval = setInterval(function(){
            playFrame++;
            $("#video"+(videoIdx)).attr("src", $(currentSeqArr[playFrame]).attr("src"));
            if(playFrame >= seqTotalFramesArr[videoIdx]){
                clearInterval(videoPlayInterval);
                playFrame = 0;
                return;
            }
        },fps);
    }
}
/** 시퀀스 리셋  */
function resetSequence(){
    if(playVideoNum != 3){
        clearInterval(videoPlayInterval);
        playFrame = 0;
        $("#video0").attr("src", $(seqArr0[0]).attr("src"));
    }
}

/** 섹션 이동방향 체크  */
function moveSectionCheck(dir){
    isTweening = true;
    if(dir == "down") {
        if(sectionIdx >= sectionArr.length - 1){
            isTweening = false;
            return;
        }
        sectionIdx++;
    }
    else if(dir == "up"){
        if(sectionIdx <= 0){
            isTweening = false;
            return;
        }
        sectionIdx--;
    }
    
    changeSection(sectionIdx);
}

/** 섹션 자동이동 체크  */
var cnt = 0;
function sectionCheck(){
    clearTimeout(sectionCheckTimer);
    sectionCheckTimer = setTimeout(function(){
        isTweening = true;
        
        switch (sectionIdx){
            case 0 : 
                $("html, body").stop().animate({"scrollTop":0}, 500, function(){ isTweening = false; });
                break;
            case 1 : 
                $("html, body").stop().animate({"scrollTop":$(".section2").offset().top+"px"}, 500, function(){ isTweening = false; });
                break;
            case 2 : 
                $("html, body").stop().animate({"scrollTop":$(".section3").offset().top+"px"}, 500, function(){ isTweening = false; });
                break;
            case 3 : 
                $("html, body").stop().animate({"scrollTop":$(".section4").offset().top+"px"}, 500, function(){ isTweening = false; });
                break;
            case 4 : 
                $("html, body").stop().animate({"scrollTop":$(".section5").offset().top+"px"}, 500, function(){ isTweening = false; });
                break;
            case 5 :
                $("html, body").stop().animate({"scrollTop":$(".section6").offset().top+"px"}, 500, function(){ isTweening = false; });
                break;
        }
    },750);
}

/** 스크롤 핸들러 */
function scrollHandler(e){
    var scrollTop = $(window).scrollTop();
    
    if(!isTweening) sectionCheck();
    showSectionMotion();
    
    /** GNB 설정  */
    if(scrollTop < $(".section2").offset().top - 34){
        $("#header").css({"height":"72px", "border-bottom":"0px", "background":"url('images/web/img_navibg.png') 0 0 repeat-x"});
        $("#header .navigation h1 .title_eng").css({"display":"block"});
        $("#header .navigation h1 .title_kor").css({"margin":"20px 0 0", "color":"#fff"});
        $("#header .navigation .gnb").css({"top":"42px"});
		$("#header .navigation .gnb li.gnb_btn3").css({ "background":"url('images/web/img_gnb_bg.png') 0 3px no-repeat"});
    }else{
        $("#header").css({"height":"36px", "border-bottom":"1px solid #f3f3f3", "background":"#fff url('') 0 0 repeat-x"});
        $("#header .navigation h1 .title_eng").css({"display":"none"});
        $("#header .navigation h1 .title_kor").css({"margin":"10px 0 0", "color":"#333"});
        $("#header .navigation .gnb").css({"top":"11px"});
		$("#header .navigation .gnb li.gnb_btn3").css({ "background":"url('images/web/img_gnb_bg2.png') 0 1px no-repeat"});
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
    
    /** 섹션 업/다운 버튼 색상 변경    */
    var sectionIdx = sectionIdxCheck();
    if(sectionIdx == 0) $(".btn_section_up").css({"display":"none"});
    else $(".btn_section_up").css({"background-position":"0 "+(-30*sectionIdx)+"px", "display":"block"});
    if(sectionIdx == 5) $(".btn_section_down").css({"display":"none"});
    else $(".btn_section_down").css({"background-position":"0 "+(-30*sectionIdx)+"px", "display":"block"});
    
    if(!isIe8){
        $(".section1 .visual").css({"margin-top":-325-(scrollTop-$(".section1").offset().top)/5+"px"});
        $(".section2 .visual").css({"margin-top":-411+(scrollTop-$(".section2").offset().top)/5+"px"});
        $(".section3 .visual").css({"margin-top":-314-(scrollTop-$(".section3").offset().top)/5+"px"});
        $(".section4 .visual").css({"margin-top":-345-(scrollTop-$(".section4").offset().top)/5+"px"});
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
        $("#header .navigation .gnb li").eq(idx-1).find("p").css({"color":"#f56565"});
    }
}
/** 섹션 이동   */
function changeSection(idx){
    isTweening = true;
    var resetVudeoNum = sectionIdx-1;
    if(!isSequenceMovie) video0.pause();
//    for(var i=0; i< videoArr.length; i++){ videoArr[i].pause(); }
    clearTimeout(sectionCheckTimer);
    switch(idx){
        case 0 : 
            $("html, body").stop().animate({"scrollTop":0}, 750, function(){ isTweening = false; showSectionMotion(); });
            break;
        case 1 : 
        case 2 : 
        case 3 : 
        case 4 : 
            var wHeight = $(window).height();
            var movY = $(sectionArr[idx]).offset().top;
            $("html, body").stop().animate({"scrollTop":movY+"px"}, 750, 
                                           function(){ isTweening = false; showSectionMotion(); });
            break;
        case 5 : 
            var moveY = $(".section6").offset().top;
            $("html, body").stop().animate({"scrollTop":moveY+"px"}, 750, function(){ isTweening = false; showSectionMotion(); });
            break;
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
            window.open('smssend.html','','scrollbars=no,width=700,height=400'); break;
        case 8 : 
            Social.shareOnCopyUrl("weather.hyundaicard.com", "아래의 URL을 복사(Ctrl+C)하여\n원하는 곳에 붙여넣기(Ctrl+V)하세요."); break;
    }
}

/** 섹션 모션   */
function showSectionMotion(){
    sectionIdx = sectionIdxCheck();
    /** 섹션 텍스트 등장 모션, 최초 한번만 실행  */
    if(!isIe8){
        switch (sectionIdx){
            case 0 : 
                if($(".section1 .title h2").css("visibility") != "hidden") break;
                TweenLite.to($(".section1 .title h2"), 0.75, {autoAlpha:1, ease:"Cubic.easeOut"});
                TweenLite.to($(".section1 .title p"), 0.75, {delay:0.35, autoAlpha:1, ease:"Cubic.easeOut"});
                $(".section1 .btn_store_wrap li").each(function(i){
                    TweenLite.to($(this), 0.75, {delay:0.55+(i/6), autoAlpha:1, ease:"Cubic.easeOut"});
                });
                TweenLite.to($(".section1 .btn_arrow"), 1, {delay:0.85, autoAlpha:1, ease:"Cubic.easeOut"});
                break;
            case 1 : 
                if($(".section2 .title h3").css("visibility") != "hidden") break;
                TweenLite.to($(".section2 .title h3"), 0.75, {autoAlpha:1, ease:"Cubic.easeOut"});
                TweenLite.to($(".section2 .list_description .list1"), 0.5, {delay:0.35, autoAlpha:1, ease:"Cubic.easeOut"});
                TweenLite.to($(".section2 .list_description .list2"), 0.5, {delay:0.55, autoAlpha:1, ease:"Cubic.easeOut"});
                break;
            case 2 : 
                if($(".section3 .title h3").css("visibility") != "hidden") break;
                TweenLite.to($(".section3 .title h3"), 0.75, {autoAlpha:1, ease:"Cubic.easeOut"});
                TweenLite.to($(".section3 .list_description .list1"), 0.5, {delay:0.35, autoAlpha:1, ease:"Cubic.easeOut"});
                TweenLite.to($(".section3 .list_description .list2"), 0.5, {delay:0.55, autoAlpha:1, ease:"Cubic.easeOut"});
                break;
            case 3 : 
                if($(".section4 .title h3").css("visibility") != "hidden") break;
                TweenLite.to($(".section4 .title h3"), 0.75, {autoAlpha:1, ease:"Cubic.easeOut"});
                TweenLite.to($(".section4 .list_description .list1"), 0.5, {delay:0.35, autoAlpha:1, ease:"Cubic.easeOut"});
                TweenLite.to($(".section4 .list_description .list2"), 0.5, {delay:0.55, autoAlpha:1, ease:"Cubic.easeOut"});
                break;
            case 4 : 
                if($(".section5 .title h3").css("visibility") != "hidden") break;
                TweenLite.to($(".section5 .title h3"), 0.75, {autoAlpha:1, ease:"Cubic.easeOut"});
                TweenLite.to($(".section5 .list_description .list1"), 0.5, {delay:0.35, autoAlpha:1, ease:"Cubic.easeOut"});
                TweenLite.to($(".section5 .list_description .list2"), 0.5, {delay:0.55, autoAlpha:1, ease:"Cubic.easeOut"});
                TweenLite.to($(".section5 .list_description .list3"), 0.5, {delay:0.75, autoAlpha:1, ease:"Cubic.easeOut"});
                break;
            case 5 : 
                if($(".section6 .title h3").css("visibility") != "hidden") break;
                TweenLite.to($(".section6 .title h3"), 0.75, {autoAlpha:1, ease:"Cubic.easeOut"});
                TweenLite.to($(".section6 .title p.txt1"), 0.75, {delay:0.35, autoAlpha:1, ease:"Cubic.easeOut"});
                TweenLite.to($(".section6 .title p.txt2"), 0.75, {delay:0.55, autoAlpha:1, ease:"Cubic.easeOut"});

                $(".section6 .btn_store_wrap li").each(function(i){
                    TweenLite.to($(this), 0.75, {delay:0.75+(i/10), autoAlpha:1, ease:"Cubic.easeOut"});
                });
                TweenLite.to($(".section6 .btn_store_wrap p"), 0.85, {delay:1, autoAlpha:1, ease:"Cubic.easeOut"});
                break;
        }
    }
    
    /** 영상 처리   */
    if(!isSequenceMovie) videoTogglePlay();
    else sequenceTogglePlay();
}

/** 영상 토글 플레이   */
function videoTogglePlay(){
    if(isTweening) return;
    if(notSupportVideo && flashVer <= 0) return;
    
    var nowSection = sectionIdxCheck();
    /** 같은 섹션인지 체크, 리턴 or 리셋    */
    if(playVideoNum == nowSection) return;
    else resetVideo();
    /** 영상 섹션이 아닌 경우 리턴 */
    if(nowSection > 4){ playVideoNum = -1; return; }
    /** 비디오 준비가 안된 경우 리턴    */
    if(nowSection == 0 && !isVideo0Loaded) return;
    if(nowSection == 3 && !isVideo1Loaded) return;
    
    playVideoNum = nowSection;
    /** 서브 한번 재생된 경우 리턴 */
    if(played[playVideoNum] == true) return;
    if(playVideoNum != 0) played[playVideoNum] = true;
    
    switch(playVideoNum){
        case 0 : video0.play(); break;
        case 1 : startDeviceMotion(playVideoNum); break;
        case 2 : startDeviceMotion(playVideoNum); break;
        case 3 : video1.play(); break;
        case 4 : startDeviceMotion(playVideoNum); break;
    }
}
/** 영상 리셋  */
function resetVideo(){
    if(isVideo0Loaded){
        video0.currentTime(0);
        video0.pause();
    }
//    if(isVideo1Loaded){
//        video1.currentTime(0);
//        video1.pause();
//    }
//    if(!isIe8) resetDeviceMotion();
}

/** 서브 섹션 디바이스 모션    */
function startDeviceMotion(idx){
    if(isIe8) return;
    switch(idx){
        case 1 : 
            TweenMax.to($(".balloon1"), 1.25, {delay:0.5, opacity:1, ease:"Cubic.easeOut"});
            TweenMax.to($(".balloon1 img"), 1.25, {delay:0.5, height:"100%", ease:"Elastic.easeOut", onStart:function(){
                TweenMax.to($(".balloon1 .txt1"), 0.5, {delay:0.65, opacity:1, "margin-top":25, ease:"Cubic.easeOut", onStart:function(){
                    setTimeout(function(){
                        if(playVideoNum == 1) RandomText.single(".balloon1 .txt3", "바람 강함", 25, false, 2);
                        else $(".balloon1 .txt3").text("바람 강함");
                    },500);
                }});
                TweenMax.to($(".balloon1 .txt2"), 0.5, {delay:0.75, opacity:1, "margin-top":0, ease:"Cubic.easeOut"});
            }});
            TweenMax.to($(".balloon2"), 1.25, {delay:2, opacity:1, ease:"Cubic.easeOut"});
            TweenMax.to($(".balloon2 img"), 1.25, {delay:2, height:"100%", ease:"Elastic.easeOut", onStart:function(){
                TweenMax.to($(".balloon2 .txt1"), 0.5, {delay:0.65, opacity:1, "margin-top":66, ease:"Cubic.easeOut", onStart:function(){
                    setTimeout(function(){
                        if(playVideoNum == 1) RandomText.single(".balloon2 .txt2", "미세먼지 나쁨", 25, false, 2);
                        else $(".balloon2 .txt2").text("미세먼지 나쁨");
                    },250);
                }});
            }});
            break;
        case 2 : 
            var wHeight = $(window).height();
            if(wHeight <= 600) wHeight = 600; 
            else if(wHeight >= 900) wHeight = 900;
            
            var per = (wHeight-600)/300;
            TweenMax.to($(".indicator1 div"), 0.75, {delay:0.5, height:93+per*60, ease:"Cubic.easeOut", onComplete:function(){
                if(playVideoNum == 2) RandomText.single(".indicator1 p", "기념일 정보", 45, false, 2);
                else $(".indicator1 p").text("기념일 정보");
            }});
            TweenMax.to($(".indicator2 div"), 0.75, {delay:2.2, height:110+per*60, ease:"Cubic.easeOut", onComplete:function(){
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
    $(".balloon1 .txt1").css({"margin-top":"30px"});
    $(".balloon1 .txt2").css({"margin-top":"5px"});
    $(".balloon2 .txt1").css({"margin-top":"71px"});
    $(".indicator1 div, .indicator2 div").css({"height":"0"});
    $(".indicator1 p, .indicator2 p, .balloon1 .txt3, .balloon2 .txt2").text("");
    TweenMax.set($(".section5 .device2"), {"rotation":"15"});
    TweenMax.set($(".section5 .device3"), {"rotation":"20"});
}

/** 섹션 번호 검사    */
function sectionIdxCheck(){
    var scrollTop = $(window).scrollTop();
    var wHeight = $(window).height();
    if(scrollTop < $(".section2").offset().top-wHeight+$(".section1").height()/2){
        return 0;
    }else if(scrollTop >= $(".section2").offset().top-wHeight+$(".section1").height()/2 && 
             scrollTop < $(".section3").offset().top-wHeight+$(".section2").height()/2){
        return 1;
    }else if(scrollTop >= $(".section3").offset().top-wHeight+$(".section2").height()/2 && 
             scrollTop < $(".section4").offset().top-wHeight+$(".section3").height()/2){
        return 2;
    }else if(scrollTop >= $(".section4").offset().top-wHeight+$(".section3").height()/2 && 
             scrollTop < $(".section5").offset().top-wHeight+$(".section4").height()/2){
        return 3;
    }else if($(".section5").offset().top-wHeight+$(".section4").height()/2 && 
             scrollTop < $(".section6").offset().top-wHeight+$(".section6").height()/2){
        return 4;
    }else if(scrollTop >= $(".section6").offset().top-wHeight+$(".section6").height()/2){
        return 5;
    }
}


/** 리사이즈 핸들러    */
function resizeHandler(){
    var wWidth = $(window).width();
    var wHeight = $(window).height();
    /** 비디오 */
    var vWidth;
    var marginNum;
    /** 섹션 높이 값 수정  */
    if(wHeight <= 600) $(".section1, .section2, .section3, .section4, .section5").css({"height":"600px"});
    else $(".section1, .section2, .section3, .section4, .section5").css({"height":wHeight+"px"});
    
    /** 비쥬얼 포지션 */
    if(wWidth > 1920){
        $(".section1 .visual").css({"left":"auto", "right":"-361px", "margin":"-333px 0 0"});
        $(".section2 .visual").css({"left":"-238px", "margin":"-411px 0 0"});
        $(".section3 .visual").css({"left":"auto", "right":"-655px", "margin":"-314px 0 0"});
        $(".section4 .visual").css({"left":"-272px", "margin":"-345px 0 0"});
    }else{
        $(".section1 .visual").css({"left":"50%", "right":"auto", "margin":"-333px 0 0 532px"});
        $(".section2 .visual").css({"left":"50%", "margin":"-411px 0 0 -1201px"});
        $(".section3 .visual").css({"left":"50%", "right":"auto", "margin":"-314px 0 0 485px"});
        $(".section4 .visual").css({"left":"50%", "margin":"-345px 0 0 -1232px"});
    }
    
    /** 비디오 리사이즈    */
    if(wHeight <= 600){ wHeight = 600; }
    if(wHeight >= 900){
        $("#video0").css({"height":$(".section1 .list_img").height()+"px", "top":"0", "left":"0", "margin":"0"});
        $("#video1").css({"height":$(".section4 .list_img").height()+"px", "top":"0", "left":"0", "margin":"0"});
        
        $(".section2 .device").css({"height":$(".section2 .list_img").height()+"px", "top":"0", "left":"0", "margin":"0"});
        $(".section2 .balloon1").css({"margin":"-300px 0 0 -445px"});
        
        $(".section3 .device").css({"height":$(".section3 .list_img").height()+"px", "top":"0", "left":"0", "margin":"0"});
        $(".section3 .indicator1").css({"margin":"-435px 0 0 -133px"});
        $(".section3 .indicator2").css({"margin":"-270px 0 0 27px"});
        if($(".section3 .indicator1 div").height() > 0){
            $(".section3 .indicator1 div").css({"height":"153px"});
            $(".section3 .indicator2 div").css({"height":"170px"});
        }
        $(".section3 .indicator1 p").css({"margin":"0px 0 0 83px"});
        $(".section3 .indicator2 p").css({"margin":"0px 0 0 105px"});
        
        $(".section5 .device").css({"height":$(".section5 .list_img").height()+"px", "top":"0", "left":"0", "margin":"0"});
        
        $(".section1 .list_img object, .section4 .list_img object").css({"width":"100%"});
    }else{
        vWidth = 1100*(wHeight/900);
        marginNum = 100 - (100*(wHeight/900));
        $("#video0").css({"height":wHeight+"px", "top":"50%", "left":"50%", "margin":-wHeight/2+"px"+" 0 0 "+((-vWidth/2)-marginNum)+"px"});
        $("#video1").css({"height":wHeight+"px", "top":"50%", "left":"50%", "margin":-wHeight/2+"px"+" 0 0 "+((-vWidth/2)-marginNum)+"px"});
        
        /** 섹션2 리사이즈    */
        if($(".section2 .list_img").height() > wHeight){
            var per = (wHeight-600)/($(".section2 .list_img").height()-600);
            $(".section2 .balloon1").css({"margin":-260-per*40+"px 0 0 "+(-415-30*per)+"px"});
            $(".section2 .device").css({"height":wHeight+"px"});
        }else{
            $(".section2 .balloon1").css({"margin":"-300px 0 0 -445px"});
            $(".section2 .device").css({"height":$(".section2 .list_img").height()+"px"});
        }
        /** 섹션3 리사이즈    */
        if($(".section3 .list_img").height() > wHeight){
            var per = (wHeight-600)/($(".section3 .list_img").height()-600);
            $(".section3 .indicator1").css({"margin":-390-per*45+"px 0 0 "+(-108-25*per)+"px"});
            $(".section3 .indicator2").css({"margin":-260-per*10+"px 0 0 "+(22+5*per)+"px"});
            $(".section3 .device").css({"height":wHeight+"px"});
        }else{
            $(".section3 .indicator1").css({"margin":"-435px 0 0 -133px"});
            $(".section3 .indicator2").css({"margin":"-270px 0 0 27px"});
            $(".section3 .device").css({"height":$(".section3 .list_img").height()+"px"});
        }
        /** 섹션3 인디케이터 리사이즈 */
        if(900 > wHeight){
            var per = (wHeight-600)/300;
            if($(".section3 .indicator1 div").height() > 0){
                $(".section3 .indicator1 div").css({"height":93+per*60+"px"});
                $(".section3 .indicator2 div").css({"height":110+per*60+"px"});
            }
            $(".section3 .indicator1 p").css({"margin":(60-60*per)+"px 0 0 "+(33+50*per)+"px"});
            $(".section3 .indicator2 p").css({"margin":(60-60*per)+"px 0 0 "+(55+50*per)+"px"});
        }else{
            if($(".section3 .indicator1 div").height() > 0){
                $(".section3 .indicator1 div").css({"height":"153px"});
                $(".section3 .indicator2 div").css({"height":"170px"});
            }
            $(".section3 .indicator1 p").css({"margin":"0px 0 0 83px"});
            $(".section3 .indicator2 p").css({"margin":"0px 0 0 105px"});
        }
        /** 섹션5 리사이즈    */
        if($(".section5 .list_img").height() > wHeight) $(".section5 .device").css({"height":wHeight+"px"});
        else $(".section5 .device").css({"height":$(".section5 .list_img").height()+"px"});
        $(".section2 .device").css({"margin":(-$(".section2 .device").height()/2)+"px"+" 0 0 "+(-$(".section2 .device").width()/2)+"px", "top":"50%", "left":"50%"});
        $(".section3 .device").css({"margin":(-$(".section3 .device").height()/2)+"px"+" 0 0 "+(-$(".section3 .device").width()/2)+"px", "top":"50%", "left":"50%"});
        $(".section5 .device").css({"margin":(-$(".section5 .device").height()/2)+"px"+" 0 0 "+(-$(".section5 .device").width()/2)+"px", "top":"50%", "left":"50%"});
        
        var wNum = 374*(wHeight/900);
        $(".section1 .list_img object, .section4 .list_img object").css({"width":726+wNum+"px"});
    }
}



























