/*!
 * res 0.2.0-0+201403312143
 * https://github.com/ryanve/res
 * MIT License, 2014 Ryan Van Etten
 */
!function(a,b,c){"undefined"!=typeof module&&module.exports?module.exports=c():a[b]=c()}(this,"res",function(){function a(a){return null==a?m:a!==a?!1:l?l>=a:k([["min--moz-device-pixel-ratio:",a],["min-resolution:",a*d,"dpi"]],j)}function b(b){return null==b?a()*d:a(b/d)}function c(b){return null==b?a()/e:a(b*e)}var d=96,e=2.54/d,f="undefined"!=typeof window&&window,g="undefined"!=typeof screen&&screen,h=[].join,i=f.matchMedia,j=i?function(){return!!i.call(f,"("+h.call(arguments,"")+")").matches}:function(){return!1},k=function(a,b,c){for(var d=0,e=a.length;e>d;)if(b.apply(c,a[d++]))return!0;return!1},l=+f.devicePixelRatio||Math.sqrt(g.logicalXDPI*g.logicalYDPI)/d||0,m=l||!i?l:function(a){for(var b,c=41;c--&&!a(b=c/20););return b}(a);return{dppx:a,dpcm:c,dpi:b}});
	/*!
 * verge 1.9.1+201402130803
 * https://github.com/ryanve/verge
 * MIT License 2013 Ryan Van Etten
 */
!function(a,b,c){"undefined"!=typeof module&&module.exports?module.exports=c():a[b]=c()}(this,"verge",function(){function a(){return{width:k(),height:l()}}function b(a,b){var c={};return b=+b||0,c.width=(c.right=a.right+b)-(c.left=a.left-b),c.height=(c.bottom=a.bottom+b)-(c.top=a.top-b),c}function c(a,c){return a=a&&!a.nodeType?a[0]:a,a&&1===a.nodeType?b(a.getBoundingClientRect(),c):!1}function d(b){b=null==b?a():1===b.nodeType?c(b):b;var d=b.height,e=b.width;return d="function"==typeof d?d.call(b):d,e="function"==typeof e?e.call(b):e,e/d}var e={},f="undefined"!=typeof window&&window,g="undefined"!=typeof document&&document,h=g&&g.documentElement,i=f.matchMedia||f.msMatchMedia,j=i?function(a){return!!i.call(f,a).matches}:function(){return!1},k=e.viewportW=function(){var a=h.clientWidth,b=f.innerWidth;return b>a?b:a},l=e.viewportH=function(){var a=h.clientHeight,b=f.innerHeight;return b>a?b:a};return e.mq=j,e.matchMedia=i?function(){return i.apply(f,arguments)}:function(){return{}},e.viewport=a,e.scrollX=function(){return f.pageXOffset||h.scrollLeft},e.scrollY=function(){return f.pageYOffset||h.scrollTop},e.rectangle=c,e.aspect=d,e.inX=function(a,b){var d=c(a,b);return!!d&&d.right>=0&&d.left<=k()},e.inY=function(a,b){var d=c(a,b);return!!d&&d.bottom>=0&&d.top<=l()},e.inViewport=function(a,b){var d=c(a,b);return!!d&&d.bottom>=0&&d.right>=0&&d.top<=l()&&d.left<=k()},e});