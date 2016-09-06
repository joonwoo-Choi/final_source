(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');

    BBuzzArtApp.controller('uploadBtnCtrl', ['$rootScope', '$scope', '$timeout', '$mdMenu', 'trackerSvc', 'authSvc', 'dialogSvc', function ($rootScope, $scope, $timeout, $mdMenu, trackerSvc, authSvc, dialogSvc) {
        
        $scope.isMobile = $rootScope.isMobile;
        $scope.isLogin = authSvc.isLogin();
        $scope.isOpen = false;
        $scope.uploadBtns = [
            {title:'IMAGE', src:'/images/btn_upload_image.png'},
            {title:'WRITING', src:'/images/btn_upload_writing.png'},
            {title:'VIDEO', src:'/images/btn_upload_video.png'},
            {title:'SHOW', src:'/images/btn_upload_show.png'},
        ];
        
        $scope.toggleOpen = function($mdOpenMenu, e){
            $scope.isOpen = true;
            $mdOpenMenu(e);
        };
        
        $scope.popupUpload = function(type){
            $scope.isOpen = false;
            $mdMenu.hide();
            switch(type){
                case 'IMAGE' :
                    trackerSvc.eventTrack('IMAGE UPLOAD', {category:'UPLOAD'});
                    if(authSvc.isLogin()){
                        dialogSvc.openUploadImage();
                    }else{
                        dialogSvc.openAccount({type: 'IMAGE'});
                    }
                    break;
                case 'WRITING' :
                    trackerSvc.eventTrack('WRITING UPLOAD', {category:'UPLOAD'});
                     if(authSvc.isLogin()){
                        dialogSvc.openUploadWriting();
                    }else{
                        dialogSvc.openAccount({type: 'WRITING'});
                    }
                    break;
                case 'VIDEO' :
                    trackerSvc.eventTrack('VIDEO UPLOAD', {category:'UPLOAD'});
                     if(authSvc.isLogin()){
                        dialogSvc.openUploadVideo();
                    }else{
                        dialogSvc.openAccount({type: 'VIDEO'});
                    }
                    break;
                case 'SHOW' :
                    trackerSvc.eventTrack('SHOW UPLOAD', {category:'UPLOAD'});
                     if(authSvc.isLogin()){
                        dialogSvc.openUploadShow();
                    }else{
                        dialogSvc.openAccount({type: 'SHOW'});
                    }
                    break;
            }
        }
        
        $scope.$on('$mdMenuClose', function(e, el) {
            angular.forEach(el, function(val, idx){
                if($(val).hasClass('btn-upload-menu')){
                    $scope.isOpen = false;
                }
            });
        });

        $scope.$on('$mdMenuOpen', function(e, el) {
            
        });
        
        $scope.$on('$stateChangeStart', function(e, to, params){
            $mdMenu.hide();
            $scope.isOpen = false;
        });
        
    }]);

})(angular);
