angular.module('giftbox.controllers').

controller('myEventCtrl', ['$scope', '$timeout', '$state', '$ionicHistory', '$ionicLoading', '$ionicScrollDelegate', 'storageSvc', 'restApiSvc', 'appDataSvc', 'dialogSvc', function($scope, $timeout, $state, $ionicHistory, $ionicLoading, $ionicScrollDelegate, storageSvc, restApiSvc, appDataSvc, dialogSvc) {

    console.log('myEvent controller');
    
    $scope.os = appDataSvc.os;
    $scope.eventList = [];
    $scope.page = 0;
    $scope.pageSize = 10;
    $scope.loadDelay = 350;
    $scope.isRefresh = false;
    $scope.isLast = false;
    $scope.isEmptyList = false;
    $scope.pageTitle = '';
    $scope.currentState = $state.current.name;
    
    $scope.listLoad = function(){
        
        $scope.page++;
        
        if($scope.currentState.indexOf('viewed') > -1){
            storageSvc.getViewedEventList($scope.page, $scope.pageSize).then(
                function(res){
                    $scope.parseList(res);
                }
            );
        }else if($scope.currentState.indexOf('bookmarked') > -1){
            storageSvc.getBookmarkedEventList($scope.page, $scope.pageSize).then(
                function(res){
                    $scope.parseList(res);
                }
            );
        }else if($scope.currentState.indexOf('joined') > -1){
            storageSvc.getJoinedEventList($scope.page, $scope.pageSize).then(
                function(res){
                    $scope.parseList(res);
                }
            );
            
        };
        
    };
    $scope.parseList = function(res){
        if($scope.isRefresh){
            $timeout(function(){
                $scope.eventList.length = 0;
                $timeout(function(){
                    $scope.isRefresh = false;
                    $scope.isLast = res.isLast;
                    $scope.$broadcast('scroll.refreshComplete');
                    $scope.eventList = res.data;

                    if($scope.eventList.length <= 0) $scope.isEmptyList = true;
                });
            }, $scope.loadDelay);
        }else{
            $timeout(function(){
                $scope.eventList = $scope.eventList.concat(res.data);
                $timeout(function(){
                    $scope.isLast = res.isLast;
                    $scope.$broadcast('scroll.infiniteScrollComplete');

                    if($scope.eventList.length <= 0) $scope.isEmptyList = true;
                }, $scope.loadDelay);
            }, $scope.loadDelay);
        };
    }
    
    $scope.doRefresh = function(){
        $scope.isRefresh = true;
        $scope.page = 0;
        $scope.listLoad();
    };
    
    $scope.setPageTitle = function(){
        switch($scope.currentState){
            case 'tab.viewed':
                $scope.pageTitle = '최근 본 이벤트';
                break;
            case 'tab.bookmarked':
                $scope.pageTitle = '찜한 이벤트';
                break;
            case 'tab.joined':
                $scope.pageTitle = '응모한 이벤트';
                break;
        }
    }
    
    
    /** initialize  */
    $scope.$on('$ionicView.enter', function(e) {
        $timeout(function(){
            $ionicHistory.clearCache();
            $ionicHistory.clearHistory();
        });
    });
    $scope.setPageTitle();
    $ionicLoading.hide();
//    $scope.listLoad();
    

}]);



