
angular.module('giftbox.directives').

directive('headerShrink', ['$document', '$timeout', function($document, $timeout){
    
    var fadeAmt;

    var shrink = function(header, content, amt, max) {
        amt = Math.min(44, amt);
        fadeAmt = 1 - amt / 44;
        ionic.requestAnimationFrame(function() {
            header.style[ionic.CSS.TRANSFORM] = 'translate3d(0, -' + amt + 'px, 0)';
            for(var i = 0, j = header.children.length; i < j; i++) {
                header.children[i].style.opacity = fadeAmt;
            }
        });
    };

    return {
        restrict: 'A',
        link: function($scope, $element, $attr) {
//            var isInfiniteScroll = false;
//            var scrollTop;
//            var timeout = null;
//            
//            $scope.$on('scroll.infiniteScrollStart', function(){
//                $timeout.cancel(timeout);
//                timeout = null;
//                isInfiniteScroll = true;
//            });
//            $scope.$on('scroll.infiniteScrollComplete', function(){
//                $timeout.cancel(timeout);
//                timeout = null;
//                timeout = $timeout(function(){
//                    isInfiniteScroll = false;
//                    timeout = null;
//                }, 1000);
//            });
            
            var starty = orgStarty = $scope.$eval($attr.headerShrink) || 40;
            var shrinkAmt;
            
            var header = $document[0].body.querySelector('.tabs-navigation');
            var headerHeight = header.offsetHeight;
            
            $element.bind('scroll', function(e) { 
//                if(isInfiniteScroll) return;
                
                if(e.detail == undefined || e.detail == null){
                    scrollTop = e.target.scrollTop;
                }else{
                    scrollTop = e.detail.scrollTop;
                };
                
                shrinkAmt = headerHeight - (headerHeight - (scrollTop - starty));
                
                if (shrinkAmt >= headerHeight){
                    starty = (scrollTop - headerHeight);
                    shrinkAmt = headerHeight;
                } else if (shrinkAmt < 0){
                    starty = Math.max(orgStarty, scrollTop);
                    shrinkAmt = 0;
                }
                
                shrink(header, $element[0], shrinkAmt, headerHeight); //do the shrinking   
            });
        }
    }
}]);








