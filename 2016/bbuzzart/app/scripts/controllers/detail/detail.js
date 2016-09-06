(function(angular){
    'use strict';
    
    var BBuzzArtApp = angular.module('BBuzzArtApp');
    
    BBuzzArtApp.controller('detailCtrl', ['$rootScope', '$scope', '$q', '$window', '$sce', '$timeout', '$mdMenu', '$state', '$mdDialog', 'initData', 'trackerSvc', 'authSvc', 'dialogSvc', 'restApiSvc', 'timeSvc', 'imgLoadSvc', 'blockUI', function ($rootScope, $scope, $q, $window, $sce, $timeout, $mdMenu, $state, $mdDialog, initData, trackerSvc, authSvc, dialogSvc, restApiSvc, timeSvc, imgLoadSvc, blockUI) {
        
        $scope.isMobile = $rootScope.isMobile;
        $scope.isMobileView = false;
        $scope.detailData = initData.detailData;
        $scope.thumbnailUrl = '/images/thumbnail_default_img.png';
        $scope.feedbackLists = [];
        $scope.feedbackListPage = 1;
        $scope.feedbackListSize = 20;
        $scope.isFeedbackListLoading = false;
        $scope.detailApiPath = '';
        $scope.isLogin = false;
        $scope.isCurator = false;
        $scope.myId = null;
        $scope.feedback = "";
        $scope.editFeedback = "";
        $scope.detailEditMenus = ['EDIT', 'DELETE', 'FACEBOOK', 'TWITTER'];
        $scope.detailFlagMenus = ['FACEBOOK', 'TWITTER', 'FLAG AN ISSUE'];
        $scope.feedbackEditMenus = ['EDIT', 'DELETE'];
        $scope.isOpenDetailInfo = false;
        $scope.minWindowHeight = 830;
        $scope.mentionUsers = [];
        $scope.mentionPromise;
        $scope.selectedNewFeedbackMentions = [];
        $scope.selectedEditFeedbackMentions = [];
        $scope.isOpenFeedbackAide = false;
        $scope.isGenerating = false;
        $scope.generateComplete = false;
        $scope.feedbackAideStep = 0;
        $scope.feedbackAideLastStep = 2;
        $scope.feedbackAideTitle = [
            'Please select the word that best describes this artwork. (1/3)',
            'Another word? (2/3)',
            'Last word (3/3)'
        ];
        $scope.feedbackAideLists = [[], [], []];
        $scope.selectedFeedbackAideIdxs = [];
        $scope.detailScrollTop = 0;
        $scope.detailScrollPct = 0;
        $scope.scrollbarsConfig = {
            callbacks: {
                onScroll: function () {
                    $scope.detailScrollTop = Math.abs(this.mcs.top);
                    $scope.detailScrollPct = Math.abs(this.mcs.topPct);
                    $scope.toggleDetailInfo();
                },
                whileScrolling: function() {
                    $scope.detailScrollTop = Math.abs(this.mcs.top);
                    $scope.detailScrollPct = Math.abs(this.mcs.topPct);
                    $scope.toggleDetailInfo();
                }
            }
        };
        $scope.feedbackScrollbarsConfig = {
            callbacks: {
                onScroll: function () {
                    $scope.onScroll(this.mcs.top, this.mcs.topPct);
                },
                whileScrolling: function() {
                    $scope.onScroll(this.mcs.top, this.mcs.topPct);
                }
            }
        };
        $scope.mobileScrollBarOptions = {
            advanced:{
                updateOnContentResize: true
            },
            mouseWheel:{
                scrollAmount: 100,
                preventDefault: false,
                disableOver: []
            },
            contentTouchScroll: 25,
            documentTouchScroll: true,
            scrollInertia: 150,
            axis: 'y',
            theme: 'minimal-dark',
            autoHideScrollbar: true,
            callbacks: {
                onScroll: function () {
                    $scope.onScroll(this.mcs.top, this.mcs.topPct);
                },
                whileScrolling: function() {
                    $scope.onScroll(this.mcs.top, this.mcs.topPct);
                }
            }
        };
        
        angular.element($window).bind('scroll', function(e){
            if(!$scope.isMobile) return;
            
            var scrollTop = e.target.body.scrollTop;
            var maxScrollTop = e.target.body.scrollHeight - angular.element($window).height();
            var scrollPct = (scrollTop/maxScrollTop)*100;
            $scope.onScroll(scrollTop, scrollPct);
        });
        $scope.onScroll = function(scrollTop, scrollPct){
            if(scrollPct != undefined && scrollPct >= 95){
                $scope.feedbackListLoad();
            }
        }
        
        $scope.feedbackListLoad = function(){
            if($scope.isFeedbackListLoading) return;
            $scope.isFeedbackListLoading = true;
            
            $scope.feedbackListPage++;
            var params = {
                    page: $scope.feedbackListPage,
                    size: $scope.feedbackListSize
                };
            restApiSvc.get(restApiSvc.apiPath.getFeedback($scope.detailData.id), params).then(
                function(res){
                    $timeout(function(){
                        $scope.isFeedbackListLoading = false;
                        
                        if($scope.feedbackListPage > res.data.datatotalPages){
                            $scope.feedbackListPage = res.data.datatotalPages;
                        }
                        
                        if(res.data.data.content.length > 0){
                            var tempList = $scope.setFeedbackList(res.data.data.content);
                            var currentIdx = tempList.length;
                            while(currentIdx > 0){
                                currentIdx--;
                                angular.forEach($scope.feedbackLists, function(val, idx){
                                    if(tempList[currentIdx].createdDate == val.createdDate){
                                        tempList.splice(currentIdx, 1);
                                    }
                                });
                            }
                            $scope.feedbackLists = $scope.feedbackLists.concat(tempList);
                        }
                    });
                },function(res, status){
                    
                }
            );
        }
        
        $scope.myDtailContentEdit = function(idx){
            $mdMenu.hide();
            switch(idx){
                case 0 :
                    /** edit    */
                    switch($scope.detailData.type){
                        case 'WORK_IMAGE' :
                            dialogSvc.openUploadImage({detailData: $scope.detailData});
                            break;
                        case 'WORK_WRITING' :
                            dialogSvc.openUploadWriting({detailData: $scope.detailData});
                            break;
                        case 'WORK_VIDEO' :
                            dialogSvc.openUploadVideo({detailData: $scope.detailData});
                            break;
                        case 'WORK_SHOW' :
                            dialogSvc.openUploadShow({detailData: $scope.detailData});
                            break;
                    }
                    break;
                case 1 :
                    /** delete  */
                    dialogSvc.confirmDialog(dialogSvc.confirmDialogType.delete, function(answer){
                        if(answer == 'yes'){
                            blockUI.start();
                            $scope.deleteDetailData();
                        }else{
                            dialogSvc.closeConfirm();
                        }
                    });
                    break;
                case 2 :
                    $scope.sendTrackDetail('FACEBOOK');
                    $scope.shareFacebook();
                    break;
                case 3 :
                    $scope.sendTrackDetail('TWITTER');
                    $scope.shareTwitter();
                    break;
            }
        }
        $scope.detailMenuHandler = function(idx){
            $mdMenu.hide();
            switch(idx){
                case 0 :
                    $scope.sendTrackDetail('FACEBOOK');
                    $scope.shareFacebook();
                    break;
                case 1 :
                    $scope.sendTrackDetail('TWITTER');
                    $scope.shareTwitter();
                    break;
                case 2 :
                    if($scope.isLogin){
                        $scope.sendTrackDetail('FLAG');
                        dialogSvc.openFlagAnIssue({artWorkId: $scope.detailData.id});
                    }else{
                        dialogSvc.openAccount();
                    }
                    break;
            }
        }
        $scope.shareFacebook = function(){
            var linkUrl = 'http://link.bbuzzart.com/works/'+$scope.detailData.id+'/share';
            window.open('http://www.facebook.com/sharer/sharer.php?u=' + encodeURIComponent(linkUrl) + '&t=' + encodeURIComponent($scope.detailData.title));
        }
        $scope.shareTwitter = function(){
            var linkUrl = location.href;
            var title = $scope.detailData.title;
            var username = $scope.detailData.createdBy.username;
            
            if($rootScope.isIE){
                title = title.replace('(', "[");
                title = title.replace(')', "]");
                username = username.replace('(', "[");
                username = username.replace(')', "]");
            };
            
            var text = 'Please explore "' + title + '" of "' + username + '" at #BBuzzArt ';
            window.open('http://twitter.com/intent/tweet?url=' + encodeURIComponent(linkUrl) + '&text=' + encodeURIComponent(text));
        }
        
        $scope.openImageViewer = function(){
            var viewer = ImageViewer({snapView:false});
            viewer.show($scope.detailData.attachments[0].url);
        }
        
        $('.content-detail').bind('scroll', function(e){
            if(!$scope.isMobile) return;
            
            var scrollTop = e.target.scrollTop;
            var maxScrollTop = e.target.scrollHeight - e.target.clientHeight;
            var scrollPct = (scrollTop/maxScrollTop)*100;
            $scope.detailScrollTop = scrollTop;
            $scope.detailScrollPct = scrollPct;
            $scope.toggleDetailInfo();
        });
        $scope.btnToggleDetailInfo = function(){
            if(!$('.detail-info-wrap .scroll-info-wrap').hasClass('fold-open') && 
               !$('.detail-info-wrap .scroll-info-wrap').hasClass('fold')) return;
            $scope.isOpenDetailInfo = !$scope.isOpenDetailInfo;
            $scope.toggleDetailInfo();
        }
        $scope.toggleDetailInfo = function(){
            if($('.content-detail .scroll-contents-wrap').css('top') == undefined || 
               $scope.detailData.type != 'WORK_IMAGE' || $scope.isMobileView) return;
            var wrapHeight = $('.detail-wrap').height();
            var contentsHeight = $('.content-detail .scroll-contents-wrap').height();
            var maxScrollY = contentsHeight - wrapHeight;
            var foldMaxHeight = maxScrollY - $('.detail-info-wrap .scroll-info-wrap').height();
            
            if($scope.isOpenDetailInfo && $('.detail-info').outerHeight() > $('.detail-info-wrap .scroll-info-wrap').height()){
                var val = $('.detail-info').outerHeight() - $('.detail-info-wrap .scroll-info-wrap').height();
                maxScrollY = maxScrollY - val;
            }
            
            if($scope.detailScrollTop >= maxScrollY){
                $scope.isOpenDetailInfo = false;
                $('.detail-info-wrap .scroll-info-wrap').removeClass('fold fold-open').css({'max-height': 'none'});
            }else{
                if($scope.isOpenDetailInfo){
                    $('.detail-info-wrap .scroll-info-wrap').removeClass('fold').addClass('fold-open').css({'max-height': $('.content-detail').height()});
                }else{
                    if($scope.detailScrollTop >= foldMaxHeight){
                        $scope.isOpenDetailInfo = false;
                        $('.detail-info-wrap .scroll-info-wrap').removeClass('fold fold-open').css({'max-height': 'none'});
                    }else{
                        $('.detail-info-wrap .scroll-info-wrap').removeClass('fold-open').addClass('fold').css({'max-height': 'none'});
                    }
                }
            }
        }
        
        $scope.bookmarkThis = function(){
            if($scope.isLogin){
                blockUI.start();
                var isBookmarked = $scope.detailData.bookmarked;
                var artWorkId = $scope.detailData.id;
                if(isBookmarked){
                    restApiSvc.delete(restApiSvc.apiPath.unBookmarkActivity(artWorkId)).then(
                        function(res){
                            blockUI.stop();
                            if(res.data.success){
                                $scope.detailData.bookmarked = !$scope.detailData.bookmarked;
                            }
                        },function(res, status){
                            blockUI.stop();
                        }
                    );
                }else{
                    restApiSvc.post(restApiSvc.apiPath.bookmarkActivity(artWorkId)).then(
                        function(res){
                            blockUI.stop();
                            if(res.data.success){
                                $scope.sendTrackDetail('BOOKMARK');
                                $scope.detailData.bookmarked = !$scope.detailData.bookmarked;
                            }
                        },function(res, status){
                            blockUI.stop();
                        }
                    );
                }
            }else{
                $scope.openAccount();
            }
        }
        
        $scope.likeThis = function(){
            if($scope.isLogin){
                blockUI.start();
                var isLiked = $scope.detailData.liked;
                var artWorkId = $scope.detailData.id;
                if(isLiked){
                    restApiSvc.delete(restApiSvc.apiPath.unLikeActivity(artWorkId)).then(
                        function(res){
                            blockUI.stop();
                            if(res.data.success){
                                $scope.detailData.liked = !$scope.detailData.liked;
                                $scope.detailData.likeCount--;
                                $scope.setDetailData();
                            }
                        },function(res, status){
                            blockUI.stop();
                        }
                    );
                }else{
                    restApiSvc.post(restApiSvc.apiPath.likeActivity(artWorkId)).then(
                        function(res){
                            blockUI.stop();
                            if(res.data.success){
                                $scope.sendTrackDetail('LIKE');
                                $scope.detailData.liked = !$scope.detailData.liked;
                                $scope.detailData.likeCount++;
                                $scope.setDetailData();
                            }
                        },function(res, status){
                            blockUI.stop();
                        }
                    );
                }
            }else{
                $scope.openAccount();
            }
        }
        
        $scope.openLikedPeopleLists = function(){
            if($scope.detailData.likeCount <= 0) return;
            $scope.sendTrackDetail('LIKE COUNT');
            
            var title = 'PEOPLE LIKE THIS',
                getType = 'like';
            dialogSvc.openPeopleLists({title: title, type: getType, searchData: $scope.detailData.id});
        }
        
        $scope.focusInputFeedback = function(){
            $scope.sendTrackDetail('FEEDBACK');
            if($scope.isLogin){
                $('.input-feedback>textarea').focus();
            }else{
                $scope.openAccount();
            }
        }
        
        $scope.openSearchTagLists = function(tag){
//            if(tag.indexOf('#') <= -1) tag = '#' + tag;
            $scope.sendTrackDetail('TAG');
            
            var title = 'Search > ' + tag,
                getType = 'tag';
            dialogSvc.openSearchedList({title: title, type: getType, searchData: tag});
        }
        
        /** mention */
        $scope.searchPeople = function(term) {
            if(term.length <= 0) return;
            
            var params = {
                username: term,
                size: 5
            }
            if($scope.mentionPromise != undefined){
                $scope.mentionPromise.abort();
            }
            $scope.mentionPromise = restApiSvc.get(restApiSvc.apiPath.getMentionUsers, params)
            $scope.mentionPromise.then(
                function(res){
                    $scope.mentionUsers = res.data.data;
                }, function(res){
                    
                }
            );
        };
        $scope.getNewMentionTextRaw = function(item) {
            var getName = '@' + item.username;
            
            if($scope.selectedNewFeedbackMentions.length > 0){
                var mentionUserCheck = false;
                angular.forEach($scope.selectedNewFeedbackMentions, function(val, idx){
                    if(!mentionUserCheck){
                        if(getName == val.username){
                            mentionUserCheck = true;
                        }
                    }
                });
                if(!mentionUserCheck){
                    $scope.selectedNewFeedbackMentions.push(item);
                }
            }else{
                $scope.selectedNewFeedbackMentions.push(item);
            }
            return getName;
        };
        
        $scope.getEditMentionTextRaw = function(item) {
            var getName = '@' + item.username;
            
            if($scope.selectedEditFeedbackMentions.length > 0){
                var mentionUserCheck = false;
                angular.forEach($scope.selectedEditFeedbackMentions, function(val, idx){
                    if(!mentionUserCheck){
                        if(getName == val.username){
                            mentionUserCheck = true;
                        }
                    }
                });
                if(!mentionUserCheck){
                    $scope.selectedEditFeedbackMentions.push(item);
                }
            }else{
                $scope.selectedEditFeedbackMentions.push(item);
            }
            return getName;
        };
        
        /** feedback aide   */
        $scope.openFeedbackAide = function(){
            if($scope.isOpenFeedbackAide) return;
            
            if($scope.isLogin){
                $scope.showFeedbackAide();
            }else{
                $scope.openAccount();
            }
        }
        $scope.showFeedbackAide = function(){
            $scope.isOpenFeedbackAide = true;
            $scope.resetFeedbackAide();
            $scope.feedbackAideListLoad(0);
        }
        $scope.hideFeedbackAide = function(){
            $scope.isOpenFeedbackAide = false;
            $scope.resetFeedbackAide();
        }
        $scope.btnOtherWords = function(idx){
            $scope.sendTrackFeedbakaide('OTHER WORDS');
            $scope.feedbackAideListLoad(idx);
        }
        $scope.feedbackAideListLoad = function(idx){
            var apiPath = '';
            switch(idx){
                case 0 : apiPath = restApiSvc.apiPath.feelingWords; break;
                case 1 : apiPath = restApiSvc.apiPath.styleWords; break;
                case 2 : apiPath = restApiSvc.apiPath.contentsWords; break;
            }
            $scope.isGenerating = true;
            restApiSvc.get(apiPath).then(
                function(res){
                    $scope.isGenerating = false;
                    switch(idx){
                        case 0 :
                            $scope.feedbackAideLists[idx] = res.data.data;
                            break;
                        case 1 :
                            $scope.feedbackAideLists[idx] = res.data.data;
                            break;
                        case 2 :
                            $scope.feedbackAideLists[idx] = res.data.data;
                            break;
                    }
                    if(idx > $scope.feedbackAideStep){
                        $scope.feedbackAideStep = idx;
                    }
                },function(res, status){
                    $scope.isGenerating = false;
                }
            );
        }
        $scope.selectWord = function(stepIdx, wordIdx){
            if(stepIdx >= $scope.feedbackAideStep){
                $scope.selectedFeedbackAideIdxs[stepIdx] = wordIdx;
                if(stepIdx < $scope.feedbackAideLastStep){
                    $scope.feedbackAideListLoad(stepIdx+1);
                }else{
                    $scope.generateSentence();
                }
            }else{
                $scope.feedbackAideStep = stepIdx;
                $scope.selectedFeedbackAideIdxs.splice(stepIdx);
                angular.forEach($scope.feedbackAideLists, function(val, idx){
                    if(idx > stepIdx) val.length = 0;
                });
            }
            
        }
        $scope.generateSentence = function(){
            var params = {
                feeling: $scope.feedbackAideLists[0][$scope.selectedFeedbackAideIdxs[0]],
                style: $scope.feedbackAideLists[1][$scope.selectedFeedbackAideIdxs[1]],
                contents: $scope.feedbackAideLists[2][$scope.selectedFeedbackAideIdxs[2]]
            };
            $scope.isGenerating = true;
            restApiSvc.get(restApiSvc.apiPath.combinedSentence, params).then(
                function(res){
                    $scope.isGenerating = false;
                    $scope.isOpenFeedbackAide = false;
                    $scope.generateComplete = true;
                    $scope.feedback = res.data.data;
                },function(res, status){
                    $scope.isGenerating = false;
                }
            );
        }
        $scope.regenerate = function(){
            $scope.sendTrackFeedbakaide('REGENERATE');
            $scope.generateSentence();
        }
        $scope.resetFeedbackAide = function(){
            $scope.feedbackAideStep = 0;
            $scope.generateComplete = false;
            $scope.selectedFeedbackAideIdxs.length = 0;
            angular.forEach($scope.feedbackAideLists, function(val, idx){
                if(idx >= 1) val.length = 0;
            });
        }
        
        $scope.addFeedback = function(feedback){
            if($scope.isLogin){
                if(feedback.length <= 0) return;
                blockUI.start();
                angular.forEach($scope.selectedNewFeedbackMentions, function(val, idx){
                    var mention = val.username;
                    var id = val.id;
                    if(mention != undefined){
                        feedback = feedback.replace(new RegExp('@'+mention, 'g'), '{{'+id+':'+mention+'}}');
                    }
                });
                
                var params = {
                    'message': feedback
                };
                restApiSvc.post(restApiSvc.apiPath.addFeedback($scope.detailData.id), params).then(
                    function(res){
                        blockUI.stop();
                        var tempList = $scope.setFeedbackList([res.data.data]);
                        $scope.feedbackLists = tempList.concat($scope.feedbackLists);
                        angular.forEach($scope.feedbackLists, function(val, idx){
                            val.commentIdx = idx;
                        });
                        $scope.detailData.feedbackCount++;
                        $scope.setDetailData();
                        
                        $scope.feedback = "";
                        $scope.resetFeedbackAide();
                        $scope.selectedNewFeedbackMentions.length = 0;
                        if($scope.isOpenFeedbackAide){
                            $scope.hideFeedbackAide();
                        }
                    },function(res, status){
                        blockUI.stop();
                    }
                );
            }else{
                $scope.openAccount();
            }
        };
        
        $scope.feedbackEditMenuHandler = function(idx, commentIdx, feedbackId){
            $mdMenu.hide();
            switch(idx){
                case 0 :
                    /** feedback edit   */
                    $scope.openEditFeedback(commentIdx, feedbackId);
                    break;
                case 1 :
                    /** feedback delete */
                    dialogSvc.confirmDialog(dialogSvc.confirmDialogType.delete, function(answer){
                        if(answer == 'yes'){
                            blockUI.start();
                            dialogSvc.closeConfirm();
                            restApiSvc.delete(restApiSvc.apiPath.deleteFeedback($scope.detailData.id, feedbackId)).then(
                                function(res){
                                    var params = {
                                            page: $scope.feedbackLists.length,
                                            size: 1
                                        };
                                    restApiSvc.get(restApiSvc.apiPath.getFeedback($scope.detailData.id), params).then(
                                        function(res){
                                            $timeout(function(){
                                                blockUI.stop();
                                                var tempList = $scope.setFeedbackList(res.data.data.content);
                                                $scope.feedbackLists.splice(commentIdx, 1);
                                                $scope.feedbackLists = $scope.feedbackLists.concat(tempList);
                                                
                                                angular.forEach($scope.feedbackLists, function(val, idx){
                                                    val.commentIdx = idx;
                                                });
                                                $scope.detailData.feedbackCount--;
                                                $scope.setDetailData();
                                            });
                                        },function(res, status){

                                        }
                                    );
                                },function(res, status){
                                    blockUI.stop();
                                }
                            );
                        }else{
                            dialogSvc.closeConfirm();
                        }
                    });
                    break;
            }
        };
        
        $scope.openEditFeedback = function(commentIdx, feedbackId){
            angular.forEach($scope.feedbackLists, function(val, idx){
                val.isEditFeedback = false;
            });
            $scope.feedbackLists[commentIdx].isEditFeedback = true;
            $scope.editFeedback = $scope.feedbackLists[commentIdx].message;
            
            var reg = /{{(\d+):(.*?)}}/ig;
            var mentions = $scope.editFeedback.match(reg);
            if(mentions != null){
                angular.forEach(mentions, function(mentionVal, idx){
                    var id = mentionVal.replace(reg, '$1');
                    var username = mentionVal.replace(reg, '$2');
                    $scope.selectedEditFeedbackMentions.push({id:id, username:username});
                    $scope.editFeedback = $scope.editFeedback.replace(mentionVal, '@'+username);
                });
            }else{
                $scope.selectedEditFeedbackMentions.length = 0;
            }
        }
        $scope.editFeedbackCancel = function(commentIdx){
            $scope.feedbackLists[commentIdx].isEditFeedback = false;
        }
        $scope.updateFeedback = function(feedbackId, editFeedback, editFeedbackIdx){
            blockUI.start();
            angular.forEach($scope.selectedEditFeedbackMentions, function(val, idx){
                var mention = val.username;
                var id = val.id;
                if(mention != undefined){
                    editFeedback = editFeedback.replace(new RegExp('@'+mention, 'g'), '{{'+id+':'+mention+'}}');
                }
            });
            
            var params = {
                'message': editFeedback
            };
            restApiSvc.post(restApiSvc.apiPath.updateFeedback($scope.detailData.id, feedbackId), params).then(
                function(res){
                    blockUI.stop();
                    var tempList = $scope.setFeedbackList([res.data.data]);
                    $scope.feedbackLists[editFeedbackIdx] = tempList[0];
                    
                    angular.forEach($scope.feedbackLists, function(val, idx){
                        val.commentIdx = idx;
                    });
                    $scope.setDetailData();
                },function(res, status){
                    blockUI.stop();
                }
            );
        };
        
        $scope.getDetailData = function(){
            $q.all([
                restApiSvc.get($scope.detailApiPath),
                restApiSvc.get(restApiSvc.apiPath.getFeedback($scope.detailData.id))
            ]).then(
                function(res){
                    blockUI.stop();
                    $scope.detailData = res[0].data.data;
                    $scope.feedbackLists = res[1].data.data.content;
                    $scope.setDetailData();
                },function(res, status){
                    
                }
            );
        };
        $scope.deleteDetailData = function(){
            restApiSvc.delete(restApiSvc.apiPath.deleteWork($scope.detailData.id)).then(
                function(res){
                    blockUI.stop();
                    $window.history.back();
//                    $state.go($rootScope.actualState, {}, {reload: true});
                },function(res, status){
                    blockUI.stop();
                }
            );
        };
        $scope.setDetailData = function(){
            $scope.isLogin = authSvc.isLogin();
            if($scope.isLogin){
                $scope.myId = authSvc.getUserInfo().id;
            }else{
                $scope.myId = null;
            }
            
            $scope.detailData.convertedDate = timeSvc.getDate($scope.detailData.createdDate);
            $scope.detailData.convertedLikeCount = $scope.detailData.likeCount;
            if($scope.detailData.convertedLikeCount > 999){
                $scope.detailData.convertedLikeCount = '999+';
            }
            
            $scope.detailData.convertedFeedbackCount = $scope.detailData.feedbackCount;
            if($scope.detailData.convertedFeedbackCount > 999){
                $scope.detailData.convertedFeedbackCount = '999+';
            }
            
            if($scope.detailData.type == 'WORK_IMAGE'){
                /** convert edition */
                if(parseInt($scope.detailData.edition) > 0){
                    var edition = $scope.detailData.edition;
                    $scope.detailData.convertedEdition = 'EDITION NUMBER ' + edition;
                }
                /** convert size    */
                var sizeTempArr = [];
                var width = Number($scope.detailData.width);
                var height = Number($scope.detailData.height);
                var depth = Number($scope.detailData.depth);
                var sizeUnit = $scope.detailData.sizeUnit;
                if(width && width > 0) sizeTempArr.push(width + '(W)');
                if(height && height > 0) sizeTempArr.push(height + '(H)');
                if(depth && depth > 0) sizeTempArr.push(depth + '(D)');
                if(sizeTempArr.length >= 2){
                    var convertedSize = '';
                    angular.forEach(sizeTempArr, function(val, idx){
                        if(idx > 0){
                            convertedSize += (' x ' + val);
                        }else{
                            convertedSize += val;
                        }
                    });
                    convertedSize += (' ' + sizeUnit);
                    $scope.detailData.convertedSize = convertedSize;
                }else{
                    $scope.detailData.convertedSize = '';
                }
            }else if($scope.detailData.type == 'WORK_VIDEO'){
                var videoUrl = $scope.detailData.video_url + '?loop=1&rel=0&html5=1&wmode=opaque';
                $scope.detailData.validVideoUrl = $sce.trustAsResourceUrl(videoUrl);
                $scope.detailData.convertedDuration = timeSvc.getDuration($scope.detailData.duration);
            }
            
            if($scope.isLogin){
                $scope.isCurator = authSvc.getUserInfo().curated;
            }
        };
        $scope.setFeedbackList = function(tempList){
            angular.forEach(tempList, function(val, idx){
                val.convertedMessage = val.message;
                val.convertedMessage = val.convertedMessage.replace(/</g, "&lt;");
                val.convertedMessage = val.convertedMessage.replace(/>/g, "&gt;");
                val.convertedMessage = val.convertedMessage.replace(/\//g, "&#47;");
                var reg = /{{(\d+):(.*?)}}/ig;
                var mentions = val.convertedMessage.match(reg);
                if(mentions != null){
                    angular.forEach(mentions, function(mentionVal, idx){
                        var id = mentionVal.replace(reg, '$1');
                        var name = '@' + mentionVal.replace(reg, '$2');
                        id = id.replace(/"/g, "'");
                        name = name.replace(/"/g, "'");
                        var tag = '<a title="'+name+'" href="/#/profile/'+id+'/works">'+name+'</a>';
                        val.convertedMessage = val.convertedMessage.replace(mentionVal, tag);
                    });
                }
                
                val.convertedDate = timeSvc.getDate(val.createdDate);
                val.isEditFeedback = false;
                val.commentIdx = idx;
                if($scope.isLogin){
                    if($scope.myId == val.createdBy.id){
                        val.isMe = true;
                    }else{
                        val.isMe = false;
                    }
                }else{
                    val.isMe = false;
                }
            });
            
            return tempList;
        }
        
        $scope.openCuratorPick = function(){
            if($scope.detailData.picked){
                dialogSvc.confirmDialog(dialogSvc.confirmDialogType.curatorPicked, function(answer){
                    dialogSvc.closeConfirm();
                });
            }else{
                var src = $scope.detailData.attachments[0].thumbnail.medium;
                src = src.replace('http://cdn6.bbuzzart.com/', 'http://bbuzzart-images.s3.amazonaws.com/');
                dialogSvc.openCuratorPick({
                    imgUrl: src,
                    imgWidth: $scope.detailData.attachments[0].width,
                    imgHeight: $scope.detailData.attachments[0].height,
                    artworkId: $scope.detailData.id
                });
            }
        };
        
        $scope.openMenu = function($mdOpenMenu, e){
            $mdOpenMenu(e);
        };
        
        $scope.openAccount = function(){
            dialogSvc.openAccount();
        }
        
        $scope.participationWorksLoaded = function(idx){
            $scope.participationWorksResize();
        }
        $scope.participationWorksResize = function(){
            var listWidth = $('.participation-works li').eq(0).width();
            angular.forEach($scope.detailData.participationWorks, function(val, idx){
                $('.participation-works li').eq(idx).css({'height': listWidth + 'px'});
                
                var target = $('.participation-works li img').eq(idx);
                if($('.participation-works li img')[idx] != undefined){
                    var imgWidth = $('.participation-works li img')[idx].naturalWidth,
                        imgHeight = $('.participation-works li img')[idx].naturalHeight;
                    if(imgWidth > imgHeight){
                        target.css({
                            'height': listWidth,
                            'margin-left': (listWidth - target.width())/2 + 'px'
                        });
                    }else if(imgWidth < imgHeight){
                        target.css({
                            'width': listWidth,
                            'margin-top': (listWidth - target.height())/2 + 'px'
                        });
                    }
                }
                
            });
        }
        
        $scope.sendTrackDetail = function(action){
            var category = '';
            switch($scope.detailData.type){
                case 'WORK_IMAGE':
                    category = 'IMAGE DETAIL';
                    break;
                case 'WORK_VIDEO':
                    category = 'VIDEO DETAIL';
                    break;
                case 'WORK_WRITING':
                    category = 'WRITING DETAIL';
                    break;
                case 'WORK_SHOW':
                    category = 'SHOW DETAIL';
                    break;
            }
            trackerSvc.eventTrack(action, {category:category});
        }
        $scope.sendTrackFeedbakaide = function(action){
            trackerSvc.eventTrack(action, {category:'FEEDBACK AIDE'});
        }
        
        $scope.detailResize = function(){
            var wWidth = angular.element($window).width();
            var tempViewType = $scope.isMobileView;
            
            if(wWidth > 999){
                $scope.isMobileView = false;
                if(!$scope.isMobile){
                    $('.detail-wrap .detail-scroll-wrap').mCustomScrollbar("destroy");
                }
            }else{
                $scope.isMobileView = true;
                if(!$scope.isMobile){
                    $('.detail-wrap .detail-scroll-wrap').mCustomScrollbar($scope.mobileScrollBarOptions);
                }
            }
            
            if($scope.detailData.type == 'WORK_SHOW'){
                $scope.participationWorksResize();
            }
            
            if(!$scope.isMobileView){
                if(!$scope.isMobile){
                    $('.detail-wrap .content-detail').mCustomScrollbar($scope.scrollbarsConfig);
                    $('.detail-wrap .feedback-lists-contents').mCustomScrollbar($scope.feedbackScrollbarsConfig);
                    if($scope.detailData.type == 'WORK_IMAGE'){
                        $('.detail-wrap .scroll-info-wrap').mCustomScrollbar('update');
                        $('.detail-info-wrap .scroll-info-wrap').css({
                            'width': $('.content-detail').width()
                        });
                    }
                }

                if(tempViewType){
                    $scope.detailScrollTop = 0;
                    $scope.detailInfoResize();
                }

                $scope.toggleDetailInfo();
                
            }else{
                if(!$scope.isMobile){
                    $('.detail-wrap .content-detail').mCustomScrollbar('destroy');
                    $('.detail-wrap .feedback-lists-contents').mCustomScrollbar('destroy');
//                        $('.detail-wrap .scroll-info-wrap').mCustomScrollbar('disable', true);
                }
                
                if($scope.detailData.type == 'WORK_IMAGE'){
                    $scope.isOpenDetailInfo = false;
                    $('.detail-info-wrap').removeAttr('style');
                    $('.detail-info-wrap .scroll-info-wrap').css({'width':'auto'}).removeClass('fold fold-open');
                }
            }
        }
        
        $scope.detailInfoResize = function(){
            $timeout(function(){
                var infoHeight = $('.detail-info-wrap .scroll-info-wrap .detail-info').outerHeight();
                $('.detail-info-wrap').css({
                    height: infoHeight + 1
                });
                $('.detail-info-wrap .scroll-info-wrap').css({
                    height: infoHeight + 1
                });
            });
        }
        $scope.$watch(function(){
            return $('.detail-info-wrap .scroll-info-wrap .detail-info').outerHeight();
        }, function(newVal, oldVal){
            $scope.detailInfoResize();
        });
        
        $scope.$watch(function(){
            return angular.element($window).width();
        }, function(newVal, oldVal){
            $scope.detailResize();
        });
        $scope.$watch(function(){
            return angular.element($window).height();
        }, function(newVal, oldVal){
            $scope.detailResize();
        });
        
        /** initialize  */
        var ua = navigator.userAgent.toLowerCase();
        if(ua.indexOf('safari') > -1){
            $('.feedback-lists-contents').css({
                '-webkit-flex': 1,
                '-ms-flex': 1,
                'flex': 1
            })
        }
        var hostname = location.href;
        switch($scope.detailData.type){
            case 'WORK_IMAGE':
                $scope.detailApiPath = restApiSvc.apiPath.getDetailImage($scope.detailData.id);
                if (hostname.indexOf('WORK_IMAGE') > -1) {
                    hostname = hostname.replace('WORK_IMAGE', 'art');
                    location.replace(hostname);
                }
                break;
            case 'WORK_VIDEO':
                $scope.detailApiPath = restApiSvc.apiPath.getDetailVideo($scope.detailData.id);
                if (hostname.indexOf('WORK_VIDEO') > -1) {
                    hostname = hostname.replace('WORK_VIDEO', 'video');
                    location.replace(hostname);
                }
                break;
            case 'WORK_WRITING':
                $scope.detailApiPath = restApiSvc.apiPath.getDetailWriting($scope.detailData.id);
                if (hostname.indexOf('WORK_WRITING') > -1) {
                    hostname = hostname.replace('WORK_WRITING', 'writing');
                    location.replace(hostname);
                }
                break;
            case 'WORK_SHOW':
                $scope.detailApiPath = restApiSvc.apiPath.getDetailShow($scope.detailData.id);
                if (hostname.indexOf('WORK_SHOW') > -1) {
                    hostname = hostname.replace('WORK_SHOW', 'show');
                    location.replace(hostname);
                }
                break;
        };
        if($scope.isMobile){
            $timeout(function(){
                $('.content-detail').mCustomScrollbar("destroy");
                $('.feedback-lists-contents').mCustomScrollbar("destroy");
                $('.scroll-info-wrap').mCustomScrollbar("destroy");
                $('.feedback-lists').css({display:'block'});
                window.scrollTo(0,0);
            });
        }else{
            if($scope.detailData.type != 'WORK_IMAGE'){
                $timeout(function(){
                    $('.scroll-info-wrap').mCustomScrollbar("destroy");
                });
            };
        };
        $scope.setDetailData();
        $scope.feedbackLists = $scope.setFeedbackList(initData.feedbackLists);
        $timeout(function(){
            $scope.detailResize();
        });
        imgLoadSvc.load($scope.detailData.attachments[0].thumbnail.medium, function(src){
            $timeout(function(){
                $scope.thumbnailUrl = src;
                $timeout(function(){
//                    var thumbnailHeight = $('.content-thumbnail').height() + $('.creator-info').outerHeight();
//                    /** init detail fold-open   */
//                    if(angular.element($window).height() >= $scope.minWindowHeight && 
//                       thumbnailHeight > $('.content-detail').height() && 
//                       $scope.detailData.type == 'WORK_IMAGE'){
//                        $scope.isOpenDetailInfo = true;
//                        $scope.toggleDetailInfo();
//                        $('.scroll-info-wrap').removeClass('fold').addClass('fold-open').css({'max-height': $('.content-detail').height()});
//                    }
                    
                    $scope.detailResize();
//                    $scope.toggleDetailInfo();
                }, 33);
            },350);
        });
        if($scope.detailData.inputFeed){
            $timeout(function(){
                $scope.focusInputFeedback();
            });
        };
        
    }]);

})(angular);
