package orpheus.templete.moviePlayer.ctrler
{
	import flash.events.Event;
	import flash.xml.XMLDocument;
	
	import orpheus.templete.moviePlayer.AbsrtractMCCtrler;
	import orpheus.templete.moviePlayer.MoviePlayer;
	
	public class CtrlerXMLData extends AbsrtractMCCtrler
	{
		public function CtrlerXMLData(mc:MoviePlayer)
		{
			super(mc);
		}
		private var _controlXML:CtrlerVideoSetXml;		
		public function loadXmlDatas(event:Event):void {
			var xmlData:XMLDocument = new XMLDocument();
			xmlData.ignoreWhite = true;
			xmlData.parseXML(new XML(_model.xmlLoad.data).toXMLString());
			var datalist= xmlData.firstChild.attributes;
			var gallxml= xmlData.firstChild.childNodes;
			
			_controlXML = new CtrlerVideoSetXml;
			_controlXML.datalist = datalist;
			_controlXML.video_mc = _con.video_mc;
			_controlXML.setting();
			
			for (var k=0; k<gallxml.length; k++) {
				if (String(gallxml[k].localName) == "videoTitle") {
					if (_model.validate(gallxml[k].firstChild,"s")) {
						_con.video_mc.tTxt.txt.htmlText=gallxml[k].firstChild;
						_model.titleText= _con.video_mc.tTxt.txt.text;
					}
				}
				if (String(gallxml[k].localName) == "videoDescription") {
					if (_model.validate(gallxml[k].firstChild,"s")) {
						_con.video_mc.tTxt.txt.htmlText=gallxml[k].firstChild;
						_model.desText=  _con.video_mc.tTxt.txt.text;
						
					}
				}
				_con.video_mc.tTxt.txt.text="";
			}
		}		
	}
}