package com.adqua.templete.moviePlayer.ctrler
{
	import com.adqua.templete.moviePlayer.ModelPlayer;
	import com.adqua.util.Atracer;

	public class CtlerVideoSet extends Ctrler
	{
		public function CtlerVideoSet()
		{
		}
		public function setting0() {
			Atracer.alert("setting0");
			_model.objs=[];
			_model.objs=new Array("ply","sek","vol","rez","ful","hdv","bri","txt");
			
			_model.autoHide=_model.autoHideF=true;
			_model.vidFixSiz=false;
			
			_model.vidWidF=0;
			_model.vidHig=45;
			
			_model.vidBr=5;
			_model.vidMrg=10;
			_model.vidVMrg=15;
			_model.vidCorRad=10;
			_model.vidCol= "0xffffff";
			_model.vidBrCol= "0x000000";
			_model.vidBgTra=.5;
			_model.vidBrTra=.4;
			_model.vidTimAlignB=true;
			_model.skinType=0;
			_model.vidOvrLayCol= "0xffffff";
			_model.vidOvrLayTra=1;
			_model.shadowAlpha=.6;
			_model.vidSekBarCol= "0x000000";
			
			_model.btnWid=50;
			_model.sekHig=4;
			_model.volWid = 76;
			_model.btnOvrCol="0xf68e56";
			_model.btnSprCol="0x000000";
			_model.icoCol="0x000000";
			_model.icoSiz=1;
			
		}
		
		public function setting2() {
			
			
			_model.objs=[];
			_model.objs=new Array("ply","sek","vol","rez","ful","hdv","bri","txt");
			
			_model.autoHide=_model.autoHideF=true;
			_model.vidFixSiz=false;
			
			_model.vidWidF=0;
			_model.vidHig=35;
			
			_model.vidBr=0;
			_model.vidMrg=0;
			_model.vidVMrg=1;
			_model.vidCorRad=0;
			_model.vidCol= "0x000000";
			_model.vidBrCol= "0x000000";
			_model.vidBgTra=.75;
			_model.vidBrTra=0;
			_model.vidTimAlignB=false;
			_model.skinType=1;
			_model.vidOvrLayCol= "0xffffff";
			_model.vidOvrLayTra=0;
			_model.shadowAlpha=1;
			_model.vidSekBarCol= "0xFF9933";
			
			_model.btnWid=40;
			
			_model.sekHig=2;
			_model.volWid = 76;
			_model.btnOvrCol="0x555555";
			_model.btnSprCol="0xffffff";
			_model.icoCol="0xffffff";
			_model.icoSiz=.5;
			
		}
		
		public function setting1() {
			Atracer.alert("setting1");
			_model.objs=[];
			_model.objs=new Array("ply","sek","vol","txt","rez","ful","bri");
			
			_model.autoHide=_model.autoHideF=true;
			_model.vidFixSiz=false;
			
			_model.vidWidF=0;
			_model.vidHig=35;
			
			_model.vidBr=3;
			_model.vidMrg=10;
			_model.vidVMrg=15;
			_model.vidCorRad=5;
			_model.vidCol= "0xffffff";
			_model.vidBrCol= "0x000000";
			_model.vidBgTra=.75;
			_model.vidBrTra=.3;
			_model.vidTimAlignB=false;
			_model.skinType=1;
			_model.vidOvrLayCol= "0x000000";
			_model.vidOvrLayTra=.5;
			_model.shadowAlpha=.5;
			_model.vidSekBarCol= "0xFF9933";
			
			_model.btnWid=40;
			
			_model.sekHig=2;
			_model.volWid = 76;
			_model.btnOvrCol="0xFFFFFF";
			_model.btnSprCol="0x000000";
			_model.icoCol="0x000000";
			_model.icoSiz=.5;
			
		}
		
		public function setting3() {
			
			_model.objs=[];
			_model.objs=new Array("ply","sek","vol","txt","rez","ful","bri");
			
			_model.autoHide=_model.autoHideF=true;
			_model.vidFixSiz=false;
			
			_model.vidWidF=0;
			_model.vidHig=35;
			
			_model.vidBr=1;
			_model.vidMrg=10;
			_model.vidVMrg=10;
			_model.vidCorRad=35;
			_model.vidCol= "0xffffff";
			_model.vidBrCol= "0xFFFFFF";
			_model.vidBgTra=.5;
			_model.vidBrTra=0;
			_model.vidTimAlignB=false;
			_model.skinType=0;
			_model.vidOvrLayCol= "0xFEC289";
			_model.vidOvrLayTra=.7;
			_model.shadowAlpha=0;
			_model.vidSekBarCol= "0xFF9933";
			
			_model.btnWid=40;
			_model.sekHig=2;
			_model.volWid = 76;
			_model.btnOvrCol="0xFFFFFF";
			_model.btnSprCol="";
			_model.icoCol="0x000000";
			_model.icoSiz=.5;
			
		}
		
		public function setting4() {
			
			_model.objs=[];
			_model.objs=new Array("ply","sek","vol","txt","ful");
			
			_model.autoHide=_model.autoHideF=true;
			_model.vidFixSizF=_model.vidFixSiz=true;
			
			_model.vidWidF=550;
			_model.vidHig=38;
			
			_model.vidBr=1;
			_model.vidMrg=10;
			_model.vidVMrg=15;
			_model.vidCorRad=17;
			_model.vidCol= "0xffffff";
			_model.vidBrCol= "0xFFFFFF";
			_model.vidBgTra=.5;
			_model.vidBrTra=0;
			_model.vidTimAlignB=false;
			_model.skinType=0;
			_model.vidOvrLayCol= "0xFFFFFF";
			_model.vidOvrLayTra=.7;
			_model.shadowAlpha=1;
			_model.vidSekBarCol= "0x332222";
			
			_model.btnWid=50;
			
			_model.sekHig=6;
			_model.volWid = 76;
			_model.btnOvrCol="0xFFFFFF";
			_model.btnSprCol="0x666666";
			_model.icoCol="0x332222";
			_model.icoSiz=.5;
			
		}
		
		public function setting5() {
			
			_model.objs=[];
			_model.objs=new Array("ply","sek","vol","txt","rez","ful","hdv","bri");
			
			_model.autoHide=_model.autoHideF=true;
			_model.vidFixSiz=false;
			
			_model.vidWidF=0;
			_model.vidHig=35;
			
			_model.vidBr=0;
			_model.vidMrg=0;
			_model.vidVMrg=1;
			_model.vidCorRad=0;
			_model.vidCol= "0x000000";
			_model.vidBrCol= "0x000000";
			_model.vidBgTra=.75;
			_model.vidBrTra=.5;
			_model.vidTimAlignB=false;
			_model.skinType=0;
			_model.vidOvrLayCol= "0xffffff";
			_model.vidOvrLayTra=1;
			_model.shadowAlpha=1;
			_model.vidSekBarCol= "0xFF9933";
			
			_model.btnWid=40;
			_model.sekHig=2;
			_model.volWid = 76;
			_model.btnOvrCol="0x404040";
			_model.btnSprCol="0x999999";
			_model.icoCol="0xffffff";
			_model.icoSiz=.5;
		}
		
		public function setting6() {
			
			_model.objs=[];
			_model.objs=new Array("ply","sek","vol","txt","rez","ful","hdv","bri");
			
			_model.autoHide=_model.autoHideF=true;
			_model.vidFixSizF=_model.vidFixSiz=false;
			
			_model.vidWidF=0;
			_model.vidHig=35;
			
			_model.vidBr=0;
			_model.vidMrg=0;
			_model.vidVMrg=1;
			_model.vidCorRad=0;
			_model.vidCol= "0xffffff";
			_model.vidBrCol= "0x000000";
			_model.vidBgTra=1;
			_model.vidBrTra=0;
			_model.vidTimAlignB=false;
			_model.skinType=0;
			_model.vidOvrLayCol= "0x000000";
			_model.vidOvrLayTra=1;
			_model.shadowAlpha=1;
			_model.vidSekBarCol= "0x0F282F";
			
			_model.btnWid=40;
			
			_model.sekHig=2;
			_model.volWid = 76;
			_model.btnOvrCol="0xA6D6E1";
			_model.btnSprCol="";
			_model.icoCol="0x0F282F";
			_model.icoSiz=.5;
		}
		
		public function setting7() {
			
			_model.objs=[];
			_model.objs=new Array("ply","sek","vol","rez","hdv","bri","txt","ful");
			
			_model.autoHide=_model.autoHideF=true;
			_model.vidFixSiz=false;
			
			_model.vidWidF=0;
			_model.vidHig=35;
			
			_model.vidBr=0;
			_model.vidMrg=0;
			_model.vidVMrg=0;
			_model.vidCorRad=0;
			_model.vidCol= "0xFFFFFF";
			_model.vidBrCol= "0x000000";
			_model.vidBgTra=.5;
			_model.vidBrTra=0;
			_model.vidTimAlignB=false;
			_model.skinType=0;
			_model.vidOvrLayCol= "0xffffff";
			_model.vidOvrLayTra=1;
			_model.shadowAlpha=1;
			_model.vidSekBarCol= "0x000000";
			
			_model.btnWid=40;
			_model.sekHig=1;
			_model.volWid = 76;
			_model.btnOvrCol="0xFEBB77";
			_model.btnSprCol="0x000000";
			_model.icoCol="0x000000";
			_model.icoSiz=.5;
		}
		
		public function setting8() {
			
			_model.objs=[];
			_model.objs=new Array("ply","sek","vol","rez","ful","txt");
			
			_model.autoHide=_model.autoHideF=true;
			_model.vidFixSiz=true;
			
			_model.vidWidF=450;
			_model.vidHig=50;
			
			_model.vidBr=0;
			_model.vidMrg=0;
			_model.vidVMrg=20;
			_model.vidCorRad=10;
			_model.vidCol= "0x000000";
			_model.vidBrCol= "0x000000";
			_model.vidBgTra=.5;
			_model.vidBrTra=0;
			_model.vidTimAlignB=true;
			_model.skinType=0;
			_model.vidOvrLayCol= "0xffffff";
			_model.vidOvrLayTra=1;
			_model.shadowAlpha=1;
			_model.vidSekBarCol= "0xFF9933";
			
			_model.btnWid=60;
			_model.sekHig=4;
			_model.volWid = 76;
			_model.btnOvrCol="0x000000";
			_model.btnSprCol="";
			_model.icoCol="0xffffff";
			_model.icoSiz=1;
		}
		
		public function setting9() {
			_model.objs=[];
			_model.objs=new Array("ply","sek","vol","rez","ful","txt");
			
			_model.autoHide=_model.autoHideF=true;
			_model.vidFixSiz=false;
			
			_model.vidWidF=0;
			_model.vidHig=35;
			
			_model.vidBr=0;
			_model.vidMrg=0;
			_model.vidVMrg=0;
			_model.vidCorRad=0;
			_model.vidCol= "0xffffff";
			_model.vidBrCol= "0x000000";
			_model.vidBgTra=.75;
			_model.vidBrTra=.25;
			_model.vidTimAlignB=false;
			_model.skinType=1;
			_model.vidOvrLayCol= "0x000000";
			_model.vidOvrLayTra=.5;
			_model.shadowAlpha=1;
			_model.vidSekBarCol= "0xFF9933";
			
			_model.btnWid=50;
			
			_model.sekHig=1;
			_model.volWid = 76;
			_model.btnOvrCol="0xffffff";
			_model.btnSprCol="0x000000";
			_model.icoCol="0x000000";
			_model.icoSiz=.5;
		}			
	}
}