(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');

    BBuzzArtApp.controller('flagAnIssueCtrl', ['$scope', '$timeout', 'authSvc', 'dialogParams', 'dialogSvc', 'restApiSvc', 'blockUI', function ($scope, $timeout, authSvc, dialogParams, dialogSvc, restApiSvc, blockUI) {
        
        $scope.flagAnIssueLists = [
            'Nudify or pornography',
            'Attacks a group or individual',
            'Graphic violence',
            'Hateful speech or symbols',
            'Actively promote self-harm',
            'Copyrights & Trademark',
            'Spam',
            'Others'
        ];
        
        $scope.flagAnIssue = function(list){
            blockUI.start();
            var params = {
                'contents' : list
            };
            dialogSvc.close();
            restApiSvc.post(restApiSvc.apiPath.issues(dialogParams.artWorkId), params, 'application/json').then(
                function(res){
                    blockUI.stop();
                    if(res.data.success){
                        dialogSvc.confirmDialog(dialogSvc.confirmDialogType.issue, function(answer){
                            $scope.popupClose();
                        });
                    }
                },function(res, status){
                    blockUI.stop();
                }
            );
        };
        
        $scope.popupClose = function(){
            dialogSvc.close();
            dialogSvc.closeConfirm();
        };
        
    }]);
    
})(angular);
