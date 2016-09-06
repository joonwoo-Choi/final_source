

var windowHeight = 0;
var mobileScreenIdx = 0;
var visualSrc = [
    'http://www.bbuzzart.com/static/about_bbuzzart/images/img_visual_1.jpg',
    'http://www.bbuzzart.com/static/about_bbuzzart/images/img_visual_2.jpg',
    'http://www.bbuzzart.com/static/about_bbuzzart/images/img_visual_3.jpg',
    'http://www.bbuzzart.com/static/about_bbuzzart/images/img_visual_4.jpg',
    'http://www.bbuzzart.com/static/about_bbuzzart/images/img_visual_5.jpg',
    'http://www.bbuzzart.com/static/about_bbuzzart/images/img_visual_6.jpg',
    'http://www.bbuzzart.com/static/about_bbuzzart/images/img_visual_7.jpg'
];
var visualLoadedCnt = 0;
var randomDelay = [
    150,
    300,
    450,
    600,
    750,
    900,
    1050
];




$(function(){
    
    $(window).bind('resize', windowResizeHandler);
    $(window).bind('scroll', scrollHandler);
    
    setInterval(function(){
        mobileScreenIdx++;
        mobileScreenChange(mobileScreenIdx);
    }, 5000);
    
    windowResizeHandler();
    mobileScreenChange(mobileScreenIdx);
    
    setTimeout(function(){
        $('body').addClass('show');
    });
    
    for(var i=0; i < visualSrc.length; i++){
        var img = new Image();
        img.onload = function() {
            visualLoadedCnt++;
            if(visualLoadedCnt == visualSrc.length){
                for(var n=0; n < visualSrc.length; n++){
                    var target = '#contents .section-1 .visual-wrap li.visual-'+(n+1);
                    var delayIdx = Math.floor(randomDelay.length*Math.random());
                    var delay = randomDelay.splice(delayIdx, 1);
                    console.log(randomDelay, delay)
                    $(target).delay(delay).queue(function(){
                        $(this).addClass('show');
                    });
                };
           };
        };
        img.src = visualSrc[i];
    }
    
});

function mobileScreenChange(idx){
    if(idx >= $('.screen-wrap li').length) mobileScreenIdx = 0;
    
    $('.screen-wrap li').eq(mobileScreenIdx).addClass('on');
    setTimeout(function(){
        $.each($('.screen-wrap li'), function(idx, val){
            if(idx != mobileScreenIdx){
                $(val).removeClass('on');
            };
        });
    }, 500);
};

function windowResizeHandler(){
    
    var windowWidth = $(window).width();
    windowHeight = $(window).height();
    if(windowWidth >= 768){
        if(windowHeight > 720){
            $('.section-1').height(windowHeight);
        }else{
            $('.section-1').height(720);
        }
    }else{
        if(windowHeight > 400){
            $('.section-1').height(windowHeight);
        }else{
            $('.section-1').height(400);
        }
    }

};

function scrollHandler(){
    var scrollPos = $(window).scrollTop();
    var windowHeight = $(window).height();
    
    if( scrollPos >= (windowHeight*0.65) ){
        if(!$('#header').hasClass('show')){
            $('#header').addClass('show');
        }
    }else{
        $('#header').removeClass('show');
    };
    
    if(!isDataLoaded) return;
    if(scrollPos >= $('.circle-item.circle-1').offset().top - (windowHeight - 150)){
        if(!$('.circle-item.circle-1').hasClass('show')){
            $('.circle-item.circle-1').addClass('show');
            
            showCircle(1);
            
            $({count: 0}).animate({count: workCount}, {
                duration: 1250,
                easing:'swing',
                step: function(){
                    var convertCount = Math.ceil(this.count);
                    convertCount = convertCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                    $('.circle-item.circle-1 .count').text(convertCount);
                },
                complete: function(){
                    var convertCount = workCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                    $('.circle-item.circle-1 .count').text(convertCount);
                }
            });
        };
    };
    if(scrollPos >= $('.circle-item.circle-2').offset().top - (windowHeight - 150)){
        if(!$('.circle-item.circle-2').hasClass('show')){
            $('.circle-item.circle-2').addClass('show');
            
            showCircle(2);
            
            $({count: 0}).animate({count: confirmedUserCount}, {
                duration: 1250,
                easing:'swing',
                step: function(){
                    var convertCount = Math.ceil(this.count);
                    convertCount = convertCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                    $('.circle-item.circle-2 .count').text(convertCount);
                },
                complete: function(){
                    var convertCount = confirmedUserCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                    $('.circle-item.circle-2 .count').text(convertCount);
                }
            });
        };
    };
    if(scrollPos >= $('.circle-item.circle-3').offset().top - (windowHeight - 150)){
        if(!$('.circle-item.circle-3').hasClass('show')){
            $('.circle-item.circle-3').addClass('show');
            
            showCircle(3);
            
            $({count: 0}).animate({count: feedbackCount}, {
                duration: 1250,
                easing:'swing',
                step: function(){
                    var convertCount = Math.ceil(this.count);
                    convertCount = convertCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                    $('.circle-item.circle-3 .count').text(convertCount);
                },
                complete: function(){
                    var convertCount = feedbackCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                    $('.circle-item.circle-3 .count').text(convertCount);
                }
            });
        }
    };
};

function showCircle(idx){
    
    var targetWeb = '.circle-item.circle-' + idx + ' .circle-web';
    $(targetWeb).circleProgress({
        value: 1,
        startAngle: -Math.PI/2,
        size: 285,
        thickness: 8,
        fill: {
            gradient: ['#f5c0cc', '#bfd9f0', '#d6e9ce'],
            gradientDirection: [0, 0, 0, 285]
        },
        emptyFill: "rgba(0, 0, 0, 0)",
    });
    
    var targetMobile = '.circle-item.circle-' + idx + ' .circle-mobile';
    $(targetMobile).circleProgress({
        value: 1,
        startAngle: -Math.PI/2,
        size: 208,
        thickness: 8,
        fill: {
            gradient: ['#f5c0cc', '#bfd9f0', '#d6e9ce'],
            gradientDirection: [0, 0, 208, 0]
        },
        emptyFill: "rgba(0, 0, 0, 0)",
    });
}


function menuChange(idx){
    var pos = 0;
    switch(idx){
        case 0 :
            $('html, body').stop().animate({scrollTop:pos}, '500', 'swing');
            break;
        case 1 :
            pos = $('.section-2').offset().top;
            $('html, body').stop().animate({scrollTop:pos}, '500', 'swing');
            break;
        case 2 :
            pos = $('.section-3').offset().top;
            $('html, body').stop().animate({scrollTop:pos}, '500', 'swing');
            break;
        case 3 :
            pos = $('.section-4').offset().top;
            $('html, body').stop().animate({scrollTop:pos}, '500', 'swing');
            break;
    };
};


var confirmedUserCount = 0;
var feedbackCount = 0;
var workCount = 0;
var isDataLoaded = false;

function getAboutData(){

    var xmlhttp = new XMLHttpRequest();
    xmlhttp.open("GET", 'http://api3.bbuzzart.com/about/stats');
    xmlhttp.onreadystatechange = function() {
        if (xmlhttp.readyState == XMLHttpRequest.DONE) {
            if(xmlhttp.status == 200){
                var res = JSON.parse(xmlhttp.responseText);
                
                if(res.success){
                    isDataLoaded = res.success;
                    confirmedUserCount = res.data.confirmedUserCount;
                    feedbackCount = res.data.feedbackCount;
                    workCount = res.data.workCount;
                    
                    scrollHandler();
                }
            }else{
                var res = JSON.parse(xmlhttp.responseText);
            }
        }
    };
    xmlhttp.send();
};

getAboutData();













