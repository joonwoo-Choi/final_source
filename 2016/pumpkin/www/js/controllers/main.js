angular.module('giftbox.controllers').

controller('mainCtrl', ['$scope', '$timeout', '$q', '$state', '$ionicHistory',  '$ionicLoading', '$ionicSlideBoxDelegate', '$ionicScrollDelegate', '$cordovaGoogleAnalytics', 'storageSvc', 'restApiSvc', 'appDataSvc', 'dialogSvc', function($scope, $timeout, $q, $state, $ionicHistory, $ionicLoading, $ionicSlideBoxDelegate, $ionicScrollDelegate, $cordovaGoogleAnalytics, storageSvc, restApiSvc, appDataSvc, dialogSvc) {
    
    console.log('home controller ');
    
    $scope.os = appDataSvc.os;
    $scope.eventList = [];
    $scope.isEmptyEvents = false;
    $scope.page = 0;
    $scope.pageSize = 10;
    $scope.isLast = false;
    $scope.isRefresh = false;
    $scope.isFilter = false;
    $scope.loadDelay = 350;
    $scope.filterDialog = null;
    $scope.filterOption = {
            premium: '',
            sortType: '',
            sort: [
                {name: '최신순', val: ''},
                {name: '마감임박순', val: 'close'}
            ],
            onGoings: [
                {name: '종료', val: 'end', checked: true},
                {name: '진행중', val: 'progress', checked: true},
                {name: '예정', val: 'oncoming', checked: true}
            ],
            forms: {
                form: [],
                place: [],
                method: []
            }
        };
    $scope.copyFilterOption;
    $scope.storageFilterParams = {premium:'', sort:'', onGoings:'', forms:''};
    
    $scope.listLoad = function(){
        if(appDataSvc.filterOption == null){
            /** 필터 타입 가져오기  */
            restApiSvc.get(restApiSvc.apiPath.getFilterEventTypes, {sort:'form'}).then(
                function(res){
                    var form;
                    if(typeof(res.data) == 'string'){
                        form = JSON.parse(res.data).data;
                    }else{
                        form = res.data.data;
                    }
                    
                    appDataSvc.filterOption = JSON.parse(JSON.stringify($scope.filterOption));
                    angular.forEach(form, function(val, idx){
                        var data = {name: val.name, val: val.id, checked: true};
                        appDataSvc.filterOption.forms.form.push(data);
                    });
                    
                    $timeout(function(){
                        $scope.syncFilterOption();
                    }, 1000);
                },
                function(err){
                    $scope.loadErrorHandler();
                }
            );
        }else{
            $scope.syncFilterOption();
        };
    };
    $scope.getList = function(){
        $scope.page++;
        
        var tempPage = $scope.page;
        if($scope.isRefresh){
            tempPage = 1;
        }
        
        var params = {
                page: tempPage,
                premium: $scope.storageFilterParams.premium,
                sort: $scope.storageFilterParams.sort,
                onGoings: $scope.storageFilterParams.onGoings,
                eventTypeCodes: $scope.storageFilterParams.forms
            };
        
        restApiSvc.cancel();
        restApiSvc.get(restApiSvc.apiPath.getEventList, params).then(
            function(res){
                $scope.$emit('homeEventListLoaded');
                if(typeof res.data !== 'Object' && typeof res.data !== 'object'){
                    res.data = JSON.parse(res.data);
                };
                var eventList = res.data.data.content,
                    isLast = res.data.data.last;
                if($scope.isFilter){
                    $timeout(function(){
                        $scope.scrollToTop();
                        $ionicLoading.hide();
                    }, 150);
                    $timeout(function(){
                        $scope.filterDialog.remove();
                        $timeout(function(){
                            $scope.isFilter = false;
                            $scope.eventList.length = 0;
                            $timeout(function(){
                                $scope.isLast = isLast;
                                $scope.eventList = eventList;
                                if($scope.eventList.length <= 0){
                                    $scope.isEmptyEvents = true;
                                }else{
                                    $scope.isEmptyEvents = false;
                                };
                            });
                        }, 250);
                    }, $scope.loadDelay);
                }else if($scope.isRefresh){
                    $timeout(function(){
                        $ionicLoading.hide();
                        $scope.isRefresh = false;
                        $scope.page = 1;
                        $scope.eventList.length = 0;
                        $timeout(function(){
                            $scope.isLast = isLast;
                            $scope.$broadcast('scroll.refreshComplete');
//                            $scope.$broadcast('scroll.infiniteScrollComplete');
                            $scope.eventList = eventList;
                            if($scope.eventList.length <= 0){
                                $scope.isEmptyEvents = true;
                            }else{
                                $scope.isEmptyEvents = false;
                            };
                        });
                    }, $scope.loadDelay);
                }else{
                    $timeout(function(){
                        $ionicLoading.hide();
                        $scope.eventList = $scope.eventList.concat(eventList);
                        $timeout(function(){
                            $scope.isLast = isLast;
                            $scope.$broadcast('scroll.infiniteScrollComplete');
                            if($scope.eventList.length <= 0){
                                $scope.isEmptyEvents = true;
                            }else{
                                $scope.isEmptyEvents = false;
                            };
                        }, $scope.loadDelay);
                    }, $scope.loadDelay);
                }
            },
            function(err){
                $scope.loadErrorHandler();
            }
        );
    };
    
    $scope.loadErrorHandler = function(){
        $ionicLoading.hide();

        if($scope.isFilter){
            $timeout(function(){
                $scope.filterDialog.remove();
                $timeout(function(){
                    $scope.isFilter = false;
                }, 250);
            }, $scope.loadDelay);
        }else if($scope.isRefresh){
            $scope.isRefresh = false;
            $scope.$broadcast('scroll.refreshComplete');
            $scope.$broadcast('scroll.infiniteScrollComplete');
        }else{
            $scope.page--;
            $timeout(function(){
                $timeout(function(){
                    $scope.$broadcast('scroll.infiniteScrollComplete');
                }, $scope.loadDelay);
            }, $scope.loadDelay);
        };
    };
    
    /** sqlite 필터 옵션 동기화    */
    $scope.syncFilterOption = function(){
        storageSvc.getByTableId('filterOption', 1).then(
            function(res){
                if(res == null){
                    storageSvc.insertFilterOption(['', '', 'oncoming,progress', '']).then(
                        function(res){
                            $scope.filterOption = JSON.parse(JSON.stringify(appDataSvc.filterOption));
                            $scope.getList();
                        }
                    );
                }else{
                    $scope.storageFilterParams = {
                        premium: res.premium,
                        sort: res.sort,
                        onGoings: res.onGoings,
                        forms: res.forms
                    };
                    appDataSvc.filterOption.premium = res.premium;
                    appDataSvc.filterOption.sortType = res.sort;
                    $scope.setFilterOption(appDataSvc.filterOption.onGoings, res.onGoings);
                    $scope.setFilterOption(appDataSvc.filterOption.forms.form, res.forms);
                    $scope.filterOption = JSON.parse(JSON.stringify(appDataSvc.filterOption));
                    $scope.getList();
                };
            }
        );
    };
    /** set 필터 옵션   */
    $scope.setFilterOption = function(appData, searchData){
        if(searchData){
            var tempArr = searchData.split(',');
            angular.forEach(appData, function(val, idx){
                var isSearched = false;
                angular.forEach(tempArr, function(tempVal, tempIdx){
                    if(!isSearched){
                        if(val.val == tempVal){
                            isSearched = true;
                            val.checked = true;
                        }else{
                            val.checked = false;
                        };
                    }
                })
            });
        };
    };
    
    $scope.filterList = function(){
        var validate = false;
        angular.forEach($scope.filterOption.onGoings, function(val, idx){
            if(!validate && val.checked){
                validate = true;
            };
        });
        if(!validate){
            dialogSvc.alert('이벤트 진행을 선택해 주세요.');
            return;
        };
        validate = false;
        angular.forEach($scope.filterOption.forms.form, function(val, idx){
            if(!validate && val.checked){
                validate = true;
            };
        });
        if(!validate){
            dialogSvc.alert('응모 방법을 선택해 주세요.');
            return;
        };
        
        $ionicLoading.show();
        $scope.isFilter = true;
        $scope.page = 0;
        $scope.updateFilterOption();
        
        if(window.cordova){
            $cordovaGoogleAnalytics.trackEvent('HOME FILTER', 'Save Filter Options');
        };
    };
    $scope.updateFilterOption = function(){
        var params = [
                $scope.filterOption.premium,
                $scope.filterOption.sortType
            ];
        var tempOnGoings = [];
        var tempForm = [];
        var tempForms = [];
        angular.forEach($scope.filterOption.onGoings, function(val, idx){
            if(val.checked) tempOnGoings.push(val.val);
        });
        params.push(tempOnGoings.join());
        
        angular.forEach($scope.filterOption.forms.form, function(val, idx){
            if(val.checked) tempForm.push(val.val);
        });
        tempForms = tempForms.concat(tempForm);
        console.log('tempForms ', tempForms)
        
        params.push(tempForms.join());
        
        storageSvc.updateFilterOption(params).then(
            function(res){
                $scope.syncFilterOption();
            }
        );
    };
    
    $scope.scrollToTop = function() {
        $ionicScrollDelegate.$getByHandle('mainScroll').scrollTop();
    };
    
    $scope.openFilterDialog = function(){
        $scope.copyFilterOption = JSON.stringify($scope.filterOption);
        dialogSvc.openFilterDialog($scope, true, function(modal){
            $scope.filterDialog = modal;
            $scope.filterDialog.show();
        });
        
        if(window.cordova){
            $cordovaGoogleAnalytics.trackEvent('HOME FILTER', 'Open Filter');
        };
    };
    $scope.closeFilterDialog = function(){
        $scope.filterDialog.remove();
        $timeout(function(){
            var originFilterOption = JSON.parse($scope.copyFilterOption);
            $scope.filterOption = originFilterOption;
        }, $scope.loadDelay);
        
        if(window.cordova){
            $cordovaGoogleAnalytics.trackEvent('HOME FILTER', 'Close Filter');
        };
    };
    $scope.resetFilterOptions = function(){
        $scope.filterOption.sortType = '';
        $scope.filterOption.premium = '';
        angular.forEach($scope.filterOption.onGoings, function(val, idx){
            if(val.val == 'end'){
                val.checked = false;
            }else{
                val.checked = true;
            }
        });
        angular.forEach($scope.filterOption.forms.form, function(val, idx){
            val.checked = true;
        });
    };
    
    $scope.doRefresh = function(){
        $scope.isRefresh = true;
        $scope.listLoad();
        $scope.$broadcast('homeRefresh');
    };
    
    $scope.$watch('isLast', function(newVal, oldVal){
        if(newVal){
            if($scope.eventList.length > 0){
                dialogSvc.alert('마지막 페이지입니다.');
            };
        };
    });
    
    
    /** initialize  */
    $scope.$on('$ionicView.enter', function(e) {
        $timeout(function(){
            $ionicHistory.clearCache();
            $ionicHistory.clearHistory();
        });
    });
    
//    $scope.listLoad();
    

}]);


