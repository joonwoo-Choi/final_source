

var samsoniteAppControllers = angular.module("samsoniteApp.controllers", []);

samsoniteAppControllers.
controller("bodyCtrl", ["$scope", "config", "commonSvc", function ($scope, config, commonSvc) {
    $scope.appName = config.appName;
    $scope.isAppBrowser = config.isAppBrowser();
    $scope.lowDevice = navigator.userAgent.match(/(shv)|(samsung)/gi) ? true : false;
    $scope.tmplLoadedCnt = 0;
    $scope.pageNum = -1;
    $scope.subNum = 0;
    $scope.isMain = false;
    $scope.pageChanging = false;
    $scope.pageArr = [];
    $scope.pageLength = 0;
    $scope.startPos = {};
    $scope.pageW = 0;
    $scope.trueColorIdx = -1;
    $scope.galleryIdx = -1;
    $scope.Math = window.Math;
    $scope.bgm;
    
    $scope.$on("tmpl:loaded", function(args){
        $scope.tmplLoadedCnt++;
        if($scope.tmplLoadedCnt >= 3){
            initSamsoniteApp($scope, commonSvc);
            $scope.$broadcast("globalEvt:resize");
        }
    });
}]).
controller("headerCtrl", ["$rootScope", "$scope", "commonSvc", function ($rootScope, $scope, commonSvc) {
    $scope.utilMenuList = [ {title:"온라인 몰", url:"http://www.samsonite.co.kr/SA/store/"}, 
                           {title:"매장안내", url:"http://m.samsonitemall.co.kr/"}, 
                           {title:"페이스북", url:"https://www.facebook.com/KoreaSamsonite"}, 
                           {title:"블로그", url:"http://blog.naver.com/samsoniter"} ];
    $scope.gnbList = [ {idx:1, title:"True Colors"}, {idx:2, title:"True Story"}, {idx:3, title:"True Frame"}, {idx:4, title:"True Journeys"} ];
    $scope.colorsBtnList = [ {idx:1, title:"TVCF"}, {idx:2, title:"Travel Story Film"} ];
    $scope.storyBtnList = [ {idx:1, title:"Orange"}, {idx:2, title:"Blue"}, {idx:3, title:"Purple"}, {idx:4, title:"Silver"} ];
    $scope.journeysBtnList = [ {idx:1, title:"Event"}, {idx:2, title:"Gallery"} ];
    
    $scope.$on("btnEvt:colorsPageChange", function(e, args) {
        $scope.$parent.subNum = args.idx;
        $scope.subHandler($scope.subNum);
    });
    /** 이벤트 페이지 갤러리 보기  */
    $scope.$on("btnEvt:goGallery", function(e, args) {
        $scope.subHandler(1);
    });
    
    $scope.$on("btnEvt:quickLink", function(e, args) {
        $scope.gnbHandler(args.idx, args.sub, args.quick);
    });
    
    $scope.$on("btnEvt:storyPageChange", function(e, args) {
        $scope.subHandler(args.idx);
    });
    
    $scope.gnbHandler = function(idx, subIdx, quick){
        if($scope.pageChanging) return;
//        if(idx == 2){
//            alert("4인 4색의 True Story는 7월 6일에 공개됩니다. 기대해주세요.");
//            return;
//        }
        
        window.scrollTo(0,0);
        $scope.$parent.pageNum = idx;
        $scope.$parent.subNum = -1;
        
        $(".gnb li a").removeClass("on");
        if(idx != 0) $(".gnb li a").eq(idx-1).addClass("on");
        if(idx == 1){
            $(".gnb-2depth-wrap").removeClass("story-on");
            $(".gnb-2depth-wrap").removeClass("journeys-on");
        }
        else if(idx == 2){
            $(".gnb-2depth-wrap").addClass("story-on");
            $(".gnb-2depth-wrap").removeClass("journeys-on");
        }else if(idx == 4){
            $(".gnb-2depth-wrap").addClass("journeys-on");
            $(".gnb-2depth-wrap").removeClass("story-on");
        }else{
            $(".gnb-2depth-wrap").removeClass("story-on");
            $(".gnb-2depth-wrap").removeClass("journeys-on");
            $(".gnb-2depth").removeClass("on");
        }
        $rootScope.$broadcast("btnEvt:gnbActive", {idx:idx});
        if(idx == 1 || idx == 2 || idx == 4){
            if(!$(".gnb-2depth").hasClass("on")) $(".gnb-2depth").addClass("on");
            if(subIdx == undefined) subIdx = 0;
            $scope.subHandler(subIdx, quick);
        }else{
            $scope.$parent.pageChanging = true;
            setTimeout(function(){
                $scope.$parent.pageChanging = false;
            },2000);
        }
    }
    $scope.subHandler = function(idx, quick){
        if($scope.pageChanging) return;
//        if($scope.pageNum == 4 && idx == 1 && !location.href.match(/test/gi)){
//            alert("True Journeys 이벤트는 7월 6일에 오픈됩니다.\n이벤트 참여하고 해외여행 기회를 잡으세요.");
//            return;
//        }
        window.scrollTo(0,0);
        $scope.$parent.subNum = idx;
        $scope.$parent.pageChanging = true;
        setTimeout(function(){
            $scope.$parent.pageChanging = false;
        },2000);
        
        $(".gnb-2depth li a").removeClass("on");
        switch($scope.pageNum){
            case 1 :
                $(".gnb-2depth .colors li a").eq(idx).addClass("on");
                $rootScope.$broadcast("btnEvt:colorsSubActive", {idx:idx});
                break;
            case 2 :
                if(idx != 0) $(".gnb-2depth .story li a").eq(idx-1).addClass("on");
                $rootScope.$broadcast("btnEvt:storySubActive", {idx:idx, quick:quick});
                break;
            case 4 :
                $(".gnb-2depth .journeys li a").eq(idx).addClass("on");
                $rootScope.$broadcast("btnEvt:journeysSubActive", {idx:idx, quick:quick});
                break;
        }
    }
    
}]).
controller("containerCtrl", ["$rootScope", "$scope", "commonSvc", function ($rootScope, $scope, commonSvc) {
    $scope.$on("globalEvt:resize", function(e, args) {
        
        var wHeight = commonSvc.screenHeight();
        $(".contents").css({"height":$($scope.pageArr[$scope.pageNum]).height()+"px"});
        $scope.$parent.pageW = $(".contents").width();
    });
    
    $scope.$on("btnEvt:gnbActive", function(e, args){
        var pageNum = $scope.pageNum;
        for(var i=0; i<$scope.pageLength; i++){
            if(i == pageNum){
                $($scope.pageArr[i]).removeClass("left right").addClass("view");
            }else{
                if(i > pageNum){
                    $($scope.pageArr[i]).removeClass("view left").addClass("right");
                }else if(i < pageNum){
                    $($scope.pageArr[i]).removeClass("view right").addClass("left");
                }
            }
        }
        $rootScope.$broadcast("globalEvt:resize");
    });
    
    $scope.popupBrowserClose = function(){
        $(".popup-browser").fadeOut(500);
    }
    
    $scope.popupTvcfClose = function(){
        $(".popup-tvcf").fadeOut(500);
    }
    $scope.goEventMain = function(){
        if($scope.pageChanging) return;
        $rootScope.$broadcast("btnEvt:quickLink", {idx:4});
        $(".popup-tvcf").fadeOut(500);
    }
}]).
controller("mainCtrl", ["$rootScope", "$scope", "commonSvc", function ($rootScope, $scope, commonSvc) {
    $scope.mainVideo = document.getElementById("mainVideo"); 
    $scope.btnMovieList = [ 
        {idx:4, title:"Flame Orange 모델 박슬기의 꿈"}, 
        {idx:2, title:"Aqua Blue 뮤지션 마이큐의 자유"}, 
        {idx:1, title:"Matt Silver 작가 김이나의 추억"}, 
        {idx:3, title:"Fancy Purple 셰프 맹기용의 영감"} 
    ];
    $scope.btnQuickList = [ 
        {idx:5, title:"TVCF 스토리 보기"}, 
        {idx:6, title:"Tru-Frame 보기"}
    ];
    
    $scope.$on("btnEvt:gnbActive", function(e, args){
        if($scope.pageNum != 0) $scope.stopMainMovie();
        else $("#footer img").attr({"src":"images/common/img_footer_main.jpg"});
    });
    
    $(".main-cont").bind("transitionend webkitTransitionEnd", function(){
        if($scope.pageNum == 0){
            if(!$(".main-cont").hasClass("on")){
                $(".main-cont").removeClass("off");
                $(".main-cont").addClass("on");
            }
        }else{
            if($(".main-cont").hasClass("on")){
                $(".main-cont").removeClass("on");
                $(".main-cont").addClass("off");
            }
        }
    });
    
    $scope.playMainMovie = function(){
        $scope.mainVideo.currentTime = 0;
        $scope.mainVideo.play();
        $(".main-cont .player-wrap").fadeIn(500);
    }
    
    $scope.stopMainMovie = function(){
        $scope.mainVideo.pause();
        $(".main-cont .player-wrap").fadeOut(500);
    }
    
    angular.element($scope.mainVideo).on("pause ended", function(){
        $(".main-cont .player-wrap").fadeOut(500);
    });
    
    $scope.mainBtnHandler = function(idx){
        if(idx < 5){
            $rootScope.$broadcast("btnEvt:quickLink", {idx:2, sub:idx, quick:true});
        }else{
            var param = (idx == 5) ? {idx:1} : {idx:3} ;
            $rootScope.$broadcast("btnEvt:quickLink", param);
        }
    }
}]).
controller("colorsCtrl", ["$rootScope", "$scope", "ytplayerSvc", "devSvc", function ($rootScope, $scope, ytplayerSvc, devSvc) {
    $scope.colorCoverList = $scope.tvcfBtnList = [ 
        {title:"4 Color Full ver."}, {title:"Matt Silver Aqua Blue"}, {title:"Fancy Purple Flame Orange"} 
    ];
    $scope.filmCoverList = $scope.filmBtnList = [ 
        {title:"Flame Orange"}, {title:"Aqua Blue "}, {title:"Matt Silver"}, {title:"Fancy Purple"}
    ];
    $scope.videoIdx = 0;
    $scope.isColors = false;
    $scope.autoPlay = true;
    $scope.startPos = null;
    $scope.nowScroll = 0;
    
    $scope.$on("ytEvt:play", function(e, args){
        if(args.status == 5){
            $("#tvcfPlayer").css({"opacity":0});
            $("#filmPlayer").css({"opacity":0});
            return;
        }
        if(args.status == 3){
            if(args.videoType == "tvcf"){
                $("#tvcfPlayer").css({"opacity":1});
            }else if(args.videoType == "film"){
                $("#filmPlayer").css({"opacity":1});
            }
        }
    });
    
    $scope.$on("btnEvt:gnbActive", function(e, args){
        if($scope.pageNum == 1){
            $scope.isColors = true;
            $(".colors-pages .cont-tvcf").addClass("set");
            $(".colors-pages .cont-film").addClass("set");
            $(".colors-cont .btn-swipe0, .colors-cont .btn-swipe1").css({"display":"block"});
            $(".tvcf-cover li, .film-cover li").css({"display":"none"});
            $(".tvcf-cover li").eq(0).css({"display":"block"});
            $(".film-cover li").eq(0).css({"display":"block"});
            $("#footer img").attr({"src":"images/common/img_footer_tvcf.jpg"});
            setTimeout(function(){
                $(".colors-cont .btn-swipe0, .colors-cont .btn-swipe1").fadeOut(500);
            },2000);
        }else{
            if(!$scope.isColors) return;
            $scope.isColors = false;
            $scope.tvcfStop();
            $scope.filmStop();
            $scope.videoIdx = 0;
            $(".colors-pages .cont-tvcf").addClass("set");
            $(".colors-pages .cont-film").addClass("set");
        }
    });
    
    $scope.$on("btnEvt:colorsSubActive", function(e, args){
        
        $scope.autoPlay = true;
        $scope.nowScroll = 0;
        $(".colors-pages>li").removeClass("on");
        $(".colors-pages>li").eq($scope.subNum).addClass("on");
        if($(".colors-pages .cont-tvcf").hasClass("set")) $(".colors-pages .cont-tvcf").removeClass("set");
        if($(".colors-pages .cont-film").hasClass("set")) $(".colors-pages .cont-film").removeClass("set");
        
        if($scope.subNum == 0){
            $(".colors-pages .cont-tvcf").removeClass("out");
            $(".colors-pages .cont-film").addClass("out");
        }else{
            $(".colors-pages .cont-tvcf").addClass("out");
            $(".colors-pages .cont-film").removeClass("out");
        }
        $(".colors-title>img").attr({"src":"images/colors/txt_title"+$scope.subNum+".png"})
        $scope.tvcfStop();
        $scope.filmStop();
    });
    
    $(".colors-cont").bind("transitionend webkitTransitionEnd", function(){
        if($scope.pageNum != 1 && !$scope.isColors) return;
        /** 메뉴 변경 - 트랜지션 후 재생   */
        if($scope.autoPlay){
            $scope.autoPlay = false;
            setTimeout(function(){
                $scope.videoPlayCheck();
            },750);
        }
    });
    
    $(".colors-pages").bind("touchstart", function(e){
        if($scope.pageChanging) return;
        $scope.startPos = $scope.getTouchPoint(e);
        $scope.nowScroll = $(window).scrollTop();
    });
    $(".colors-pages").bind("touchmove", function(e){
        e.preventDefault();
        var point = $scope.getTouchPoint(e);
        var movePosY = $scope.nowScroll+($scope.startPos.y-point.y)/2;
        
        window.scrollTo(0, movePosY);
    });
    $(".colors-pages").bind("touchend", function(e){
        if($scope.pageChanging || $scope.startPos == null) return;
        var point = $scope.getTouchPoint(e);
        var idx = $scope.videoIdx;
        var movePos = point.x-$scope.startPos.x;
        if(movePos<-150) idx++;
        else if(movePos>150) idx--;
        
        if(idx < 0) idx = 0;
        if($scope.subNum == 0){
            if(idx > 2) idx = 2;
            if(idx != $scope.videoIdx) $scope.tvcfPlay(idx);
        }else{
            if(idx > 3) idx = 3;
            if(idx != $scope.videoIdx) $scope.filmPlay(idx);
        }
        $scope.videoIdx = idx;
        
        $scope.startPos = null;
        $(".colors-pages>li").removeAttr("style");
        $(".colors-pages>li").removeClass("down");
    });
    
    $scope.getTouchPoint = function(e){
        var point = utils.pointerEventToXY(e);
        return point;
    }
    
    $scope.videoPlayCheck = function(){
        if($scope.trueColorIdx > -1){
            if($scope.trueColorIdx >= 3) $scope.videoIdx = $scope.trueColorIdx-3;
            else $scope.videoIdx = $scope.trueColorIdx;
            $scope.$parent.trueColorIdx = -1;
            
        }else{
            $scope.videoIdx = 0;
        }
        if($scope.subNum == 0){
            $scope.filmStop();
            $scope.tvcfPlay($scope.videoIdx);
        }else{
            $scope.tvcfStop();
            $scope.filmPlay($scope.videoIdx);
        }
    }
    
    $scope.tvcfPlay = function(idx){
        $scope.videoIdx = idx;
        $scope.tvcfStop();
        $("#tvcfPlayer").css({"opacity":0});
        ytplayerSvc.tvcfPlayer.play(idx);
        $(".cont-tvcf .thumbnail-wrap li").eq(idx).addClass("on");
        $(".tvcf-cover li").css({"display":"none"});
        $(".tvcf-cover li").eq($scope.videoIdx).css({"display":"block"});
    }
    
    $scope.tvcfPlayStart = function(idx){
        if($scope.pageChanging) return;
        ytplayerSvc.tvcfPlayer.start();
        $(".tvcf-cover li").eq(idx).fadeOut(500);
    }
    
    $scope.tvcfStop = function(){
        ytplayerSvc.tvcfPlayer.stop();
        $(".cont-tvcf .thumbnail-wrap li").removeClass("on");
    }
    
    $scope.filmPlay = function(idx){
        $scope.videoIdx = idx;
        $scope.filmStop();
        $("#filmPlayer").css({"opacity":0});
        ytplayerSvc.filmPlayer.play(idx);
        $(".cont-film .thumbnail-wrap li").eq(idx).addClass("on");
        $(".film-cover li").css({"display":"none"});
        $(".film-cover li").eq($scope.videoIdx).css({"display":"block"});
    }
    
    $scope.filmPlayStart = function(idx){
        if($scope.pageChanging) return;
        ytplayerSvc.filmPlayer.start();
        $(".film-cover li").eq(idx).fadeOut(500);
    }
    
    $scope.filmStop = function(){
        ytplayerSvc.filmPlayer.stop();
        $(".cont-film .thumbnail-wrap li").removeClass("on");
    }
    
    $scope.shareFb = function(){
        /** 2페이지일 경우 idx+3 후 값 전달   */
        var idx = $scope.videoIdx;
        if($scope.subNum == 1) idx = idx+3;
        devSvc.shareYoutubeMovie(idx);
    }
    
}]).
controller("storyCtrl", ["$rootScope", "$scope", "ytplayerSvc", "devSvc", function ($rootScope, $scope, ytplayerSvc, devSvc) {
    $scope.storyBtnList = [{title:"Matt Silver"}, {title:"Aqua Blue"}, {title:"Fancy Purple"}, {title:"Flame Orange"}];
    
    $scope.$on("btnEvt:gnbActive", function(e, args){
        if($scope.pageNum == 2){
            
        }else{
            $(".story-cont>ul>li").removeClass("on");
            $(".story-cont>ul>li").eq(0).addClass("on");
            $(".story-cont").css({"height":$(".story-cont>ul>li").eq(0).height()+"px"});
        }
        if($(".story-cont .player-bg").css("display") == "block"){
            ytplayerSvc.storyPlayer.stop();
            $(".story-cont .player-bg").css({"display":"none"});
        }
    });
    
    $scope.$on("btnEvt:storySubActive", function(e, args){
        
        $scope.pageChange($scope.subNum, args.quick);
        $("#footer img").attr({"src":"images/common/img_footer_story"+$scope.subNum+".jpg"});
    });
    
    $scope.pageChange = function(idx, quick){
        $(".story-cont>ul>li").removeClass("on");
        $(".story-cont>ul>li").eq(idx).addClass("on");
        $(".story-cont").css({"height":$(".story-cont>ul>li").eq(idx).height()+"px"});
        if(idx > 0) $(".story-cont .player-bg").css({"display":"block"});
        if(idx > 0) ytplayerSvc.storyPlayer.play(idx-1);
        $(".story-cont>ul>li").each(function(i, el){
            if($(this).hasClass("on")){
                $(this).css({"z-index":1});
            }else{
                $(this).css({"z-index":0});
            }
        });
        if(quick){
            setTimeout(function(){
                $rootScope.$broadcast("globalEvt:resize");
            }, 1500);
        }else{
            $rootScope.$broadcast("globalEvt:resize");
        }
    }
    
    $scope.storyBtnHandler = function($idx){
        $rootScope.$broadcast("btnEvt:storyPageChange", {idx:$idx});
    }
    
    $scope.shareFb = function(idx){
    }
    
}]).
controller("frameCtrl", ["$rootScope", "$scope", "commonSvc", function ($rootScope, $scope, commonSvc) {
    $scope.productIdx = -1;
    $scope.listIdx = -1;
    $scope.startPos = null;
    $scope.nowScroll = 0;
    $scope.productList = [
        {title:"Matt Silver 1"}, {title:"Matt Silver 2"}, {title:"Matt Silver 3"}, {title:"Matt Silver 4"},
        {title:"Aqua Blue 1"}, {title:"Aqua Blue 2"}, {title:"Aqua Blue 3"}, {title:"Aqua Blue 4"},
        {title:"Fancy Purple 1"}, {title:"Fancy Purple 2"}, {title:"Fancy Purple 3"}, {title:"Fancy Purple 4"},
        {title:"Flame Orange 1"}, {title:"Flame Orange 2"}, {title:"Flame Orange 3"}, {title:"Flame Orange 4"},
        {title:"Matt Graphite 1"}, {title:"Matt Graphite 2"}, {title:"Matt Graphite 3"}, {title:"Matt Graphite 4"}
    ];
    $scope.btnProductList = [
        {title:"Matt Silver", color:"Silver"}, {title:"Aqua Blue", color:"Blue"}, {title:"Fancy Purple", color:"Purple"}, 
        {title:"Flame Orange", color:"Orange"}, {title:"Matt Graphite", color:"Graphite"}
    ];
    
    $scope.$on("btnEvt:gnbActive", function(e, args){
        if($scope.pageNum == 3){
            $scope.productIdx = -1;
            $scope.listIdx = -1;
            $("#footer img").attr({"src":"images/common/img_footer_frame.jpg"});
            $scope.changeProductList(0);
        }else{
            $(".product-cont li").addClass("set right");
            $(".product-cont li").eq(0).removeClass("right").addClass("on");
            $(".product-cont li").removeClass("set");
            $(".btn-bullet-wrap li").removeClass("on");
            $(".btn-bullet-wrap li").eq(0).addClass("on");
        }
    });
    
    $scope.swipeHandler = function(dir){
        var idx = $scope.productIdx;
        if(dir == 0){
            idx--;
        }else{
            idx++;
        }
        $scope.productListChange(idx);
    }
    
    $(".frame-cont").on("touchstart", function(e){
        if($scope.lowDevice) return;
        $scope.startPos = $scope.getTouchPoint(e);
        $scope.nowScroll = $(window).scrollTop();
        $(".product-cont li").addClass("set");
    });
    $(".frame-cont").on("touchmove", function(e){
        if($scope.lowDevice) return;
        e.preventDefault();
        var point = $scope.getTouchPoint(e);
        var movePos = (point.x-$scope.startPos.x)/12;
        var movePosY = $scope.nowScroll+($scope.startPos.y-point.y)/2;
        
        window.scrollTo(0, movePosY);
        $(".product-cont li").eq($scope.productIdx).css({"left":movePos+"px"});
//        $(".product-cont li").eq($scope.productIdx).css({"-webkit-transform":"translateX("+(movePos)+"px)", "transform":"translateX("+(movePos)+"px)"});
    });
    $(".frame-cont").on("touchend", function(e){
        if($scope.lowDevice) return;
        var point = $scope.getTouchPoint(e);
        var idx = $scope.productIdx;
        var movePos = point.x-$scope.startPos.x;
        if(movePos<-125){
            idx++;
        }else if(movePos>125){
            idx--;
        }
        
        $scope.productListChange(idx);
    });
    
    $scope.productListChange = function(idx){
        if(idx<0) idx = $(".product-cont li").length-1;
        else if(idx>$(".product-cont li").length-1) idx = 0;
        
        $scope.startPos = null;
        $(".product-cont li").removeAttr('style');
        if(idx != $scope.productIdx){
            $scope.changeProductList(idx);
        }else{
            $(".product-cont li").removeClass("set");
        }
    }
    
    $scope.getTouchPoint = function(e){
        var point = utils.pointerEventToXY(e);
        return point;
    }
    
    $scope.bulletHandler = function(idx){
        $scope.changeProductList(idx*4);
    }
    
    $scope.changeProductList = function(idx){
        $(".product-cont li").removeClass("set right left on");
        var i=0, len = $(".product-cont li").length;
        if($scope.lowDevice){
            $(".product-cont li").css({"display":"none", "opacity":0});
            $(".product-cont li").eq(idx).css({"display":"block", "opacity":1});
        }else{
            for(; i < len; i++){
                if(i == idx){
                    $(".product-cont li").eq(i).addClass("on");
                }else if(i < idx){
                    if(i == $scope.productIdx) $(".product-cont li").eq(i).addClass("left");
                    else $(".product-cont li").eq(i).addClass("set left");
                }else{
                    if(i == $scope.productIdx) $(".product-cont li").eq(i).addClass("right");
                    else $(".product-cont li").eq(i).addClass("set right");
                }
            }
        }
        $scope.productIdx = idx;
        
        var tmpListIdx = Math.floor(idx/4);
        if($scope.listIdx != tmpListIdx){
            $scope.listIdx = tmpListIdx;
            $(".btn-bullet-wrap li").removeClass("on");
            $(".btn-bullet-wrap li").eq($scope.listIdx).addClass("on");
        }
    }
    
    $scope.frameBtnHandler = function(idx){
        if(idx == 0){
            var url = "";
            switch($scope.listIdx){
                case 0 : url = "http://m.samsonitemall.co.kr/mobile/display/showDisplay.lecs?goodsNo=SS00014927&optionCode=25"; break;
                case 1 : url = "http://m.samsonitemall.co.kr/mobile/display/showDisplay.lecs?goodsNo=SS00014926&optionCode=31"; break;
                case 2 : url = "http://m.samsonitemall.co.kr/mobile/display/showDisplay.lecs?goodsNo=SS00014929&optionCode=50"; break;
                case 3 : url = "http://m.samsonitemall.co.kr/mobile/display/showDisplay.lecs?goodsNo=SS00014925&optionCode=60"; break;
                case 4 : url = "http://m.samsonitemall.co.kr/mobile/display/showDisplay.lecs?goodsNo=SS00014928&optionCode=28"; break;
            }
            window.open(url);
        }else{
            if($scope.listIdx == 4){
                alert("영상이 준비되어 있지 않습니다.\n다른 네가지 컬러의 영상을 감상해주세요.");
            }else{
                switch($scope.listIdx){
                    case 0 : $scope.$parent.trueColorIdx = 5; break;
                    case 1 : $scope.$parent.trueColorIdx = 4; break;
                    case 2 : $scope.$parent.trueColorIdx = 6; break;
                    case 3 : $scope.$parent.trueColorIdx = 3; break;
                }
                $rootScope.$broadcast("btnEvt:quickLink", {idx:1, sub:1});
            }
            
        }
        
    }
    
}]).
controller("popupPlayerCtrl", ["$rootScope", "$scope", "commonSvc", function ($rootScope, $scope, commonSvc) {
    $scope.sceneList = [];
    $scope.director = "";
    $scope.movieType = "";
    
    $scope.$on("btnEvt:showPopupPlayer", function(e, args){
        $scope.director = args.director;
        
        switch(Number(args.movieType)){
            case 0 : 
                $scope.movieType = "silver"; 
                $(".popup-player .btn-wrap").css({"background-color":"rgba(193,191,192,0.5)"});
                break;
            case 1 : 
                $scope.movieType = "blue"; 
                $(".popup-player .btn-wrap").css({"background-color":"rgba(117,204,214,0.5)"});
                break;
            case 2 : 
                $scope.movieType = "purple"; 
                $(".popup-player .btn-wrap").css({"background-color":"rgba(127,66,126,0.5)"});
                break;
            case 3 : 
                $scope.movieType = "orange"; 
                $(".popup-player .btn-wrap").css({"background-color":"rgba(184,90,47,0.5)"});
                break;
        }
        $scope.bgm.type = 'audio/mpeg';
        $scope.bgm.src = "snd/snd_"+$scope.movieType+".mp3";
        $scope.bgm.pause();
        $scope.bgm.load();
        
        var sceneList = [
            "images/journeys/gallery/"+$scope.movieType+"/img_scene0.jpg",
            "images/journeys/gallery/"+$scope.movieType+"/img_scene1.jpg",
            "images/journeys/gallery/"+$scope.movieType+"/img_scene2.jpg",
            "images/journeys/gallery/"+$scope.movieType+"/img_scene3.jpg",
            "images/journeys/gallery/"+$scope.movieType+"/img_scene4.jpg",
            "images/journeys/gallery/"+$scope.movieType+"/img_scene5.jpg",
            args.imageName1,
            args.imageName2,
            "images/journeys/gallery/"+$scope.movieType+"/img_scene6.jpg",
            args.imageName3,
            args.imageName4,
            "images/journeys/gallery/"+$scope.movieType+"/img_scene7.jpg",
            args.imageName5,
            "images/journeys/gallery/"+$scope.movieType+"/img_scene8.jpg",
            "images/journeys/gallery/"+$scope.movieType+"/img_scene9.jpg",
            "images/journeys/gallery/"+$scope.movieType+"/img_scene10.jpg"
        ];
        
        $(".loader").fadeIn(350);
        
        var loadedCnt = 0;
        for(var i=0; i<sceneList.length; i++){
            var img = new Image();
            img.src = sceneList[i];
            
            $(img).bind("load", function(){
                loadedCnt++;
                if(loadedCnt==sceneList.length){
                    $scope.$apply(function(){
                        $scope.sceneList = sceneList;
                        $(".loader").fadeOut(350);
                        $(".popup-player").fadeIn(500);
                        $(".popup-player .btn-wrap").css({"display":"block"});
                    });
                }
            });
        }
    });
    
    $scope.$watch(function(){
        return $(".popup-player .omnibus-film li").length;
    }, function(newVal, oldVal){
        $(".popup-player .omnibus-film li:first-child p").text($scope.director);
        var imgW = 0;
        var imgH = 0;
        
        setTimeout(function(){
            for(var i=0; i<newVal; i++){
                if(i==6||i==7||i==9||i==10||i==12){
                    $(".popup-player .omnibus-film li").eq(i).css({
                        "background-image":"url(images/journeys/gallery/"+$scope.movieType+"/img_bg.jpg)"});
                    var target = $(".popup-player .omnibus-film li img").eq(i);
                    imgW = target.width();
                    imgH = target.height();
                    if((imgW/imgH) >= 1.33){
                        if(imgW < 586) target.css({"width":"100%", "height":"auto"});
                        target.css({"left":"50%", "margin-left":-(target.width()/2)+"px", "top":"50%", "margin-top":-(target.height()/2)+"px"});
                    }else{
                        target.css({"margin-left":-imgW/2+"px"});
                    }
                }
            }
        }, 100);
    });
    
    $scope.goEvent = function(idx){
        if(idx == 15) {
            $scope.moviePopupClose();
            $rootScope.$broadcast("btnEvt:quickLink", {idx:4});
        }
    }
    
    $scope.moviePopupClose = function(){
        $(".popup-player").fadeOut(500);
        $scope.bgm.currentTime = 0;
        $scope.bgm.pause();
        $scope.sceneList.length = 0;
    }
    
    $scope.moviePlay = function(){
        $(".popup-player .btn-wrap").fadeOut(500);
        $scope.bgm.play();
        var sceneArr = $(".popup-player .omnibus-film li");
        
        var _tl = new TimelineLite();
        var zoomInSpeed = 5;
        var userImgSpeed = 0.8;
        
        $(sceneArr[15]).css({"display":"none"});
        _tl.to($(sceneArr[0]), zoomInSpeed, {scale:1.1, ease:Linear.easeNone});
        
        var cntSpeed = 0.6, cntGap = 0.35, cntInterval = cntSpeed + cntGap;
        _tl.addLabel("start", 2);
        _tl.add( [TweenLite.to($(sceneArr[0]), cntSpeed, {opacity:0}), TweenLite.to($(sceneArr[1]), cntSpeed, {opacity:1})], "start+="+cntGap );
        _tl.add( [TweenLite.to($(sceneArr[1]), cntSpeed, {opacity:0}), TweenLite.to($(sceneArr[2]), cntSpeed, {opacity:1})], "start+="+cntInterval );
        _tl.add( [TweenLite.to($(sceneArr[2]), cntSpeed, {opacity:0}), TweenLite.to($(sceneArr[3]), cntSpeed, {opacity:1})], "start+="+(cntInterval*2) );
        _tl.add( [TweenLite.to($(sceneArr[3]), cntSpeed, {opacity:0}), TweenLite.to($(sceneArr[4]), cntSpeed, {opacity:1})], "start+="+(cntInterval*3) );
        _tl.add( [TweenLite.to($(sceneArr[4]), cntSpeed, {opacity:0}), TweenLite.to($(sceneArr[5]), cntSpeed, {opacity:1})], "start+="+(cntInterval*4) );

        _tl.to($(sceneArr[5]), zoomInSpeed, {scale:1.1, ease:Linear.easeNone}, "-="+cntSpeed);

        _tl.addLabel("user0", 8.5);
        _tl.to($(sceneArr[6]), userImgSpeed, {opacity:1}, "user0");
        _tl.to($(sceneArr[7]), userImgSpeed, {opacity:1}, "user0+=2");
        _tl.set($(sceneArr[6]), {opacity:0});

        _tl.to($(sceneArr[8]), cntSpeed, {opacity:1}, "+=2");
        _tl.to($(sceneArr[8]), zoomInSpeed, {scale:1.1, ease:Linear.easeNone}, "-="+cntSpeed);
        _tl.set($(sceneArr[7]), {opacity:0});

        _tl.addLabel("user2", 16);
        _tl.to($(sceneArr[9]), userImgSpeed, {opacity:1}, "user2");
        _tl.to($(sceneArr[10]), userImgSpeed, {opacity:1}, "user2+=2");
        _tl.set($(sceneArr[9]), {opacity:0});

        _tl.to($(sceneArr[11]), cntSpeed, {opacity:1}, "+=2");
        _tl.to($(sceneArr[11]), zoomInSpeed, {scale:1.1, ease:Linear.easeNone}, "-="+cntSpeed);
        _tl.set($(sceneArr[10]), {opacity:0});

        _tl.addLabel("user4", 23.5);
        _tl.to($(sceneArr[12]), userImgSpeed, {opacity:1}, "user4");

        _tl.to($(sceneArr[13]), 1, {opacity:1}, "user4+=2");
        
        _tl.to($(sceneArr[14]), 1, {opacity:1}, "+=1.2");
        _tl.set($(sceneArr[13]), {opacity:0});
        
        _tl.set($(sceneArr[15]), {display:"none"});
        _tl.to($(sceneArr[15]), 1, {display:"block", opacity:1, ease:Quad.easeInOut}, "+=1");
        _tl.call(function() {});
    }
}]).
controller("popupEvtCompleteCtrl", ["$rootScope", "$scope", "commonSvc", function ($rootScope, $scope, commonSvc) {
    $scope.goEventMain = function(){
        $rootScope.$broadcast("btnEvt:quickLink", {idx:4});
        $(".popup-event-complete").fadeOut(500);
    }
    $scope.goGalleryMain = function(){
        $rootScope.$broadcast("btnEvt:quickLink", {idx:4, sub:1});
        $(".popup-event-complete").fadeOut(500);
    }
}]);


/** init-app    */
function initSamsoniteApp($scope, commonSvc){
    $scope.pageArr = $(".contents>li");
    $scope.pageLength = $scope.pageArr.length;
    $scope.pageW = $(".contents").width();
    $scope.bgm = document.getElementById("bgm");
    
    var param = {idx:0};
    if(utils.netUtil.getParameterByName("p") != ""){
        param.idx = Number(utils.netUtil.getParameterByName("p"));
        if(param.idx == 1) $(".popup-tvcf").css({"display":"block"});
    }
    else if(utils.netUtil.getParameterByName("movieType") != ""){
        $scope.trueColorIdx = Number(utils.netUtil.getParameterByName("movieType"));
        param.idx = 1;
        if($scope.trueColorIdx <= 2) param.sub = 0;
        else param.sub = 1;
    }
    else if(utils.netUtil.getParameterByName("storyType") != ""){
        param.idx = 2;
        param.sub = Number(utils.netUtil.getParameterByName("storyType"));
        param.quick = true;
    }
    else if(utils.netUtil.getParameterByName("idx") != ""){
        $scope.galleryIdx = Number(utils.netUtil.getParameterByName("idx"));
        param.idx = 4;
        param.sub = 1;
        param.quick = true;
    }
    
    for(var i=0; i<$scope.pageLength; i++){
        $($scope.pageArr[i]).addClass("right");
    }
    $(".popup-player, .popup-event-complete, .loader").bind("touchmove", function(e){
        e.preventDefault();
    });
    
    setTimeout(function(){
        $scope.$broadcast("btnEvt:quickLink", param);
    },1000);
}











