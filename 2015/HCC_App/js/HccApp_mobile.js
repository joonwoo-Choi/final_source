"use strict"

/** 콘솔 설정   */
try{
    var console = window.console || {log:function(){  }};
}catch(e){}

/** 스크린 타입  */
var screenType = "";
/** gnb */
var gnbArr = [];
/** 섹션 배열   */
var sectionArr = [];
/** 팝업 오픈   */
var isPopup = false;
/** 시퀀스 플레이 관련  */
/** 시퀀스 영상 컨테이너 */
var sequenceContainerArr = [".section2 .list_img .seq_m", ".section3 .list_img .seq_m", ".section4 .list_img .seq_m", ".section5 .list_img .seq_m"];
/** 시퀀스 경로 배열   */
var sequencePath = [];
var sequencePathArr = ["images/mobile/sequence/myaccount/img_seq_", "images/mobile/sequence/mine/img_seq_", 
                       "images/mobile/sequence/appcard/img_seq_", "images/mobile/sequence/service/img_seq_"];
var sequencePathAndroidArr = ["images/mobile/sequence_android/myaccount/img_seq_", "images/mobile/sequence_android/mine/img_seq_", 
                       "images/mobile/sequence_android/appcard/img_seq_", "images/mobile/sequence_android/service/img_seq_"];
/** My Account  */
var isAccountLoaded = false;
var accountSeqArr = [];
/** Mine    */
var isMineLoaded = false;
var mineSeqArr = [];
/** App Card    */
var isAppcardLoaded = false;
var appcardSeqArr = [];
/** Service    */
var isServiceLoaded = false;
var serviceSeqArr = [];

/** 비디오 플레이 체크  */
var fps = 111;
var videoPlayCheck = true;
var playVideoNum = -1;
var videoPlayInterval;
var playTime = 0;
var seqTotalArr = [76, 89, 89, 18];


/** DOM 로드 완료   */
$(function(){
    if (navigator.userAgent.match(/(iphone)|(ipod)|(ipad)/i)){
        $('meta[name=viewport]').attr("content","width=640, user-scalable=no");
        $(".section6 .btn_store_wrap .btn_down1").parent().css({"display":"block"});
        $(".section6 .btn_store_wrap .btn_down2").parent().css({"display":"none"});
        $(".section1 .btn_store_wrap .btn_down1").parent().css({"display":"block"});
        $(".section1 .btn_store_wrap .btn_down2").parent().css({"display":"none"});
        $(".section6 .btn_store_wrap p").text("아이폰 OS VER 6.0 이상");
        $(".sms").css({"display":"none"});
        sequencePath = sequencePathArr;
    }else{
        $(".section6 .btn_store_wrap .btn_down1").parent().css({"display":"none"});
        $(".section6 .btn_store_wrap .btn_down2").parent().css({"display":"block"});
        $(".section1 .btn_store_wrap .btn_down1").parent().css({"display":"none"});
        $(".section1 .btn_store_wrap .btn_down2").parent().css({"display":"block"});
        $(".section6 .btn_store_wrap p").text("안드로이드폰 OS VER 4.0 이상");
        $(".seq_m").css({"height":"700px"});
        $(".section2, .section2 .list_img").css({"height":"1226px"});
        $(".section3, .section3 .list_img").css({"height":"1245px", "background-color":"#f7f7f7"});
        $(".section4, .section4 .list_img").css({"height":"1190px"});
        $(".section5").css({"height":"1205px"});
        $(".section5 .list_img").css({"background":"url('images/mobile/img_section_bg5_android.png') 0 0 no-repeat"});
        $(".section5 .list_img .seq_m").css({"width":"218px", "height":"380px", "top":"570px", "margin-left":"-102px"});
        sequencePath = sequencePathAndroidArr;
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
    })
    
    mainTitleSetting();
});

/** 리소스로드 완료    */
$(window).load(function () {
    initSequenceMovie(0);
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
        $("#container .section1 .contents").css({"top":wHeight/2+"px", "margin":-(contentsHeight/2) + "px 0 0"});
    }else{
        $("#container .section1 .btn_arrow").css({"top":"auto", "bottom":"40px"});
        $("#container .section1 .contents").css({"top":"50%", "margin":"-210px 0 0"});
    }
}

/** 시퀀스 로드 재귀 함수    */
function initSequenceMovie(currentVideoIdx){
    var sequenceLoadedCount = 0;
    sequenceLoad($(sequenceContainerArr[currentVideoIdx]), sequencePath[currentVideoIdx], seqTotalArr[currentVideoIdx], function(e){
        $(e.currentTarget).unbind("load");
        sequenceLoadedCount++;
        if(sequenceLoadedCount == seqTotalArr[currentVideoIdx]){
            switch(currentVideoIdx){
                case 0 :
                    isAccountLoaded = true;
                    accountSeqArr = $(".section2 .list_img .seq_m img");
                    break;
                case 1 :
                    isMineLoaded = true;
                    mineSeqArr = $(".section3 .list_img .seq_m img");
                    break;
                case 2 :
                    isAppcardLoaded = true;
                    appcardSeqArr = $(".section4 .list_img .seq_m img");
                    break;
                case 3 :
                    isServiceLoaded = true;
                    serviceSeqArr = $(".section5 .list_img .seq_m img");
                    break;
            }
            videoTogglePlay();
            if(currentVideoIdx < 3) initSequenceMovie(currentVideoIdx+1);
        }
    });
}
/** 시퀀스 로드  */
function sequenceLoad($cont, src, totalFrames, _complete){
    var currentCnt = 1;
    while(currentCnt <= totalFrames){
        var img = $("<img>");
        img.attr('src', src+currentCnt+".jpg");
        $cont.append(img);
        $(img).bind("load", _complete);
        currentCnt++;
    }
}

/**  시퀀스 영상 재생  */
function videoTogglePlay(){
    var nowSection = sectionIdxCheck();
    nowSection = nowSection-1;
    /** 같은 섹션인지 체크, 리턴 or 리셋    */
    if(playVideoNum == nowSection) return;
    else resetVideo();
    /** 영상 섹션이 아닌 경우 리턴 */
    if(nowSection < 0 || nowSection > 3){ playVideoNum = -10; return; }
    /** 비디오 준비가 안된 경우 리턴    */
    if(nowSection == 0 && !isAccountLoaded) return;
    else if(nowSection == 1 && !isMineLoaded) return;
    else if(nowSection == 2 && !isAppcardLoaded) return;
    else if(nowSection == 3 && !isServiceLoaded) return;
    
    playVideoNum = nowSection;
    var currentSeqArr = [];
    switch (playVideoNum){
        case 0 : currentSeqArr = accountSeqArr; break;  
        case 1 : currentSeqArr = mineSeqArr; break;  
        case 2 : currentSeqArr = appcardSeqArr; break;  
        case 3 : currentSeqArr = serviceSeqArr; break;  
    }
    
    videoPlayInterval = setInterval(function(){
        playTime++;
        $(".section"+(playVideoNum+2)+" .viewer").attr("src", $(currentSeqArr[playTime]).attr("src"));
        if(playTime >= seqTotalArr[playVideoNum]){
            clearInterval(videoPlayInterval);
            playTime = 0;
            return;
        }
    },fps);
}
/** 비디오 리셋  */
function resetVideo(){
    clearTimeout(videoPlayInterval);
    playTime = 0;
    $(".section2 .viewer").attr("src", $(accountSeqArr[1]).attr("src"));
    $(".section3 .viewer").attr("src", $(mineSeqArr[1]).attr("src"));
    $(".section4 .viewer").attr("src", $(appcardSeqArr[1]).attr("src"));
    $(".section5 .viewer").attr("src", $(serviceSeqArr[1]).attr("src"));
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
    resetVideo();
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

























