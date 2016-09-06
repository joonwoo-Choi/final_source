(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');
    
    BBuzzArtApp.factory('timeSvc', ['$filter', function($filter){
        
        function getConvertedData(date) {
			var temp = String(date).split(' ');
			var tempDate = temp[0].split('-');
			return new Date(tempDate.join('/') + ' ' + temp[1] + ' UTC');
		}
        
        return {
            getDate: function (date) {
				var MIN_1 = 1000 * 60 * 1;
                var HOUR_1 = 1000 * 60 * 60 * 1;
                var HOUR_24 = 1000 * 60 * 60 * 24;

                var objDate = getConvertedData(date);
                var currntDate = new Date();
                var diff = currntDate.getTime() - objDate.getTime();

                function getHour(milsec) {
                    return parseInt(milsec / HOUR_1);
                }
                function getMin(milsec) {
                    return parseInt(milsec / MIN_1);
                }

                if (diff >= HOUR_24) {
                    //지난 시간이 24시간 이상인 경우
                    return $filter('date')(objDate.toISOString(), 'MMM. d, yyyy');	
                } else if (diff >= HOUR_1) {
                    //지난 시간이 1시간 이상인 경우
                    return getHour(diff) + ' hours ago';
                } else if (diff < HOUR_1 && diff >= MIN_1) {
                    //지난 시간이 1시간 미만인 경우
                    return getMin(diff) + ' minutes ago';
                } else if (diff < MIN_1) {
                    //1분 미만인 경우
                    return 'Now';
                }
			},
			getDuration: function (durationSec) {
				var duSec = parseInt(durationSec, 10); // don't forget the second param
                var hours   = Math.floor(duSec / 3600);
                var minutes = Math.floor((duSec - (hours * 3600)) / 60);
                var seconds = duSec - (hours * 3600) - (minutes * 60);

                if (hours < 10) {
                    hours   = "0" + hours;
                }
                if (minutes < 10) {
                    minutes = "0" + minutes;
                }
                if (seconds < 10) {
                    seconds = "0" + seconds;
                }

                return hours + ':' + minutes + ':' + seconds;
            }
		};
    }]);
    
})(angular);
