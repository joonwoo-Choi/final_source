angular.module('giftbox.services')

.factory('restApiSvc', ['$rootScope', '$q', '$http', '$timeout', 'cordovaHTTP', '$ionicLoading', 'dialogSvc', function($rootScope, $q, $http, $timeout, cordovaHTTP, $ionicLoading, dialogSvc){
    var apiBaseUrl = '',
        timeout = 20000,
        timeoutMessage = '네크워크 연결을 확인해 주세요.',
        apiPath = {
            /** account */
//            login: '/account/login/email',
            getFilterEventTypes: '/eventTypeCodes',
            getMainPopup: '/popups',
            getSlideBanner: '/banners',
            getBottomBanner: '/events',
            getEventList: '/events',
            getEventDetail: function(id){ return '/events/' + id },
            setPushToken: '/devices'
        },
        requests = [],
        req;

    /** all request cancel  */
    $rootScope.$on('$stateChangeSuccess', function() {
        abort();
    });
    $rootScope.$on('$$stateChangeError', function() {
        abort();
    });
    
    function abort(){
        while (req = requests.pop()) {
            req.abort();
        };
    };
    
    /** json to form  */
    function json2Form(data) {
        var formData = new FormData();
        angular.forEach(data, function (value, key) {
            formData.append(key, value);
        });
        return angular.identity(formData);
    };
    
    function connection(method, path, data, contentType){
        
        var request;
        var canceler = $q.defer();
        
        if(window.cordova && ionic.Platform.isIOS()){
            
            var url = path ? (apiBaseUrl + path) : apiBaseUrl;
            
            if(method === 'POST'){
                request = cordovaHTTP.post(url, data);
            }else{
                request = cordovaHTTP.get(url, data, {'Content-Type': 'application/json'});
            }
            request.abort = function () {
                canceler.resolve();
            };
            
            request.then(function (res) {
                $ionicLoading.hide();
            }, function(err) {
                $ionicLoading.hide();
                dialogSvc.alert(timeoutMessage);
            });
            
        }else{
            
            var params = {
                    method: method,
                    url: path ? (apiBaseUrl + path) : apiBaseUrl,
                    timeout: canceler.promise,
                    responseType: 'json'
                };

            if(method === 'POST'){
                params.data = data;
                params.headers = {
//                    'Authorization': authSvc.getAuthKey(),
//                    'Content-Type': contentType == 'form' ? undefined : 'application/json'
                }
            }else{
                params.params = data;
//                params.headers = {
//                    'Authorization' : authSvc.getAuthKey()
//                }
            }

            request = $http(params);
            request.abort = function () {
                canceler.resolve();
            };

            /** time limit & cancel */
            if(method === 'GET'){
                var timer = $timeout(function(){
                        request.abort();
                        $ionicLoading.hide();
                        dialogSvc.alert(timeoutMessage);
                    }, timeout);

                request.then(function () {
                    $timeout.cancel(timer);
                }, function() {
                    $timeout.cancel(timer);
                });
            };
            
            requests.push(request);
        };
        
        
        return request;
    }

    return {
        setBaseUrl: function(url){
            apiBaseUrl = url;
        },
        getBaseUrl: function(){
            return apiBaseUrl;
        },
        get: function(path, data) {
            return connection('GET', path, data);
        },
        post: function(path, data, contentType) {
//            if(typeof(data) == 'object') data = json2Form(data);
            return connection('POST', path, data, contentType);
        },
        delete: function(path, data) {
            return connection('DELETE', path, data);
        },
        jsonToForm: json2Form,
        jsonToString: function(json){
            var tempJson = JSON.stringify(json);
            return tempJson;
        },
        cancel: abort,
        apiPath: apiPath
    };
}]);





