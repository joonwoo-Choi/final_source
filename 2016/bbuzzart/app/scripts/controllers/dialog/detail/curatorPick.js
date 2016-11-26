(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');

    BBuzzArtApp.controller('curatorPickCtrl', ['$scope', '$timeout', '$state', 'authSvc', 'dialogSvc', 'restApiSvc', 'convertFileSvc', 'dialogParams', 'Cropper', 'blockUI', 'Upload', function ($scope, $timeout, $state, authSvc, dialogSvc, restApiSvc, convertFileSvc, dialogParams, Cropper, blockUI, Upload) {
        
        $scope.curatorPickInfo = {};
        $scope.imgUrl = dialogParams.imgUrl;
        $scope.artworkId = dialogParams.artworkId;
        $scope.picksFeedback = '';
        $scope.activate = false;
        $scope.cropper = {};
        $scope.cropperProxy = 'cropper.pick';
        $scope.showEvent = 'show';
        $scope.cropperOptions = {
            autoCropArea: 1,
            dragCrop: false,
            doubleClickToggle: false,
            crop: function(dataNew) {
                $scope.cropData = dataNew;
            },
            build: function(e){

            }
        };
        $scope.originFile;
        $scope.cropData;
        
        $scope.initCropper = function(blob) {
            Cropper.encode(blob).then(function(dataUrl) {
                $scope.dataUrl = dataUrl;
                $timeout(function(){
                    $scope.$broadcast($scope.showEvent);
                    $timeout(function(){
                        var data = $scope.cropper.pick('getContainerData'),
                            x = 0,
                            y = 0,
                            cavasWidth = $('.cropper-canvas').width(),
                            cavasHeight = $('.cropper-canvas').height();
                        
                        if(cavasWidth > data.width){
                            x = (data.width - cavasWidth)/2;
                        };
                        if(cavasHeight > data.height){
                            x = (data.height - cavasHeight)/2;
                        };
                        
                        $scope.cropper.pick('move', x, y);
                        $('.popup-curator-pick .img-crop-wrap .img-container').addClass('loaded');
                    }, 250);
                });
            });
        };
        
        $scope.pickSubmit = function(){
            if(!$scope.activate) return;
            
            Cropper.crop($scope.originFile, $scope.cropData).then(function(blob){
                var cropFile = blob,
                    params = {
                        pick: {
                            feedback: $scope.picksFeedback
                        }
                    },
                    contentType = 'form';
                
                params.pick = restApiSvc.jsonToString(params.pick);
                params.file = cropFile;
                params = restApiSvc.jsonToForm(params);
                
                blockUI.start();
                restApiSvc.post(restApiSvc.apiPath.addCuratorPick($scope.artworkId), params, contentType).then(
                    function(res){
                        blockUI.stop();
                        
                        dialogSvc.close();
                        dialogSvc.closeConfirm();
                        location.reload();
                    },function(err){
                        dialogSvc.confirmDialog(dialogSvc.confirmDialogType.curatorPicked, function(answer){
                            dialogSvc.closeConfirm();
                        });
                        blockUI.stop();
                    }
                );
            });
        };
        
        $scope.popupClose = function(){
            dialogSvc.confirmDialog(dialogSvc.confirmDialogType.curatorPickCancel, function(answer){
                if(answer == 'yes'){
                    dialogSvc.close();
                    dialogSvc.closeConfirm();
                }else{
                    dialogSvc.closeConfirm();
                };
            });
        };
        
        $scope.$watch('picksFeedback', function(newVal, oldVal){
            if(newVal.length > 0){
                $scope.activate = true;
            }else{
                $scope.activate = false;
            }
        });
        
        /** initialize  */
        if(dialogParams.imgWidth/360 > dialogParams.imgHeight/450){
            $scope.cropperOptions.minContainerHeight = 450;
            $scope.cropperOptions.minCanvasHeight = 450;
            $scope.cropperOptions.minCropBoxHeight = 450;
        }else if(dialogParams.imgWidth/360 < dialogParams.imgHeight/450){
            $scope.cropperOptions.minContainerWidth = 360;
            $scope.cropperOptions.minCanvasWidth = 360;
            $scope.cropperOptions.minCropBoxWidth = 360;
            $scope.cropperOptions.minContainerHeight = 450;
            $scope.cropperOptions.minCanvasHeight = 450;
            $scope.cropperOptions.minCropBoxHeight = 450;
        }else{
            $scope.cropperOptions.minContainerHeight = 450;
            $scope.cropperOptions.minContainerWidth = 360;
            $scope.cropperOptions.minCanvasHeight = 450;
            $scope.cropperOptions.minCanvasWidth = 360;
            $scope.cropperOptions.minCropBoxHeight = 450;
            $scope.cropperOptions.minCropBoxWidth = 360;
        };
        convertFileSvc.getImgDataUrl($scope.imgUrl, function(dataUrl){
			$scope.originFile = Cropper.decode(dataUrl);
            $scope.initCropper($scope.originFile);
        });
        
    }]);
    
})(angular);
