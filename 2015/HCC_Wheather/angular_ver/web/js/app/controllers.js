

var weatherAppControllers = angular.module('weatherApp.controllers', []);

weatherAppControllers.controller('mainCtrl', ['$scope', 'appName', 'commonSvc', function ($scope, appName, commonSvc) {
    $scope.appName = appName;
    $scope.tmplLoadedCnt = 0;
    $scope.isTmplLoaded = false;
    $scope.$on('tmpl:loaded', function(args) {
        $scope.tmplLoadedCnt++;
        if($scope.tmplLoadedCnt>=2){
            console.log('templateLoadedComplate');
            $scope.isTmplLoaded = true;
            initWeatherApp($scope, commonSvc);
        }
    });
}])
.controller('headerCtrl', ['$scope', '$rootScope', 'commonSvc', function ($scope, $rootScope, commonSvc) {
    var menuList = [
        {idx:2, title:'주요 서비스', class:'', param:1},
        {idx:3, title:'앱 설치', class:'', param:5}
    ];
    $scope.menuList = menuList;
    
    var utilMenuList = [
        {idx:0, title:'페이스북', class:'fb', tooltip:'tooltip1'},
        {idx:1, title:'트위터', class:'tw', tooltip:'tooltip2'},
        {idx:2, title:'카카오스토리', class:'cas', tooltip:'tooltip3'},
        {idx:3, title:'밴드', class:'band', tooltip:'tooltip4'},
        {idx:6, title:'메일', class:'mail', tooltip:'tooltip5'},
        {idx:7, title:'SMS', class:'sms', tooltip:'tooltip6'},
        {idx:8, title:'URL복사', class:'url', tooltip:'tooltip7'}
    ];
    $scope.utilMenuList = utilMenuList;
    
    $scope.gnbActivation = function(idx){
        $scope.sectionIdx = idx;
        var moveY = $($scope.sectionArr[$scope.sectionIdx]).offset().top;
        commonSvc.changeSection($scope.sectionIdx, function(){
            if(!$scope.isIe8){
                commonSvc.showSectionMotion($scope.sectionIdx);
                $rootScope.$broadcast('video:videoTogglePlay');
            }
        }, moveY);
    }
    $scope.utilMenuShowHide = function(){
        commonSvc.utilMenuShowHide();
    }
    $scope.utilMenuActivation = function(idx){
        commonSvc.utilMenuActivation(idx);
    }
    
    $scope.$emit('tmpl:loaded');
}])
.controller('containerCtrl', ['$scope', 'commonSvc', function ($scope, commonSvc) {
    containerCtrl($scope, commonSvc);
    videoCtrl($scope, commonSvc);
    
    $scope.$emit('tmpl:loaded');
}])

/** init-app    */
function initWeatherApp($scope, commonSvc){
    /** 브라우저 체크  */
    $scope.isSequenceMovie = false;
    $scope.isIe8 = false;
    /** 트위닝 체크  */
    $scope.isTweening = false;
    /** 섹션 체크 타이머  */
    $scope.sectionCheckTimer;
    /** 섹션 번호   */
    $scope.sectionIdx = 0;
    /** 섹션 배열   */
    $scope.sectionArr = $(".section1, .section2, .section3, .section4, .section5, .section6");
    $scope.sectionLength = $scope.sectionArr.length;
    /** 비디오 관련  */
    $scope.video0;
    $scope.video1;
    $scope.isVideo0Loaded = false;
    $scope.isVideo1Loaded = false;
    $scope.playVideoNum = -1;
    $scope.videoArr = [];
    $scope.flashVer = 0;
    $scope.notSupportVideo = false;
    /** 시퀀스 경로 배열   */
    $scope.sequencePathArr = ["images/web/sequence/video0/img_seq_", "images/web/sequence/video1/img_seq_"];
    /** 시퀀스 플레이 체크  */
    $scope.fps = 83;
    $scope.videoPlayInterval;
    $scope.playFrame = 0;
    $scope.seqTotalFramesArr = [241, 37];
    /** main    */
    $scope.seqArr0 = [];
    /** App Card    */
    $scope.seqArr1 = [];
    /** 재생 여부   */
    $scope.played = [false, false, false, false, false];
    
    /** 브라우저 검사    */
    $scope.browser = utils.netUtil.getBrowser();
    if($scope.browser.match(/safari|chrome/gi)) $scope.isSequenceMovie = true;
    if($scope.browser.match(/msie 7|msie 8/gi)){
        $scope.isIe8 = true;
        $scope.played = [false, true, true, false, true];
        $(".section3 .indicator1 div").css({"height":"153px"});
        $(".section3 .indicator2 div").css({"height":"170px"});
    }else{
        $(".title h2, .title h3, .title p, .btn_store_wrap li, .list_description li.list1, .list_description li.list2, .list_description li.list3, .btn_arrow").css({"visibility":"hidden", "opacity":"0", "filter":"alpha(opacity=0)"});
        $scope.$broadcast('video:resetDeviceMotion');
    }
    if($scope.browser.match(/firefox/)){
        $("#video0, #video1").css({
            "filter":"brightness(104%)"
        });
    }
    
    /** global events   */
    $scope.$on('globalEvt:resize', function(args) {
        commonSvc.resizeHandler();
        var sectionIdx = commonSvc.sectionIdxCheck();
        commonSvc.sectionCheck(sectionIdx);
    });
    $scope.$on('globalEvt:scroll', function(args) {
        var scrollTop = $(window).scrollTop();
        var sectionIdx = commonSvc.sectionIdxCheck();
        commonSvc.sectionCheck(sectionIdx);
        if(!commonSvc.isTweening()){
            commonSvc.showSectionMotion(sectionIdx);
            $scope.$broadcast('video:videoTogglePlay');
        }

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
            commonSvc.changeMenu(0);
        }else if(scrollTop >= $(".section2").offset().top-$("#header").height() && 
                 scrollTop < $(".section6").offset().top-$(window).height()+$(".section6").height()){
            commonSvc.changeMenu(1);
        }else{
            commonSvc.changeMenu(2);
        }

        /** 섹션 업/다운 버튼 색상 변경    */
        if(sectionIdx == 0) $(".btn_section_up").css({"display":"none"});
        else $(".btn_section_up").css({"background-position":"0 "+(-30*sectionIdx)+"px", "display":"block"});
        if(sectionIdx == 5) $(".btn_section_down").css({"display":"none"});
        else $(".btn_section_down").css({"background-position":"0 "+(-30*sectionIdx)+"px", "display":"block"});

        if(!$scope.isIe8){
            $(".section1 .visual").css({"margin-top":-325-(scrollTop-$(".section1").offset().top)/5+"px"});
            $(".section2 .visual").css({"margin-top":-411+(scrollTop-$(".section2").offset().top)/5+"px"});
            $(".section3 .visual").css({"margin-top":-314-(scrollTop-$(".section3").offset().top)/5+"px"});
            $(".section4 .visual").css({"margin-top":-345-(scrollTop-$(".section4").offset().top)/5+"px"});
        }
    });
    
    /** 리소스로드 완료    */
    $(window).load(function () {
        if($scope.isSequenceMovie){
            $(".section1 .list_img, .section4 .list_img").empty();
            $(".section1 .list_img").html("<img id='video0' style='psition:relative;' src='images/web/sequence/video0/img_seq_1.jpg' />");
            $(".section4 .list_img").html("<img id='video1' style='psition:relative;' src='images/web/sequence/video1/img_seq_1.jpg' />");
            $(".list_img").css({"display":"block"});
            initSequenceMovie($scope, 0);
        }
        commonSvc.resizeHandler();
    });
    
    if(!$scope.isSequenceMovie) initVideo();
    commonSvc.changeMenu(0);
    commonSvc.resizeHandler();
    var sectionIdx = commonSvc.sectionIdxCheck();
    commonSvc.showSectionMotion(sectionIdx);
}

/** 비디오 설정  */
function initVideo($scope){
    /** 비디오태그 지원X & 플래시 플레이어 설치X 대체 문구 표시   */
    $scope.notSupportVideo = (typeof(document.createElement('video').canPlayType) == 'undefined');
    $scope.flashVer = swfobject.getFlashPlayerVersion().major;
    if($scope.notSupportVideo && $scope.flashVer <= 0){
        $(".none_flash").css({"display":"block"});
        return;
    }
    var params = { "controls":false, "autoplay":false, "preload":"auto", "bgcolor":"#70c0ac" };
    videojs.options.flash.params = params;
    videojs.options.flash.swf = "js/libs/video/video-js.swf"
    $scope.video0 = videojs("video0", { "controls":false, "autoplay":false, "preload":"auto" }, function(){
        this.on('loadedmetadata', function() {
            $scope.isVideo0Loaded = true;
            $scope.$broadcast('video:videoTogglePlay');
        });
    });
    params.bgcolor = "#faf4e8";
    videojs.options.flash.params = params;
    $scope.video1 = videojs("video1", { "controls":false, "autoplay":false, "preload":"auto" }, function(){
        this.on('loadedmetadata', function() {
            $scope.isVideo1Loaded = true;
            $scope.$broadcast('video:videoTogglePlay');
        });
    });
    $scope.videoArr = [video0, video1];
    $("video").css({"width":"auto"});
    $(".list_img").css({"display":"block"});
}

/** 시퀀스 로드 재귀 함수    */
function initSequenceMovie($scope, currentVideoIdx){
    var sequenceLoadedCount = 0;
    sequenceLoad($scope, currentVideoIdx, $scope.sequencePathArr[currentVideoIdx], $scope.seqTotalFramesArr[currentVideoIdx], function(e){
        $(e.currentTarget).unbind("load");
        sequenceLoadedCount++;
        if(sequenceLoadedCount == $scope.seqTotalFramesArr[currentVideoIdx]){
            switch(currentVideoIdx){
                case 0 : $scope.isVideo0Loaded = true; break;
                case 1 : $scope.isVideo1Loaded = true; break;
            }
            $scope.$broadcast('video:videoTogglePlay');
            if(currentVideoIdx < 1) initSequenceMovie($scope, currentVideoIdx+1);
        }
    });
}
/** 시퀀스 로드  */
function sequenceLoad($scope, videoIdx, src, totalFrames, _complete){
    var loadedCnt = 0;
    var currentvideo = [];
    switch(videoIdx){
        case 0 : currentvideo = $scope.seqArr0; break;
        case 1 : currentvideo = $scope.seqArr1; break;
    }
    while(loadedCnt < totalFrames){
        var img = new Image();
        currentvideo[loadedCnt] = img;
        $(img).bind("load", _complete);
        img.src = src+(loadedCnt+1)+".jpg";
        loadedCnt++;
    }
}


function containerCtrl($scope, commonSvc){
    $scope.moveSectionCheck = function(dir){
        $scope.sectionIdx = commonSvc.sectionIdxCheck();
        var sectionIdx = $scope.sectionIdx;
        sectionIdx = commonSvc.moveSectionCheck(dir, $scope.sectionIdx, $scope.sectionLength);
        $scope.sectionIdx = sectionIdx;
        commonSvc.changeSection(sectionIdx, function(){
            if(!$scope.isIe8){
                commonSvc.showSectionMotion($scope.sectionIdx);
                $scope.$broadcast('video:videoTogglePlay');
            }
        }, $($scope.sectionArr[$scope.sectionIdx]).offset().top);
    }
    
    $("html, body").bind("mousewheel", function(e){
        if(e.preventDefault) e.preventDefault();
        else e.returnValue = false;
        
        $scope.sectionIdx = commonSvc.sectionIdxCheck();
        var sectionIdx = $scope.sectionIdx;
        if(event.deltaY == 100){
            sectionIdx = commonSvc.moveSectionCheck("down", $scope.sectionIdx, $scope.sectionLength);
        }else if(event.deltaY == -100){
            sectionIdx = commonSvc.moveSectionCheck("up", $scope.sectionIdx, $scope.sectionLength);
        }
        if($scope.sectionIdx != sectionIdx){
            $scope.sectionIdx = sectionIdx;
        }else{
            return;
        }
        
        commonSvc.changeSection(sectionIdx, function(){
            if(!$scope.isIe8){
                commonSvc.showSectionMotion($scope.sectionIdx);
                $scope.$broadcast('video:videoTogglePlay');
            }
        }, $($scope.sectionArr[$scope.sectionIdx]).offset().top);
    });
    $(window).bind("keydown", function(e){
        if(e.keyCode != 40 && e.keyCode != 38) return;
        if(e.preventDefault) e.preventDefault();
        else e.returnValue = false;
        
        $scope.sectionIdx = commonSvc.sectionIdxCheck();
        var sectionIdx = $scope.sectionIdx;
        if(e.keyCode == 40){
            sectionIdx = commonSvc.moveSectionCheck("down", $scope.sectionIdx, $scope.sectionLength);
        }else if(e.keyCode == 38){
            sectionIdx = commonSvc.moveSectionCheck("up", $scope.sectionIdx, $scope.sectionLength);
        }
        if($scope.sectionIdx != sectionIdx){
            $scope.sectionIdx = sectionIdx;
        }else{
            return;
        }
        
        commonSvc.changeSection(sectionIdx, function(){
            if(!$scope.isIe8){
                commonSvc.showSectionMotion($scope.sectionIdx);
                $scope.$broadcast('video:videoTogglePlay');
            }
        }, $($scope.sectionArr[$scope.sectionIdx]).offset().top);
    });
}

function videoCtrl($scope, commonSvc){
    $scope.$on('video:videoTogglePlay', function(args) {
        /** 영상 처리   */
        if(!$scope.isSequenceMovie) $scope.videoTogglePlay();
        else $scope.sequenceTogglePlay();
    });
    $scope.$on('video:resetDeviceMotion', function(args) {
        $scope.resetDeviceMotion();
    });
    
    /** 영상 토글 플레이   */
    $scope.videoTogglePlay = function (){
        if(commonSvc.isTweening()) return;
        if($scope.notSupportVideo && $scope.flashVer <= 0) return;

        var nowSection = commonSvc.sectionIdxCheck();
        /** 같은 섹션인지 체크, 리턴 or 리셋    */
        if($scope.playVideoNum == nowSection) return;
        else $scope.resetVideo();
        /** 영상 섹션이 아닌 경우 리턴 */
        if(nowSection > 4){ $scope.playVideoNum = -1; return; }
        /** 비디오 준비가 안된 경우 리턴    */
        if(nowSection == 0 && !$scope.isVideo0Loaded) return;
        if(nowSection == 3 && !$scope.isVideo1Loaded) return;

        $scope.playVideoNum = nowSection;
        /** 서브 한번 재생된 경우 리턴 */
        if($scope.played[$scope.playVideoNum] == true) return;
        if($scope.playVideoNum != 0) $scope.played[$scope.playVideoNum] = true;

        switch($scope.playVideoNum){
            case 0 : $scope.video0.play(); break;
            case 1 : $scope.startDeviceMotion($scope.playVideoNum); break;
            case 2 : $scope.startDeviceMotion($scope.playVideoNum); break;
            case 3 : $scope.video1.play(); break;
            case 4 : $scope.startDeviceMotion($scope.playVideoNum); break;
        }
    }
    /** 영상 리셋  */
    $scope.resetVideo = function (){
        if($scope.isVideo0Loaded){
            $scope.video0.currentTime(0);
            $scope.video0.pause();
        }
    }
    
    /**  시퀀스 영상 재생  */
    $scope.sequenceTogglePlay = function (){
        if(commonSvc.isTweening()) return;
        var nowSection = commonSvc.sectionIdxCheck();

        /** 같은 섹션인지 체크, 리턴 or 리셋    */
        if($scope.playVideoNum == nowSection) return;
        else $scope.resetSequence();
        /** 영상 섹션이 아닌 경우 리턴 */
        if(nowSection > 4){ $scope.playVideoNum = -1; return; }
        /** 비디오 준비가 안된 경우 리턴    */
        if(nowSection == 0 && !$scope.isVideo0Loaded) return;
        if(nowSection == 3 && !$scope.isVideo1Loaded) return;

        $scope.playVideoNum = nowSection;
        /** 서브 한번 재생된 경우 리턴 */
        if($scope.played[$scope.playVideoNum] == true) return;
        if($scope.playVideoNum != 0) $scope.played[$scope.playVideoNum] = true;

        var currentSeqArr = [];
        switch ($scope.playVideoNum){
            case 0 : currentSeqArr = $scope.seqArr0; break;
            case 1 : $scope.startDeviceMotion($scope.playVideoNum); break;
            case 2 : $scope.startDeviceMotion($scope.playVideoNum); break;
            case 3 : currentSeqArr = $scope.seqArr1; break;
            case 4 : $scope.startDeviceMotion($scope.playVideoNum); break;
        }

        if($scope.playVideoNum == 0 || $scope.playVideoNum == 3){
            var videoIdx = $scope.playVideoNum;
            if(videoIdx == 3) videoIdx = 1;
            $scope.videoPlayInterval = setInterval(function(){
                $scope.playFrame++;
                $("#video"+(videoIdx)).attr("src", $(currentSeqArr[$scope.playFrame]).attr("src"));
                if($scope.playFrame >= $scope.seqTotalFramesArr[videoIdx]){
                    clearInterval($scope.videoPlayInterval);
                    $scope.playFrame = 0;
                    return;
                }
            },$scope.fps);
        }
    }
    /** 시퀀스 리셋  */
    $scope.resetSequence = function (){
        if($scope.playVideoNum != 3){
            clearInterval($scope.videoPlayInterval);
            $scope.playFrame = 0;
            $("#video0").attr("src", $($scope.seqArr0[0]).attr("src"));
        }
    }
    
    /** 서브 섹션 디바이스 모션    */
    $scope.startDeviceMotion = function (idx){
        if($scope.isIe8) return;
        switch(idx){
            case 1 : 
                TweenMax.to($(".balloon1"), 1.25, {delay:0.5, opacity:1, ease:"Cubic.easeOut"});
                TweenMax.to($(".balloon1 img"), 1.25, {delay:0.5, height:"100%", ease:"Elastic.easeOut", onStart:function(){
                    TweenMax.to($(".balloon1 .txt1"), 0.5, {delay:0.65, opacity:1, "margin-top":25, ease:"Cubic.easeOut", onStart:function(){
                        setTimeout(function(){
                            if($scope.playVideoNum == 1) RandomText.single(".balloon1 .txt3", "바람 강함", 25, false, 2);
                            else $(".balloon1 .txt3").text("바람 강함");
                        },500);
                    }});
                    TweenMax.to($(".balloon1 .txt2"), 0.5, {delay:0.75, opacity:1, "margin-top":0, ease:"Cubic.easeOut"});
                }});
                TweenMax.to($(".balloon2"), 1.25, {delay:2, opacity:1, ease:"Cubic.easeOut"});
                TweenMax.to($(".balloon2 img"), 1.25, {delay:2, height:"100%", ease:"Elastic.easeOut", onStart:function(){
                    TweenMax.to($(".balloon2 .txt1"), 0.5, {delay:0.65, opacity:1, "margin-top":66, ease:"Cubic.easeOut", onStart:function(){
                        setTimeout(function(){
                            if($scope.playVideoNum == 1) RandomText.single(".balloon2 .txt2", "미세먼지 나쁨", 25, false, 2);
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
                    if($scope.playVideoNum == 2) RandomText.single(".indicator1 p", "기념일 정보", 45, false, 2);
                    else $(".indicator1 p").text("기념일 정보");
                }});
                TweenMax.to($(".indicator2 div"), 0.75, {delay:2.2, height:110+per*60, ease:"Cubic.easeOut", onComplete:function(){
                    if($scope.playVideoNum == 2) RandomText.single(".indicator2 p", "축제 정보", 45, false, 2);
                    else $(".indicator2 p").text("축제 정보");
                }});
                break;
            case 4 : 
                TweenMax.to($(".section5 .device2"), 0.75, {delay:0.5, opacity:1, rotation:0, ease:"Cubic.easeOut"});
                TweenMax.to($(".section5 .device3"), 0.75, {delay:0.75, opacity:1, rotation:0, ease:"Cubic.easeOut"});
                break;
        }

    }
    $scope.resetDeviceMotion = function (){
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
}











