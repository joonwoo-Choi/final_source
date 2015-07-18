"use strict";
/** 콘솔 설정   */
var console = window.console || {log:function(str){alert(str)}};


var samsoniteApp = angular.module('samsoniteApp', ['samsoniteApp.controllers', 'samsoniteApp.eventsControllers', 'samsoniteApp.directives', 'samsoniteApp.services', "samsoniteApp.eventsServices"]);



/** DOM 로드 완료   */
$(function(){
    
});

/** 리소스로드 완료    */
$(window).load(function(){
    
});


//aqApp.config(['$routeProvider', function ($routeProvider) {
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




