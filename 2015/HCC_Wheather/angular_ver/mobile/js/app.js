"use strict";
/** 콘솔 설정   */
var console = window.console || {log:function(str){alert(str)}};


var weatherApp = angular.module('weatherApp', ['weatherApp.controllers', 'weatherApp.directives', 'weatherApp.services']);


/** 리소스로드 완료    */
$(window).load(function(){
    
});


//weatherApp.config(['$routeProvider', function ($routeProvider) {
//    $routeProvider.when('/sub', {
//        templateUrl: 'js/app/template/sub1.tmpl.html',
//        controller: 'sub1Ctrl',
//        resolve: {
//            bookmarks : function (Bookmark) {
//                return Bookmark.query().$promise;
//            }
//        } 
//    })
//    .otherwise({ redirectTo: '/home' });
//}]);




