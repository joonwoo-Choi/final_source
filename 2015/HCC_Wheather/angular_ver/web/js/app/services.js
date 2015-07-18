

var weatherAppServices = angular.module("weatherApp.services", []);

weatherAppServices.value('appName','weatherApp')
.factory('commonSvc', [function () {
    
    var isTweening = false,
        sectionCheckTimer;
    
    
    function showHideCopyPopup(){
        if($(".popup_copyurl").css("display") == "none") $(".popup_copyurl").css({"display":"block"});
        else $(".popup_copyurl").css({"display":"none"});
    }
    
    return{
        /** SNS 공유  */
        utilMenuActivation: function(idx){
            switch(idx){
                case 0 : 
                    social.shareOnFacebook("http://weather.hyundaicard.com/", "현대카드 웨더\nweather.hyundaicard.com/\n새로운 방법으로 날씨를 표현하는 현대카드의 날씨 정보서비스. 위트 있는 날씨 멘트와 감각적인 표현으로 현대카드만의 차별화된 날씨 정보를 제공합니다."); break;
                case 1 : 
                    social.shareOnTwitter("http://weather.hyundaicard.com/", "현대카드 웨더 – 새로운 방법으로 날씨를 표현하는 현대카드의 날씨 정보서비스. 위트 있는 날씨 멘트와 감각적인 표현으로 현대카드만의 차별화된 날씨 정보를 제공합니다."); break;
                case 2 : 
                    social.kakao.shareOnStory("http://weather.hyundaicard.com/", "현대카드 웨더", "새로운 방법으로 날씨를 표현하는 현대카드의 날씨 정보서비스. 위트 있는 날씨 멘트와 감각적인 표현으로 현대카드만의 차별화된 날씨 정보를 제공합니다.", ["http://weather.hyundaicard.com/images/img_scrap_122_v1.png"], function(){
                        alert("카카오스토리에 게시되었습니다.");
                    });
                    break;
                case 3 : 
                    social.shareOnBand("weather.hyundaicard.com/", "현대카드 웨더\n새로운 방법으로 날씨를 표현하는 현대카드의 날씨 정보서비스. 위트 있는 날씨 멘트와 감각적인 표현으로 현대카드만의 차별화된 날씨 정보를 제공합니다.\nweather.hyundaicard.com"); break;
                case 4 : 
                    social.kakao.shareOnTalk("weather.hyundaicard.com", "현대카드 웨더\n새로운 방법으로 날씨를 표현하는 현대카드의 날씨 정보서비스. 위트 있는 날씨 멘트와 감각적인 표현으로 현대카드만의 차별화된 날씨 정보를 제공합니다.", "weather.hyundaicard.com", "", 80, 80, "현대카드 웨더 다운받기");
                    break;
                case 5 : 
                    social.shareOnLine("weather.hyundaicard.com", "현대카드 웨더\n새로운 방법으로 날씨를 표현하는 현대카드의 날씨 정보서비스. 위트 있는 날씨 멘트와 감각적인 표현으로 현대카드만의 차별화된 날씨 정보를 제공합니다.\n"); break;
                case 6 : 
                    social.shareOnMail("", "", "현대카드 웨더\n새로운 방법으로 날씨를 표현하는 현대카드의 날씨 정보서비스. \n위트 있는 날씨 멘트와 감각적인 표현으로 현대카드만의 차별화된 날씨 정보를 제공합니다. \nweather.hyundaicard.com"); break;  
                case 7 : 
                    social.shareOnSMS("", "현대카드 웨더\n새로운 방법으로 날씨를 표현하는 현대카드의 날씨 정보서비스. 위트 있는 날씨 멘트와 감각적인 표현으로 현대카드만의 차별화된 날씨 정보를 제공합니다.\nweather.hyundaicard.com"); break;
                case 8 : 
                    showHideCopyPopup(); break;
            }
        },
        /** 섹션 번호 검사    */
        sectionIdxCheck: function(){
            var scrollTop = $(window).scrollTop(),
                wHeight = $(window).height();
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
        },
        /** SNS 공유 열기 닫기    */
        utilMenuShowHide: function (){
            if($(".util_menu ul").css("display") == "none") {
                $(".util_menu ul").css({"display":"block"});
                $(".toggle a").addClass("on");
            } else {
                $(".util_menu ul").css({"display":"none"});
                $(".toggle a").removeClass("on");
            }
        },
        /** URL카피 팝업 열기 닫기    */
        showHideCopyPopup: function (){
            showHideCopyPopup();
        },
        /** gnb 메뉴 변경   */
        changeMenu: function (idx){
            if(idx == 0){
                $("#header .navigation .gnb li").find("p").css({"color":"#fff"});
            }else{
                $("#header .navigation .gnb li").find("p").css({"color":"#333"});
                $("#header .navigation .gnb li").eq(idx-1).find("p").css({"color":"#f56565"});
            }
        },
        isTweening :function (){
            return isTweening;
        },
        /** 섹션 이동방향 체크  */
        moveSectionCheck: function (dir, sectionIdx, sectionLength){
            if(String(dir) == "down") {
                sectionIdx++;
                if(sectionIdx >= sectionLength - 1) sectionIdx = sectionLength - 1;
            }
            else if(String(dir) == "up"){
                sectionIdx--;
                if(sectionIdx <= 0) sectionIdx = 0;
            }
            
            return sectionIdx;
        },
        /** 섹션 이동   */
        changeSection: function (idx, callback, moveY){
            if(isTweening) return;
            isTweening = true;
            switch(idx){
                case 0 : 
                    $("html, body").stop().animate({"scrollTop":0}, 1000, function(){ isTweening=false; callback(); });
                    break;
                case 1 : 
                case 2 : 
                case 3 : 
                case 4 : 
                    $("html, body").stop().animate({"scrollTop":moveY+"px"}, 1000, function(){ isTweening=false; callback(); });
                    break;
                case 5 : 
                    moveY = $(".section6").offset().top;
                    $("html, body").stop().animate({"scrollTop":moveY+"px"}, 1000, function(){ isTweening=false; callback(); });
                    break;
            }
        },
        /** 섹션 자동이동 체크  */
        sectionCheck: function (sectionIdx){
            clearTimeout(sectionCheckTimer);
            if(isTweening) return;
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
        },
        /** 섹션 모션   */
        showSectionMotion: function (sectionIdx){
            /** 섹션 텍스트 등장 모션, 최초 한번만 실행  */
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
        },
        resizeHandler: function(){
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
    }
}])







