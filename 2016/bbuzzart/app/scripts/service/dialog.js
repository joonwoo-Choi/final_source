(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');
    
    BBuzzArtApp.factory('dialogSvc', ['$mdDialog', 'ngDialog', 'blockUI', function($mdDialog, ngDialog, blockUI){
        
        var dialogType = {
                uploadCancel: 'uploadCancel',
                curatorPickCancel: 'curatorPickCancel',
                curatorPicked: 'curatorPicked',
                videoUrl: 'videoUrl',
                validateUrl: 'validateUrl',
                delete: 'delete',
                page: 'page',
                imageSize: 'imageSize',
                nomember: 'nomember',
                issue: 'issue',
                facebook: 'facebook',
                signup: 'signup'
            }
        
        function confirmDialogCtrl($scope, dep){
            $scope.type = dep.confirmType;
            $scope.data = dep.data;
            
            $scope.confirm = function(answer){
                dep.confirmCallback(answer);
            }
        }
        
        function participationWorksCtrl($rootScope, $scope, $window, $timeout, dep, restApiSvc, dialogSvc, blockUI){
            $scope.isMobile = $rootScope.isMobile;
            $scope.isParticipationWorksLists = true;
            $scope.userId = dep.userId;
            $scope.copyParticipationWorkIds = JSON.parse(JSON.stringify(dep.participationWorkIds));
            $scope.participationWorkIds = dep.participationWorkIds;
            $scope.searchedLists = [];
            $scope.listColumnLength = 0;
            $scope.page = 0;
            $scope.totalPages = 1;
            $scope.pageSize = 20;
            $scope.isLoading = false;
            $scope.loadDelay = 500;
            $scope.isFirstSearched = false;

            $scope.getSearchList = function(){
                if($scope.isLoading || ($scope.page > $scope.totalPages-1)) return;
                $scope.isLoading = true;
                $scope.page++;

                var params = {
                    page: $scope.page,
                    size: $scope.pageSize
                };
                restApiSvc.get(restApiSvc.apiPath.participationWorksLists($scope.userId), params).then(
                    function(res){
                        $scope.addLists(res);
                    },function(res, status){
                        
                    }
                );
            };
            $scope.addLists = function(loadedLists){
                var tempList = loadedLists.data.data.content;
                
                if($scope.participationWorkIds.length > 0){
                    angular.forEach(tempList, function(tempVal, idx){
                        var isSelected = false;
                        angular.forEach($scope.participationWorkIds, function(workVal, idx){
                            if(tempVal.id == workVal.id){
                                isSelected = true;
                            };
                        });
                        if(isSelected){
                            tempVal.selected = true;
                        }else{
                            tempVal.selected = false;
                        };
                    });
                }else{
                    angular.forEach(tempList, function(tempVal, idx){
                        tempVal.selected = false;
                    });
                };
                
                $scope.searchedLists = $scope.searchedLists.concat(tempList);
                $scope.totalPages = loadedLists.data.data.totalPages;
                
                $timeout(function(){
                    $scope.isLoading = false;
                }, $scope.loadDelay);
                
                if(!$scope.isFirstSearched) $scope.isFirstSearched = true;
            };
            
            $scope.confirm = function(){
                if($scope.participationWorkIds.length <= 0) return;
                $('.popup-participation-lists .list-wrap').css({display: 'none'});
                $scope.participationWorkIds.sort(function(a, b){return b.id - a.id});
                dep.confirmCallback($scope.participationWorkIds);
                dialogSvc.closeConfirm();
            };
            
            $scope.scrollHandler = function(e){
    //            if(!$scope.isMobile) return;

                var scrollTop = e.target.scrollTop;
                var maxScrollTop = e.target.scrollHeight - e.target.clientHeight;
                var scrollPct = (scrollTop/maxScrollTop)*100;
                $scope.onScroll(scrollTop, scrollPct);
            };
            $scope.onScroll = function(scrollTop, scrollPct){
                scrollTop = Math.abs(scrollTop);

                /** list load   */
                if(scrollPct != undefined && scrollPct >= 95){
                    $scope.getSearchList();
                };
            };

            $scope.popupClose = function(){
                $('.popup-participation-lists .list-wrap').css({display: 'none'});
                dep.confirmCallback($scope.copyParticipationWorkIds);
                dialogSvc.closeConfirm();
            };
        
            $scope.$watch(function(){
                return angular.element($window).width();
            }, function(newVal, oldVal){
                if(newVal > 1024){
                    $scope.listColumnLength = 4;
                }else if(newVal > 767 && newVal <= 1024){
                    $scope.listColumnLength = 3;
                }else{
                    $scope.listColumnLength = 2;
                }
            });

            $scope.$watch('searchedLists', function(newVal, oldVal){
                if(newVal.length > 0 && oldVal.length == 0){
                    $timeout(function(){
                        $('.searched-lists-container').bind('scroll', $scope.scrollHandler);
                    });
                };
            });

            /** initialize  */
            $scope.getSearchList();
        }
        
        function openDialog(ctrl, tempUrl, outsideClose, params, callback){
            $mdDialog.show({
                controller: ctrl,
                templateUrl: tempUrl,
                clickOutsideToClose: outsideClose,
                escapeToClose: outsideClose,
                parent: angular.element(document.body),
                preserveScope: true,
                locals: {
                    dialogParams: params || null
                }
            })
            .then(function(params) {
                if(callback != null || callback != undefined){
                    callback(params);
                }
            }, function() {
                
            });
        }
        
        return {
            confirmDialogType: dialogType,
            confirmDialog: function(type, callback, data){
                ngDialog.open({
                    controller: ['$scope', 'dep', confirmDialogCtrl],
                    template: '/views/dialog/confirm/confirm.html',
                    className: 'ngdialog-theme-default popup-confirm-wrap',
                    resolve: {
                        dep: function depFactory() {
                            return {
                                confirmType: type,
                                confirmCallback: callback,
                                data: data
                            };
                        }
                    }
                });
            },
            openParticipationWorksLists: function(userId, participationWorkIds, callback){
                ngDialog.open({
                    controller: ['$rootScope', '$scope', '$window', '$timeout', 'dep', 'restApiSvc', 'dialogSvc', 'blockUI', participationWorksCtrl],
                    template: '/views/dialog/upload/participationWorksLists.html',
                    className: 'ngdialog-theme-default popup-participation-lists-dialog',
                    resolve: {
                        dep: function depFactory() {
                            return {
                                userId: userId,
                                participationWorkIds: participationWorkIds,
                                confirmCallback: callback
                            };
                        }
                    }
                });
            },
            openBanner: function (params) {
                openDialog('popupBannerCtrl', '/views/dialog/main/banner.html', false, params);
            },
            openAccount: function (params) {
                openDialog('popupAccountCtrl', '/views/dialog/account/account.html', false, params);
            },
            openSearchedList: function (params) {
                openDialog('searchedListsCtrl', '/views/dialog/search/searchedLists.html', false, params);
            },
            openUploadImage: function (params) {
                openDialog('uploadImageCtrl', '/views/dialog/upload/uploadImage.html', false, params);
            },
            openUploadWriting: function (params) {
                openDialog('uploadWritingCtrl', '/views/dialog/upload/uploadWriting.html', false, params);
            },
            openUploadVideo: function (params) {
                openDialog('uploadVideoCtrl', '/views/dialog/upload/uploadVideo.html', false, params);
            },
            openUploadShow: function (params) {
                openDialog('uploadShowCtrl', '/views/dialog/upload/uploadShow.html', false, params);
            },
            openPeopleLists: function (params) {
                openDialog('peopleListCtrl', '/views/dialog/people/peopleLists.html', false, params);
            },
            openCuratorPick: function (params) {
                openDialog('curatorPickCtrl', '/views/dialog/detail/curatorPick.html', false, params);
            },
            openFlagAnIssue: function (params) {
                openDialog('flagAnIssueCtrl', '/views/dialog/detail/flagAnIssue.html', true, params);
            },
            close: function (params) {
				$mdDialog.hide(params);
			},
            closeConfirm: function(){
                ngDialog.closeAll();
            }
		};
    }]);
    
})(angular);
