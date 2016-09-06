(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');
    
    BBuzzArtApp.factory('storageSvc', ['$window', function($window){
        return {
            localStorage: function (prefix) {
				var prefix_ = prefix ? (prefix + '_') : '';
				return {
					set: function(key, value) {
						$window.localStorage[prefix_ + key] = value;
					},
					get: function(key, defaultValue) {
						return $window.localStorage[prefix_ + key] || defaultValue;
					},
					setObject: function(key, value) {
						$window.localStorage[prefix_ + key] = JSON.stringify(value);
					},
					getObject: function(key) {
						return JSON.parse($window.localStorage[prefix_ + key] || null);
					},
					removeAll: function () {
						var key, i, length = $window.localStorage.length;
			            for ( i = length - 1; i >= 0; i-- ) {
			                key = $window.localStorage.key(i);
			                if ( key.substr(0, prefix_.length) === prefix_ ) {
			                    $window.localStorage.removeItem(key);
			                }
			            }
					}
				};
			},
			sessionStorage: function (prefix) {
				var prefix_ = prefix ? (prefix + '_') : '';
				return {
					set: function(key, value) {
						$window.sessionStorage[prefix_ + key] = value;
					},
					get: function(key, defaultValue) {
						return $window.sessionStorage[prefix_ + key] || defaultValue;
					},
					setObject: function(key, value) {
						$window.sessionStorage[prefix_ + key] = JSON.stringify(value);
					},
					getObject: function(key) {
						return JSON.parse($window.sessionStorage[prefix_ + key] || null);
					},
					removeAll: function () {
						var key, i, length = $window.sessionStorage.length;
			            for ( i = length - 1; i >= 0; i-- ) {
			                key = $window.sessionStorage.key(i);
			                if ( key.substr(0, prefix_.length) === prefix_ ) {
			                    $window.sessionStorage.removeItem(key);
			                }
			            }
					}
				};
			}
		};
    }]);
    
})(angular);
