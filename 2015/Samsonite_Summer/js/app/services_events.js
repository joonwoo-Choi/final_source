/**
*
*   개발 페이지
*
*/

var samsoniteAppEventsServices = angular.module("samsoniteApp.eventsServices", []);

samsoniteAppEventsServices.
factory("devSvc", [function(){
    
    var listType = "";
    
    /** 테스트용 이미지 리스트 파일 로더  */
    function getImgList(url, callback){
        $(".loader").fadeIn(350);
        $.ajax({
            type:"GET",
            url:url,
            dataType:"json",
            data:"",
            contentType:"application/json; charset=utf-8",
            success:function(data) {
                var loadedGalleryList = [];
                var dataLength;
                var loadCnt = 0;
                loadedGalleryList = data.list;
                dataLength = loadedGalleryList.length;
                
                for(var i=0; i<dataLength; i++){
                    var img = new Image();
                    if(listType=="") img.src = loadedGalleryList[i]["imageName1"];
                    else img.src = loadedGalleryList[i].src;
                    $(img).bind("load", function(){
                        loadCnt++;
                        if(loadCnt==dataLength){
                            callback(loadedGalleryList, listType);
                            listType = "";
                            $(".loader").fadeOut(350);
                        }
                    });
                }
            },
            error:function(e) {
                listType = "";
                $(".loader").fadeOut(350);
            }
        });
    }

    return {
        /** 트루컬러 페이지 유튜브 영상 공유  */
        shareYoutubeMovie: function(idx){
            /** idx -> 유튜브 영상 번호    */
            
            
        },
        /** 이미지 리스트 불러오기    */
        getFbList: function(callback){
            /** 이미지 리스트 데이터 로드 완료 시 콜백 함수에 JSON 데이터와 리스트 타입 인자값으로 넣어 호출 */
            listType = "A";
            getImgList("data/fb_list.json", callback);
        },
        getInstaList: function(callback){
            listType = "B";
            getImgList("data/insta_list.json", callback);
        },
        getPhotoList: function(callback){
            listType = "C";
            getImgList("data/photo_list.json", callback);
        },
        getGalleryList: function(callback){
            listType = "";
            getImgList("data/gallery_list.json", callback);
        },
        /** 유저가 만든 영상 저장    */
        saveUserMovie: function(makerName, imgList, callback){
            /** 
            *   감독 이름, 
            *   이미지 정보 오브젝트 배열 / imgList = [ {idx:n, src:"이미지 경로"} ]
            *   저장 완료 후 콜백함수 호출
            */
            
            callback();
        },
        /** 유저 개인정보 */
        requestCertification: function(user){
            /** user 오브젝트 (key, value)로 데이터 전달 - { user.name, user.tel1, user.confirm .. } */
        },
        inputCertification: function(user){
        },
        validateForm: function(user){
        }
    };
}]);














