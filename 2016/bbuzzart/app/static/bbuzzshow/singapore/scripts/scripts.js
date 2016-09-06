

var windowHeight = 0;
var showCount = 1;
var mobileResizeInterval = null;
var clearIntervalTimeout = null;
var isMobile = false;



$(function(){
    
    $(window).bind('resize', windowResizeHandler);
    $(window).bind('scroll', scrollHandler);
    $('#header .util-menu-wrap .select-list .dimmed').bind('click', closeShowList);
    
    
    windowResizeHandler();
    
    setTimeout(function(){
        $('body').addClass('show');
        
        setTimeout(function(){
            $({count: 0}).animate({count: showCount}, {
                duration: showCount*100,
                easing:'swing',
                step: function(){
                    var convertCount = Math.ceil(this.count);
                    convertCount = convertCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                    if(parseInt(convertCount) < 10) convertCount = '0' + convertCount;
                    $('#contents .contents-top .contents-top-wrap .column-2 .visual-wrap .thumbnail-3 .text-wrap .text p').text(convertCount);
                },
                complete: function(){
                    var convertCount = showCount;
                    convertCount = convertCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                    if(parseInt(convertCount) < 10) convertCount = '0' + convertCount;
                    $('#contents .contents-top .contents-top-wrap .column-2 .visual-wrap .thumbnail-3 .text-wrap .text p').text(convertCount);
                }
            });
            
            $('#contents .contents-top .contents-top-wrap .column-2 .visual-wrap .thumbnail-2 .text-wrap').addClass('show');
            
            setTimeout(function(){
                var textArr = $('#contents .contents-top .contents-top-wrap .column-2 .visual-wrap .thumbnail-2 .text-wrap .text p span');
                $.each(textArr, function(idx, val){
                    $(this).delay(110*idx).queue(function(){
                        $(this).addClass('show');
                    });
                });
            }, 400);
        }, 1000);
    });
    
});


function windowResizeHandler(){
    
    var windowWidth = $(window).width();
//    windowHeight = $(window).height();
    
    if($('.contents-top-wrap .column-2 .visual-wrap').css('margin') == '0px'){
        if(!isMobile){
            isMobile = true;
            if(clearIntervalTimeout != null){
                clearMobileResize();
            };
            mobileResizeInterval = setInterval(function(){
                mobileResize();
            });
            clearIntervalTimeout = setTimeout(function(){
                clearMobileResize();
            }, 500);
        }else{
            mobileResize();
        };
    }else{
        if(isMobile){
            isMobile = false;
            clearMobileResize();
            $('.contents-top-wrap .column-2 .visual-wrap .thumbnail-4 img').removeAttr('style');
            $('.contents-top-wrap .column-2 .visual-wrap .thumbnail-5 img').removeAttr('style');
        };
    };
    
    scrollHandler();

};

function mobileResize(){
    var thumb4 = $('.contents-top-wrap .column-2 .visual-wrap .thumbnail-3 .visual').height()*0.48;
    var thumb5 = $('.contents-top-wrap .column-2 .visual-wrap .thumbnail-3 .visual').height()*0.52;
    $('.contents-top-wrap .column-2 .visual-wrap .thumbnail-4 img').height(thumb4);
    $('.contents-top-wrap .column-2 .visual-wrap .thumbnail-5 img').height(thumb5);
}

function clearMobileResize(){
    clearInterval(mobileResizeInterval);
    mobileResizeInterval = null;
    clearTimeout(clearIntervalTimeout);
    clearIntervalTimeout = null;
}

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
    pos = $('.artist-' + idx).offset().top - $('#header').height();
    $('html, body').stop().animate({scrollTop:pos}, '500', 'swing');
};

function goArtworkContents(){
    var pos = 0;
    pos = $('#contents .contents-artist').offset().top - $('#header').height();
    $('html, body').stop().animate({scrollTop:pos}, '500', 'swing');
}















