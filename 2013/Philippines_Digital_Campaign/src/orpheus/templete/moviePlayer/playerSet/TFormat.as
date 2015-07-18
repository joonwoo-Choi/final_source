package orpheus.templete.moviePlayer.playerSet
{
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import orpheus.templete.moviePlayer.AbsrtractMCCtrler;
	import orpheus.templete.moviePlayer.MoviePlayer;
	
	public class TFormat extends AbsrtractMCCtrler
	{
		public function TFormat(mc:MoviePlayer)
		{
			super(mc);
		}
		// Set Description Text
		public function txtformat(txtMc, txt,w) {
			var textMc:*;
			_con.video_mc.desTxt.bg.height=_con.video_mc.desTxt.sh.height=0;
			textMc=_model.embedFont?txtMc.txt:txtMc.txtNonEmb;
			var myFmt:TextFormat = new TextFormat();
			myFmt.leftMargin = 5;
			myFmt.rightMargin = 5;
			textMc.y=4;
			textMc.width = w;
			textMc.wordWrap = true;
			textMc.autoSize = TextFieldAutoSize.LEFT;
			textMc.htmlText = txt;
			textMc.setTextFormat(myFmt);
			_con.video_mc.desTxt.bg.width=_con.video_mc.desTxt.sh.width=w;
			_con.video_mc.desTxt.bg.height=_con.video_mc.desTxt.sh.height=Math.round(_con.video_mc.desTxt.height+5);
			_con.video_mc.txtMsk.width=_con.video_mc.desTxt.bg.width;
			_con.video_mc.txtMsk.height=_con.video_mc.desTxt.bg.height+5;
		}		
	}
}