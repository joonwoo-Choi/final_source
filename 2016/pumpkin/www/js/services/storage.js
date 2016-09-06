
angular.module('giftbox.services')

.factory('storageSvc', ['$q', '$cordovaSQLite', function($q, $cordovaSQLite) {
    
    var DB_CONFIG = {
            name: 'giftbox.db',
            tables: [
                {
                    name: 'userInfo',
                    columns: [
                        {name: 'tableId', type: 'integer primary key'},
                        {name: 'os', type: 'text'},
                        {name: 'isPush', type: 'text'},
                        {name: 'deviceToken', type: 'text'}
                    ]
                },
                {
                    name: 'homePopupClosed',
                    columns: [
                        {name: 'tableId', type: 'integer primary key'},
                        {name: 'id', type: 'integer'}
                    ]
                },
                {
                    name: 'filterOption',
                    columns: [
                        {name: 'tableId', type: 'integer primary key'},
                        {name: 'premium', type: 'text'},
                        {name: 'sort', type: 'text'},
                        {name: 'onGoings', type: 'text'},
                        {name: 'forms', type: 'text'}
                    ]
                },
                {
                    name: 'viewedList',
                    columns: [
                        {name: 'tableId', type: 'integer primary key'},
                        {name: 'id', type: 'integer'},
                        {name: 'title', type: 'text'},
                        {name: 'description', type: 'text'},
                        {name: 'company', type: 'text'},
                        {name: 'eventTarget', type: 'text'},
                        {name: 'eventTypes', type: 'text'},
                        {name: 'gifts', type: 'text'},
                        {name: 'registrationDate', type: 'text'},
                        {name: 'startDate', type: 'text'},
                        {name: 'startTime', type: 'text'},
                        {name: 'endDate', type: 'text'},
                        {name: 'endTime', type: 'text'},
                        {name: 'publicationContent1', type: 'text'},
                        {name: 'publicationContent2', type: 'text'},
                        {name: 'publicationDate', type: 'text'},
                        {name: 'publicationTime', type: 'text'},
                        {name: 'publicationType', type: 'text'},
                        {name: 'homePage', type: 'text'},
                        {name: 'eventPage', type: 'text'},
                        {name: 'prizePage', type: 'text'},
                        {name: 'attachments', type: 'text'},
                        {name: 'createdDate', type: 'text'},
                        {name: 'premium', type: 'text'},
                        {name: 'updatedTime', type: 'integer'}
                    ]
                },
                {
                    name: 'bookmarkedList',
                    columns: [
                        {name: 'tableId', type: 'integer primary key'},
                        {name: 'id', type: 'integer'},
                        {name: 'title', type: 'text'},
                        {name: 'description', type: 'text'},
                        {name: 'company', type: 'text'},
                        {name: 'eventTarget', type: 'text'},
                        {name: 'eventTypes', type: 'text'},
                        {name: 'gifts', type: 'text'},
                        {name: 'registrationDate', type: 'text'},
                        {name: 'startDate', type: 'text'},
                        {name: 'startTime', type: 'text'},
                        {name: 'endDate', type: 'text'},
                        {name: 'endTime', type: 'text'},
                        {name: 'publicationContent1', type: 'text'},
                        {name: 'publicationContent2', type: 'text'},
                        {name: 'publicationDate', type: 'text'},
                        {name: 'publicationTime', type: 'text'},
                        {name: 'publicationType', type: 'text'},
                        {name: 'homePage', type: 'text'},
                        {name: 'eventPage', type: 'text'},
                        {name: 'prizePage', type: 'text'},
                        {name: 'attachments', type: 'text'},
                        {name: 'createdDate', type: 'text'},
                        {name: 'premium', type: 'text'},
                        {name: 'updatedTime', type: 'integer'}
                    ]
                },
                {
                    name: 'joinedList',
                    columns: [
                        {name: 'tableId', type: 'integer primary key'},
                        {name: 'id', type: 'integer'},
                        {name: 'title', type: 'text'},
                        {name: 'description', type: 'text'},
                        {name: 'company', type: 'text'},
                        {name: 'eventTarget', type: 'text'},
                        {name: 'eventTypes', type: 'text'},
                        {name: 'gifts', type: 'text'},
                        {name: 'registrationDate', type: 'text'},
                        {name: 'startDate', type: 'text'},
                        {name: 'startTime', type: 'text'},
                        {name: 'endDate', type: 'text'},
                        {name: 'endTime', type: 'text'},
                        {name: 'publicationContent1', type: 'text'},
                        {name: 'publicationContent2', type: 'text'},
                        {name: 'publicationDate', type: 'text'},
                        {name: 'publicationTime', type: 'text'},
                        {name: 'publicationType', type: 'text'},
                        {name: 'homePage', type: 'text'},
                        {name: 'eventPage', type: 'text'},
                        {name: 'prizePage', type: 'text'},
                        {name: 'attachments', type: 'text'},
                        {name: 'createdDate', type: 'text'},
                        {name: 'premium', type: 'text'},
                        {name: 'updatedTime', type: 'integer'}
                    ]
                },
                {
                    name: 'joiningList',
                    columns: [
                        {name: 'tableId', type: 'integer primary key'},
                        {name: 'id', type: 'integer'}
                    ]
                }
            ]
        };
    
    var viewedListSize = 0;
    var bookmarkedListSize = 0;
    var joinedListSize = 0;
    
    var self = this;
    self.db = null;
    
    self.init = function(){
        if (window.cordova) {
            self.db = window.sqlitePlugin.openDatabase({name: DB_CONFIG.name, location:'default'});
        }else{
//            window.indexedDB.deleteDatabase(DB_CONFIG.name);
            self.db = window.openDatabase(DB_CONFIG.name, '1', 'database', 1024 * 1024 * 100);
        };
        
        angular.forEach(DB_CONFIG.tables, function(table) {
//            self.dropTable(table.name);
            var columns = [];
            
            angular.forEach(table.columns, function(column) {
                columns.push(column.name + ' ' + column.type);
            });
            
            var query = 'CREATE TABLE IF NOT EXISTS ' + table.name + ' (' + columns.join(',') + ')';
            self.query(query).then(
                function(res){
                    /** success */
                    console.log('Table ' + table.name + ' initialized');
                    
                    self.query('SELECT count(id) FROM ' + table.name).then(
                        function(res){
                            /** success */
                            switch(table.name){
                                case 'viewedList':
                                    viewedListSize = res.rows.item(0)['count(id)'];
                                    break;
                                case 'bookmarkedList':
                                    bookmarkedListSize = res.rows.item(0)['count(id)'];
                                    break;
                                case 'joinedList':
                                    joinedListSize = res.rows.item(0)['count(id)'];
                                    break;
                            }
                        },
                        function(err){
                            /** error   */
                        }
                    );
                },
                function(err){
                    /** error   */
                }
            );
        });
        
    };
    
    self.query = function(query, bindings) {
        bindings = typeof bindings !== 'undefined' ? bindings : [];
        var deferred = $q.defer();
        
        self.db.transaction(function(transaction) {
            transaction.executeSql(query, bindings, function(transaction, res) {
                deferred.resolve(res);
            }, function(transaction, error) {
                deferred.reject(error);
            });
        });
        
        return deferred.promise;
    };
    
    self.fetchAll = function(res) {
        var output = [];

        for (var i = 0; i < res.rows.length; i++) {
            output.push(res.rows.item(i));
        }
        
        return output;
    };

    self.fetch = function(res) {
        return res.rows.item(0);
    };
    
    
    
    
    
    self.getAll = function(table) {
        return self.query('SELECT * FROM ' + table).then(
            function(res){
                /** success */
                if(res.rows.length > 0){
                    return self.fetchAll(res);
                }else{
                    return [];
                }
            },
            function(err){
                /** error   */
            }
        );
    };
    
    self.getByTableId = function(table, tableId) {
        return self.query('SELECT * FROM ' + table + ' WHERE tableId = ?', [tableId]).then(
            function(res){
                /** success */
                if(res.rows.length > 0){
                    return self.fetch(res);
                }else{
                    return null;
                }
            },
            function(err){
                /** error   */
            }
        );
    };
    
    self.getByEventId = function(table, id) {
        return self.query('SELECT * FROM ' + table + ' WHERE id = ?', [id]).then(
            function(res){
                /** success */
                if(res.rows.length > 0){
                    var event = self.fetch(res);
                    
                    if(event.gifts) event.gifts = JSON.parse(event.gifts);
                    if(event.eventTypes) event.eventTypes = JSON.parse(event.eventTypes);
                    if(event.attachments) event.attachments = JSON.parse(event.attachments);
                    if(event.premium) event.premium = JSON.parse(event.premium);
                    
                    return event;
                }else{
                    return null;
                }
            },
            function(err){
                /** error   */
            }
        );
    };
    
    self.insert = function(table, column, insertData) {
        return self.query('INSERT INTO ' + table + ' (' + column + ') VALUES (?)', [insertData]);
    };
    
    self.update = function(table, column, updateData) {
        return self.query('UPDATE ' + table + ' SET ' + column + ' = ?', [updateData]);
    };
    
    self.deleteByTableId = function(table, tableId) {
        return self.query('DELETE FROM ' + table + ' WHERE tableId = ?', [tableId]);
    };
    
    self.deleteByEventId = function(table, id) {
        return self.query('DELETE FROM ' + table + ' WHERE id = ?', [id]);
    };
    
    self.deleteAll = function(table) {
        return self.query('DELETE FROM ' + table);
    };
    
    self.dropTable = function(table) {
        return self.query('DROP TABLE IF EXISTS ' + table);
    };
    
    
    /** 유저 정보 저장    */
    self.insertUserInfo = function(insertData){
        var deferred = $q.defer();
        self.dropTable('userInfo').then(
            function(res){
                var table = DB_CONFIG.tables[0];
                var columns = [];
                angular.forEach(table.columns, function(column) {
                    columns.push(column.name + ' ' + column.type);
                });
                var query = 'CREATE TABLE IF NOT EXISTS userInfo (' + columns.join(',') + ')';
                self.query(query).then(
                    function(res){
                        self.query('INSERT INTO userInfo (os,isPush,deviceToken) VALUES (?,?,?)', insertData).then(
                            function(res){
                                deferred.resolve(res);
                            },
                            function(err){

                            }
                        );
                    }
                );
            },
            function(err){

            }
        );
        return deferred.promise;
    };
    /** 유저 정보 업데이트  */
    self.updateUserInfo = function(insertData){
        var deferred = $q.defer();
        var query = 'UPDATE userInfo SET os=?,isPush=?,deviceToken=? WHERE tableId = 1';
        self.query(query, insertData).then(
            function(res){
                deferred.resolve(res);
            },
            function(err){
                
            }
        );
        return deferred.promise;
    };
    
    
    /** 필터 옵션 저장    */
    self.insertFilterOption = function(insertData){
        var deferred = $q.defer();
        self.query('INSERT INTO filterOption (premium,sort,onGoings,forms) VALUES (?,?,?,?)', insertData).then(
            function(res){
                deferred.resolve(res);
            },
            function(err){
                
            }
        );
        return deferred.promise;
    };
    /** 필터 옵션 업데이트  */
    self.updateFilterOption = function(insertData){
        var deferred = $q.defer();
        var query = 'UPDATE filterOption SET premium=?,sort=?,onGoings=?,forms=?';
        self.query(query, insertData).then(
            function(res){
                deferred.resolve(res);
            },
            function(err){
                
            }
        );
        return deferred.promise;
    };
    /** 최근 본 이벤트 리스트 저장 */
    self.insertViewedEvent = function(insertData){
        self.deleteByEventId('viewedList', insertData.id);
        
        var deferred = $q.defer();
        self.makeInsertData('viewedList', insertData, deferred);
        
        return deferred.promise;
    };
    /** 북마크 이벤트 리스트 저장 */
    self.insertBookmarkedEvent = function(insertData){
//        self.deleteByEventId('bookmarkedList', insertData.id);
        
        var deferred = $q.defer();
        self.makeInsertData('bookmarkedList', insertData, deferred);
        
        return deferred.promise;
    };
    /** 북마크 이벤트 리스트 삭제 */
    self.deleteBookmarkedEvent = function(id){
        return self.deleteByEventId('bookmarkedList', id);
    };
    /** 이벤트 응모 진행중 리스트 저장    */
    self.insertJoiningEvent = function(id){
        return self.getByEventId('joiningList', id).then(
            function(res){
                if(res === null){
                    return self.insert('joiningList', 'id', id);
                };
            },
            function(err){
                
            }
        );
    };
    /** 응모한 이벤트 리스트 저장 */
    self.insertJoinedEvent = function(insertData){
        self.deleteByEventId('joinedList', insertData.id);
        
        var deferred = $q.defer();
        self.makeInsertData('joinedList', insertData, deferred);
        
        return deferred.promise;
    };
    /** 응모한 이벤트 리스트 삭제 */
    self.deleteJoinedEvent = function(id){
        return self.deleteByEventId('joinedList', id);
    };
    /** 저장할 이벤트 가공  */
    self.makeInsertData = function(table, insertData, deferred){
        var dataQuery = [],
            valuesQuery = [],
            insertValues = [];
        
        angular.forEach(insertData, function(val, key){
            if(typeof val === 'object'){
                val = JSON.stringify(val);
            };
            dataQuery.push(key);
            valuesQuery.push('?');
            insertValues.push(val);
        });
        
        self.query('INSERT INTO ' + table + ' (' + dataQuery.join() + ') VALUES (' + valuesQuery.join() + ')', insertValues).then(
            function(res){
                /** success */
                deferred.resolve(res);
                self.query('SELECT count(id) FROM ' + table).then(
                    function(res){
                        /** success */
                        switch(table){
                            case 'viewedList':
                                /** 리스트는 50개 까지만 저장 */
                                if(res.rows[0]['count(id)'] <= 50){
                                    viewedListSize = res.rows[0]['count(id)'];
                                }else{
                                    viewedListSize = 50;
                                    self.query('DELETE FROM viewedList WHERE tableId IN (SELECT tableId FROM viewedList ORDER BY tableId ASC LIMIT 1)');
                                };
                                break;
                            case 'bookmarkedList':
                                /** 리스트는 100개 까지만 저장    */
                                if(res.rows[0]['count(id)'] <= 100){
                                    bookmarkedListSize = res.rows[0]['count(id)'];
                                }else{
                                    bookmarkedListSize = 100;
                                    self.query('DELETE FROM bookmarkedList WHERE tableId IN (SELECT tableId FROM bookmarkedList ORDER BY tableId ASC LIMIT 1)');
                                };
                                break;
                            case 'joinedList':
                                /** 리스트는 100개 까지만 저장    */
                                if(res.rows[0]['count(id)'] <= 100){
                                    joinedListSize = res.rows[0]['count(id)'];
                                }else{
                                    joinedListSize = 100;
                                    self.query('DELETE FROM joinedList WHERE tableId IN (SELECT tableId FROM joinedList ORDER BY tableId ASC LIMIT 1)');
                                };
                                break;
                        }
                    },
                    function(err){
                        /** error   */
                    }
                );
            },
            function(err){
                /** error   */
            }
        );
    };
    
    
    /** 최근 본 이벤트 업데이트   */
    self.updateViewedEvent = function(insertData){
        var deferred = $q.defer();
        self.makeUpdateData('viewedList', insertData, deferred);
        
        return deferred.promise;
    };
    /** 북마크 이벤트 업데이트   */
    self.updateBookmarkedEvent = function(insertData){
        var deferred = $q.defer();
        self.makeUpdateData('bookmarkedList', insertData, deferred);
        
        return deferred.promise;
    };
    /** 응모한 이벤트 업데이트   */
    self.updateJoinedEvent = function(insertData){
        var deferred = $q.defer();
        self.makeUpdateData('joinedList', insertData, deferred);
        
        return deferred.promise;
    };
    /** 업데이트 이벤트 가공  */
    self.makeUpdateData = function(table, insertData, deferred){
        var dataQuery = [],
            insertValues = [];
        
        angular.forEach(insertData, function(val, key){
            if(typeof val === 'object'){
                val = JSON.stringify(val);
            };
            dataQuery.push(key+'=?');
            insertValues.push(val);
        });
        
        var query = 'UPDATE ' + table + ' SET ' + dataQuery.join()  + ' WHERE id = ' + insertData.id;
        self.query(query, insertValues).then(
            function(res){
                /** success */
                deferred.resolve(res);
            },
            function(err){
                /** error   */
            }
        );
    };
    
    
    
    
    /** 최근 본 이벤트 리스트 가져오기   */
    self.getViewedEventList = function(page, size){
        var deferred = $q.defer();
        self.makeEventList('viewedList', page, size, deferred);
        
        return deferred.promise;
    };
    /** 북마크 이벤트 리스트 가져오기    */
    self.getBookmarkedEventList = function(page, size){
        var deferred = $q.defer();
        self.makeEventList('bookmarkedList', page, size, deferred);
        
        return deferred.promise;
    };
    /** 응모한 이벤트 리스트 가져오기    */
    self.getJoinedEventList = function(page, size){
        var deferred = $q.defer();
        self.makeEventList('joinedList', page, size, deferred);
        
        return deferred.promise;
    };
    /** 이벤트 리스트 가공  */
    self.makeEventList = function(table, page, size, deferred){
        self.query('SELECT * FROM ' + table + ' ORDER BY tableId DESC LIMIT ' + size + ' OFFSET ' + ((page-1)*size)).then(
            function(res){
                /** success */
                var callbackParams = {
                        data: null,
                        isLast: false
                    };
                var fetchedList = self.fetchAll(res);
                
                if(fetchedList.length > 0){
                    angular.forEach(fetchedList, function(val, key){
                        if(val.gifts) val.gifts = JSON.parse(val.gifts);
                        if(val.eventTypes) val.eventTypes = JSON.parse(val.eventTypes);
                        if(val.attachments) val.attachments = JSON.parse(val.attachments);
                        if(val.premium) val.premium = JSON.parse(val.premium);
                        
                        switch(table){
                            case 'viewedList':
                                if(viewedListSize <= (page*size)){
                                    callbackParams.isLast = true;
                                };
                                break;
                            case 'bookmarkedList':
                                if(bookmarkedListSize <= (page*size)){
                                    callbackParams.isLast = true;
                                };
                                break;
                            case 'joinedList':
                                if(joinedListSize <= (page*size)){
                                    callbackParams.isLast = true;
                                };
                                break;
                        }
                    });
                }else{
                    callbackParams.isLast = true;
                };
                callbackParams.data = fetchedList;
                
                deferred.resolve(callbackParams);
            },
            function(err){
                /** error   */
            }
        );
    };
    
    
    return self;
    
    
}]);
