var isYoutubeApiLoad = false;
/** 유튜브 플레이어 API 로드 */
var youTubeTag = document.createElement('script');
youTubeTag.src = "https://www.youtube.com/player_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(youTubeTag, firstScriptTag);
/** 유튜브 API 로드 완료   */
function onYouTubePlayerAPIReady() {
    isYoutubeApiLoad = true;
}


var YoutubePlayer = (function() {
    
    var ytplayer;
    var ytwrap;
    var container;
    var videoId;
    var width;
    var height;
    var data;
    var readyFn;
    var stateFn;
    var reloadInterval;
    var readyFn;
    var stateFn;
    function youtubeLoad(){
        ytplayer = new YT.Player(container, {
            width: width,
            height: height,
            videoId: videoId,
            playerVars: data,
            events: {
                'onReady': readyFn,
                'onStateChange': stateFn
            }
        });
    }
    
    /** API 로드 미완료시 로드 체크  */
    function reload(){
        if(isYoutubeApiLoad){
            clearInterval(reloadInterval);
            youtubeLoad();
        }
    }
    
    return {
        load: function($ytwrap, $container, $videoId, $width, $height, $data, $readyFn, $stateFn) {
            $("#"+$ytwrap).html("<div id='ytplayer'></div>");
            ytwrap = $ytwrap;
            container = $container;
            videoId = $videoId;
            width = $width;
            height = $height;
            data = $data;
            readyFn = $readyFn;
            stateFn = $stateFn;
            if(isYoutubeApiLoad) youtubeLoad();
            else reloadInterval = setInterval(reload, 30);
        },empty: function() {
            player = null;
            $("#"+ytwrap).empty();
        }
    }
    
})(YoutubePlayer);

/**

ytplayer.playVideo();
ytplayer.pauseVideo();
ytplayer.stopVideo();
ytplayer.seekTo($seekNum);
ytplayer.loadVideoById($videoId, $seekNum);

*/

