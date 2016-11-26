(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');
    
    BBuzzArtApp.factory('restApiSvc', ['$rootScope', '$q', '$http', '$timeout', 'authSvc', 'blockUI', function($rootScope, $q, $http, $timeout, authSvc, blockUI){
        var apiBaseUrl = '',
			timeout = 30000,
			timeoutMessage = 'Oops! Something wrong. Please try again later.',
            apiPath = {
                /** account */
                authLogin: '/account/login',
                login: '/account/login/email',
                fbLogin: '/account/login/facebook',
                signUpEmail: '/account/sign-up/email',
                verificationEmail: '/account/verification',
                resetPassword: '/account/reset-password',
                changePassword: '/account/change-password',
                removeEmail: '/account/remove',
                /** gnb */
                logout: '/users/logout.json',
                getNotis: '/notifications',
                resetNotiCount: '/notifications/reset-count',
                setViewedNoti: function(id){ return '/notifications/' + id; },
                /** search  */
                search: '/search',
                searchHistories: '/search-histories',
                removeHistory: function(id){ return '/search-histories/' + id; },
                searchPerson: '/search/person',
                searchTag: '/search/tag',
                searchKeywordWorks: '/search/keyword/works',
                searchTagWorks: '/search/tag/works',
                searchTitle: '/search/title',
                /** main    */
                curationLists: '/picks',
                keywordLists: '/keywords',
                discoverLists: '/discovers',
                showLists: '/shows',
                getBanners: '/banners',
                /** my feeds    */
                getMyfeeds: '/my-feeds',
                getHotBuzzler: '/hot-buzzlers',
                /** upload  */
                categories: '/works/images/categories',
                uploadImage: '/works/images',
                uploadWriting: '/works/writings',
                uploadVideo: '/works/videos',
                uploadShow: '/works/shows',
                participationWorksLists: function(id){ return '/users/' + id + '/show-works'; },
                getVideoInfo: '/works/videos/verification',
                getWritingBackground: '/works/writings/backgrounds',
                /** edit    */
                editImage: function(id){ return '/works/' + id + '/image'; },
                editWriting: function(id){ return '/works/' + id + '/writing'; },
                editVideo: function(id){ return '/works/' + id + '/video'; },
                editShow: function(id){ return '/works/' + id + '/show'; },
                /** profile */
                getUserInfo: function(id){ return '/users/' + id; },
                getProfile: function(id){ return '/users/' + id + '/profile'; },
                editProfile: function(id){ return '/users/' + id + '/profile'; },
                getWorks: function(id){ return '/users/' + id + '/works'; },
                getBookmarks: function(id){ return '/users/' + id + '/bookmarks'; },
                /** people  */
                getFollowings: function(id){ return '/users/' + id + '/followings'; },
                getFollowers: function(id){ return '/users/' + id + '/followers'; },
                follow: function(userId, followingId){ 
                    return '/users/' + userId + '/followings/' + followingId 
                },
                unfollow: function(userId, followingId){ 
                    return '/users/' + userId + '/followings/' + followingId 
                },
                /** detail  */
                getDetailImage: function(id){ return '/works/' + id + '/image'; },
                getDetailVideo: function(id){ return '/works/' + id + '/video'; },
                getDetailWriting: function(id){ return '/works/' + id + '/writing'; },
                getDetailShow: function(id){ return '/works/' + id + '/show'; },
                deleteWork: function(id){ return '/works/' + id; },
                getFeedback: function(id){ return '/works/' + id + '/feedbacks'; },
                addFeedback: function(id){ return '/works/' + id + '/feedbacks'; },
                updateFeedback: function(workId, feedbackId){ 
                    return '/works/' + workId + '/feedbacks/' + feedbackId;
                },
                deleteFeedback: function(workId, feedbackId){ 
                    return '/works/' + workId + '/feedbacks/' + feedbackId;
                },
                issues: function(id){ return '/works/' + id + '/issues' },
                getMentionUsers: '/works/mention/users',
                addCuratorPick: function(id){ return '/works/' + id + '/picks'; },
                /** like & bookmark */
                likeActivity: function(id){ return '/works/' + id + '/likes'; },
                unLikeActivity: function(id){ return '/works/' + id + '/likes'; },
                getLikePeople: function(id){ return '/works/' + id + '/likes'; },
                bookmarkActivity: function(id){ return '/works/' + id + '/bookmarks'; },
                unBookmarkActivity: function(id){ return '/works/' + id + '/bookmarks'; },
                /** feedback aide   */
                feelingWords: '/feedback-aide/feeling-words',
                styleWords: '/feedback-aide/style-words',
                contentsWords: '/feedback-aide/contents-words',
                combinedSentence: '/feedback-aide/combined-sentence'
            },
            requests = [],
            req;
        
        /** all request cancel  */
		$rootScope.$on('$routeChangeSuccess', function() {
			while (req = requests.pop()) {
				req.abort();
			}
		});
		$rootScope.$on('$routeChangeError', function() {
			while (req = requests.pop()) {
				req.abort();
			}
		});
        
        /** json to form  */
        function json2Form(data) {
            var formData = new FormData();
            angular.forEach(data, function (value, key) {
                formData.append(key, value);
            });
            return angular.identity(formData);
        }
        
        function connection(method, path, data, contentType){
            var canceler = $q.defer();
            var params = {
                method: method,
                url: path ? (apiBaseUrl + path) : apiBaseUrl,
                timeout: canceler.promise,
                responseType: 'json'
            };
            
            if(method === 'POST'){
                params.data = data;
                params.headers = {
                    'Authorization': authSvc.getAuthKey(),
                    'Content-Type': contentType == 'form' ? undefined : 'application/json'
                }
            }else{
                params.params = data;
                params.headers = {
                    'Authorization' : authSvc.getAuthKey()
                }
            }
            
            var request = $http(params);
            request.abort = function () {
                canceler.resolve();
            };
            
            /** time limit & cancel */
            if(method === 'GET'){
                var timer = $timeout(function () {
                    request.abort();
                    blockUI.stop();
                    alert(timeoutMessage);
                }, timeout);

                request.then(function () {
                    $timeout.cancel(timer);
                }, function() {
                    $timeout.cancel(timer);
                });
            }
            
            requests.push(request);
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
//                if(typeof(data) == 'object') data = json2Form(data);
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
            apiPath: apiPath
        };
    }]);
    
})(angular);
