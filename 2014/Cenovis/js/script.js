var currentPage = 1;


$(document).ready( function(){
	pageOpen(1);

	$(".mainMenu").css({height:$(document).height()});
	$(".subMenu").css({height:$(document).height()});

	$(window).resize(function(){	
		$(".mainMenu").css({height:$(document).height()});
		$(".subMenu").css({height:$(document).height()});
	});
/*
	$(".prodList li").click(function(){
		$(".prodList li").removeClass("on");
		$(this).addClass("on");
	});
*/
});

// ������ ���
function PageMotion( val ){
	switch(val){
		case 1:
			window.setInterval( Motiioninterval1,1500); 
			break;
		case 2:
			break;
		case 3:
			break;
		case 4:
			break;
		case 5:
			break;
		default:
			break;
	}
}

// ������ �ʱ�ȭ
function reset(){}

// ������ ���� �Լ�
function pageOpen(val ) {
	// ����޴��� ��� �� Ʈ��ŷ........!!!
	$(".prev, .next").show();
	switch(val){
		case 1:
			$(".prev").hide();
			break;
		case 2:
			break;
		case 3: 
			break;
		case 4: 
			break;
		case 5: 
			$(".next").hide();
			break;
		default:
			break;
	}

	// ������ �ʱ�ȭ
	 reset();
	
	if (val != currentPage) {
		var $list = $(".contents #page" +currentPage);

		if ( val > currentPage ) {
			var $item = $("#page"+val).show().addClass("nextPage"); 

			$list.css({left:0}).animate({ left: "-100%" }, 500);

			$item.css({left:"100%"}).animate({ left: 0 }, 500, function () {
				$list.hide().removeClass("currentPage");
				$item.removeClass("nextPage").addClass("currentPage");
			});

			currentPage = val;

		} else if ( val < currentPage ) {
			var $item = $("#page"+val).show().addClass("prevPage");

			$item.css({left:"-100%"}).animate({ left: 0 }, 500);

			$list.css({left:0}).animate({ left: "100%" }, 500, function () {
				$list.hide().removeClass("currentPage");
				$item.removeClass("prevPage").addClass("currentPage");
			});

			currentPage = val;
		}

		 showNavi();
	}

	window.clearInterval( Motiioninterval1 );
	PageMotion(currentPage);


	
}

// Main ���͹� �Լ�
function Motiioninterval1(){
	/* ����
	$(".page0 .item1").animate({marginTop:"-10px"}, 800, function(){
		$(".page0 .item1").animate({marginTop:"10px"}, 500);
	});
	*/
}

/* �׺���̼� ON/OFF
function showNavi() {
	$(".nav li.on").removeClass("on").addClass("off");
	if ( currentPage > 0) {
		$(".nav li:eq(" + (currentPage-1) + ")").removeClass("off").addClass("on");
	}
}*/

// ���� ������ �̵�
function showPrev() {
	if( currentPage > 1 )
		pageOpen( currentPage-1 );
	else
		pageOpen( $(".page").size() );
}

// ���� ������ �̵�
function showNext() {
	if( currentPage < $(".page").size() )
		pageOpen( currentPage+1 );
	else
		pageOpen( 1 );
}


/* �׺���̼� */
function mainNav(depth1){
	$(".mainMenu .gnb li").removeClass("on");
	$(".mainMenu .gnb li:eq("+(depth1-1)+")").addClass("on");

	TweenLite.to( $(".subMenu"), 0.4, {left:50});
	TweenLite.to( $(".container"), 0.4, {marginLeft:190});

	TweenLite.to( $(".subMenu"), 0.5, { delay:0.5, left:190,  ease:"Cubic.easeOut"});
	TweenLite.to( $(".container"), 0.5, {delay:0.5, marginLeft:330,  ease:"Cubic.easeOut"});

	$(".subNav").hide();
	$("#subNav"+depth1).show();

	$(".subNav li").removeClass("on");
	$("#subNav"+ depth1+" li:eq(0)").addClass("on");

}

function subNav(depth1, depth2) {
	$(".mainMenu .gnb li").removeClass("on");
	$(".mainMenu .gnb li:eq("+(depth1-1)+")").addClass("on");

	$(".subNav li").removeClass("on");
	$("#subNav"+ depth1+" li:eq("+(depth2-1)+")").addClass("on");
}

/* �Ǹ޴� */
function TabMenu(mId, idx){
	$(mId + " #tabBoard li").removeClass("on");
	$(mId + " #tabBoard li:eq("+(idx-1)+")").addClass("on");
	
	$(mId + " .tabBoard_sub").hide();
	$(mId + " #tabBoard_sub"+idx).show();
}

/* ����Ʈ �޴� */
function SelectMenu(depth1){
	$(".prodTab>li").removeClass("on");
	$(".prodTab>li:eq("+(depth1-1)+")").addClass("on");

	TweenLite.to( $(".prodList"), .5, { opacity:0, height:0, ease:"Cubic.easeOut"});
	TweenLite.to( $("#prodList"+depth1), 1, { delay:0.5, opacity:1, height:405, ease:"Cubic.easeOut"});

}

function OptionMenu(depth1, depth2){
	$(".prodList li").removeClass("on");
	$("#prodList"+depth1+" li:eq("+depth2+")").addClass("on");


	TweenLite.to( $(".prodList"), .5, { opacity:0, height:0, ease:"Cubic.easeOut"});
//	TweenLite.to( $("#prodList"+depth1), 1, { delay:0.5, opacity:1, height:405, ease:"Cubic.easeOut"});

}

