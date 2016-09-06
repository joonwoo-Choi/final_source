angular.module('giftbox.services')

.factory('calendarSvc', ['$cordovaCalendar', 'appDataSvc', function($cordovaCalendar, appDataSvc){
    
    var calendarName = 'Pumpkin Calendar';
    var calendarColor = '#FF0000';
    
    function createCordovaCalendar(){
        $cordovaCalendar.createCalendar({
                calendarName: calendarName,
                calendarColor: calendarColor
            }).then(
            function (res) {
//                alert('success create calendar ', JSON.stringify(res));
            },
            function (err) {
//                alert('error create calendar ', JSON.stringify(err));
            }
        );
    };
    
    function deleteCordovaCalendar(){
        $cordovaCalendar.deleteCalendar(calendarName).then(
            function (res) {
//                alert('success delete calendar ', JSON.stringify(res));
            },
            function (err) {
//                alert('error delete calendar ', JSON.stringify(err));
            }
        );
    };
    
    function createCordovaEvent(params){
        if(params.publicationDate.length == 0) return;
        
        /**  오전 8시 알람   */
        var firstReminderMinutes = 60;
        if(appDataSvc.os == 'IOS'){
            params.title = JSON.stringify('[' + params.location + '] ' + params.title);
            params.title = String(params.title).replace(/"|'/g, '');
            params.location = '';
            firstReminderMinutes = -480;
        };

        $cordovaCalendar.createEventWithOptions({
            title: params.title,
            location: params.location,
            notes: params.notes,
            startDate: params.publicationDate,
            endDate: params.publicationDate,
            firstReminderMinutes: firstReminderMinutes
        }).then(
            function (res) {
//                alert('success create event ', JSON.stringify(res));
            }, function (err) {
//                alert('error create event ', JSON.stringify(err));
            }
        );

    }
    
    function deleteCordovaEvent(params){
        if(params.publicationDate.length == 0) return;
        
        /**  오전 8시 알람   */
        var firstReminderMinutes = 60;
        if(appDataSvc.os == 'IOS'){
            params.title = JSON.stringify('[' + params.location + '] ' + params.title);
            params.notes = JSON.stringify(params.notes);
            params.title = params.title.replace(/"|'/g, '');
            params.notes = params.notes.replace(/^\"|\"$/g, '');
            params.location = '';
            firstReminderMinutes = -480;
        };
        
        $cordovaCalendar.deleteEvent({
            newTitle: params.title,
            location: params.location,
            notes: params.notes,
            startDate: params.publicationDate,
            endDate: params.publicationDate,
            firstReminderMinutes: firstReminderMinutes
        }).then(
            function (res) {
//                alert('success delete event ', JSON.stringify(res));
            },
            function (err) {
//                alert('error delete event ', JSON.stringify(err));
            }
        );
    }
    
    
    
    return {
        createCalendar: createCordovaCalendar,
        deleteCalendar: deleteCordovaCalendar,
        createEvent: createCordovaEvent,
        deleteEvent: deleteCordovaEvent
    };
}]);
    
