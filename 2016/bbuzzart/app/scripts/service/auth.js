(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');
    
    BBuzzArtApp.factory('authSvc', ['$rootScope', 'storageSvc', function($rootScope, storageSvc){
        var KEY_PREFIX = 'BBuzzArt',
            KEY_AUTH = 'authKey',
			KEY_AUTO_LOGIN = 'autoLogin',
			KEY_USER_INFO = 'userInfo',
			events = {
                userInfoChanged: 'userInfoChanged'
            },
			sessionStorage = storageSvc.sessionStorage(KEY_PREFIX),
			localStorage = storageSvc.localStorage(KEY_PREFIX);
        
        return {
            event: events,
            
			/**  set Auto Login Enable   */
			setEnableAutoLogin: function(useAutoLogin){
				localStorage.set(KEY_AUTO_LOGIN, useAutoLogin);
			},

			/**  get Auto Login Enable   */
			isAutoLoginEnabled: function(){
				var useAutoLogin = localStorage.get(KEY_AUTO_LOGIN);
				return useAutoLogin == 'true' ? true : false;
			},

			/**  set AuthKey */
			setAuthKey: function(authKey, useAutoLogin){
				if(authKey){
					this.setEnableAutoLogin(useAutoLogin);
					if(useAutoLogin){
						localStorage.set(KEY_AUTH, authKey);
					}else{
						sessionStorage.set(KEY_AUTH, authKey);
					};
				}else{
                    
				};
			},

			/**  get AuthKey */
			getAuthKey: function(){
				var authKey = null;
				if(this.isAutoLoginEnabled()){
					authKey = localStorage.get(KEY_AUTH);
				}else{
					authKey = sessionStorage.get(KEY_AUTH);
				};
				return authKey;
			},

			/**  set Login Info  */
			setUserInfo: function(userInfo){
                if(this.isAutoLoginEnabled()){
                    localStorage.setObject(KEY_USER_INFO, userInfo);
                }else{
                    sessionStorage.setObject(KEY_USER_INFO, userInfo);
                };
                $rootScope.$broadcast(events.userInfoChanged, userInfo);
			},

			/**  get Login Info  */
			getUserInfo: function(){
				if(this.isAutoLoginEnabled()){
					return localStorage.getObject(KEY_USER_INFO);
				}else{
					return sessionStorage.getObject(KEY_USER_INFO);
				};
			},

			/**  remove Storage  */
			removeData: function(){
				if(this.isAutoLoginEnabled()){
					$rootScope.$broadcast(events.userInfoChanged, null);
					return localStorage.removeAll();
				}else{
					$rootScope.$broadcast(events.userInfoChanged, null);
					return sessionStorage.removeAll();
				};
			},

			/**  get Login Status    */
			isLogin: function(){
				if(this.getAuthKey() && this.getUserInfo()){
					return true;
				}else{
					return false;
				};
			}
		};
    }]);
    
})(angular);
