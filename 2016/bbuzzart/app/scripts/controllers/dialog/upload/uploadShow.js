(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');

    BBuzzArtApp.controller('uploadShowCtrl', ['$scope', '$http', '$timeout', '$state', 'Upload', 'authSvc', 'dialogSvc', 'restApiSvc', 'convertFileSvc', 'dialogParams', 'blockUI', function ($scope, $http, $timeout, $state, Upload, authSvc, dialogSvc, restApiSvc, convertFileSvc, dialogParams, blockUI) {
        
        $scope.tagsMaxLength = 10;
        $scope.uploadInfo = {};
        $scope.uploadInfo.file = '';
        $scope.uploadInfo.convertedFile = null;
        $scope.uploadInfo.workShow = {
            title: '',
            startDate: '',
            endDate: '',
            place: '',
            latitude: 0,
            longitude: 0,
            introduction: '',
            homepage: '',
            contact: '',
            participationWorkIds: [],
            tags: ['show']
        };
        $scope.participationWorksLists = [];
        $scope.showThumbnailUrl = '';
        $scope.isShowFileThumb = false;
        $scope.isEditUpload = false;
        $scope.editInfo = {};
        $scope.activate = '';
        $scope.error = {
            image:'',
            title:'',
            startDate:'',
            endDate:'',
            place:'',
            introduction:''
        };
        /** calendar    */
        $scope.startMinDate;
        $scope.startMaxDate;
        $scope.endMinDate;
        $scope.endMaxDate;
        /** google map  */
        $scope.map = { 
            center: { 
                latitude: 40.7127837, 
                longitude: -74.0059413
            }, 
            zoom: 15,
            options: {
                scrollwheel: false,
                mapTypeControl: false,
                scaleControl  : false,
                streetViewControl: false
            }
        };
        $scope.marker = {
            id: 0,
            coords: angular.copy($scope.map.center),
            options: { draggable: false }
        };
        
        $scope.inputAddress = function(e, address) {
            if(e.keyCode != 13) return;
            $scope.findAddress(address);
        }
        
        $scope.findAddress = function(address){
            if($scope.map.formattedAddress == address) return;
            $http.get('https://maps.googleapis.com/maps/api/geocode/json', {params: {address: address}}).
            success(function(data, status, headers, config) {
                if(data.status != 'OK') return;
                $scope.map.center = { 
                    latitude: data.results[0].geometry.location.lat,
                    longitude: data.results[0].geometry.location.lng
                }
                $scope.map.zoom = 15;
                $scope.map.formattedAddress = data.results[0].formatted_address;
                $scope.uploadInfo.workShow.place = $scope.map.formattedAddress;
                $scope.uploadInfo.workShow.latitude = $scope.map.center.latitude;
                $scope.uploadInfo.workShow.longitude = $scope.map.center.longitude;
            });
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
                var tagText = String($('.popup-upload-show .input-tag .input').val());
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
                tagsArr = $scope.uploadInfo.workShow.tags;
            }
            if(tagsArr[0] == '') tagsArr.length = 0;
            $scope.uploadInfo.workShow.tags = tagsArr;
            var tagTxt = '';
            angular.forEach($scope.uploadInfo.workShow.tags, function(val, key){
                if(val.indexOf('#') <= -1) val = '#' + val;
                tagTxt +=  val + ', ';
                $scope.uploadInfo.workShow.tags[key] = val;
            });
            if ($(".popup-upload-show .input-tag .input").is(":focus")) {
                tagTxt = tagTxt + '#';
            }
            $('.popup-upload-show .input-tag .input').val(tagTxt);
        }
        
        $scope.onlyNumber = function(e, value, isDot){
            var contact = $scope.uploadInfo.workShow.contact;
            var keyCode = e.keyCode > 0 ? e.keyCode : e.charCode;
            
            if( (keyCode == 189 && contact.charAt(contact.length-1) == '-')
               || (keyCode == 189 && contact.charAt(contact.length-1) == '.')
               || (keyCode == 110 && contact.charAt(contact.length-1) == '-')
               || (keyCode == 110 && contact.charAt(contact.length-1) == '.')
               || (keyCode == 190 && contact.charAt(contact.length-1) == '-')
               || (keyCode == 190 && contact.charAt(contact.length-1) == '.')
              ) {
                e.preventDefault();
            };
            
            if( !(keyCode == 8                              // backspace
                || keyCode == 9                             // tap
                || keyCode == 189                           // hyphen
                || keyCode == 110                           // dot
                || keyCode == 190                           // dot
                || (keyCode >= 48 && keyCode <= 57)         // numbers on keyboard
                || (keyCode >= 96 && keyCode <= 105))       // numbers on keyboard
               ) {
                e.preventDefault();
            };
        }
        
        $scope.openParticipationWorksLists = function(){
            dialogSvc.openParticipationWorksLists(authSvc.getUserInfo().id, $scope.participationWorksLists, function(selectedLists){
                $scope.participationWorksLists = selectedLists;
                $scope.uploadInfo.workShow.participationWorkIds.length = 0;
                angular.forEach($scope.participationWorksLists, function(val, idx){
                    $scope.uploadInfo.workShow.participationWorkIds.push(val.id);
                });
            });
        }
        $scope.removeSelectedWork = function(idx){
            $scope.participationWorksLists.splice(idx, 1);
            $scope.uploadInfo.workShow.participationWorkIds.splice(idx, 1);
        }
        
        $scope.btnUploadShow = function(){
            if(validateData($scope, true)){
                $scope.uploadShow();
            }else{
                console.log('validate-error');
            }
        }
        $scope.uploadShow = function(){
            if($scope.uploadInfo.workShow.homepage.length > 0 && !validateUrl($scope.uploadInfo.workShow.homepage)){
                dialogSvc.confirmDialog(dialogSvc.confirmDialogType.validateUrl, function(answer){
                    dialogSvc.closeConfirm();
                });
                return;
            };
            
            var params = {
                    workShow: {
                        title: $scope.uploadInfo.workShow.title,
                        startDate: $scope.uploadInfo.workShow.startDate,
                        endDate: $scope.uploadInfo.workShow.endDate,
                        place: $scope.uploadInfo.workShow.place,
                        latitude: $scope.uploadInfo.workShow.latitude,
                        longitude: $scope.uploadInfo.workShow.longitude,
                        introduction: $scope.uploadInfo.workShow.introduction,
                        homepage: $scope.uploadInfo.workShow.homepage,
                        contact: $scope.uploadInfo.workShow.contact,
                        participationWorkIds: $scope.uploadInfo.workShow.participationWorkIds,
                        tags: $scope.uploadInfo.workShow.tags
                    }
                };
            
            blockUI.start();
            var apiPath = restApiSvc.apiPath.uploadShow;
            var contentType = undefined;
            if(!$scope.isEditUpload){
                contentType = 'form';
                params.workShow = restApiSvc.jsonToString(params.workShow);
                params.file = $scope.uploadInfo.convertedFile;
                params = restApiSvc.jsonToForm(params);
            }else{
                params = params.workShow;
                apiPath = restApiSvc.apiPath.editShow($scope.editInfo.id);
            }
            restApiSvc.post(apiPath, params, contentType).then(
                function(res){
                    blockUI.stop();
                    if(!$scope.isEditUpload){
//                        $state.go('detail', {artworkType:res.data.data.type, id:res.data.data.id}, {reload: true});
                        $state.go('my-feeds', {}, {reload: true});
                    }else{
                        location.reload();
                    }
                },function(res, status){
                    blockUI.stop();
                }
            );
        }
        
        $scope.removeFile = function(){
            $scope.uploadInfo.file = null;
            $scope.uploadInfo.convertedFile = null;
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
        
        $scope.convertFile = function(file){
            blockUI.start();
            convertFileSvc.convertFile(file, function(convertedFile){
                blockUI.stop();
                $scope.uploadInfo.convertedFile = convertedFile;
                if(convertedFile == null) $scope.uploadInfo.file = null;
            });
        }
        
        /** googlemap location change   */
        $scope.$watch(function(){
            return $scope.map.center;
        }, function(newVal, oldVal){
            /** 브라우저 언어 설정 가져오기 */
//            var userLang = navigator.language || navigator.userLanguage;
            $http.get('https://maps.googleapis.com/maps/api/geocode/json', {
                params: {latlng: newVal.latitude + ',' + newVal.longitude, language:'en'}
            }).
            success(function(data, status, headers, config) {
                if(data.status != 'OK') return;
                $scope.map.formattedAddress = data.results[0].formatted_address;
                $scope.uploadInfo.workShow.place = $scope.map.formattedAddress;
                $scope.uploadInfo.workShow.latitude =data.results[0].geometry.location.lat;
                $scope.uploadInfo.workShow.longitude = data.results[0].geometry.location.lng;
                
                /** upload btn show */
                $('.select-image-wrap').addClass('show-upload');
            });
        }, true);
        
        /** input tag focus check   */
        $scope.$watch(function(){
            return $scope.focusTag;
        }, function(newVal, oldVal){
            if(newVal){
                var tagTxt = $('.popup-upload-show .input-tag .input').val();
                $('.popup-upload-show .input-tag .input').val(tagTxt + ' #');
            }
        });
        
        /** upload possible check   */
        $scope.$watchCollection('uploadInfo', function(newVal, oldVal){
            if(validateData($scope)) $scope.activate = 'activate';
            else $scope.activate = '';
        });
        $scope.$watchCollection('uploadInfo.workShow', function(newVal, oldVal){
            if(validateData($scope)) $scope.activate = 'activate';
            else $scope.activate = '';
        });
        
        $scope.$watch('uploadInfo.convertedFile', function(newVal, oldVal){
            if(newVal != null){
                Upload.dataUrl(newVal, true).then(function(dataUrl){
                    $scope.isShowFileThumb = true;
                    $scope.showThumbnailUrl = dataUrl;
                });
            }else{
                $scope.isShowFileThumb = false;
            }
        });
        
        $scope.$watch('uploadInfo.workShow.startDate', function(newVal, oldVal){
            $scope.endMinDate = newVal;
        });
        $scope.$watch('uploadInfo.workShow.endDate', function(newVal, oldVal){
            $scope.startMaxDate = newVal;
        });
        
        $scope.imgLoadComplete = function(idx){
            var listWidth = $('.selected-works-wrap li').width();
            $('.selected-works-wrap li').css({
                height: listWidth
            });
            var target = $('.selected-works-wrap .work-thumbnail')[idx];
            var imgWidth = target.naturalWidth;
            var imgHeight = target.naturalHeight;
            var currWidth;
            var currHeight;
            if(imgWidth > imgHeight){
                angular.element(target).css({
                    width: 'auto',
                    height: '100%'
                });
                currWidth = angular.element(target).width();
                currHeight = angular.element(target).height();
                angular.element(target).css({
                    'margin-left': (currHeight-currWidth)/2+'px'
                });
            }else{
                angular.element(target).css({
                    width: '100%',
                    height: 'auto'
                });
                currWidth = angular.element(target).width();
                currHeight = angular.element(target).height();
                angular.element(target).css({
                    'margin-top': (currWidth-currHeight)/2+'px'
                });
            }
        }

        $scope.participationWorksResize = function(){
            var listWidth = $('.selected-works-wrap li').width();
            $('.selected-works-wrap li').css({
                height: listWidth
            });
            angular.forEach($scope.participationWorksLists, function(val, idx){
                if($('.selected-works-wrap li').eq(idx).css('width') == 'auto'){
                    var target = $('.selected-works-wrap li .work-thumbnail').eq(idx),
                        imgHeight = target.height();
                    target.css({
                        'margin-top': (listWidth-imgHeight)/2+'px'
                    });
                }else{
                    var target = $('.selected-works-wrap li .work-thumbnail').eq(idx),
                        imgWidth = target.width();
                    target.css({
                        'margin-left': (listWidth-imgWidth)/2+'px'
                    });
                }
            });
        }

        angular.element(window).bind('resize', function(){
            $scope.participationWorksResize();
        });
        
        /** initialize  */
        $timeout(function(){
            
            if(dialogParams == null){
                /** calendar    */
                var now = new Date(),
                    minDate = new Date(
                        now.getFullYear(),
                        now.getMonth() - 12,
                        now.getDate()
                    ),
                    maxDate = new Date(
                        now.getFullYear(),
                        now.getMonth() + 12,
                        now.getDate()
                    );
                $scope.startMinDate = minDate;
                $scope.startMaxDate = maxDate;
                $scope.endMinDate = minDate;
                $scope.endMaxDate = maxDate;
                
                $scope.tagListUpdate($scope.uploadInfo.workShow.tags);
                
                /** google map  */
                if("geolocation" in navigator){
                    navigator.geolocation.getCurrentPosition(function getLocation(loc){
                        $scope.map.center = { 
                            latitude: loc.coords.latitude, 
                            longitude: loc.coords.longitude
                        };
                        $scope.marker.coords = angular.copy($scope.map.center);
                    });
                }
            }else{
                /** calendar    */
                var now = new Date(dialogParams.detailData.startDate),
                    minDate = new Date(
                        now.getFullYear(),
                        now.getMonth() - 12,
                        now.getDate()
                    ),
                    maxDate = new Date(
                        now.getFullYear(),
                        now.getMonth() + 12,
                        now.getDate()
                    );
                $scope.startMinDate = minDate;
                $scope.startMaxDate = maxDate;
                $scope.endMinDate = minDate;
                $scope.endMaxDate = maxDate;
                
                $scope.isEditUpload = true;
                $scope.editInfo = dialogParams.detailData;
                $scope.uploadInfo.workShow = {
                    title: $scope.editInfo.title,
                    startDate: new Date($scope.editInfo.startDate),
                    endDate: new Date($scope.editInfo.endDate),
                    place: $scope.editInfo.place,
                    latitude: $scope.editInfo.latitude,
                    longitude: $scope.editInfo.longitude,
                    introduction: $scope.editInfo.introduction,
                    homepage: $scope.editInfo.homepage,
                    contact: $scope.editInfo.contact,
                    participationWorkIds: [],
                    tags: $scope.editInfo.tags
                }
                $scope.isShowFileThumb = true;
                $scope.showThumbnailUrl = $scope.editInfo.attachments[0].thumbnail.small;
                $scope.tagListUpdate($scope.uploadInfo.workShow.tags);
                
                angular.forEach($scope.editInfo.participationWorks, function(val, idx){
                    var tempList = {
                        id: val.id,
                        thumbnail: val.attachments[0].thumbnail.small
                    }
                    $scope.participationWorksLists.push(tempList);
                    $scope.uploadInfo.workShow.participationWorkIds.push(tempList.id);
                });
                
                /** google map  */
                $scope.map.center.latitude = $scope.uploadInfo.workShow.latitude;
                $scope.map.center.longitude = $scope.uploadInfo.workShow.longitude;
            }
        }, 10);
        
    }]);
    
    function validateData($scope, isErrorCheck){
        var validate = true;
        if (!$scope.uploadInfo.convertedFile && !$scope.isEditUpload) {
            validate = false;
            if(isErrorCheck) $scope.error.image = 'error';
        }
        if (!$scope.uploadInfo.workShow.title) {
            validate = false;
            if(isErrorCheck) $scope.error.title = 'error';
        }
        if (!$scope.uploadInfo.workShow.startDate) {
            validate = false;
            if(isErrorCheck) $scope.error.startDate = 'error';
        }
        if (!$scope.uploadInfo.workShow.endDate) {
            validate = false;
            if(isErrorCheck) $scope.error.endDate = 'error';
        }
        if (!$scope.uploadInfo.workShow.place) {
            validate = false;
            if(isErrorCheck) $scope.error.place = 'error';
        }
        if (!$scope.uploadInfo.workShow.introduction) {
            validate = false;
            if(isErrorCheck) $scope.error.introduction = 'error';
        }
        return validate;
    };
    
    function validateUrl(url){
        var pattern = /(https?:\/\/)?([\w\-])+\.{1}([a-zA-Z]{2,63})([\/\w-]*)*\/?\??([^#\n\r]*)?#?([^\n\r]*)/g;
        return pattern.test(url);
    }

})(angular);
