(function(angular){
	'use strict';
    
	var BBuzzArtApp = angular.module('BBuzzArtApp');
    
	BBuzzArtApp.factory('convertFileSvc', ['Upload', 'dialogSvc', function(Upload, dialogSvc){
        
        function convert(file, callBack){
            if(file == null) return;
            
            if(file.size >= 10240000){
                callBack(null);
                dialogSvc.confirmDialog(dialogSvc.confirmDialogType.imageSize, function(answer){
                    dialogSvc.closeConfirm();
                });
            }else{
                if(file.size > 2048000){
                    Upload.imageDimensions(file).then(function(dimensions){
                        var w = dimensions.width,
                            h = dimensions.height,
                            q = 0.7;
                        Upload.resize(file, w, h, q).then(function(convertedFile){
                            Upload.dataUrl(convertedFile, true).then(function(dataUrl){
                                callBack(convertedFile, dataUrl);
                            });
                        });
                    });
                }else{
                    Upload.dataUrl(file, true).then(function(dataUrl){
                        callBack(file, dataUrl);
                    });
                }
            }
        }
        
        function getBase64FromImageUrl(imgUrl, callback) {
            var img = new Image();
            img.setAttribute('crossOrigin', 'anonymous');

            img.onload = function () {
                var canvas = document.createElement("canvas");
                canvas.style.display = 'none';
                document.body.appendChild(canvas);
                canvas.width = this.width;
                canvas.height = this.height;
                
                var ctx = canvas.getContext("2d");
                ctx.drawImage(this, 0, 0);
                
                var dataURL = canvas.toDataURL("image/jpeg");
                callback(dataURL);
            };
            img.src = imgUrl;
        }
        
		return {
			convertFile: convert,
            getImgDataUrl: getBase64FromImageUrl
		};
	}]);
})(angular);