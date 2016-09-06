
angular.module('giftbox.directives')

.directive('eventList', ['$timeout', '$filter', '$state', '$cordovaGoogleAnalytics', 'browserSvc', 'dialogSvc', 'imgLoadSvc', 'appDataSvc', function($timeout, $filter, $state, $cordovaGoogleAnalytics, browserSvc, dialogSvc, imgLoadSvc, appDataSvc){
    return {
        restrict: 'A',
        templateUrl: 'templates/lists/event-list.html',
        scope: true,
        replace: true,
        link: function($scope, iElm, iAttrs){
            
            $scope.thumbnailUrl = 'img/img_thumanail_default.png';
            $scope.loadTimeout = null;
            $scope.sitelinkDialog = null;
            $scope.sitelinkUrl = '';
            $scope.dDay = 0;
            $scope.waitingDay = 0;
            $scope.waitingEvent = false;
            $scope.openedEvent = false;
            $scope.closedEvent = false;
            $scope.isMainList = false;
            
            $scope.goDetail = function(detailId, company){
                var currentState = $state.current.name;
                var params = {
                        detailId: detailId,
                        company: company
                    };
                $state.go(currentState+'-detail', params);
                
                var isPremium = $scope.listItem.premium ? 'Premium List' : '';
                
                if(window.cordova){
                    switch(currentState){
                        case 'tab.home':
                            $cordovaGoogleAnalytics.trackEvent('HOME EVENT LIST', 'Event Detail', isPremium);
                            break;
                        case 'tab.viewed':
                            $cordovaGoogleAnalytics.trackEvent('VIEWED EVENT LIST', 'Event Detail');
                            break;
                        case 'tab.bookmarked':
                            $cordovaGoogleAnalytics.trackEvent('BOOKMARKED EVENT LIST', 'Event Detail');
                            break;
                        case 'tab.joined':
                            $cordovaGoogleAnalytics.trackEvent('JOINED EVENT LIST', 'Event Detail');
                            break;
                    };
                };
            };
            
            $scope.openSitelinkDialog = function(url){
                browserSvc.open(url);
            };
            
            $scope.getDday = function(){
                
                if($scope.listItem.startDate == null || $scope.listItem.startDate == 'null'){
                    $timeout(function(){
                        $scope.openedEvent = true;
                    });
                }else{
                    var startDate = $scope.listItem.startDate.split('-');
                    var endDate = $scope.listItem.endDate.split('-');
                    var s_day = new Date().setFullYear(startDate[0], parseInt(startDate[1])-1, startDate[2]);
                    var e_day = new Date().setFullYear(endDate[0], parseInt(endDate[1])-1, endDate[2]);
                    var t_day = new Date().getTime();
                    var HOUR_24 = 1000 * 60 * 60 * 24;

                    /** 이벤트 시작까지 남은 기간 체크   */
                    $timeout(function(){
                        var todayToStart = t_day - s_day;
                        if(todayToStart < 0){
                            $scope.waitingEvent = true;
                            $scope.waitingDay = Math.floor(todayToStart/HOUR_24);
                        };

                        if(!$scope.waitingEvent){
                            /** 이벤트 남은 기간 체크    */
                            var startToEnd = t_day - e_day;
                            $scope.dDay = Math.floor(startToEnd/HOUR_24)-1;
                            
                            /** 이벤트 종료 체크   */
                            if($scope.dDay >= 0){
                                $scope.closedEvent = true;
                            };
                        };
                    });
                };
                
            };
            
            
            /** initialize  */
            if($state.current.name.indexOf('home') > -1){
                $scope.isMainList = true;
            };
            
            $scope.loadTimeout = $timeout(function(){
                $scope.thumbnailUrl = $scope.listItem.attachments[0].thumbnailS;
            }, 10000);
            
            $scope.getDday();
            $timeout(function(){
                iElm.addClass('show');
                imgLoadSvc.load($scope.listItem.attachments[0].thumbnailS, function(src){
                    $timeout.cancel($scope.loadTimeout);
                    $scope.loadTimeout = null;
                    $timeout(function(){
                        $scope.thumbnailUrl = src;
                    });
                });
            });
            
        }
    };
}]);



