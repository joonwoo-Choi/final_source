angular.module('giftbox.controllers').

controller('eventDetailCtrl', ['$scope', '$timeout', '$state', '$ionicNavBarDelegate', '$ionicActionSheet', '$cordovaSocialSharing', '$cordovaGoogleAnalytics', 'appDataSvc', 'storageSvc', 'dialogSvc', 'browserSvc', 'imgLoadSvc', 'calendarSvc', 'initData', function($scope, $timeout, $state, $ionicNavBarDelegate, $ionicActionSheet, $cordovaSocialSharing, $cordovaGoogleAnalytics, appDataSvc, storageSvc, dialogSvc, browserSvc, imgLoadSvc, calendarSvc, initData) {

    console.log('event detail controller ');
    
    $scope.detailInfo = initData.eventList;
    $scope.convertedStartDate;
    $scope.convertedEndDate;
    $scope.convertedPublicationDate;
    $scope.convertedGifts = [];
    $scope.thumbnailUrl = 'img/img_thumanail_default.png';
    $scope.loadTimeout = null;
    $scope.isClosedEvent = false;
    $scope.isJoining = false;
    $scope.isJoinComplete = false;
    $scope.isBookmarked = false;
    
//    for ( var prop in $scope.detailInfo ) {
//        if(prop === '$$hashKey'){
//            delete $scope.detailInfo.$$hashKey;
//        };
//        /** storage 테이블 아이디 제거  */
//        if(prop === 'tableId'){
//            delete $scope.detailInfo.tableId;
//        };
//    };
//    if($state.current.name.indexOf('home') > -1){
//        storageSvc.insertViewedEvent($scope.detailInfo);
//    };
    
    $scope.toggleBookmark = function(){
        if($scope.isBookmarked){
            $scope.isBookmarked = false;
            storageSvc.deleteBookmarkedEvent($scope.detailInfo.id);
            if(window.cordova){
                $cordovaGoogleAnalytics.trackEvent('EVENT DETAIL', 'Release Bookmark');
            };
        }else{
            $scope.isBookmarked = true;
            storageSvc.insertBookmarkedEvent($scope.detailInfo);
            if(window.cordova){
                $cordovaGoogleAnalytics.trackEvent('EVENT DETAIL', 'Set Bookmark');
            };
        };
    };
    
    $scope.openSitelinkDialog = function(url, joiningCheck){
        if(joiningCheck){
            storageSvc.insertJoiningEvent($scope.detailInfo.id).then(
                function(res){
                    $scope.isJoining = true;
                }
            );
        };
        if(window.cordova){
            if(url == $scope.detailInfo.eventPage){
                $cordovaGoogleAnalytics.trackEvent('EVENT DETAIL', 'Go Event Page');
            }else{
                $cordovaGoogleAnalytics.trackEvent('EVENT DETAIL', 'Go Prize Page');
            }
        };
        browserSvc.open(url);
    };
    
    $scope.showFullScreenImage = function(){
        var viewer = ImageViewer({snapView:false});
        viewer.show($scope.detailInfo.attachments[0].url);
    }
    
    $scope.toggleJoinComplete = function(){
        var title = $scope.detailInfo.title;
        var location = $scope.detailInfo.company;
        var notes = '';
        var publicationDate = '';
        if($scope.detailInfo.prizePage.length > 0){
            notes = '당첨확인\n' + $scope.detailInfo.prizePage;
        }else{
            notes = '당첨확인\n' + $scope.detailInfo.eventPage;
        }
        if($scope.convertedPublicationDate){
            publicationDate = $scope.detailInfo.publicationDate;
        }else{
            publicationDate = '';
        }
        
        if($scope.isJoinComplete){
            $scope.isJoinComplete = false;
            storageSvc.deleteJoinedEvent($scope.detailInfo.id);
            dialogSvc.alert('응모를 취소했습니다.');
            if(window.cordova){
                calendarSvc.deleteEvent({
                    title: title,
                    location: location,
                    notes: notes,
                    publicationDate: publicationDate
                });
                $cordovaGoogleAnalytics.trackEvent('EVENT DETAIL', 'Release Join Event');
            };
        }else{
            $scope.isJoinComplete = true;
            storageSvc.insertJoinedEvent($scope.detailInfo);
            dialogSvc.alert('응모했습니다.');
            if(window.cordova){
                calendarSvc.createEvent({
                    title: title,
                    location: location,
                    notes: notes,
                    publicationDate: publicationDate
                });
                $cordovaGoogleAnalytics.trackEvent('EVENT DETAIL', 'Set Join Event');
            };
        }
    };
    
    $scope.openShareSheet = function() {
        if(window.cordova){
            var title = $scope.detailInfo.title,
                company = $scope.detailInfo.company,
                description = $scope.detailInfo.description,
                image = $scope.detailInfo.attachments[0].url,
                link = $scope.detailInfo.eventPage;
            
            var message = '[' + company + ']\n' + title + '\n';
            
            $cordovaGoogleAnalytics.trackEvent('SHARE EVENT', 'Open Sheet');
            $cordovaSocialSharing.share(message, '', '', link).then(
                function(res) {
                    
                }, function(err) {
                    
                }
            );
        };
    };
    
    $scope.swipe = function (direction) {
        if(direction == 'right') {
            $ionicNavBarDelegate.back();
        };
    };
    
    
    /** initialize  */
    
    /** 이벤트 사이트 방문 여부 체크    */
    storageSvc.getByEventId('joiningList', $scope.detailInfo.id).then(
        function(res){
            if(res !== null){
                $scope.isJoining = true;
                storageSvc.getByEventId('joinedList', $scope.detailInfo.id).then(
                    function(res){
                        if(res !== null){
                            $scope.isJoinComplete = true;
                        };
                    }
                );
            };
        }
    );
    /** 북마크한 이벤트인지 체크   */
    storageSvc.getByEventId('bookmarkedList', $scope.detailInfo.id).then(
        function(res){
            if(res !== null && res !== undefined){
                $scope.isBookmarked = true;
            };
        }
    );
    /** 날짜 요일 추가    */
    $scope.week = ['(일)', '(월)', '(화)', '(수)', '(목)', '(금)', '(토)'];
    if($scope.detailInfo.startDate != null && $scope.detailInfo.startDate != 'null'){
        var startDate = new Date($scope.detailInfo.startDate);
        $scope.convertedStartDate = $scope.detailInfo.startDate + $scope.week[startDate.getDay()];
    }else{
        $scope.convertedStartDate = 0;
    };
    if($scope.detailInfo.endDate != null && $scope.detailInfo.endDate != 'null'){
        var endDate = new Date($scope.detailInfo.endDate);
        $scope.convertedEndDate = $scope.detailInfo.endDate + $scope.week[endDate.getDay()];
    }else{
        $scope.convertedEndDate = 0;
    };
    if($scope.detailInfo.publicationDate != null && $scope.detailInfo.publicationDate != 'null'){
        var publicationDate = new Date($scope.detailInfo.publicationDate);
        $scope.convertedPublicationDate = $scope.detailInfo.publicationDate + $scope.week[publicationDate.getDay()];
    }else{
        $scope.convertedPublicationDate = 0;
    };
    /** 상품 1000단위 변환    */
    if($scope.detailInfo.gifts){
        angular.forEach($scope.detailInfo.gifts, function(val, idx){
            var convertedGift = JSON.parse(JSON.stringify(val));
            convertedGift.count = convertedGift.count.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            $scope.convertedGifts.push(convertedGift);
        });
    };
    /** 이벤트 종료 체크   */
    if($scope.detailInfo.startDate != null && $scope.detailInfo.startDate != 'null'){
        var startDate = $scope.detailInfo.startDate.split('-');
        var endDate = $scope.detailInfo.endDate.split('-');
        var e_day = new Date().setFullYear(endDate[0], parseInt(endDate[1])-1, endDate[2]);
        var t_day = new Date().getTime();
        
        var todayToEnd = t_day - e_day;
        if(todayToEnd > 0){
            $scope.isClosedEvent = true;
        };
    };
    
    
    $scope.$on('$ionicView.enter', function(e) {
        
        $scope.loadTimeout = $timeout(function(){
            $scope.thumbnailUrl = $scope.detailInfo.attachments[0].thumbnailS;
        }, 10000);

        imgLoadSvc.load($scope.detailInfo.attachments[0].thumbnailS, function(src){
            $timeout.cancel($scope.loadTimeout);
            $scope.loadTimeout = null;
            $timeout(function(){
                $scope.thumbnailUrl = src;
            });
        });
        
    });
    
    

}]);



