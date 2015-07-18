package contents.movie
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.XMLLoader;
	
	import event.MovieEvent;
	
	import flash.display.MovieClip;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.media.Video;
	
	import net.ConLoader;
	import net.Track;
	
	import util.BGM;
	

	/**		
	 *	SK2_Hershys :: 메인 영상 로더
	 */
	public class MovieLoader
	{
		/**	외부에서 받은 데이터 ()	*/
		private var _data:Object;
		/**	로더	*/
		private var loader:LoaderMax;
		/**	로드할 영상 내용	*/
		private var loadAry:Array;
		/**	로드된 영상	*/
		private var mcAry:Array;
		/**	xml데이터		*/
		private var xmlAry:Array;
		/**	인터렉션 그래픽경로	*/
		private var assetPath:String;
		/**	인터렉션 그래픽		*/
		private var assetMc:MovieClip;
		
		/**	영상 플레이 진행과 로드 내용이 만났을때	*/
		public var bLoadContact:Boolean;
		
		/**	생성자	*/
		public function MovieLoader(ary:Array,data:Object = null)
		{
			_data = data;
			if(_data == null) _data = new Object();
			
			loadAry = ary;
			mcAry = [];
			xmlAry = [];
			assetPath = "";
			bLoadContact = false;
			init();	
		}
		
		/**	초기화	*/
		private function init():void
		{
			
		}
		
		/**	인터렉션 그래픽 자원 로드 경로 적용	*/
		public function setAssetPath(path:String = "Asset"):void
		{	assetPath = path;	}
		
		/**	인터렉션 그래픽 자원 반환		*/
		public function getAsset():MovieClip
		{	return assetMc;	}
		
		/**	로드 시작	*/
		public function load():void
		{
			//트래킹
			Track.go("43","01");
			ConLoader.getIns().setViewLoading();
			
			loader = new LoaderMax({onComplete:onLoadComplete,onProgress:ConLoader.getIns().onProgress,auditSize:false,maxConnections:1});
			
			//인터렉션 그래픽 자원 로드
			if(assetPath != "") 
			{
				var assetURL:String = Global.getIns().rootURL+"asset/"+_data.loadPath+assetPath+".swf";
				loader.append(new SWFLoader(assetURL,{onComplete:onLoadAsset,name:"asset"+i,auditSize:false}));
			}
			
			for(var i:int = 0; i<loadAry.length; i++)
			{	//영상 로드
				var file:String = loadAry[i];
				var url:String = Global.getIns().rootURL+"asset/"+_data.loadPath+file+".swf";
				
				if(_data.loadPath == MovieEvent.Q_AND_A_PATH) url = Global.getIns().rootURL+file+".swf";
				
				var mcLoader:SWFLoader = new SWFLoader(url,{onInit:onOpenMc,onComplete:onLoad,name:"mc"+i,auditSize:false});
				
				loader.append(mcLoader);
				if(file.lastIndexOf("_Key") != -1)
				{	//인터렉션 데이터 xml데이터 로드
					var xmlURL:String = Global.getIns().rootURL+"asset/xml/"+file+".xml";
					loader.append(new XMLLoader(xmlURL,{onComplete:onLoadXML,name:"xml"+i,auditSize:false}));
				}
				
				//mcAry.push("");
				//xmlAry.push("");
			}
			
			
			loader.load();
			 
			onSndOut();
		}
		/**	소리 끄기	*/
		private function onSndOut():void
		{
			var transform:SoundTransform = SoundMixer.soundTransform;
			transform.volume = 0;
			SoundMixer.soundTransform = transform;
			
			if(Global.getIns().bgm != null)
			{
				Global.getIns().bgm.destroy();
				Global.getIns().bgm = null;
			}
		}
		/**		*/
		private function onOpenMc(e:LoaderEvent):void
		{
			var	swfLoader:SWFLoader = e.target as SWFLoader;
			var mc:MovieClip = swfLoader.rawContent as MovieClip;
//			trace(mc);
			mc.gotoAndStop(1);
		}
		/**	각각 영상 로드 완료	*/
		private function onLoad(e:LoaderEvent):void
		{
			var	swfLoader:SWFLoader = e.target as SWFLoader;
			var mc:MovieClip = swfLoader.rawContent as MovieClip;
			var str:String = swfLoader.name as String;
			var num:int = int(str.substr(2));
			
			//테스트 용 사운드 끄기
//			var transform:SoundTransform = mc.soundTransform;
//			transform.volume = 0;
//			SoundMixer.soundTransform = transform;
			
			
			mc.gotoAndStop(1);
			
			if(_data.playStage == "facebook")
			{	//페이스 북에서 볼때에만 영상 부드럽게 처리
				for(var i:int = 0; i<mc.numChildren; i++)
				{
					if(mc.getChildAt(i) is Video)
					{
						var video:Video = mc.getChildAt(i) as Video;
						video.smoothing = true;
					}
				}
			}
			
			mcAry[num] = mc;
			//mcAry.push(mc);
			var url:String = swfLoader.url;
			if(url.substr(url.length-7) != "Key.swf") xmlAry[num] = "";
			
			_data.updateMc(mcAry);
		}
		
		/**	XML데이터 로드 완료	*/
		private function onLoadXML(e:LoaderEvent):void
		{
			var	xmlLoader:XMLLoader = e.target as XMLLoader;
			var xml:XML = xmlLoader.content as XML;
			var str:String = xmlLoader.name as String;
			var num:int = int(str.substr(3));
			
			xmlAry[num] = xml;
			//xmlAry.push(xml);
			
			_data.updateXml(xmlAry);
		}
		
		/**	그래픽 자원 로드	*/
		private function onLoadAsset(e:LoaderEvent):void
		{
			var	swfLoader:SWFLoader = e.target as SWFLoader;
			assetMc = swfLoader.rawContent as MovieClip;
		}
		/**	모든 영상 로드 완료	*/
		private function onLoadComplete(e:LoaderEvent):void
		{
			ConLoader.getIns().setHideLoading();
			
			if(_data.onComplete != null) _data.onComplete(mcAry,xmlAry);
		}
		/**	소리 플레이	*/
		public function playSound():void
		{
			ConLoader.getIns().setHideLoading();
			
			var transform:SoundTransform = SoundMixer.soundTransform;
			transform.volume = Global.getIns().volum;
			SoundMixer.soundTransform = transform;
			//배경 음악 플레이
			Global.getIns().bgm = new BGM(Global.getIns().rootURL+"asset/bgm.mp3");
		}
	}//class
}//package