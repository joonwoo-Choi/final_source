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
                    controller: 'participationWorksCtrl',
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
