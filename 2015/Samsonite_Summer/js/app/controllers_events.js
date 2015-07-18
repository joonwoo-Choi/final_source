

var samsoniteAppEventsControllers = angular.module("samsoniteApp.eventsControllers", []);

samsoniteAppEventsControllers.
controller("journeysCtrl", ["$rootScope","$scope","devSvc","ytplayerSvc", "$timeout", function ($rootScope, $scope, devSvc, ytplayerSvc, $timeout) {
    initEventsCtrl($scope);
    
    /** 서브버튼 리스너    */
    $scope.$on("btnEvt:journeysSubActive", function(e, args){
        
        if($scope.subNum == 0){
            if($scope.eventOn) $scope.eventReset();
            $scope.eventOn = true;
            if($scope.galleryOn) $scope.galleryReset();
        }else{
            $scope.galleryOn = true;
            $scope.galleryResize();
            $scope.galleryListLoad();
            if($scope.eventOn) $scope.eventReset();
        }
        if(args.quick) $scope.myMoviePlay($scope.galleryIdx);
        $(".journeys-cont>ul>li").removeClass("on");
        $($scope.journeysPageArr[$scope.subNum]).addClass("on");
        $(".journeys-cont").css({"height":$(".event-cont").height()+"px"});
        $("#footer img").attr({"src":"images/common/img_footer_journeys.jpg"});
        $rootScope.$broadcast("globalEvt:resize");
    });
    
    eventCtrl($rootScope, $scope, devSvc, ytplayerSvc);
    galleryCtrl($rootScope, $scope, devSvc, $timeout);
}]);

/** 이벤트 컨트롤러 설정 */
function initEventsCtrl($scope){
    $scope.eventOn = false;
    $scope.galleryOn = false;
    $scope.eventStepArr = $(".event-process>li");
    $scope.journeysPageArr = $(".journeys-cont>ul>li");
    $scope.isEventPopup = false;
    $scope.eventProcessIdx = -1;
    $scope.selectedFilmIdx = -1;
    $scope.isFilmPreview = false;
    $scope.makerName = "";
    $scope.isLoadedPopup = false;
    $scope.filmList = [
        {title:"Flame Orange 꿈"},
        {title:"Aqua Blue 자유"},
        {title:"Matt Silver 도전"},
        {title:"Fancy Purple 영감"}
    ];
    if(navigator.userAgent.match(/(iphone)|(ipod)|(ipad)/i)){
        $scope.btnGetImgList = [
            {idx:0, class:"btn-get-fb", title:"페이스북 이미지 가져오기", src:"images/journeys/event/btn_get_img0.png"},
            {idx:2, class:"btn-get-gall", title:"갤러리에서 이미지 가져오기", src:"images/journeys/event/btn_get_img2.png"}
        ];
    }else{
        $scope.btnGetImgList = [
            {idx:0, class:"btn-get-fb", title:"페이스북 이미지 가져오기", src:"images/journeys/event/btn_get_img0.png"},
            {idx:1, class:"btn-get-gram", title:"인스타그램 이미지 가져오기", src:"images/journeys/event/btn_get_img1.png"},
            {idx:2, class:"btn-get-gall", title:"갤러리에서 이미지 가져오기", src:"images/journeys/event/btn_get_img2.png"}
        ];
    }
    $scope.galleryListIdx = -1;
    $scope.myimgList = [];
    $scope.loadedImgList = [];
    $scope.loadedListType = "";
    $scope.loadedImgSelectList = [];
    $scope.previewTaget = null;
    $scope.previewLength = 0;
}

/** 이벤트 페이지 컨트롤러    */
function eventCtrl($rootScope, $scope, devSvc, ytplayerSvc){
    $scope.$on("btnEvt:gnbActive", function(e, args){
        if($scope.pageNum == 4) $scope.eventOn = true;
        else if($scope.pageNum != 4 && $scope.eventOn) $scope.eventReset();
    });
    /** 이벤트 페이지 메인 버튼 핸들러   */
    $scope.eventHandler = function(idx){
        switch(idx){
            case 0 :
//                if(!location.href.match(/test/gi)){
//                    alert("True Journeys 이벤트는 7월 6일에 오픈됩니다.\n이벤트 참여하고 해외여행 기회를 잡으세요.");
//                    return;
//                }
                $rootScope.$broadcast("btnEvt:goGallery");
                break;
            case 1 :
//                if(!location.href.match(/test/gi)){
//                    alert("True Journeys 이벤트는 7월 6일에 오픈됩니다.\n이벤트 참여하고 해외여행 기회를 잡으세요.");
//                    return;
//                }
                if($scope.isAppBrowser){
                    $(".popup-browser").fadeIn(500);
                    return;
                }
                $(".popup-title-wrap").css({"display":"block"});
                $scope.eventStepProcess(1);
                break;
            case 2 :
                $(".popup-title-wrap").css({"display":"none"});
                $scope.eventStepProcess(0);
                break;
        }
    }
    /** 이벤트 프로세스 진행 */
    $scope.eventStepProcess = function(idx){
        window.scrollTo(0,0);
        $scope.isEventPopup = true;
        $scope.eventProcessIdx = idx;
        if($(".popup-cont").css("display") == "none") $(".popup-cont").fadeIn(500);
        $(".event-process>li").removeClass("on");
        $($scope.eventStepArr[idx]).addClass("on");
        
        if(idx>0){
            $(".step-navi li").removeClass("on");
            $(".step-navi li").eq(idx-1).addClass("on");
        }
        
        if(!$scope.bgm.paused) $scope.movieStop();
        $scope.eventResize();
    }
    
    $scope.eventResize = function(){
        if($scope.isEventPopup){
            if($scope.isLoadedPopup){
                $(".journeys-cont").css({"height":$(window).height()+"px"});
            }else{
                var height = $($scope.eventStepArr[$scope.eventProcessIdx]).height()+$($scope.eventStepArr[$scope.eventProcessIdx]).offset().top;
                $(".journeys-cont").css({"height":height+"px"});
            }
        }else{
            $(".journeys-cont").css({"height":$(".event-cont").height()+"px"});
        }
        $rootScope.$broadcast("globalEvt:resize");
    }
    
    /** 이벤트 및 자세히 보기 팝업 닫기  */
    $scope.popupClose = function(){
        window.scrollTo(0,0);
        if($scope.isLoadedPopup){
            $scope.isLoadedPopup = false;
            $scope.loadedImgList = [];
            $scope.loadedImgSelectList = [];
            $scope.loadedListType = "";
            $("#footer").css({"display":"block"});
            $(".popup-title-wrap").css({"display":"block"});
            $(".popup-loadedimg-list").fadeOut(500);
            $("#header").fadeIn(500);
            $scope.eventResize();
            return;
        }
        $scope.isEventPopup = false;
        $scope.isFilmPreview = false;
        $scope.selectedFilmIdx = -1;
        $scope.myimgList = [];
        $scope.loadedImgList = [];
        $scope.loadedImgSelectList = [];
        $scope.makerName = "";
        $scope.loadedListType = "";
        $scope.eventProcessIdx = -1;
        
        if(!$scope.bgm.paused) $scope.movieStop();
        ytplayerSvc.journeysPlayer.stop();
        $(".step1 .film-list li").removeClass("on");
        $(".step-navi li").removeClass("on");
        $("input").val("");
        $("#input-check").attr("checked",false);
        $(".popup-cont").fadeOut(500);
        $(".select-wrap").css({"display":"block"});
        if($(".film-preview").css("display") == "block") $(".film-preview").fadeOut(500);
        if($(".popup-loadedimg-list").css("display") == "block") $(".popup-loadedimg-list").fadeOut(500);
        $(".event-process>li").removeClass("on");
        $scope.eventResize();
    }
    /** 이벤트 페이지 리셋  */
    $scope.eventReset = function(){
        
        $scope.eventOn = false;
        $scope.isLoadedPopup = false;
        if($(".popup-cont").css("display") == "block") $scope.popupClose();
    }
    
    eventCtrlStep1($scope, ytplayerSvc);
    eventCtrlStep2($scope, devSvc);
    eventCtrlStep3($scope, devSvc);
    eventCtrlStep4($scope, devSvc);
}
/** 이벤트 프로세스    */
function eventCtrlStep1($scope, ytplayerSvc){
//    $scope.$on("ytEvt:play", function(e, args){
//        if(args.status == 5){
//            $("#jouneysPlayer").css({"opacity":0});
//            return;
//        }
//        if(args.status == 3 && args.videoType == "journeys"){
//            $("#jouneysPlayer").css({"opacity":1});
//        }
//    });
    /** step1 - 필름 선택 */
    $scope.filmListHandler = function(idx){
        
        $scope.selectedFilmIdx = idx;
        $scope.isFilmPreview = true;
        ytplayerSvc.journeysPlayer.play(idx);
        $(".step1 .film-list li").removeClass("on");
        $(".step1 .film-list li").eq($scope.selectedFilmIdx).addClass("on");
        setTimeout(function(){
            $(".select-wrap").css({"display":"none"});
//            $("#jouneysPlayer").css({"opacity":0});
            $(".jouneys-cover").css({"display":"block"});
            $(".film-preview").fadeIn(500);
            $scope.eventResize();
        },650);
    }
    $scope.jouneysPlayStart = function(){
//        alert("4인 4색의 True Story는 추후 공개됩니다. 기대해주세요.");
//        ytplayerSvc.journeysPlayer.start();
//        $(".jouneys-cover").fadeOut(500);
    }
    /** step1 - 필름 선택 체크 및 진행   */
    $scope.videoSelectedCheck = function(idx){
        $scope.isFilmPreview = false;
        ytplayerSvc.journeysPlayer.stop();
        $(".select-wrap").css({"display":"block"});
        if(idx == 0){
            $(".film-preview").fadeOut(500);
            $scope.eventResize();
        }else{
            $(".film-preview").css({"display":"none"});
            $scope.eventStepProcess(2);
        }
    }
}
function eventCtrlStep2($scope, devSvc){
    /** step2 - 이미지 가져오기 선택 버튼  */
    $scope.getMakeMovieImg = function(idx){
        if(idx != undefined) $scope.galleryListIdx = idx;
        
        if(!$scope.isLoadedPopup){
            $scope.isLoadedPopup = true;
            
            $(".popup-loadedimg-list .title-wrap li").css({"display":"none"});
            if(idx == 0){
                $(".popup-loadedimg-list .title-wrap li").eq(0).css({"display":"block"});
            }else{
                $(".popup-loadedimg-list .title-wrap li").eq(1).css({"display":"block"});
            }
            
            $(".popup-title-wrap").css({"display":"none"});
            $("#footer").css({"display":"none"});
            $("#header").fadeOut(500);
            $(".popup-loadedimg-list").fadeIn(500);
            $scope.eventResize();
        }
        switch($scope.galleryListIdx){
            case 0:
                devSvc.getFbList(function(loadedList, listType){
                    $scope.$apply(function(){
                        $scope.loadedListType = listType;
                        $scope.loadedImgList = $scope.loadedImgList.concat(loadedList);
                    });
                });
                break;
            case 1:
                devSvc.getInstaList(function(loadedList, listType){
                    $scope.$apply(function(){
                        $scope.loadedListType = listType;
                        $scope.loadedImgList = $scope.loadedImgList.concat(loadedList);
                    });
                });
                break
            case 2:
                devSvc.getPhotoList(function(loadedList, listType){
                    $scope.$apply(function(){
                        $scope.loadedListType = listType;
                        $scope.loadedImgList = $scope.loadedImgList.concat(loadedList);
                    });
                });
                break;
        }
    }
    $scope.$watch(function(){
        return $(".myimg-list-wrap li").length;
    }, function(newVal, oldVal){
        if(newVal === oldVal) return;
        for(var i=0, len=newVal; i<len; i++){
            if(i>=oldVal) TweenMax.to($(".myimg-list-wrap li").eq(i), 0, {delay:(i-oldVal)*0.08, className:"+=add"});
        }
    });
    /** step2 - 사용자 이미지 목록 이미지 선택   */
    $scope.selectloadedImg = function(idx){
        if($(".myimg-list-wrap li").eq(idx).hasClass("checked")){
            var i=$scope.loadedImgSelectList.length-1, len=0, cIdx;
            for(; i>=len; i--){
                cIdx = $scope.loadedImgSelectList[i].idx;
                if(cIdx == $scope.loadedImgList[idx].idx && $scope.loadedListType) $scope.loadedImgSelectList.splice(i,1);
            }
            $(".myimg-list-wrap li").eq(idx).removeClass("checked");
        }else{
            if($scope.myimgList.length+$scope.loadedImgSelectList.length>=5){
                alert("이미지는 최대 5장까지 선택 가능합니다.");
                return;
            }
            var i=0, len=$scope.myimgList.length, cIdx, type, isPush=false;
            if(len>0){
                $scope.loadedImgList[idx].idx = idx;
                for(; i<len; i++){
                    cIdx = $scope.myimgList[i].idx;
                    type = $scope.myimgList[i].type;
                    if(cIdx == $scope.loadedImgList[idx].idx && type == $scope.loadedListType){
                        alert("이미 선택된 이미지입니다.");
                        return;
                    }
                }
                $scope.loadedImgSelectList.push($scope.loadedImgList[idx]);
                $(".myimg-list-wrap li").eq(idx).addClass("checked");
            }else{
                $scope.loadedImgList[idx].idx = idx;
                $scope.loadedImgSelectList.push($scope.loadedImgList[idx]);
                $(".myimg-list-wrap li").eq(idx).addClass("checked");
            }
        }
    }
    /** step2 - 이미지 선택 완료   */
    $scope.selectComplete = function(){
        $.each($scope.loadedImgSelectList, function(i) {
            $scope.loadedImgSelectList[i].type = $scope.loadedListType;
            
        });
        $scope.loadedImgSelectList.sort(function(a, b){
            return a.idx - b.idx;
        });
        $scope.myimgList = $scope.myimgList.concat($scope.loadedImgSelectList);
        $scope.popupClose();
    }
    /** step2 - 업로드 이미지 미리보기 위치 설정  */
    $scope.$watch(function(){
        return $(".selected-wrap li").length;
    }, function(newVal, oldVal){
        if (newVal === oldVal) return;
        $scope.previewLength = newVal;
        var arr = $(".selected-wrap li");
        $scope.previewListSort(arr);
    });
    $scope.previewListSort = function(arr){
        var imgW = 198;
        var imgH = 200;
        var i=0, len=arr.length;
        for(; i<len; i++){
            $(arr[i]).css({
                "top":(imgH+3)*Math.floor(i/3)+"px",
                "left":(imgW+3)*(i%3)+"px"
            });
        }
    }
    /** step2 - 업로드 이미지 선택 취소 */
    $scope.cancelSelectedImg = function(idx){
        $scope.myimgList.splice(idx,1);
    }
    
    /** step2 - 선택 이미지 리스트 순서 정렬    */
    $(".selected-wrap").on("touchstart", "li", function(e){
        $scope.previewTaget = $(this);
        $(this).addClass("selected");
    });
    $(".selected-wrap").on("touchmove", function(e){
        if($scope.previewTaget == null) return;
        e.preventDefault();
        var point = $scope.getTouchPoint(e);
        $scope.movePreviewThumb(point);
        var listIdx = $scope.getListIdx(point);
    });
    $(".selected-wrap").on("touchend", function(e){
        if($scope.previewTaget == null) return;
        var point = $scope.getTouchPoint(e);
        var listIdx = $scope.getListIdx(point);
        var arr = $(".selected-wrap li");
        var targetIdx = $scope.previewTaget.index();
        if(listIdx != targetIdx){
            var list = arr[targetIdx];
            arr.splice(targetIdx, 1);
            arr.splice(listIdx, 0, list);
            setTimeout(function(){
                $scope.$apply(function(){
                    var list = $scope.myimgList[targetIdx];
                    $scope.myimgList.splice(targetIdx, 1);
                    $scope.myimgList.splice(listIdx, 0, list);
                })
            },350);
        }
        $scope.previewListSort(arr);
        
        $scope.previewTaget = null;
        $(".selected-wrap li").removeClass("selected");
    });
    $scope.movePreviewThumb = function(point){
        $scope.previewTaget.css({"top":(point.y-$scope.previewTaget.height()/2)+"px", "left":(point.x-$scope.previewTaget.width()/2)+"px"});
    }
    $scope.getTouchPoint = function(e){
        var point = utils.pointerEventToXY(e);
        var listW = parseInt($scope.previewTaget.width()/2);
        var listH = parseInt($scope.previewTaget.height()/2);
        var wrapW = $(".selected-wrap").width();
        var wrapH = $(".selected-wrap").height();
        var wrapX = $(".selected-wrap").offset().left;
        var wrapY = $(".selected-wrap").offset().top;
        point.x = parseInt(point.x - wrapX);
        point.y = parseInt(point.y - wrapY);
        if(point.x <= listW) point.x = listW;
        else if(point.x+listW >= wrapW) point.x = wrapW-listW;
        if(point.y <= listH) point.y = listH;
        else if(point.y+listH >= wrapH) point.y = wrapH-listH;
        
        return point;
    }
    $scope.getListIdx = function(point){
        var idx=0;
        var wrapW = $(".selected-wrap").width();
        var wrapH = $(".selected-wrap").height();
        if(point.x >= wrapW*0.33 && point.x < wrapW*0.66) idx = 1;
        else if(point.x >= wrapW*0.66) idx = 2;
        if(point.y >= wrapH*0.5) idx = idx+3;
        if(idx >= $scope.myimgList.length) idx = $scope.myimgList.length-1;
        
        return idx;
    }
    
    /** 이전 / 다음 버튼 핸들러  */
    $scope.prevStep = function(){
        $scope.eventStepProcess($scope.eventProcessIdx-1);
    }
    $scope.makeMovieCheck = function(makerName){
        
        if(makerName == ""){
            alert("이름을 입력해주세요.");
            return;
        }else if($scope.myimgList.length < 5){
            alert("이미지를 5장 선택해주세요.");
            return;
        }
        
        /** 유저 영상 저장    */
        $(".loader").fadeIn(350);
        devSvc.saveUserMovie(makerName, $scope.myimgList, function(){
            $scope.eventStepProcess(3);
            $scope.setUserMovie(makerName, $scope.myimgList);
        });
    }
}
/** step3 - 제작 영상 플레이   */
function eventCtrlStep3($scope, devSvc){
    $scope.makeSceneList = [];
    $scope.director = "";
    $scope.movieType = "";
    
    $scope.setUserMovie = function(makerName, myimgList){
        $scope.makeSceneList.length = 0;
        $scope.director = makerName;
        
        switch(Number($scope.selectedFilmIdx)){
            case 0 : $scope.movieType = "silver"; break;
            case 1 : $scope.movieType = "blue"; break;
            case 2 : $scope.movieType = "purple"; break;
            case 3 : $scope.movieType = "orange"; break;
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
            myimgList[0].src,
            myimgList[1].src,
            "images/journeys/gallery/"+$scope.movieType+"/img_scene6.jpg",
            myimgList[2].src,
            myimgList[3].src,
            "images/journeys/gallery/"+$scope.movieType+"/img_scene7.jpg",
            myimgList[4].src,
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
                        $scope.makeSceneList = sceneList;
                        $(".loader").fadeOut(350);
                        $(".step3 .btn-play-wrap").css({"display":"block", "background-image":"url("+myimgList[0].src+")"});
                    });
                }
            });
        }
        
    }
    $scope.$watch(function(){
        return $(".step3 .omnibus-film li").length;
    }, function(newVal, oldVal){
        $(".step3 .omnibus-film li:first-child p").text($scope.director);
        var imgW = 0;
        var imgH = 0;
        
        setTimeout(function(){
            for(var i=0; i<newVal; i++){
                if(i==6||i==7||i==9||i==10||i==12){
                    $(".step3 .omnibus-film li").eq(i).css({"background-image":"url(images/journeys/gallery/"+$scope.movieType+"/img_bg.jpg)"});
                    imgW = $(".step3 .omnibus-film li img").eq(i).width();
                    imgH = $(".step3 .omnibus-film li img").eq(i).height();
                    if((imgW/imgH) >= 1.33){
                        $(".step3 .omnibus-film li img").eq(i).css({"width":"100%", "height":"auto"});
                        $(".step3 .omnibus-film li img").eq(i).css({
                            "margin-top":-($(".step3 .omnibus-film li img").eq(i).height()/2)+"px"
                        });
                    }else{
                        $(".step3 .omnibus-film li img").eq(i).css({"margin-left":-imgW/2+"px"});
                    }
                }
            }
        },100);
    });

    $scope.moviePlay = function(){
        $(".step3 .btn-play-wrap").fadeOut(500);
        $scope.bgm.play();
        var sceneArr = $(".step3 .omnibus-film li");

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

    $scope.movieStop = function(){
        $scope.bgm.currentTime = 0;
        $scope.bgm.pause();
        $scope.makeSceneList.length = 0;
    }
}
/** step4 - 개인인정보 입력 팝업 */
function eventCtrlStep4($scope, devSvc){
    /** 인증번호 요청    */
    $scope.requestCertification = function(user){
        devSvc.requestCertification(user);
    }
    /** 인증번호 입력 */
    $scope.inputCertification = function(user){
        devSvc.inputCertification(user);
    }
    /** 공유 - 폼 검사   */
    $scope.validateForm = function(user){
        devSvc.validateForm(user);
    }
}



/** 갤러리 페이지 컨트롤러    */
function galleryCtrl($rootScope, $scope, devSvc, $timeout){
    $scope.galleryList = [];
    $scope.listRandomSize = [
        [
            {width:"295px", height:"364px"}, {width:"295px", height:"177px"}, {width:"295px", height:"177px"}, {width:"600px", height:"331px"}, 
            {width:"295px", height:"230px"}, {width:"295px", height:"230px"}, {width:"295px", height:"177px"}, {width:"295px", height:"364px"}, 
            {width:"295px", height:"177px", top:1140}, {width:"600px", height:"331px"}
        ],
        [
            {width:"295px", height:"230px"}, {width:"295px", height:"230px"}, {width:"295px", height:"177px"}, {width:"295px", height:"364px"}, 
            {width:"295px", height:"177px", top:2097}, {width:"600px", height:"331px"}, {width:"295px", height:"364px"}, {width:"295px", height:"364px"}, 
            {width:"295px", height:"230px"}, {width:"295px", height:"230px"}
        ],
        [
            {width:"600px", height:"331px"}, {width:"295px", height:"177px"}, {width:"295px", height:"364px"}, {width:"295px", height:"177px", top:3767}, 
            {width:"295px", height:"230px"}, {width:"295px", height:"230px"}, {width:"295px", height:"364px"}, {width:"295px", height:"177px"}, 
            {width:"295px", height:"177px"}, {width:"600px", height:"331px"}
        ],
        [
            {width:"295px", height:"177px"}, {width:"295px", height:"364px"}, {width:"295px", height:"177px", top:5096}, {width:"600px", height:"331px"}, 
            {width:"600px", height:"331px"}, {width:"295px", height:"364px"}, {width:"295px", height:"364px"}, {width:"295px", height:"364px"}, 
            {width:"295px", height:"177px"}, {width:"295px", height:"177px"}
        ],
        [
            {width:"295px", height:"364px"}, {width:"295px", height:"364px"}, {width:"295px", height:"230px"}, {width:"295px", height:"230px"}, 
            {width:"295px", height:"364px"}, {width:"295px", height:"177px"}, {width:"295px", height:"177px"}, {width:"295px", height:"230px"}, 
            {width:"295px", height:"230px"}, {width:"600px", height:"331px"}
        ]
    ];
    
    $scope.$on("btnEvt:gnbActive", function(e, args){
        if($scope.pageNum != 4 && $scope.galleryOn) $scope.galleryReset();
    });
    
    $scope.$on("globalEvt:scroll", function(e, args){
        if(!$scope.galleryOn) return;
        var scrollTop = $(window).scrollTop();
        if(scrollTop+$(window).height() >= $(".journeys-cont").height()+55) $scope.galleryListLoad();
    });
    
    $scope.scrollToTop = function(){
        $("html, body").stop().animate({"scrollTop":0}, 1000);
    }
    
    /** 갤러리 리스트 로드  */
    $scope.galleryListLoad = function(){
        devSvc.getGalleryList(function(loadedList){
            $scope.$apply(function(){
                $scope.galleryList = $scope.galleryList.concat(loadedList);
                console.log("dddddddddddddd", $(".list-wrap li img").length);
            });
        });
    }
    /** 갤러리 리스트 상태 감지   */
    $scope.sizeCnt = 0;
    $scope.$watch(function(){
        return $(".list-wrap li img").length;
    }, function(newVal, oldVal){
        if(newVal === oldVal || !$scope.galleryOn) return;
        var cnt = 0;
        var target = null;
        for(var i=0, len=newVal; i<len; i++){
            target = $(".list-wrap li").eq(i);
            if(i>=oldVal){
                target.css({"width":$scope.listRandomSize[$scope.sizeCnt%5][cnt].width, "height":$scope.listRandomSize[$scope.sizeCnt%5][cnt].height});
                if($scope.listRandomSize[$scope.sizeCnt%5][cnt].top != undefined){
                    target.addClass("abs").css({"top":($scope.listRandomSize[$scope.sizeCnt%5][cnt].top+(8282*Math.floor($scope.sizeCnt/5)))+"px"});
                }
                $(".list-wrap li img").eq(i).load(function(){
                    var idx = $(this).parent().parent().index();
                    if($(this).height() < $(".list-wrap li").eq(idx).height()){
                        $(this).css({"width":"auto", "height":"100%"});
                        $(this).css({
                            "margin-left":($(".list-wrap li").eq(idx).width()-$(this).width())/2 + "px"});
                    }else{
                        $(this).css({
                            "margin-top":($(".list-wrap li").eq(idx).height()-$(this).height())/2 + "px"});
                    }
                });
                TweenMax.to(target, 0, {delay:(i-oldVal)*0.05, className:"+=on"});
                cnt++;
            }
        }
        $scope.sizeCnt++;
        $scope.galleryResize();
    });
    
    $scope.galleryListHandler = function(idx){
        $rootScope.$broadcast("btnEvt:showPopupPlayer", $scope.galleryList[idx]);
    }
    
    $scope.myMoviePlay = function(idx){
        window.getMovieInfo(idx, function(response){
            $rootScope.$broadcast("btnEvt:showPopupPlayer", response);
        });
        
    }
    
    $scope.galleryResize = function(){
        if($(".gallery-cont .cont-wrap").height()+$("#header").height()>1000){
            $(".journeys-cont").css({"height":$(".gallery-cont .cont-wrap").height()+$("#header").height()+"px"});
        }else{
            $(".journeys-cont").css({"height":"1000px"});
        }
        $rootScope.$broadcast("globalEvt:resize");
    }
    
    $scope.galleryReset = function(){
        
        $scope.galleryOn = false;
        $scope.galleryList = [];
        $scope.sizeCnt = 0;
    }
}




function getMovieInfo(idx, callback) {
    var obj = {
			"idx":14346903764904127,
			"name":"1234",
			"phone":"000-0000-0000",
			"agree":null,
			"movieType":"2",
			"director":"1234123",
			"imageName1":"https://scontent.xx.fbcdn.net/hphotos-xtf1/v/t1.0-9/11407072_702031166590541_2911068119815025247_n.jpg?oh=98bb1d7616353b857fad06368533948d&oe=562AA49C",
			"imageName2":"https://scontent.xx.fbcdn.net/hphotos-xft1/v/t1.0-9/11392924_702031089923882_5034430578415468030_n.jpg?oh=e6a0bd86b5caee812111eea183168fac&oe=56263485",
			"imageName3":"https://fbcdn-sphotos-f-a.akamaihd.net/hphotos-ak-xpf1/v/t1.0-9/10524679_702031086590549_2485096550962053194_n.jpg?oh=48cba28881eb7662b967d0d7b6af996a&oe=55F631BE&__gda__=1441628628_97602fe31b3e502760d0f933494d9afd",
			"imageName4":"https://fbcdn-sphotos-d-a.akamaihd.net/hphotos-ak-xft1/v/t1.0-9/11391155_702031083257216_8130548368291253548_n.jpg?oh=ecc6538abd24b699a26e9a6d71128f99&oe=56231B85&__gda__=1441163535_e0728966ef7ce34094a97f8b60015136",
			"imageName5":"https://fbcdn-sphotos-g-a.akamaihd.net/hphotos-ak-xat1/v/t1.0-9/11401298_702031056590552_1741714809576115641_n.jpg?oh=6063c429cad4ec3526c54f1913d3d0b5&oe=55F39B06&__gda__=1442122201_3d0801c72b23dce28082fcd980710558",
			"regDate":"2015-06-19 14:06:30.0",
			"ip":"127.0.0.1",
			"shareUrl":"1234",
			"facebookUrl":"https://www.facebook.com/123412341234/posts/123412341234",
			"agent":"W",
			"displayYN":null
		}
    callback(obj);
}














