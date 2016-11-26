(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');

    BBuzzArtApp.controller('popupAccountCtrl', ['$scope', '$window', '$timeout', '$state', 'trackerSvc', 'restApiSvc', 'authSvc', 'dialogSvc', 'dialogParams', 'Facebook', 'blockUI', 'Upload', 'convertFileSvc', function ($scope, $window, $timeout, $state, trackerSvc, restApiSvc, authSvc, dialogSvc, dialogParams, Facebook, blockUI, Upload, convertFileSvc) {
        
        $scope.selectedIdx = 0;
        $scope.error = {
            login: {},
            signup: {},
            expired: {},
            reset: {}
        };
        $scope.isMoibileView = false;
        
        $scope.changeTab = function(idx){
            $scope.selectedIdx = idx;
            switch(idx){
                case 1 :
                    /** sign up */
                    trackerSvc.eventTrack('SIGN UP', {category:'SIGN UP WITH E-MAIL'});
                    break;
                case 2 :
                    /** forgot password */
                    trackerSvc.eventTrack('FORGOT PASSWORD', {category:'LOG IN WITH E-MAIL'});
                    break;
            };
        };
        
        $scope.popupClose = function(){
            if(dialogParams != null){
                if(dialogParams.type == 'verification' || 
                   dialogParams.type == 'expired' || 
                   dialogParams.type == 'delete' || 
                   dialogParams.type == 'resetPassword'){
                    $state.go('main', {}, {reload: true});
                }else{
                    dialogSvc.close();
                };
            }else{
                dialogSvc.close();
            };
            $('.popup-verification-email').fadeOut(500);
        };
        
        $scope.initInfo = function(idx){
            switch(idx){
                case 0 :
                    $scope.loginInfo.email = '';
                    $scope.loginInfo.password = '';
                    $scope.resetError($scope.error.login);
                    break;
                case 1 :
                    $scope.signupInfo.name = '';
                    $scope.signupInfo.email = '';
                    $scope.signupInfo.password = '';
                    $scope.resetError($scope.error.signup);
                    break;
                case 2 :
                    /** forgot password */
                    break;
                case 3 :
                    /** expired */
                    break;
                case 4 :
                    /** reset password  */
                    break;
            };
        };
        
        $scope.resetError = function(errorObj){
            angular.forEach(errorObj, function(value, key){
                errorObj[key] = false;
            });
        };
        
        $scope.reloadPage = function(){
			blockUI.stop();
			$window.location.reload();
		};
        
        $scope.$watch(function(){
            return angular.element($window).width();
        }, function(newVal, oldVal){
            if(newVal > 767){
                $scope.isMoibileView = false;
            }else{
                $scope.isMoibileView = true;
            };
        });
        
        loginCtrl($scope, $timeout, $state, trackerSvc, restApiSvc, authSvc, dialogSvc, dialogParams, Facebook, blockUI, Upload, convertFileSvc);
        signupCtrl($scope, $window, restApiSvc, dialogSvc, blockUI);
        expiredCtrl($scope, $state, dialogParams);
        resetCtrl($scope, $state, dialogParams, restApiSvc, blockUI);
        changeCtrl($scope, $state, dialogParams, restApiSvc, authSvc, blockUI);
        deleteCtrl($scope, $state, dialogParams, restApiSvc, blockUI);
        
    }]);
    
    function loginCtrl($scope, $timeout, $state, trackerSvc, restApiSvc, authSvc, dialogSvc, dialogParams, Facebook, blockUI, Upload, convertFileSvc){
        $scope.loginInfo = {
            email: '',
            password: '',
            fbId: '',
            fbName: '',
            accessFbToken: '',
            remember: true
        };
        $scope.loginActivate = false;
        
        $scope.loginKeydown = function(e){
            if(e.keyCode == 13){
                $scope.login();
            };
        };
        
        /** 이메일 로그인 버튼  */
        $scope.login = function(){
            if(!$scope.loginActivate) return;
            
            if(!isValidEmail($scope.loginInfo.email)){
                $scope.error.login.email = true;
            };
            if(!$scope.error.login.email){
                trackerSvc.eventTrack('LOG IN', {category:'LOG IN WITH E-MAIL'});
                blockUI.start();
                var params = {
                    email: $scope.loginInfo.email,
				    password: $scope.loginInfo.password
                };
                restApiSvc.post(restApiSvc.apiPath.login, params).then(
                    function(res){
                        $scope.loginCallback(res.data);
                    },function(err){
                        $scope.loginCallback(res.data);
                    }
                );
            };
        };
        
        $scope.loginCallback = function(res){
            if(res.success){
                var userInfo = res.data;
                authSvc.setAuthKey(userInfo.auth, $scope.loginInfo.remember);
                authSvc.setUserInfo(userInfo);
                
                if(dialogParams != null){
                    blockUI.stop();
                    dialogSvc.close();
                    switch(dialogParams.type){
                        case 'IMAGE' :
                            dialogSvc.openUploadImage();
                            break;
                        case 'WRITING' :
                            dialogSvc.openUploadWriting();
                            break;
                        case 'VIDEO' :
                            dialogSvc.openUploadVideo();
                            break;
                        case 'SHOW' :
                            dialogSvc.openUploadShow();
                            break;
                        case 'verification' :
                        case 'resetPassword' :
                            $state.go('main', {}, {reload: true});
                            break;
                    };
                }else{
                    $scope.reloadPage();
                };
            }else{
                $('md-dialog').focus();
                switch(res.message){
                    case 'No user for given E-mail.' :
                        $scope.error.login.email = true;
                        $scope.error.login.account = true;
                        break;
                    case 'Wrong password.' :
                        $scope.error.login.password = true;
                        $scope.error.login.wrongPassword = true;
                        break;
                    case 'E-mail verification has not been completed. Verification will be complete once you click the link contained within the e-mail.' :
                        $('.popup-verification-email').fadeIn(500);
                        break;
                };
                blockUI.stop()
            };
            
            $scope.hideVerificationPopup = function(){
                $('.popup-verification-email').fadeOut(500);
            };
        };
        
        /** 페이스북 로그인 버튼 */
        $scope.fbLogin = function(){
            trackerSvc.eventTrack('LOG OUT', {category:'CONTINUE WITH Facebook'});
            Facebook.getLoginStatus(function(res) {
                if (res.status === 'connected'){
                    getFbInfo(res);
                }else{
                    Facebook.login(function(res){
                        if(res.status == 'connected'){
                            getFbInfo(res);
                        };
                    }, { scope: 'public_profile,email' });
                };
            });
            function getFbInfo(res){
                $scope.getFbInfo({
                    accessToken : res.authResponse.accessToken,
                    userID : res.authResponse.userID
                });
            };
        };
        
        $scope.getFbInfo = function(fbInfo){
            Facebook.api('/me/permissions', function(res){
                var needPermission = false;
                angular.forEach(res.data, function(val, idx){
                    if(!needPermission && val.permission == 'email' && val.status == 'declined'){
                        needPermission = true;
                    };
                });

                if(needPermission == true){
                    /** email 정보가 거부되었을 경우 > 다시 permission 세팅 다이얼로그가 보여지도록 함.   */
                    console.log('이메일제공 거부 ');
                    Facebook.login(function(res){
                        if(res.status == 'connected'){
                            Facebook.api('/me', function(res){
                                console.log('이메일 받기 ', res);
                                if(res.email){
                                    $scope.fbLoginCallback(res, fbInfo);
                                };
                            });
                        };
                    }, { 
                        scope: 'public_profile,email',
                        auth_type: 'rerequest'
                    });
                }else{
                    /** email 정보 제공이 허용된 경우 바로  */
                    Facebook.api('/me', function(res){
                        console.log('이메일제공 허용 ', res);
                        if(res.email){
                            $scope.fbLoginCallback(res, fbInfo);
                        }else{
                            /** 정보에 이메일이 없을 때   */
                            dialogSvc.confirmDialog(dialogSvc.confirmDialogType.facebook, function(answer){
                                dialogSvc.closeConfirm();
                            });
                        };
                    });
                };
            });
            
            $scope.fbLoginCallback = function(res, fbInfo){
                blockUI.start();
                
                var imgSrc = 'https://graph.facebook.com/' + fbInfo.userID + '/picture?width=200&height=200';
                convertFileSvc.getImgDataUrl(imgSrc, function(dataURL){
                    var profileImageBlob = Upload.dataUrltoBlob(dataURL, 'file'),
                        profile = {
                            email : res.email,
                            username : res.name,
                            userId : fbInfo.userID,
                            accessToken : fbInfo.accessToken
                        },
                        params = {
                            file: profileImageBlob
                        };
                    profile = restApiSvc.jsonToString(profile);
                    params.profile = profile;
                    params = restApiSvc.jsonToForm(params);
                    
                    restApiSvc.post(restApiSvc.apiPath.fbLogin, params, 'form').then(
                        function(res){
                            if(res.data.success){
                                var fbInfo = JSON.parse(profile);
                                $scope.loginInfo.email = fbInfo.email;
                                $scope.loginInfo.fbId = fbInfo.userId;
                                $scope.loginInfo.fbName = fbInfo.username;
                                $scope.loginInfo.accessFbToken = fbInfo.accessToken;
                                $scope.loginCallback(res.data);
                            };
                        },function(err){
                            blockUI.stop();
                            dialogSvc.confirmDialog(dialogSvc.confirmDialogType.facebook, function(answer){
                                dialogSvc.closeConfirm();
                            });
                        }
                    );
                });
            };
        };
        
        $scope.$watchGroup(['loginInfo.email', 'loginInfo.password'], function(newValues, oldValues){
            var flag = true;
            angular.forEach(newValues, function(val, idx){
                if(flag){
                    if(val.length <= 0){
                        $scope.loginActivate = false;
                        flag = false;
                    }else{
                        $scope.loginActivate = true;
                    };
                };
            });
        });
    };
    
    function signupCtrl($scope, $window, restApiSvc, dialogSvc, blockUI){
        $scope.signupInfo = {
            name: '',
            email: '',
            password: ''
        };
        $scope.signupActivate = false;
        
        $scope.signupKeydown = function(e){
            if(e.keyCode == 13){
                $scope.btnSignUp();
            };
        };
        $scope.btnSignUp = function(){
            if(!$scope.signupActivate) return;
            
            var signupFlag = true;
            if($scope.signupInfo.name.length <= 0){
                signupFlag = false;
                $scope.error.signup.name = true;
            };
            if(!isValidEmail($scope.signupInfo.email)){
                signupFlag = false;
                $scope.error.signup.email = true;
            };
            if($scope.signupInfo.password.length <= 5){
                signupFlag = false;
                $scope.error.signup.password = true;
            };
            
            if(signupFlag) $scope.signUp();
        };
        $scope.signUp = function(){
            var params = {
                    email: $scope.signupInfo.email,
                    password: $scope.signupInfo.password,
                    username: $scope.signupInfo.name
                };
            
            blockUI.start();
            restApiSvc.post(restApiSvc.apiPath.signUpEmail, params).then(
                function(res){
                    blockUI.stop();
                    dialogSvc.confirmDialog(dialogSvc.confirmDialogType.signup, function(answer){
                        dialogSvc.close();
                        dialogSvc.closeConfirm();
                        var email = $scope.signupInfo.email;
                        var url = 'http://' + email.split('@')[1];
                        $window.open(url);
                    }, {email: $scope.signupInfo.email});
                },function(err){
                    blockUI.stop();
                    if(res.data.message == 'E-mail is already in use.'){
                        $scope.error.signup.alreadyEmail = true;
                    };
                }
            );
        };
        
        $scope.btnFbSignup = function(){
            $scope.fbLogin();
        };
        
        $scope.$watchGroup(['signupInfo.email', 'signupInfo.password'], function(newValues, oldValues){
            var flag = true;
            angular.forEach(newValues, function(val, idx){
                if(flag){
                    if(val.length <= 0){
                        $scope.signupActivate = false;
                        flag = false;
                    }else{
                        $scope.signupActivate = true;
                    };
                };
            });
        });
    };
    
    function expiredCtrl($scope, $state, dialogParams){
        $scope.expiredInfo = {
            email: ''
        };
        
        if(dialogParams != null){
            if(dialogParams.type == 'expired'){
                $scope.changeTab(3);
                $scope.expiredInfo.email = dialogParams.data.email;
            };
        };
        
        $scope.sendResetLink = function(){
            $scope.changeTab(1);
            $scope.signupInfo.email = $scope.expiredInfo.email;
        };
    };
    
    function resetCtrl($scope, $state, dialogParams, restApiSvc, blockUI){
        $scope.resetInfo = {
            email: '',
            token: '',
            newPassword: '',
            verifyPassword: ''
        };
        $scope.resetActivate = false;
        
        if(dialogParams != null){
            if(dialogParams.type == 'resetPassword'){
                $scope.changeTab(4);
                $scope.resetInfo.email = dialogParams.data.email;
                $scope.resetInfo.token = dialogParams.data.token;
            };
        };
        
         $scope.resetKeydown = function(e){
            if(e.keyCode == 13){
                $scope.btnReset();
            };
        };
        
        $scope.btnReset = function(){
            if(!$scope.resetActivate) return;
            
            var resetFlag = true;
            if(!isValidEmail($scope.resetInfo.email)){
                resetFlag = false;
                $scope.error.reset.email = true;
            };
            if($scope.resetInfo.newPassword.length <= 5){
                resetFlag = false;
                $scope.error.reset.newPassword = true;
            };
            if($scope.resetInfo.newPassword !== $scope.resetInfo.verifyPassword ||
               $scope.error.reset.newPassword){
                resetFlag = false;
                $scope.error.reset.verifyPassword = true;
                if(!$scope.error.reset.newPassword){
                    $scope.resetInfo.verifyPassword = '';
                };
            };
            
            if(resetFlag) $scope.reset();
        };
        
        $scope.reset = function(){
            var params = {
                    email: $scope.resetInfo.email,
                    resetToken: $scope.resetInfo.token,
                    newPassword: $scope.resetInfo.newPassword,
                    verifyPassword: $scope.resetInfo.verifyPassword
                };
            restApiSvc.post(restApiSvc.apiPath.resetPassword, params).then(
                function(res){
                    console.log('reset password ', res);
                    blockUI.stop();
                    $scope.changeTab(0);
                },function(err){
                    console.log('reset password - error ', res);
                    blockUI.stop();
                    alert(res.data.message);
                    $state.go('main', {}, {reload: true});
                }
            );
        };
        
        $scope.$watchGroup(['resetInfo.email', 'resetInfo.newPassword', 'resetInfo.verifyPassword'], function(newValues, oldValues){
            var flag = true;
            angular.forEach(newValues, function(val, idx){
                if(flag){
                    if(val.length <= 0){
                        $scope.resetActivate = false;
                        flag = false;
                    }else{
                        $scope.resetActivate = true;
                    };
                };
            });
        });
    };
    
    function changeCtrl($scope, $state, dialogParams, restApiSvc, authSvc, blockUI){
        $scope.changeInfo = {
            currentPassword: '',
            newPassword: '',
            verifyPassword: ''
        };
        $scope.changeActivate = false;
        
        if(dialogParams != null){
            if(dialogParams.type == 'changePassword'){
                $scope.changeTab(5);
            };
        };
        
         $scope.changeKeydown = function(e){
            if(e.keyCode == 13){
                $scope.btnChange();
            };
        };
        
        $scope.btnChange = function(){
            if(!$scope.changeActivate) return;
            
            var changeFlag = true;
            if($scope.changeInfo.newPassword.length <= 5){
                changeFlag = false;
                $scope.error.change.newPassword = true;
            }
            if($scope.changeInfo.newPassword !== $scope.changeInfo.verifyPassword ||
               $scope.error.change.newPassword){
                changeFlag = false;
                $scope.error.change.verifyPassword = true;
                if(!$scope.error.change.newPassword){
                    $scope.changeInfo.verifyPassword = '';
                };
            };
            
            if(changeFlag) $scope.change();
        };
        
        $scope.change = function(){
            var params = {
                    currentPassword: $scope.changeInfo.currentPassword,
                    newPassword: $scope.changeInfo.newPassword,
                    verifyPassword: $scope.changeInfo.verifyPassword
                };
            restApiSvc.post(restApiSvc.apiPath.changePassword, params).then(
                function(res){
                    blockUI.stop();
                    if(res.data.success){
                        location.reload();
                    };
                },function(err){
                    console.log('change password - error ', res);
                    blockUI.stop();
                    if(res.data.message == 'Wrong current password.'){
                        $scope.error.change.currentPassword = true;
                    };
                }
            );
        };
        
        $scope.$watchGroup(['changeInfo.currentPassword', 'changeInfo.newPassword', 'changeInfo.verifyPassword'], function(newValues, oldValues){
            var flag = true;
            angular.forEach(newValues, function(val, idx){
                if(flag){
                    if(val.length <= 0){
                        $scope.changeActivate = false;
                        flag = false;
                    }else{
                        $scope.changeActivate = true;
                    };
                };
            });
        });
    };
    
    function deleteCtrl($scope, $state, dialogParams, restApiSvc, blockUI){
        $scope.deleteInfo = {
            email: ''
        };
        
        if(dialogParams != null){
            if(dialogParams.type == 'delete'){
                $scope.changeTab(6);
                $scope.deleteInfo.email = dialogParams.data.email;
            };
        };
        
        $scope.deleteEmail = function(){
            var params = {
                email: $scope.deleteInfo.email
            };
            blockUI.start();
            restApiSvc.get(restApiSvc.apiPath.removeEmail, params).then(
                function(res){
                    blockUI.stop();
                    $state.go('main', {}, {reload: true});
                },function(err){
                    blockUI.stop();
                    alert(res.data.message);
                }
            );
        };
    };
    
    function isValidEmail(email){
        var pattern = /[a-z0-9!#$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/g;
        return pattern.test(email);
    }
    
})(angular);
