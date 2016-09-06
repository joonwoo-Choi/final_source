

var windowHeight = 0;



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
    $('body').css({'overflow': 'hidden'});
    $('#header .util-menu-wrap .select-list').fadeIn();
};
function closeShowList(){
    $('body').removeAttr('style');
    $('#header .util-menu-wrap .select-list').fadeOut();
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















