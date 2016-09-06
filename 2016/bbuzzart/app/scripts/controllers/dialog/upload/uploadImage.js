(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');

    BBuzzArtApp.controller('uploadImageCtrl', ['$scope', '$timeout', '$state', 'authSvc', 'dialogSvc', 'restApiSvc', 'convertFileSvc', 'dialogParams', 'blockUI', 'Upload', function ($scope, $timeout, $state, authSvc, dialogSvc, restApiSvc, convertFileSvc, dialogParams, blockUI, Upload) {
        
        $scope.categories = [{name:'CATEGORY SELECT', value:'CATEGORY SELECT'}];
        $scope.units = ['Inch', 'cm', 'ft'];
        $scope.years = getYears();
        $scope.tagsMaxLength = 10;
        $scope.uploadInfo = {};
        $scope.uploadInfo.file = '';
        $scope.uploadInfo.convertedFile = null;
        $scope.uploadInfo.workImage = {
            category: $scope.categories[0].value,
            title: '',
            note: '',
            tags: [],
            year: $scope.years[0],
            edition: '',
            width: '',
            height: '',
            depth: '',
            sizeUnit: $scope.units[0]
        }
        $scope.imageThumbnailUrl = '';
        $scope.isShowFileThumb = false;
        $scope.isEditUpload = false;
        $scope.editInfo = {};
        $scope.activate = '';
        $scope.error = {
            image:'',
            category:'',
            title:'',
            note:'',
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
            }
            
            if(keyCode == 13 || keyCode== 32 || keyCode== 44){
                e.preventDefault();
                $scope.tagListCheck();
            }
        }
        
        $scope.tagListCheck = function(){
            $timeout(function(){
                var tagText = String($('.popup-upload-image .input-tag .input').val());
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
                tagsArr = $scope.uploadInfo.workImage.tags;
            }
            if(tagsArr[0] == '') tagsArr.length = 0;
            $scope.uploadInfo.workImage.tags = tagsArr;
            var tagTxt = '';
            angular.forEach($scope.uploadInfo.workImage.tags, function(val, key){
                if(val.indexOf('#') <= -1) val = '#' + val;
                tagTxt +=  val + ', ';
                $scope.uploadInfo.workImage.tags[key] = val;
            });
            console.log('vvvvvvvvvvvv ', $scope.uploadInfo.workImage.tags);
            if($(".popup-upload-image .input-tag .input").is(":focus")) {
                tagTxt = tagTxt + '#';
            }
            $('.popup-upload-image .input-tag .input').val(tagTxt);
        }
        
        $scope.categoryChange = function(category){
            if(category == $scope.categories[0].value) return;
            var tagsArr = JSON.parse(JSON.stringify($scope.uploadInfo.workImage.tags));
            category = category.toLowerCase();
            category = category.replace(/\s+/g, '_');
            /** 첫글자만 대문자    */
//            category = category.replace(/(?:^|\s)\S/g,  function(a) { return a.toUpperCase(); });
            tagsArr.push(category);
            $scope.tagListUpdate(tagsArr);
        }
        
        $scope.onlyNumber = function(e, value, isDot){
            var keyCode = e.keyCode > 0 ? e.keyCode : e.charCode;
            if( !(keyCode == 8                              // backspace
                || keyCode == 9                             // tap
                || (isDot && keyCode == 46 && String(value).indexOf('.') <= -1) // dot
                || (keyCode >= 48 && keyCode <= 57))        // numbers on keyboard
                ) {
                    e.preventDefault();
            }
            $timeout(function(){
                $scope.uploadInfo.workImage.width = $scope.setFixed($scope.uploadInfo.workImage.width);
                $scope.uploadInfo.workImage.height = $scope.setFixed($scope.uploadInfo.workImage.height);
                $scope.uploadInfo.workImage.depth = $scope.setFixed($scope.uploadInfo.workImage.depth);
            });
        }
        $scope.setFixed = function(size){
            if(String(size).indexOf('.') > -1){
                var numArr = String(size).split('.');
                if(numArr[1] != undefined){
                    if(numArr[1].length > 0){
                        numArr[1] = numArr[1].charAt(0);
                        size = numArr[0] + '.' + numArr[1];
                        return size
                    }
                }
            }
            return size;
        }
        
        $scope.uploadImage = function(){
            if(validateData($scope, true)){
                uploadArtwork($scope, $state, authSvc, restApiSvc, blockUI, $scope.uploadInfo);
            }else{
                console.log('validate-error');
            }
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
        
        /** input tag focus check   */
        $scope.$watch(function(){
            return $scope.focusTag;
        }, function(newVal, oldVal){
            if(newVal){
                var tagTxt = $('.popup-upload-image .input-tag .input').val();
                $('.popup-upload-image .input-tag .input').val(tagTxt + ' #');
            }
        });
        
        /** upload possible check   */
        $scope.$watchCollection('uploadInfo', function(newVal, oldVal){
            if(validateData($scope)) $scope.activate = 'activate';
            else $scope.activate = '';
        });
        $scope.$watchCollection('uploadInfo.workImage', function(newVal, oldVal){
            if(validateData($scope)) $scope.activate = 'activate';
            else $scope.activate = '';
        });
        
        $scope.$watch('uploadInfo.convertedFile', function(newVal, oldVal){
            if(newVal != null){
                Upload.dataUrl(newVal, true).then(function(dataUrl){
                    $scope.isShowFileThumb = true;
                    $scope.imageThumbnailUrl = dataUrl;
                });
            }else{
                $scope.isShowFileThumb = false;
            }
        });
        
        /** initialize  */
        getCategories($scope, restApiSvc);
        
        $scope.editInit = function(){
            if(dialogParams != null){
                $scope.isEditUpload = true;
                $scope.editInfo = dialogParams.detailData;
                $scope.uploadInfo.file = '';
                $scope.uploadInfo.convertedFile = '';
                $scope.uploadInfo.workImage = {
                    category: $scope.editInfo.category.value,
                    title: $scope.editInfo.title,
                    note: $scope.editInfo.note,
                    tags: $scope.editInfo.tags,
                    year: $scope.editInfo.year || $scope.years[0],
                    edition: $scope.editInfo.edition || '',
                    width: Number($scope.editInfo.width) || '',
                    height: Number($scope.editInfo.height) || '',
                    depth: Number($scope.editInfo.depth) || '',
                    sizeUnit: $scope.editInfo.sizeUnit || 'Inch'
                }
                if($scope.uploadInfo.workImage.sizeUnit.indexOf('in') > -1){
                    $scope.uploadInfo.workImage.sizeUnit = 'Inch';
                }
                if(typeof($scope.uploadInfo.workImage.width) != 'number'){
                    $scope.uploadInfo.workImage.width = '';
                }
                if(typeof($scope.uploadInfo.workImage.height) != 'number'){
                    $scope.uploadInfo.workImage.height='';
                }
                if(typeof($scope.uploadInfo.workImage.depth) != 'number'){
                    $scope.uploadInfo.workImage.depth = '';
                }
                $scope.isShowFileThumb = true;
                $scope.imageThumbnailUrl = $scope.editInfo.attachments[0].thumbnail.small;
                $scope.tagListUpdate($scope.uploadInfo.workImage.tags);
            }
        }
    }]);
    
    function validateData($scope, isErrorCheck){
        var validate = true;
        if(!$scope.isEditUpload){
            if (!$scope.uploadInfo.convertedFile) {
                validate = false;
                if(isErrorCheck) $scope.error.image = 'error';
            }
        }
        if ($scope.uploadInfo.workImage.category == $scope.categories[0].name) {
            validate = false;
            if(isErrorCheck) $scope.error.category = 'error';
        }
        if (!$scope.uploadInfo.workImage.title) {
            validate = false;
            if(isErrorCheck) $scope.error.title = 'error';
        }
        if (!$scope.uploadInfo.workImage.note) {
            validate = false;
            if(isErrorCheck) $scope.error.note = 'error';
        }
        
        return validate;
    };
    
    function getYears(){
        var years = [];
        var currentYear = new Date().getFullYear();
        for(var i = currentYear; i >= 1900; i--){
            years.push(i);
        }
        years.unshift('Year');
        return years;
    }
    
    function getCategories($scope, restApiSvc){
        restApiSvc.get(restApiSvc.apiPath.categories).then(
            function(res){
                var data = res.data.data;
                angular.forEach(data, function(val, key){
                    $scope.categories.push(val);
                });
                $scope.editInit();
            },function(res, status){
                
            }
        );
    }
    
    function uploadArtwork($scope, $state, authSvc, restApiSvc, blockUI, uploadInfo){
        var params = {
                workImage: {
                    category: uploadInfo.workImage.category,
                    title: uploadInfo.workImage.title,
                    note: uploadInfo.workImage.note,
                    tags: uploadInfo.workImage.tags,
                    year: uploadInfo.workImage.year,
                    edition: uploadInfo.workImage.edition,
                    width: Number(uploadInfo.workImage.width),
                    height: Number(uploadInfo.workImage.height),
                    depth: Number(uploadInfo.workImage.depth),
                    sizeUnit: String(uploadInfo.workImage.sizeUnit).toLocaleLowerCase()
                }
            };
        
        if(String(params.workImage.width).indexOf('.') > -1){
            if(String(params.workImage.width).split('.')[1].length <= 0){
                params.workImage.width = String(params.workImage.width).split('.')[0];
            }
        }
        if(String(params.workImage.height).indexOf('.') > -1){
            if(String(params.workImage.height).split('.')[1].length <= 0){
                params.workImage.height = String(params.workImage.height).split('.')[0];
            }
        }
        if(String(params.workImage.depth).indexOf('.') > -1){
            if(String(params.workImage.depth).split('.')[1].length <= 0){
                params.workImage.depth = String(params.workImage.depth).split('.')[0];
            }
        }
        
        blockUI.start();
        var apiPath = restApiSvc.apiPath.uploadImage;
        var contentType = '';
        if(!$scope.isEditUpload){
            contentType = 'form';
            if(params.workImage.year == $scope.years[0]) params.workImage.year = '';
            params.workImage = restApiSvc.jsonToString(params.workImage);
            params.file = uploadInfo.convertedFile;
            params = restApiSvc.jsonToForm(params);
        }else{
            params = params.workImage;
            if(params.year == $scope.years[0]) params.year = '';
            apiPath = restApiSvc.apiPath.editImage($scope.editInfo.id);
        }
        
        restApiSvc.post(apiPath, params, contentType).then(
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
