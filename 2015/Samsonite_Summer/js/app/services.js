

var samsoniteAppServices = angular.module("samsoniteApp.services", []);

samsoniteAppServices.
constant("config", {
    "appName":"samsoniteApp",
    "isAppBrowser":function(){
        var isAppBrowser = false;
        if(navigator.userAgent.match(/(daum)|(naver)|(crios)/gi)) isAppBrowser = true;
        return isAppBrowser;
    }
}).
factory("commonSvc", [function(){
    
    function screenHeight(){
        var zoomLevel = document.documentElement.clientWidth / window.innerWidth,
            wHeight = window.innerHeight * zoomLevel;
        return wHeight;
    }
    
    return {
        /** 윈도우 높이값 */
        screenHeight: function(){
            var wHeight = screenHeight();
            return wHeight;
        }
    };
}]).
factory("ytplayerSvc", ["$rootScope", function($rootScope){
    var isYoutubeApiLoad = false;
    var isPlayerReady = false;
    var readyCnt = 0;
    var youTubeTag = document.createElement('script');
    youTubeTag.src = "https://www.youtube.com/player_api";
    var firstScriptTag = document.getElementsByTagName('script')[0];
    firstScriptTag.parentNode.insertBefore(youTubeTag, firstScriptTag);
    
    var tvcfPlayer;
    var filmPlayer;
    var storyPlayer;
    var jouneysPlayer;
    var videoType = "";
    var plyListTvcf = ["es0fQfZR88w", "TCBpRPRqwtc", "cLWWXCUtaXc"];
    var plyListFilm = ["nR3toey3d8U", "PIP7zi1xGQM", "ism5slg6AZE", "13bywonEgAQ"];
    var plyListStory = ["WA6kL_R5WEk", "OCPyaJ2adj8", "jbPDAUtQl4I", "ZPff5slLb_U"];
    var plyListJourneys = ["WA6kL_R5WEk", "OCPyaJ2adj8", "jbPDAUtQl4I", "ZPff5slLb_U"];
    var playVars = {
            "controls":0,
            "rel":0,
            "autoplay":0,
            "showinfo":0,
            "feature":"player_detailpage",
            "wmode":"opaque"
        };
    
    window.onYouTubePlayerAPIReady = function() {
        isYoutubeApiLoad = true;
        tvcfPlayer = new YT.Player("tvcfPlayer", {
            width:586,
            height:330,
            videoId:"es0fQfZR88w",
            playerVars:playVars,
            events: {
                "onReady": onPlayerReady,
                "onStateChange": onPlayerStateChange
            }
        });
        filmPlayer = new YT.Player("filmPlayer", {
            width:586,
            height:330,
            videoId:"nR3toey3d8U",
            playerVars:playVars,
            events: {
                "onReady": onPlayerReady,
                "onStateChange": onPlayerStateChange
            }
        });
        storyPlayer = new YT.Player("storyPlayer", {
            width:586,
            height:344,
            videoId:"nR3toey3d8U",
            playerVars:playVars,
            events: {
                "onReady": onPlayerReady,
                "onStateChange": onPlayerStateChange
            }
        });
        jouneysPlayer = new YT.Player("jouneysPlayer", {
            width:600,
            height:338,
//            videoId:"ism5slg6AZE",
            playerVars:playVars,
            events: {
                "onReady": onPlayerReady,
                "onStateChange": onPlayerStateChange
            }
        });
    }
    
    function onPlayerReady(e){
        readyCnt++;
        e.target.seekTo(0);
        e.target.pauseVideo();
        
        if(readyCnt == 4){
            isPlayerReady = true;
        }
    }
    
    function onPlayerStateChange(e){
        if ( e.data == 1) {
            // 플레이중
            isPlay = true;
            if(videoType == "tvcf"){
                
            }else if(videoType == "film"){
                
            }else if(videoType == "story"){
                
            }else if(videoType == "journeys"){
                
            }
        } else if ( e.data == 2) {
            // 일시정지
        } else if ( e.data == -1) {
            // 종료
            isPlay = false;
        } else if (e.data == 3) {
            // 로딩
        } else {

        }
        $rootScope.$broadcast("ytEvt:play", {videoType:videoType, status:e.data});
    }
    
    return {
        tvcfPlayer:{
            play:function(idx){
                if(!isPlayerReady) return;
                videoType = "tvcf";
                tvcfPlayer.cueVideoById(plyListTvcf[idx]);
            },
            start:function(){
                tvcfPlayer.seekTo(0);
                tvcfPlayer.playVideo();
            },
            pause:function(){
                if(isPlay) tvcfPlayer.pauseVideo();
            },
            resume:function(){
                if(isPlay) tvcfPlayer.playVideo();
            },
            stop:function(){
                if(!isPlayerReady) return;
                tvcfPlayer.seekTo(0);
                tvcfPlayer.stopVideo();
            }
        },
        filmPlayer:{
            play:function(idx){
                if(!isPlayerReady) return;
                videoType = "film";
                filmPlayer.cueVideoById(plyListFilm[idx]);
            },
            start:function(){
                filmPlayer.seekTo(0);
                filmPlayer.playVideo();
            },
            pause:function(){
                if(isPlay) filmPlayer.pauseVideo();
            },
            resume:function(){
                if(isPlay) filmPlayer.playVideo();
            },
            stop:function(){
                if(!isPlayerReady) return;
                filmPlayer.seekTo(0);
                filmPlayer.stopVideo();
            }
        },
        storyPlayer:{
            play:function(idx){
                if(!isPlayerReady) return;
                videoType = "story";
                storyPlayer.cueVideoById(plyListStory[idx]);
            },
            start:function(){
                jouneysPlayer.seekTo(0);
                storyPlayer.playVideo();
            },
            pause:function(){
                if(isPlay) storyPlayer.pauseVideo();
            },
            resume:function(){
                if(isPlay) storyPlayer.playVideo();
            },
            stop:function(){
                if(!isPlayerReady) return;
                storyPlayer.seekTo(0);
                storyPlayer.stopVideo();
            }
        },
        journeysPlayer:{
            play:function(idx){
                if(!isPlayerReady) return;
                videoType = "journeys";
                jouneysPlayer.cueVideoById(plyListJourneys[idx]);
            },
            start:function(){
                jouneysPlayer.seekTo(0);
                jouneysPlayer.playVideo();
            },
            stop:function(){
                if(!isPlayerReady) return;
                jouneysPlayer.seekTo(0);
                jouneysPlayer.stopVideo();
            }
        }
    };
}]);














