var RandomText = (function() {
    
    var tf;
    /**	인수의 문자열을 담을 변수	*/
    var txt;
    /**	한 글자씩 표시하는 변수	*/
    var rightTxt;
    /**	사용 될 랜덤 텍스트	*/
    var fakeTxt = "ㄱㄴㄷㄹㅁㅂㅅㅇㅈㅊㅋㅌㅍㅎ가나다라마바사아자차카타파하거너더러머버서어저처커터퍼허고노도로모보소오조초코토포호";
    /** 글자 바뀌는 시간   */
    var changeTime = 30;
    /** 실제 글 보여주기 카운트   */
    var changeCount;
    var count = 0;
    
    /** 반대로 보이기 */
    var reverse;
    
    var isSingle;
    var timer;
    var isTweening = false;
    
    /**	시작	*/
    function start($tf, $text, $changeTime, $reverse, $changeCount) {
        isTweening = true;
        tf = $($tf);
        txt = $text;
        changeTime = $changeTime;
        reverse = $reverse;
        changeCount = $changeCount;
        
        txtNum = 0;
        rightTxt = ""; //한글자씩 대입되는 변수
        timer = setInterval(rollWord, changeTime);
    }

    /**	랜덤 글자 표시	*/
    function rollWord() {
        /**	랜덤하게 글자를 표시하는 글자수	*/
        var randomText = "";
        var randomTextNum = txt.length - rightTxt.length;
        var randNum;
        if(!isSingle){
            for (var i = 0; i < randomTextNum-1; i++) {
                randNum = Math.floor(Math.random()*fakeTxt.length);
                randomText += fakeTxt.charAt(randNum);
            }
        }else{
            randNum = Math.floor(Math.random()*fakeTxt.length);
            randomText = fakeTxt.charAt(randNum);
        }
        if(reverse) tf.text(randomText + rightTxt);
        else tf.text(rightTxt + randomText);
        
        endCheck();
    }

    /**	종료 체크	*/
    function endCheck() {
        if (txtNum != txt.length) {
            if(count >= changeCount){
                rightTxt += txt.charAt(txtNum);
                txtNum += 1;
                count = 0;
            }else{
                count++;
            }
        }
        else
        {
            /**	종료	*/
            isTweening = false;
            clearInterval(timer);
            tf.text(rightTxt);
        }
    }
    
    return {
        single: function($tf, $text, $changeTime, $reverse, $changeCount) { 
            console.log(isTweening);
            isSingle = true;
            start($tf, $text, $changeTime, $reverse, $changeCount);
        },
        full: function($tf, $text, $changeTime, $reverse, $changeCount) { 
            isSingle = false;
            start($tf, $text, $changeTime, $reverse, $changeCount);
        },
        stop: function() {
            isTweening = false;
            clearInterval(timer);
        },
        isTween: function() {
            return isTweening;
        }
    }
    
})(RandomText);

