

var weatherAppServices = angular.module("weatherApp.services", []);

weatherAppServices.value('appName','weatherApp')
.factory('commonSvc', [function () {
    
    function screenHeight(){
        var zoomLevel = document.documentElement.clientWidth / window.innerWidth,
            wHeight = window.innerHeight * zoomLevel;
        return wHeight;
    }
    
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
                windowHeight = screenHeight();
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
        },
        /** 메인 타이틀 & 화살표 버튼 위치  */
        mainTitleSetting: function (){
            var wHeight = screenHeight();
            var contentsHeight = $(".section1 .contents").height();
            if(wHeight > 665){
                $("#container .section1 .btn_arrow").css({"bottom":"auto", "top":wHeight-80+"px"});
            }else{
                $("#container .section1 .btn_arrow").css({"top":"auto", "bottom":"40px"});
            }
        },
        /** SNS 공유 열기 닫기    */
        showHideSnsPopup: function (){
            if($(".popup_sns").css("display") == "none"){
                $(".popup_sns").css({"display":"block"});
            }else{
                $(".popup_sns").css({"display":"none"});
            }
        },
        /** URL카피 팝업 열기 닫기    */
        showHideCopyPopup: function (){
            showHideCopyPopup();
        },
        /** 윈도우 높이값 */
        screenHeight: function(){
            var wHeight = screenHeight();
            return wHeight;
        }
    }
}])







