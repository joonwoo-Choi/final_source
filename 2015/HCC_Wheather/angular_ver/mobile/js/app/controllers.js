

var weatherAppControllers = angular.module('weatherApp.controllers', []);

weatherAppControllers.controller('mainCtrl', ['$scope', 'appName', 'commonSvc', function ($scope, appName, commonSvc) {
    $scope.appName = appName;
    $scope.tmplLoadedCnt = 0;
    $scope.isTmplLoaded = false;
    $scope.$on('tmpl:loaded', function(args) {
        $scope.tmplLoadedCnt++;
        if($scope.tmplLoadedCnt>=3){
            console.log('templateLoadedComplate');
            $scope.isTmplLoaded = true;
            initWeatherApp($scope, commonSvc);
        }
    });
}])
.controller('headerCtrl', ['$scope', function ($scope) {
    $scope.$emit('tmpl:loaded');
    
    var menuList = [
        {idx:'1', title:'홈', class:'on', param:'0'},
        {idx:'2', title:'주요 서비스', class:'', param:'1'},
        {idx:'3', title:'앱 설치', class:'', param:'5'}
    ];
    $scope.menuList = menuList;
}])
.controller('containerCtrl', ['$scope', 'commonSvc', function ($scope, commonSvc) {
    $scope.$emit('tmpl:loaded');
    
    containerCtrl($scope, commonSvc);
}])
.controller('popupCtrl', ['$scope', 'commonSvc', function ($scope, commonSvc) {
    $scope.$emit('tmpl:loaded');

    var menuList = [
        {idx:0, title:'페이스북', class:'nm', src:'images/mobile/img_share_fb.png'},
        {idx:1, title:'트위터', class:'', src:'images/mobile/img_share_tw.png'},
        {idx:2, title:'카카오스토리', class:'', src:'images/mobile/img_share_ks.png'},
        {idx:3, title:'밴드', class:'nm', src:'images/mobile/img_share_band.png'},
        {idx:4, title:'카카오톡', class:'', src:'images/mobile/img_share_kt.png'},
        {idx:5, title:'라인', class:'', src:'images/mobile/img_share_line.png'},
        {idx:6, title:'메일', class:'nm', src:'images/mobile/img_share_sms.png'},
        {idx:7, title:'SMS', class:'sms', src:'images/mobile/img_share_txt.png'},
        {idx:8, title:'URL복사', class:'', src:'images/mobile/img_share_url.png'}
    ];
    $scope.menuList = menuList;
    
    $scope.showHideSnsPopup = function(){
        commonSvc.showHideSnsPopup();
    }
    $scope.utilMenuActivation = function(idx){
        commonSvc.utilMenuActivation(idx);
    }
    $scope.showHideCopyPopup = function(){
        commonSvc.showHideCopyPopup();
    }
}]);

/** init-app    */
function initWeatherApp($scope, commonSvc){
    /** 스크린 타입  */
    $scope.screenType = "";
    /** gnb */
    $scope.gnbArr = [];
    /** 섹션 배열   */
    $scope.sectionArr = $(".section1, .section2, .section3, .section4, .section5, .section6");
    /** 시퀀스 경로   */
    $scope.sequencePath = "images/mobile/sequence/video0/img_seq_";
    $scope.sequencePathAndroid = "images/mobile/sequence_android/video0/img_seq_";
    /** 시퀀스 배열  */
    $scope.isSeqLoaded = false;
    $scope.seqArr = [];
    /** 비디오 플레이 체크  */
    $scope.fps = 111;
    $scope.videoPlayCheck = true;
    $scope.playVideoNum = -1;
    $scope.videoPlayInterval;
    $scope.playFrame = 0;
    $scope.seqTotalFrames = 28;
    $scope.played = [false, false, false, false, false];
    $scope.resourceLoaded = false;
    
    if(navigator.userAgent.match(/(iphone)|(ipod)|(ipad)/i)){
        $(".section6 .btn_store_wrap .btn_down1").parent().css({"display":"block"});
        $(".section6 .btn_store_wrap .btn_down2").parent().css({"display":"none"});
        $(".section1 .btn_store_wrap .btn_down1").parent().css({"display":"block"});
        $(".section1 .btn_store_wrap .btn_down2").parent().css({"display":"none"});
        $(".section6 .btn_store_wrap p").text("iOS 6.0 버전 이상 지원");
        setTimeout(function(){ $(".sms").css({"display":"none"}) },33);
    }else{
        $(".section6 .btn_store_wrap .btn_down1").parent().css({"display":"none"});
        $(".section6 .btn_store_wrap .btn_down2").parent().css({"display":"block"});
        $(".section1 .btn_store_wrap .btn_down1").parent().css({"display":"none"});
        $(".section1 .btn_store_wrap .btn_down2").parent().css({"display":"block"});
        $(".section6 .btn_store_wrap p").text("Android 버전 출시예정");
        $(".seq_m").css({"height":"700px"});
        $scope.sequencePath = $scope.sequencePathAndroid;
    }
    
    /** 리소스로드 완료    */
    $(window).load(function(){
        $scope.resourceLoaded = true;
        initSequenceMovie();
        /** 시퀀스 로드 재귀 함수    */
        function initSequenceMovie(){
            var sequenceLoadedCount = 0;
            sequenceLoad($scope.sequencePath, $scope.seqTotalFrames, function(e){
                $(e.currentTarget).unbind("load");
                sequenceLoadedCount++;
                if(sequenceLoadedCount == $scope.seqTotalFrames){
                    $scope.isSeqLoaded = true;
                    $scope.$broadcast('video:videoTogglePlay');
                }
            });
        }
        /** 시퀀스 로드  */
        function sequenceLoad(src, totalFrames, _complete){
            var loadedCnt = 0;
            while(loadedCnt < totalFrames){
                var img = new Image();
                $scope.seqArr[loadedCnt] = img;
                $(img).bind("load", _complete);
                img.src = src+(loadedCnt+1)+".jpg";
                loadedCnt++;
            }
        }
    });
    
    /** global events   */
    $scope.$on('globalEvt:resize', function(args) {
        console.log('resize');
    });
    $scope.$on('globalEvt:scroll', function(args) {
        console.log('scroll');
        var scrollTop = $(window).scrollTop();
        var wHeight = commonSvc.screenHeight();
        if(scrollTop > wHeight) $(".btn_top").css({"display":"inline-block"});
        else $(".btn_top").css({"display":"none"});

        /** 영상 처리   */
        if($scope.videoPlayCheck) $scope.$broadcast('video:videoTogglePlay');
    });
    $scope.$on('globalEvt:orientationchange', function(args) {
        console.log('orientationchange');
        commonSvc.mainTitleSetting();
    });
    $scope.$on('globalEvt:touchmove', function(args) {
        console.log('touchmove');
    });
    
    commonSvc.mainTitleSetting();
    $scope.$broadcast('globalEvt:scroll');
}


function containerCtrl($scope, commonSvc){
    $scope.$on('video:videoTogglePlay', function(args) {
        videoTogglePlay();
    });
    resetDeviceMotion();
    
    /**  시퀀스 영상 재생  */
    function videoTogglePlay(){
        if(!$scope.resourceLoaded) return;
        var nowSection = commonSvc.sectionIdxCheck();

        /** 같은 섹션인지 체크, 리턴 or 리셋    */
        if($scope.playVideoNum == nowSection) return;

        $scope.playVideoNum = nowSection;
        /** 서브 한번 재생된 경우 리턴 */
        if($scope.played[$scope.playVideoNum] == true) return;
        if($scope.playVideoNum != 0) $scope.played[$scope.playVideoNum] = true;

        switch ($scope.playVideoNum){
            case 0 : startDeviceMotion($scope.playVideoNum); break;  
            case 1 : startDeviceMotion($scope.playVideoNum); break;  
            case 2 : startDeviceMotion($scope.playVideoNum); break;  
            case 3 : 
                /** 비디오 준비가 안된 경우 리턴    */
                if(!$scope.isSeqLoaded) return;

                $scope.videoPlayInterval = setInterval(function(){
                    $scope.playFrame++;
                    $(".section4 .viewer").attr("src", $($scope.seqArr[$scope.playFrame]).attr("src"));
                    if($scope.playFrame >= $scope.seqTotalFrames){
                        clearInterval($scope.videoPlayInterval);
                        $scope.playFrame = 0;
                        return;
                    }
                },$scope.fps);
                break;  
            case 4 : startDeviceMotion($scope.playVideoNum); break;  
        }
    }
    /** 비디오 리셋  */
    function resetVideo(){
        clearTimeout($scope.videoPlayInterval);
        $scope.playFrame = 0;
        $(".section4 .viewer").attr("src", $($scope.seqArr[0]).attr("src"));
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
                            if($scope.playVideoNum == 1) RandomText.single(".balloon1 .txt3", "바람 강함", 25, false, 2);
                            else $(".balloon1 .txt3").text("바람 강함");
                        },500);
                    }});
                    TweenMax.to($(".balloon1 .txt2"), 0.5, {delay:0.75, opacity:1, "margin-top":0, ease:"Cubic.easeOut"});
                }});
                TweenMax.to($(".balloon2"), 1.25, {delay:2, opacity:1, ease:"Cubic.easeOut"});
                TweenMax.to($(".balloon2 img"), 1.25, {delay:2, height:"100%", ease:"Elastic.easeOut", onStart:function(){
                    TweenMax.to($(".balloon2 .txt1"), 0.5, {delay:0.65, opacity:1, "margin-top":61, ease:"Cubic.easeOut", onStart:function(){
                        setTimeout(function(){
                            if($scope.playVideoNum == 1) RandomText.single(".balloon2 .txt2", "미세먼지 나쁨", 25, false, 2);
                            else $(".balloon2 .txt2").text("미세먼지 나쁨");
                        },250);
                    }});
                }});
                break;
            case 2 : 
                TweenMax.to($(".indicator1 div"), 0.75, {delay:0.5, height:$(".indicator1 img").height(), ease:"Cubic.easeOut", onComplete:function(){
                    if($scope.playVideoNum == 2) RandomText.single(".indicator1 p", "기념일 정보", 45, false, 2);
                    else $(".indicator1 p").text("기념일 정보");
                }});
                TweenMax.to($(".indicator2 div"), 0.75, {delay:2.5, height:$(".indicator2 img").height(), ease:"Cubic.easeOut", onComplete:function(){
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
    
    /** 섹션 이동   */
    $scope.changeSection = function (idx){
        $scope.videoPlayCheck = false;
        switch(idx){
            case 0 : 
                $("html, body").stop().animate({"scrollTop":0}, 1000, function(){ $scope.videoPlayCheck = true; });
                break;
            case 1 : 
            case 2 : 
            case 3 : 
            case 4 : 
                var movY = $($scope.sectionArr[idx]).offset().top;
                $("html, body").stop().animate({"scrollTop":movY+"px"}, 1000, function(){ $scope.videoPlayCheck = true; });
                break;
            case 5 : 
                var moveY = $(".section6").offset().top;
                $("html, body").stop().animate({"scrollTop":moveY+"px"}, 1000, function(){ $scope.videoPlayCheck = true; });
                break;
        }
    }
    /** SNS팝업 show/hide */
    $scope.showHideSnsPopup = function(){
        commonSvc.showHideSnsPopup();
    }
}











