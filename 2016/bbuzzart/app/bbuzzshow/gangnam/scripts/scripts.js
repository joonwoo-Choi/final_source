

var windowHeight = 0;
var ua = navigator.userAgent.toLowerCase();
var isMobile = false;

if( /android|iphone|ipad|ipod/.test(ua) ){
    isMobile = true;
}



$(function(){
    
    $(window).bind('resize', windowResizeHandler);
    $(window).bind('scroll', scrollHandler);
    $('#header .util-menu-wrap .select-list .dimmed').bind('click', closeShowList);
    
    windowResizeHandler();
    
    setTimeout(function(){
        $('body').addClass('show');
    });
    
});


function windowResizeHandler(){
    
    var windowWidth = $(window).width();
//    windowHeight = $(window).height();
    
    scrollHandler();

};

function scrollHandler(){
    
    var scrollPos = $(window).scrollTop();
    var blockArr = $('.contents-artist-wrap .artist-list .block');
    $.each(blockArr, function(idx, val){
        var pos = $(this).offset().top + $(this).height() - $(window).height();
        if(scrollPos >= pos){
            if(!$(this).hasClass('show')){
                $(this).addClass('show');
                $(this).delay().queue(function(){
                    $(this).css({
                        '-webkit-transition-delay': '0s',
                        'transition-delay': '0s'
                    });
                });
            };
        };
    });
    
};

function openShowList(){
    if(!isMobile){
        $('body').css({'overflow': 'hidden', 'padding-right': '17px'});
        $('#header .header-contents .util-menu-wrap').css({'padding-right': '17px'});
        $('#header .util-menu-wrap .select-list .list-wrap').removeAttr('style');
    }else{
        $('body').css({'overflow': 'hidden'});
    };
    $('#header .util-menu-wrap .select-list').fadeIn();
    $('#header .util-menu-wrap .select-list').addClass('on');
};
function closeShowList(){
    if(!isMobile){
        $('#header .util-menu-wrap .select-list .list-wrap').css({'margin-right': '-17px'});
    }
    $('body').removeAttr('style');
    $('#header .header-contents .util-menu-wrap').removeAttr('style');
    $('#header .util-menu-wrap .select-list').fadeOut();
    $('#header .util-menu-wrap .select-list').removeClass('on');
};

function menuChange(idx){
    var pos = 0;
    pos = $('.contents-artist .artist-' + idx).offset().top - $('#header').height();
    $('html, body').stop().animate({scrollTop:pos}, '500', 'swing');
};

function goArtworkContents(){
    var pos = 0;
    pos = $('.contents-artist').offset().top - $('#header').height();
    $('html, body').stop().animate({scrollTop:pos}, '500', 'swing');
}















