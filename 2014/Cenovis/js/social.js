function shareOnFacebook(){
	var url = "http://www.thereallifecompany.co.kr/festival/";
	var text = "AIA REAL LIFE: NOW FESTIVAL 2014 레이디 가가, YG 패밀리 등 국내외 최정상 아티스트를 한자리에서 만나는 유일한 기회";
//	sendTracking("share_facebook", "click");
	window.open("http://www.facebook.com/sharer/sharer.php?u=" + encodeURIComponent(url) + "&t=" + encodeURIComponent(text));
}
function shareOnTwitter(){
	var url = "http://www.thereallifecompany.co.kr/festival";
	var text = "레이디 가가, YG 패밀리 등 국내외 최정상 아티스트가 한자리에 AIA REAL LIFE: NOW FESTIVAL 2014";
//	sendTracking("share_twitter", "click");
	window.open("http://twitter.com/intent/tweet?url=" + encodeURIComponent(url) + "&text=" + encodeURIComponent(text));
}