(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');

    BBuzzArtApp.controller('serviceCtrl', ['$rootScope', '$scope', '$window', '$timeout', '$state',  function ($rootScope, $scope, $window, $timeout, $state) {
        
        $scope.noticeMenus = [
            {name: 'NOTICE', state: 'notice'}, 
            {name: 'HELP', state: 'help'}, 
            {name: 'CONTACT US', state: 'contactus'}, 
            {name: 'TERMS OF USE', state: 'termsofuse'}, 
            {name: 'PRIVACY POLICY', state: 'privacypolicy'}
        ];
        $scope.pageSrcLists = [
            '/static/service/notice.html',
            '/static/service/help.html',
            '/static/service/contactus.html',
            '/static/service/termsofuse.html',
            '/static/service/privacypolicy.html'
        ];
        $scope.pageIdx = 0;
        
        $scope.noticeMenuHandler = function(idx){
            $scope.pageIdx = idx;
        };
        
        $scope.setNotice = function(){
            var url = location.href;
            if(url == undefined) return;
            
            if(url.indexOf('notice') > -1){
                $scope.pageIdx = 0;
            }else if(url.indexOf('help') > -1){
                $scope.pageIdx = 1;
            }else if(url.indexOf('contact') > -1){
                $scope.pageIdx = 2;
            }else if(url.indexOf('termsofuse') > -1){
                $scope.pageIdx = 3;
            }else if(url.indexOf('privacypolicy') > -1){
                $scope.pageIdx = 4;
            };
        };
        
        $scope.noticeResize = function(){
            if(location.href.indexOf('service') <= 0) return;
            
            var iframeText = angular.element(document.getElementById('notice-view').contentWindow.document.body).text();
            if(iframeText == '') return;
            
            $timeout(function(){
                var iframeHeight = document.getElementById('notice-view').contentWindow.document.body.offsetHeight;
                angular.element(document.getElementById('notice-view')).css({'height':iframeHeight+'px'});
            });
        };
        
        $scope.$watch(function(){
            return document.getElementById('notice-view').contentWindow.document.body.offsetHeight;
        }, function(newVal, oldVal){
            $timeout(function(){
                $scope.noticeResize();
            });
        });
        
        $scope.$on('$locationChangeSuccess', function(e, to, params){
            $scope.setNotice();
            $scope.noticeResize();
        });
        
        angular.element(document.getElementById('notice-view')).bind('load', function(){
            $timeout(function(){
                $scope.noticeResize();
                $scope.noticeResize();
            });
        });
        
        angular.element($window).bind('resize', function(){
            $scope.noticeResize();
        });
        
        top.window.addEventListener("message", function(message) {
            $scope.noticeResize();
            if(!$rootScope.isMobile){
                $timeout(function(){
                    $('.notice-scroll-wrap').mCustomScrollbar('scrollTo','top',{
                        scrollInertia: 0
                    });
                });
            }else{
                window.scrollTo(0, 0);
            };
        });
        
        if($rootScope.isMobile){
            $timeout(function(){
                $('.notice-wrap .notice-scroll-wrap').mCustomScrollbar("destroy").removeAttr('style');
            });
        };
        
        $scope.setNotice();
        $scope.noticeResize();
        
    }]);

})(angular);
