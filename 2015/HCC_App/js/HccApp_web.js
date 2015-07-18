"use strict"

/** 콘솔 설정   */
try{
    var console = window.console || {log:function(){  }};
}catch(e){}

/** gnb */
var gnbArr = [];
/** 브라우저 체크  */
var isSequenceMovie = false;
var isIe8 = false;
/** section 배경 이미지 사이즈    */
var section1Bg = {width:2560, height:1440};
/** 트위닝 체크  */
var isTweening = false;
/** 섹션 체크 타이머  */
var sectionCheckTimer;
/** 섹션 번호   */
var sectionIdx = 0;
/** 섹션 배열   */
var sectionArr = [];
/** 비디오 관련  */
var video1;
var video2;
var video3;
var video4;
var isVideo1Loaded = false;
var isVideo2Loaded = false;
var isVideo3Loaded = false;
var isVideo4Loaded = false;
var playVideoNum = -1;
var videoArr = [];
var flashVer = 0;
var notSupportVideo = false;

/** 시퀀스 관련  */
var sequenceContainerArr = [".section2 .list_img", ".section3 .list_img", ".section4 .list_img", ".section5 .list_img"];
/** 시퀀스 경로 배열   */
var sequencePathArr = ["images/web/sequence/myaccount/img_seq_", "images/web/sequence/mine/img_seq_", 
                       "images/web/sequence/appcard/img_seq_", "images/web/sequence/service/img_seq_"];
/** 시퀀스 플레이 체크  */
var fps = 83;
var videoPlayCheck = true;
var videoPlayInterval;
var playTime = 0;
var seqTotalArr = [156, 181, 169, 43];
/** My Account  */
var accountSeqArr = [];
/** Mine    */
var mineSeqArr = [];
/** App Card    */
var appcardSeqArr = [];
/** Service    */
var serviceSeqArr = [];


/** DOM 로드 완료   */
$(function(){
    var browser = NetUtil.getBrowser();
    browser = browser.toLowerCase();
    
    /** 브라우저 검사    */
    if(browser.match("safari") != null || browser.match("chrome") != null) isSequenceMovie = true;
    if(browser.match("msie 7") != null || browser.match("msie 8") != null){
        isIe8 = true;
    }else{
        $(".title h2, .title h3, .title p, .btn_store_wrap li, .btn_store_wrap p, .list_description li.list1, .list_description li.list2, .list_description li.list2 li, .btn_arrow").css({"visibility":"hidden", "opacity":"0", "filter":"alpha(opacity=0)"});
    }
    
    if(browser.match("firefox") != null){
        $("#video1, #video2, #video3").css({
            "filter":"brightness(105%)"
        });
    }
    /** 크롬 브라우저 브라이트 조정 */
//    if(browser.match("chrome") != null){
//        $("#video1, #video2, #video3").css({
//            "-webkit-filter":"brightness(105%)"
//        });
//    }
    
    initEventHandler();
    if(!isSequenceMovie) initVideo();
    resizeHandler();
    changeMenu(0);
});

/** 리소스로드 완료    */
$(window).load(function () {
    section1Bg.width = $(".section1_bg_1").width();
    section1Bg.height = $(".section1_bg_1").height();
    
    if(isSequenceMovie){
        $(".list_img").empty();
        for(var i=1; i<5; i++) $(".section" + (i+1) + " .list_img").html("<img id='video" + i + "' style='psition:relative;' />");
        $(".list_img").css({"display":"block"});
        initSequenceMovie(0);
    }
    resizeHandler();
    showSectionMotion();
});

/** 윈도우 리사이즈    */
$(window).resize(function () {
    showSectionMotion();
    sectionCheck();
    resizeHandler();
});

/** 이벤트 설정  */
function initEventHandler(){
    gnbArr = $("#header .navigation .gnb li a");
    sectionArr = $(".section1, .section2, .section3, .section4, .section5, .section6");
    $(window).bind("scroll", scrollHandler);
    $("html, body").bind("mousewheel", function(e){
        if(e.preventDefault) e.preventDefault();
        else e.returnValue = false;
        if(isTweening) return;
        
        if(e.deltaY == -1) moveSectionCheck("down");
        else if(e.deltaY == 1) moveSectionCheck("up");
    });
    $("html, body").bind("keydown", function(e){
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
    var params = { "controls":false, "autoplay":false, "preload":"auto", "bgcolor":"#ffffff" };
    videojs.options.flash.params = params;
    videojs.options.flash.swf = "js/libs/video/video-js.swf"
    video1 = videojs("video1", { "controls":false, "autoplay":false, "preload":"auto" }, function(){
        this.on('loadedmetadata', function() {
            isVideo1Loaded = true;
            showSectionMotion();
        });
    });
    video2 = videojs("video2", { "controls":false, "autoplay":false, "preload":"auto" }, function(){
        this.on('loadedmetadata', function() {
            isVideo2Loaded = true;
            showSectionMotion();
        });
    });
    video3 = videojs("video3", { "controls":false, "autoplay":false, "preload":"auto" }, function(){
        this.on('loadedmetadata', function() {
            isVideo3Loaded = true;
            showSectionMotion();
        });
    });
    video4 = videojs("video4", { "controls":false, "autoplay":false, "preload":"auto" }, function(){
        this.on('loadedmetadata', function() {
            isVideo4Loaded = true;
            showSectionMotion();
        });
    });
    videoArr = [video1, video2, video3, video4];
    $("video").css({"width":"auto"});
    $(".list_img").css({"display":"block"});
}

/** 시퀀스 로드 재귀 함수    */
function initSequenceMovie(currentVideoIdx){
    var sequenceLoadedCount = 0;
    sequenceLoad($(sequenceContainerArr[currentVideoIdx]), sequencePathArr[currentVideoIdx], seqTotalArr[currentVideoIdx], function(e){
        $(e.currentTarget).unbind("load");
        sequenceLoadedCount++;
        if(sequenceLoadedCount == seqTotalArr[currentVideoIdx]){
            switch(currentVideoIdx){
                case 0 :
                    isVideo1Loaded = true;
                    accountSeqArr = $(".section2 .list_img img");
                    break;
                case 1 :
                    isVideo2Loaded = true;
                    mineSeqArr = $(".section3 .list_img img");
                    break;
                case 2 :
                    isVideo3Loaded = true;
                    appcardSeqArr = $(".section4 .list_img img");
                    break;
                case 3 :
                    isVideo4Loaded = true;
                    serviceSeqArr = $(".section5 .list_img img");
                    break;
            }
            showSectionMotion();
            if(currentVideoIdx < 3) initSequenceMovie(currentVideoIdx+1);
        }
    });
}
/** 시퀀스 로드  */
function sequenceLoad($cont, src, totalFrames, _complete){
    var currentCnt = 1;
    while(currentCnt <= totalFrames){
        var img = $("<img style='display:none;'>");
        img.attr('src', src+currentCnt+".jpg");
        $cont.append(img);
        $(img).bind("load", _complete);
        currentCnt++;
    }
}

/**  시퀀스 영상 재생  */
function sequenceTogglePlay(){
    var nowSection = sectionIdxCheck();
    /** 같은 섹션인지 체크, 리턴 or 리셋    */
    if(playVideoNum == nowSection) return;
    else resetSequence();
    /** 영상 섹션이 아닌 경우 리턴 */
    if(nowSection <= 0 || nowSection > 4){ playVideoNum = 0; return; }
    /** 비디오 준비가 안된 경우 리턴    */
    if(nowSection == 1 && !isVideo1Loaded) return;
    else if(nowSection == 2 && !isVideo2Loaded) return;
    else if(nowSection == 3 && !isVideo3Loaded) return;
    else if(nowSection == 4 && !isVideo4Loaded) return;
    
    playVideoNum = nowSection;
    var currentSeqArr = [];
    switch (playVideoNum){
        case 1 : currentSeqArr = accountSeqArr; break;  
        case 2 : currentSeqArr = mineSeqArr; break;  
        case 3 : currentSeqArr = appcardSeqArr; break;  
        case 4 : currentSeqArr = serviceSeqArr; break;  
    }
    
    videoPlayInterval = setInterval(function(){
        playTime++;
        $("#video"+(playVideoNum)).attr("src", $(currentSeqArr[playTime]).attr("src"));
        if(playTime >= seqTotalArr[playVideoNum-1]){
            clearInterval(videoPlayInterval);
            playTime = 0;
            return;
        }
    },fps);
}
/** 시퀀스 리셋  */
function resetSequence(){
    clearTimeout(videoPlayInterval);
    playTime = 0;
    $("#video1").attr("src", $(accountSeqArr[1]).attr("src"));
    $("#video2").attr("src", $(mineSeqArr[1]).attr("src"));
    $("#video3").attr("src", $(appcardSeqArr[1]).attr("src"));
    $("#video4").attr("src", $(serviceSeqArr[1]).attr("src"));
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
    if(scrollTop < $(".section2").offset().top - 37){
        $("#header").css({"height":"69px", "border-bottom":"0px", "background":"url('images/web/header/img_navibg.png') 0 0 repeat-x"});
        $("#header .navigation h1 .title_eng").css({"display":"block"});
        $("#header .navigation h1 .title_kor").css({"margin":"20px 0 0", "color":"#fff"});
        $("#header .navigation .gnb").css({"top":"42px"});
		$("#header .navigation .gnb li.gnb_btn3").css({ "background":"url('images/web/header/img_gnb_bg.png') 0 3px no-repeat"});
    }else{
        $("#header").css({"height":"36px", "border-bottom":"1px solid #f3f3f3", "background":"#fff url('') 0 0 repeat-x"});
        $("#header .navigation h1 .title_eng").css({"display":"none"});
        $("#header .navigation h1 .title_kor").css({"margin":"10px 0 0", "color":"#333"});
        $("#header .navigation .gnb").css({"top":"11px"});
		$("#header .navigation .gnb li.gnb_btn3").css({ "background":"url('images/web/header/img_gnb_bg2.png') 0 1px no-repeat"});
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
        $("#header .navigation .gnb li").eq(idx-1).find("p").css({"color":"#398ff0"});
    }
}
/** 섹션 이동   */
function changeSection(idx){
    isTweening = true;
    var resetVudeoNum = sectionIdx-1;
    for(var i=0; i< videoArr.length; i++){ videoArr[i].pause(); }
    clearTimeout(sectionCheckTimer);
    switch(idx){
        case 0 : 
            $("html, body").stop().animate({"scrollTop":0}, 750, function(){ isTweening = false; showSectionMotion(); });
            break;
        case 1 : 
        case 2 : 
        case 3 : 
        case 4 : 
            var windowHeight = $(window).height();
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
            Social.shareOnFacebook("https://www.hyundaicard.com/about/mobile/", "현대카드 앱\nwww.hyundaicard.com/about/mobile/\n혜택을 확인하고, 모바일로 결제하고, 카드 이용내역을 관리하는 카드생활의 모든 것.\n이제 편리한 모바일에서 경험하세요."); break;
        case 1 : 
            Social.shareOnTwitter("https://www.hyundaicard.com/about/mobile/", "현대카드 앱 – 혜택을 확인하고, 모바일로 결제하고, 카드 이용내역을 관리하는 카드생활의 모든 것. 이제 편리한 모바일에서 경험하세요.\n"); break;
        case 2 : 
            Social.kakao.shareOnStory("https://www.hyundaicard.com/about/mobile/", "현대카드 앱", "혜택을 확인하고, 모바일로 결제하고, 카드 이용내역을 관리하는 카드생활의 모든 것. 이제 편리한 모바일에서 경험하세요.", ["https://www.hyundaicard.com/about/mobile/images/img_scrap_122.png"], function(){
                alert("카카오스토리에 게시되었습니다.");
            });
            break;
        case 3 : 
            Social.shareOnBand("www.hyundaicard.com/about/mobile/", "현대카드 앱\n혜택을 확인하고, 모바일로 결제하고, 카드 이용내역을 관리하는 카드생활의 모든 것. 이제 편리한 모바일에서 경험하세요.\nwww.hyundaicard.com/about/mobile/"); break;
        case 4 : 
            Social.kakao.shareOnTalk("www.hyundaicard.com/about/mobile/", "현대카드 앱\n혜택을 확인하고, 모바일로 결제하고, 카드 이용내역을 관리하는 카드생활의 모든 것. 이제 편리한 모바일에서 경험하세요.", "www.hyundaicard.com/about/mobile/", "", 80, 80, "현대카드 앱 다운받기");
            break;
        case 5 : 
            Social.shareOnLine("www.hyundaicard.com/about/mobile/", "현대카드 앱\n혜택을 확인하고, 모바일로 결제하고, 카드 이용내역을 관리하는 카드생활의 모든 것. 이제 편리한 모바일에서 경험하세요.\n"); break;
        case 6 : 
            Social.shareOnMail("", "", "현대카드 앱\n혜택을 확인하고, 모바일로 결제하고, 카드 이용내역을 관리하는 \n카드생활의 모든 것. 이제 편리한 모바일에서 경험하세요. \nwww.hyundaicard.com/about/mobile/"); break;  
        case 7 : 
            Social.shareOnSMS("", "현대카드 앱\n혜택을 확인하고, 모바일로 결제하고, 카드 이용내역을 관리하는 카드생활의 모든 것. 이제 편리한 모바일에서 경험하세요.\nwww.hyundaicard.com/about/mobile/"); break;
        case 8 : 
            Social.shareOnCopyUrl("www.hyundaicard.com/about/mobile/", "아래의 URL을 복사(Ctrl+C)하여\n원하는 곳에 붙여넣기(Ctrl+V)하세요."); break;
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
                TweenLite.to($(".section1 .title p"), 0.75, {delay:0.25, autoAlpha:1, ease:"Cubic.easeOut"});
                $(".section1 .btn_store_wrap li").each(function(i){
                    TweenLite.to($(this), 0.75, {delay:0.35+(i/10), autoAlpha:1, ease:"Cubic.easeOut"});
                });
                TweenLite.to($(".section1 .btn_arrow"), 1, {delay:0.75, autoAlpha:1, ease:"Cubic.easeOut"});
                break;
            case 1 : 
                if($(".section2 .title h3").css("visibility") != "hidden") break;
                TweenLite.to($(".section2 .title h3"), 0.75, {autoAlpha:1, ease:"Cubic.easeOut"});
                TweenLite.to($(".section2 .list_description .list1"), 0.5, {delay:0.25, autoAlpha:1, ease:"Cubic.easeOut"});
                TweenLite.to($(".section2 .list_description .list2"), 0.5, {delay:0.75, autoAlpha:1, ease:"Cubic.easeOut"});
                $(".section2 .list_description .list2 li").each(function(i){
                    TweenLite.to($(this), 0.65, {delay:0.85+(i/8), autoAlpha:1, ease:"Cubic.easeOut"});
                });
                break;
            case 2 : 
                if($(".section3 .title h3").css("visibility") != "hidden") break;
                TweenLite.to($(".section3 .title h3"), 0.75, {autoAlpha:1, ease:"Cubic.easeOut"});
                TweenLite.to($(".section3 .list_description .list1"), 0.5, {delay:0.25, autoAlpha:1, ease:"Cubic.easeOut"});
                TweenLite.to($(".section3 .list_description .list2"), 0.5, {delay:0.5, autoAlpha:1, ease:"Cubic.easeOut"});
                $(".section3 .list_description .list2 li").each(function(i){
                    TweenLite.to($(this), 0.65, {delay:0.85+(i/8), autoAlpha:1, ease:"Cubic.easeOut"});
                });
                break;
            case 3 : 
                if($(".section4 .title h3").css("visibility") != "hidden") break;
                TweenLite.to($(".section4 .title h3"), 0.75, {autoAlpha:1, ease:"Cubic.easeOut"});
                TweenLite.to($(".section4 .list_description .list1"), 0.5, {delay:0.25, autoAlpha:1, ease:"Cubic.easeOut"});
                TweenLite.to($(".section4 .list_description .list2"), 0.5, {delay:0.5, autoAlpha:1, ease:"Cubic.easeOut"});
                $(".section4 .list_description .list2 li").each(function(i){
                    TweenLite.to($(this), 0.65, {delay:0.85+(i/8), autoAlpha:1, ease:"Cubic.easeOut"});
                });
                break;
            case 4 : 
                if($(".section5 .title h3").css("visibility") != "hidden") break;
                TweenLite.to($(".section5 .title h3"), 0.75, {autoAlpha:1, ease:"Cubic.easeOut"});
                TweenLite.to($(".section5 .list_description .list1"), 0.5, {delay:0.25, autoAlpha:1, ease:"Cubic.easeOut"});
                break;
            case 5 : 
                if($(".section6 .title h3").css("visibility") != "hidden") break;
                TweenLite.to($(".section6 .title h3"), 0.75, {autoAlpha:1, ease:"Cubic.easeOut"});
                TweenLite.to($(".section6 .title p.txt1"), 0.75, {delay:0.15, autoAlpha:1, ease:"Cubic.easeOut"});
                TweenLite.to($(".section6 .title p.txt2"), 0.75, {delay:0.3, autoAlpha:1, ease:"Cubic.easeOut"});

                $(".section6 .btn_store_wrap li").each(function(i){
                    TweenLite.to($(this), 0.75, {delay:0.55+(i/10), autoAlpha:1, ease:"Cubic.easeOut"});
                });
                TweenLite.to($(".section6 .btn_store_wrap p"), 0.65, {delay:1, autoAlpha:1, ease:"Cubic.easeOut"});
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
    if(nowSection <= 0 || nowSection >= 5){ playVideoNum = 0; return; }
    /** 비디오 준비가 안된 경우 리턴    */
    if(nowSection == 1 && !isVideo1Loaded) return;
    else if(nowSection == 2 && !isVideo2Loaded) return;
    else if(nowSection == 3 && !isVideo3Loaded) return;
    else if(nowSection == 4 && !isVideo4Loaded) return;
    
    playVideoNum = nowSection;
    switch(playVideoNum){
        case 1 : video1.play(); break;
        case 2 : video2.play(); break;
        case 3 : video3.play(); break;
        case 4 : video4.play(); break;
    }
}
/** 영상 리셋  */
function resetVideo(){
    if(isVideo1Loaded){
        video1.currentTime(0);
        video1.pause();
    }
    if(isVideo2Loaded){
        video2.currentTime(0);
        video2.pause();
    }
    if(isVideo3Loaded){
        video3.currentTime(0);
        video3.pause();
    }
    if(isVideo4Loaded){
        video4.currentTime(0);
        video4.pause();
    }
}

/** 섹션 번호 검사    */
function sectionIdxCheck(){
    var scrollTop = $(window).scrollTop();
    var windowHeight = $(window).height();
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


/** 리사이즈 핸들러    */
function resizeHandler(){
    var windowWidth = $(window).width();
    var windowHeight = $(window).height();
    /** 메인 배경   */
    var bgHscale;
    var bgVscale;
    var maxScale;
    /** 비디오 */
    var vWidth;
    var marginNum;
    /** 섹션 높이 값 수정  */
    if(windowHeight <= 600) $(".section1, .section2, .section3, .section4, .section5").css({"height":"600px"});
    else $(".section1, .section2, .section3, .section4, .section5").css({"height":windowHeight+"px"});
    
    /** 메인 배경 리사이즈  */
    if(windowWidth >= section1Bg.width || windowHeight >= section1Bg.height){
        bgHscale = windowWidth/section1Bg.width;
        bgVscale = windowHeight/section1Bg.height;
        maxScale = Math.max(bgHscale, bgVscale);
        $(".section1_bg_1").css({"width":Math.ceil(maxScale*section1Bg.width)+"px", "height":Math.ceil(maxScale*section1Bg.height)+"px"});
    }
    $(".section1_bg_1").css({"left":"50%", "margin-left":-($(".section1_bg_1").width()/2)+"px", "top":"50%", 
                             "margin-top":-($(".section1_bg_1").height()/2)+"px"});
    
    /** 비디오 리사이즈    */
    if(windowHeight <= 600){ windowHeight = 600; }
    if(windowHeight >= 900){
        $("#video1").css({"height":"900px", "top":"0", "left":"0", "margin":"0"});
        $("#video2").css({"height":"900px", "top":"0", "left":"0", "margin":"0"});
        $("#video3").css({"height":"900px", "top":"0", "left":"0", "margin":"0"});
        $(".section2 .list_img object, .section3 .list_img object, .section4 .list_img object").css({"width":"100%"});
    }else{
        vWidth = 1100*(windowHeight/900);
        marginNum = 100 - (100*(windowHeight/900));
        $("#video1").css({"height":windowHeight+"px", "top":"50%", "left":"50%", "margin":-windowHeight/2+"px"+" 0 0 "+((-vWidth/2)-marginNum)+"px"});
        $("#video2").css({"height":windowHeight+"px", "top":"50%", "left":"50%", "margin":-windowHeight/2+"px"+" 0 0 "+((-vWidth/2)+marginNum)+"px"});
        $("#video3").css({"height":windowHeight+"px", "top":"50%", "left":"50%", "margin":-windowHeight/2+"px"+" 0 0 "+((-vWidth/2)-marginNum)+"px"});
        var wNum = 374*(windowHeight/900);
        $(".section2 .list_img object, .section3 .list_img object, .section4 .list_img object").css({"width":726+wNum+"px"});
    }
}



























