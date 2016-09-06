(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');

    BBuzzArtApp.controller('uploadVideoCtrl', ['$scope', '$timeout', '$state', 'authSvc', 'dialogSvc', 'restApiSvc', 'dialogParams', 'blockUI', 'timeSvc', function ($scope, $timeout, $state, authSvc, dialogSvc, restApiSvc, dialogParams, blockUI, timeSvc) {
        
        $scope.years = getYears();
        $scope.tagsMaxLength = 10;
        $scope.uploadInfo = {};
        $scope.uploadInfo.inputUrl = '';
        $scope.uploadInfo.title = '';
        $scope.uploadInfo.name = authSvc.getUserInfo().username;
        $scope.uploadInfo.note = '';
        $scope.uploadInfo.tags = ['video'];
        $scope.uploadInfo.convertedDuration = '';
        $scope.uploadInfo.year = $scope.years[0];
        $scope.isEditUpload = false;
        $scope.editInfo = {};
        $scope.activate = '';
        $scope.error = {
            url:'',
            title:'',
            note:'',
            tag:''
        };
        
        $scope.videoUrlCheck = function(){
            if(validateUrl($scope.uploadInfo.inputUrl)){
                restApiSvc.get(restApiSvc.apiPath.getVideoInfo, {url:$scope.uploadInfo.inputUrl}).then(
                    function(res){
                        if(res.data.data.serviceType != null){
                            $scope.uploadInfo.title = res.data.data.title;
                            $scope.uploadInfo.note = res.data.data.description;
                            $scope.uploadInfo.duration = res.data.data.duration;
                            $scope.uploadInfo.convertedDuration = timeSvc.getDuration(res.data.data.duration) || '';
                            $scope.uploadInfo.thumbnail = res.data.data.thumbnail_url;
                            $scope.uploadInfo.videoId = res.data.data.video_id;
                            $scope.uploadInfo.videoUrl = res.data.data.video_url;
                            $scope.uploadInfo.serviceType = res.data.data.serviceType;
                        }else{
                            dialogSvc.confirmDialog(dialogSvc.confirmDialogType.videoUrl, function(answer){
                                dialogSvc.closeConfirm();
                            });
                        }
                    },function(res, status){
                        
                    }
                );
            }else{
                dialogSvc.confirmDialog(dialogSvc.confirmDialogType.videoUrl, function(answer){
                    dialogSvc.closeConfirm();
                });
            }
        }
        
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
            }
            
            if(keyCode == 13 || keyCode== 32 || keyCode== 44){
                e.preventDefault();
                $scope.tagListCheck();
            }
        }
        
        $scope.tagListCheck = function(){
            $timeout(function(){
                var tagText = String($('.popup-upload-video .input-tag .input').val());
                tagText = tagText.replace(/#|,/g, ' ');
                tagText = tagText.replace(/\s+/g, ' ');
                tagText = escape(tagText);
                tagText = tagText.replace(/%u202A|%u200E|%u202C/g, '');
                tagText = tagText.replace(/%20/g, ' ');
                if(tagText.charAt(tagText.length-1) == ' '){
                    tagText = tagText.slice(0, tagText.length-1);
                }
                if(tagText.charAt(0) == ' '){
                    tagText = tagText.slice(1);
                }
                var tagsArr = tagText.split(' ');
                $scope.tagListUpdate(tagsArr);
            });
        }
        
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
                }
            });
            tagsArr = tempArr;
            if(tagsArr.length > $scope.tagsMaxLength) {
                tagsArr = $scope.uploadInfo.tags;
            }
            if(tagsArr[0] == '') tagsArr.length = 0;
            $scope.uploadInfo.tags = tagsArr;
            var tagTxt = '';
            angular.forEach($scope.uploadInfo.tags, function(val, key){
                if(val.indexOf('#') <= -1) val = '#' + val;
                tagTxt +=  val + ', ';
                $scope.uploadInfo.tags[key] = val;
            });
            if ($(".popup-upload-video .input-tag .input").is(":focus")) {
                tagTxt = tagTxt + '#';
            }
            $('.popup-upload-video .input-tag .input').val(tagTxt);
        }
        
        $scope.uploadVideo = function(){
            if(validateData($scope, true)){
                uploadArtwork($scope, $state, authSvc, restApiSvc, blockUI, $scope.uploadInfo);
            }else{
                console.log('validate-error');
            }
        }
        
        $scope.popupClose = function(){
            dialogSvc.confirmDialog(dialogSvc.confirmDialogType.uploadCancel, function(answer){
                if(answer == 'yes'){
                    dialogSvc.close();
                    dialogSvc.closeConfirm();
                }else{
                    dialogSvc.closeConfirm();
                }
            });
        }
        
        /** input tag focus check   */
        $scope.$watch(function(){
            return $scope.focusTag;
        }, function(newVal, oldVal){
            if(newVal){
                var tagTxt = $('.popup-upload-video .input-tag .input').val();
                $('.popup-upload-video .input-tag .input').val(tagTxt + ' #');
            }
        });
        
        /** upload possible check   */
        $scope.$watchCollection('uploadInfo', function(newVal, oldVal){
            if(validateData($scope)) $scope.activate = 'activate';
            else $scope.activate = '';
        });
        
        /** initialize  */
        $timeout(function(){
            if(dialogParams == null){
                $scope.tagListUpdate($scope.uploadInfo.tags);
            }else{
                $scope.isEditUpload = true;
                $scope.editInfo = dialogParams.detailData;
                $scope.uploadInfo.inputUrl = $scope.editInfo.video_url;
                $scope.uploadInfo.videoId = $scope.editInfo.video_id;
                $scope.uploadInfo.videoUrl = $scope.editInfo.video_url;
                $scope.uploadInfo.title = $scope.editInfo.title;
                $scope.uploadInfo.note = $scope.editInfo.note;
                $scope.uploadInfo.duration = $scope.editInfo.duration;
                $scope.uploadInfo.convertedDuration = $scope.editInfo.convertedDuration;
                $scope.uploadInfo.year = $scope.editInfo.year || $scope.years[0];
                $scope.uploadInfo.thumbnail = $scope.editInfo.attachments[0].thumbnail.small;
                $scope.uploadInfo.serviceType = $scope.editInfo.serviceType;
                $scope.uploadInfo.tags = $scope.editInfo.tags;
                $scope.tagListUpdate($scope.uploadInfo.tags);
            }
        }, 10);
        
    }]);
    
    function validateData($scope, isErrorCheck){
        var validate = true;
        if (!$scope.uploadInfo.inputUrl) {
            validate = false;
            if(isErrorCheck) $scope.error.inputUrl = 'error';
        }
        if (!$scope.uploadInfo.title) {
            validate = false;
            if(isErrorCheck) $scope.error.title = 'error';
        }
        if (!$scope.uploadInfo.note) {
            validate = false;
            if(isErrorCheck) $scope.error.note = 'error';
        }
        
        return validate;
    };
    
    function validateUrl(url){
        var pattern = /(https?:\/\/)?([\w\-])+\.{1}([a-zA-Z]{2,63})([\/\w-]*)*\/?\??([^#\n\r]*)?#?([^\n\r]*)/g;
        return pattern.test(url);
    }
    
    function getYears(){
        var years = [];
        var currentYear = new Date().getFullYear();
        for(var i = currentYear; i >= 1900; i--){
            years.push(i);
        }
        years.unshift('Year');
        return years;
    }
    
    function uploadArtwork($scope, $state, authSvc, restApiSvc, blockUI, uploadInfo){
        var params = {
                video_id: $scope.uploadInfo.videoId,
                video_url: $scope.uploadInfo.videoUrl,
                thumbnail_url: $scope.uploadInfo.thumbnail,
                title: $scope.uploadInfo.title,
                tags: $scope.uploadInfo.tags,
                note: $scope.uploadInfo.note,
                duration: $scope.uploadInfo.duration,
                year: $scope.uploadInfo.year,
                serviceType: $scope.uploadInfo.serviceType
            };
        if(params.year == $scope.years[0]) params.year = '';
        
        blockUI.start();
        var apiPath = restApiSvc.apiPath.uploadVideo;
        if($scope.isEditUpload){
            apiPath = restApiSvc.apiPath.editVideo($scope.editInfo.id);
        }
        restApiSvc.post(apiPath, params).then(
            function(res){
                blockUI.stop();
                if(!$scope.isEditUpload){
//                    $state.go('detail', {artworkType:res.data.data.type, id:res.data.data.id}, {reload: true});
                    $state.go('my-feeds', {}, {reload: true});
                }else{
                    location.reload();
                }
            },function(res, status){
                blockUI.stop();
            }
        );
    }


})(angular);
