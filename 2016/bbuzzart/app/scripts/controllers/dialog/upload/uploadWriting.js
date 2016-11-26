(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');

    BBuzzArtApp.controller('uploadWritingCtrl', ['$scope', '$timeout', '$mdMenu', '$state', 'Cropper', 'Upload', 'authSvc', 'dialogSvc', 'restApiSvc', 'convertFileSvc', 'dialogParams', 'blockUI', function ($scope, $timeout, $mdMenu, $state, Cropper, Upload, authSvc, dialogSvc, restApiSvc, convertFileSvc, dialogParams, blockUI) {
        
        $scope.years = getYears();
        $scope.tagsMaxLength = 10;
        $scope.uploadInfo = {};
        $scope.uploadInfo.file = null;
        $scope.uploadInfo.convertedFile = null;
        $scope.uploadInfo.workWriting = {
            title: '',
            abstractText: '',
            backgroundImage: '',
            tags: ['writing'],
            year: $scope.years[0]
        };
        $scope.defaultBackgroundImageLists = [];
        $scope.convertedFileThumbnailDataurl = null;
        $scope.writingThumbnailUrl = '/images/thumbnail_default_img.png';
        $scope.isEditUpload = false;
        $scope.editInfo = {};
        $scope.activate = '';
        $scope.error = {
            image:'',
            title:'',
            abstractText:'',
            tag:''
        };
        
        $scope.tagKeyDown = function(e){
            var keyCode = e.keyCode > 0 ? e.keyCode : e.charCode;
            if((keyCode >= 33 && keyCode <= 43) || 
               (keyCode >= 45 && keyCode <= 47) || 
               (keyCode >= 58 && keyCode <= 64) || 
               (keyCode >= 91 && keyCode <= 94) || 
               (keyCode == 96) ||
               (keyCode >= 123 && keyCode <= 126)){
                   
                e.preventDefault();
                return;
            };
            
            if(keyCode == 13 || keyCode== 32 || keyCode== 44){
                e.preventDefault();
                $scope.tagListCheck();
            };
        };
        
        $scope.tagListCheck = function(){
            $timeout(function(){
                var tagText = String($('.popup-upload-writing .input-tag .input').val());
                tagText = tagText.replace(/#|,/g, ' ');
                tagText = tagText.replace(/\s+/g, ' ');
                tagText = escape(tagText);
                tagText = tagText.replace(/%u202A|%u200E|%u202C/g, '');
                tagText = tagText.replace(/%20/g, ' ');
                if(tagText.charAt(tagText.length-1) == ' '){
                    tagText = tagText.slice(0, tagText.length-1);
                };
                if(tagText.charAt(0) == ' '){
                    tagText = tagText.slice(1);
                };
                var tagsArr = tagText.split(' ');
                $scope.tagListUpdate(tagsArr);
            });
        };
        
        $scope.tagListUpdate = function(tagsArr){
            var tempArr = [];
            angular.forEach(tagsArr, function(val, key){
                if(key < $scope.tagsMaxLength){
                    var cnt = 0;
                    var bool = true;
                    do {
                        if(tempArr[cnt] == val) bool = false;
                        cnt++;
                    }
                    while (cnt < tempArr.length);
                    if(bool) tempArr.push(val);
                };
            });
            tagsArr = tempArr;
            if(tagsArr.length > $scope.tagsMaxLength) {
                tagsArr = $scope.uploadInfo.tags;
            };
            if(tagsArr[0] == '') tagsArr.length = 0;
            $scope.uploadInfo.workWriting.tags = tagsArr;
            var tagTxt = '';
            angular.forEach($scope.uploadInfo.workWriting.tags, function(val, key){
                if(val.indexOf('#') <= -1) val = '#' + val;
                tagTxt +=  val + ', ';
                $scope.uploadInfo.workWriting.tags[key] = val;
            });
            if ($(".popup-upload-writing .input-tag .input").is(":focus")) {
                tagTxt = tagTxt + '#';
            };
            $('.popup-upload-writing .input-tag .input').val(tagTxt);
        };
        
        $scope.openDefaultImageLists = function($mdOpenMenu, e){
            $mdOpenMenu(e);
        };
        $scope.defaultBackgroundImageSelect = function(image){
            $scope.uploadInfo.workWriting.backgroundImage = image;
            $scope.removeFile();
        };
        
        $scope.uploadWriting = function(){
            if(validateData($scope, true)){
                uploadArtwork($scope, $state, authSvc, restApiSvc, blockUI, $scope.uploadInfo);
            }else{
                console.log('validate-error');
            };
        };
        
        $scope.removeFile = function(){
            $scope.uploadInfo.file = null;
            $scope.uploadInfo.convertedFile = null;
        };
        
        $scope.popupClose = function(){
            dialogSvc.confirmDialog(dialogSvc.confirmDialogType.uploadCancel, function(answer){
                if(answer == 'yes'){
                    dialogSvc.close();
                    dialogSvc.closeConfirm();
                }else{
                    dialogSvc.closeConfirm();
                };
            });
        };
        
        $scope.convertFile = function(file){
            convertFileSvc.convertFile(file, function(convertedFile, dataUrl){
                if(convertedFile == null){
                    $scope.uploadInfo.file = null;
                }else{
                    Upload.imageDimensions(convertedFile).then(function(dimensions){
                        var originW = dimensions.width,
                            originH = dimensions.height,
                            cropData = {
                                x: 0,
                                y: 0,
                                rotate: 0
                            };
                        
                        if(originW > originH){
                            cropData.width = originH*0.8;
                            cropData.height = originH;
                            cropData.x = (originW - cropData.width)/2;
                        }else{
                            cropData.width = originW;
                            cropData.height = originW*1.25;
                            cropData.y = (originH - cropData.height)/2
                        };
                        
                        Cropper.crop(convertedFile, cropData).then(function(cropedFile){
                            $scope.uploadInfo.convertedFile = cropedFile;
                            Upload.dataUrl(cropedFile, true).then(function(cropedDataUrl){
                                $scope.uploadInfo.workWriting.backgroundImage = '';
                                $scope.convertedFileThumbnailDataurl = cropedDataUrl;
                            });
                        });
                    });
                };
            });
        };
        
        /** input tag focus check   */
        $scope.$watch(function(){
            return $scope.focusTag;
        }, function(newVal, oldVal){
            if(newVal){
                var tagTxt = $('.popup-upload-writing .input-tag .input').val();
                $('.popup-upload-writing .input-tag .input').val(tagTxt + ' #');
            };
        });
        
        /** upload possible check   */
        $scope.$watchCollection('uploadInfo', function(newVal, oldVal){
            if(validateData($scope)) $scope.activate = 'activate';
            else $scope.activate = '';
        });
        $scope.$watchCollection('uploadInfo.workWriting', function(newVal, oldVal){
            if(validateData($scope)) $scope.activate = 'activate';
            else $scope.activate = '';
        });
        
        $scope.$watch(function(){
            return $scope.uploadInfo.workWriting.backgroundImage;
        }, function(newVal, oldVal){
            if(newVal == null) return;
            
            if(newVal.length > 0){
                $scope.convertedFileThumbnailDataurl = '';
                $scope.writingThumbnailUrl = newVal;
            };
        });
        $scope.$watch(function(){
            return $scope.convertedFileThumbnailDataurl;
        }, function(newVal, oldVal){
            if(newVal == null) return;
            
            if(newVal.length > 0){
                $scope.uploadInfo.workWriting.backgroundImage = '';
                $scope.writingThumbnailUrl = newVal;
            };
        });
        
        $timeout(function(){
            if(dialogParams == null){
                restApiSvc.get(restApiSvc.apiPath.getWritingBackground).then(
                    function(res){
                        $scope.defaultBackgroundImageLists = res.data.data;
                        $scope.defaultBackgroundImageSelect($scope.defaultBackgroundImageLists[0].image);
                    },function(err){
                        
                    }
                );
                $scope.tagListUpdate($scope.uploadInfo.workWriting.tags);
            }else{
                $scope.isEditUpload = true;
                $scope.editInfo = dialogParams.detailData;
                $scope.uploadInfo.file = '';
                $scope.uploadInfo.convertedFile = '';
                $scope.uploadInfo.workWriting = {
                    title: $scope.editInfo.title,
                    abstractText: $scope.editInfo.abstractText,
                    backgroundImage: '',
                    tags: $scope.editInfo.tags,
                    year: $scope.editInfo.year || $scope.years[0]
                };
                $scope.writingThumbnailUrl = $scope.editInfo.attachments[0].thumbnail.small;
                $scope.tagListUpdate($scope.uploadInfo.workWriting.tags);
            };
        }, 10);
        
    }]);
    
    function validateData($scope, isErrorCheck){
        var validate = true;
        if(!$scope.isEditUpload){
            if(!$scope.uploadInfo.convertedFile && $scope.uploadInfo.workWriting.backgroundImage.length <= 0){
                validate = false;
                if(isErrorCheck) $scope.error.image = 'error';
            };
        };
        if (!$scope.uploadInfo.workWriting.title) {
            validate = false;
            if(isErrorCheck) $scope.error.title = 'error';
        };
        if (!$scope.uploadInfo.workWriting.abstractText) {
            validate = false;
            if(isErrorCheck) $scope.error.abstractText = 'error';
        };
        
        return validate;
    };
    
    function getYears(){
        var years = [];
        var currentYear = new Date().getFullYear();
        for(var i = currentYear; i >= 1900; i--){
            years.push(i);
        };
        years.unshift('Year');
        return years;
    };
    
    function uploadArtwork($scope, $state, authSvc, restApiSvc, blockUI, uploadInfo){
        var params = {
                workWriting: {
                    title: uploadInfo.workWriting.title,
                    abstractText: uploadInfo.workWriting.abstractText,
                    backgroundImage: uploadInfo.workWriting.backgroundImage,
                    tags: uploadInfo.workWriting.tags,
                    year: uploadInfo.workWriting.year
                }
            };
        
        blockUI.start();
        var apiPath = restApiSvc.apiPath.uploadWriting;
        var contentType = '';
        if(!$scope.isEditUpload){
            contentType = 'form';
            if(params.workWriting.year == $scope.years[0]) params.workWriting.year = '';
            params.workWriting = restApiSvc.jsonToString(params.workWriting);
            params.file = uploadInfo.convertedFile;
            params = restApiSvc.jsonToForm(params);
        }else{
            params = params.workWriting;
            if(params.year == $scope.years[0]) params.year = '';
            apiPath = restApiSvc.apiPath.editWriting($scope.editInfo.id);
        }
        
        restApiSvc.post(apiPath, params, contentType).then(
            function(res){
                blockUI.stop();
                if(!$scope.isEditUpload){
                    $state.go('my-feeds', {}, {reload: true});
                }else{
                    location.reload();
                }
            },function(err){
                blockUI.stop();
            }
        );
    }

})(angular);
