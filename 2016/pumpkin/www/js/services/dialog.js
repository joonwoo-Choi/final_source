angular.module('giftbox.services')

.factory('dialogSvc', ['$ionicModal', '$ionicPopup', function($ionicModal, $ionicPopup){
    
    var mainPopup = null,
        isAlertOpen = false;
    
    function openDialog(scope, outsideClose, callback, tempUrl){
        $ionicModal.fromTemplateUrl(tempUrl, {
            scope: scope,
            animation: 'slide-in-up',
            focusFirstInput: true,
            backdropClickToClose: outsideClose,
            hardwareBackButtonClose: outsideClose
        })
        .then(function(modal) {
            callback(modal);
        });
    };
    
    function openPopup(template, cssClass){
        var options = {
                cssClass: cssClass,
                template: template
            };
        mainPopup = $ionicPopup.show(options);
    };
    
    return {
        openFilterDialog: function (scope, outsideClose, callback) {
            openDialog(scope, outsideClose, callback, 'templates/dialog/filter.html');
        },
        openChangeInfoDialog: function (scope, outsideClose, callback) {
            openDialog(scope, outsideClose, callback, 'templates/dialog/account-change-info.html');
        },
        openPushDialog: function (scope, outsideClose, callback) {
            openDialog(scope, outsideClose, callback, 'templates/dialog/push.html');
        },
        openProvideDialog: function (scope, outsideClose, callback) {
            openDialog(scope, outsideClose, callback, 'templates/dialog/provide.html');
        },
        openMainPopup: function(){
            var template = '<div main-popup></div>';
            var cssClass = 'popup-main-banner';
            openPopup(template, cssClass);
        },
        alert: function(text, callback){
            if(isAlertOpen) return;
            isAlertOpen = true;
            
            var alertPopup = $ionicPopup.alert({
                    title: text,
                    template: '',
                    cssClass: 'popup-alert',
                    okText: '확인'
               });

            alertPopup.then(function(res) {
                isAlertOpen = false;
                if(callback != null && callback != undefined){
                    callback(res);
                };
            });
        },
        popupClose: function(){
            if(mainPopup != null){
                mainPopup.close();
                mainPopup = null
            }
        }
    };
}]);




