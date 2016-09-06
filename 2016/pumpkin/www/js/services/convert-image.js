angular.module('giftbox.services')

.factory('convertImageSvc', [function(){

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
        getImgDataUrl: getBase64FromImageUrl
    };
}]);