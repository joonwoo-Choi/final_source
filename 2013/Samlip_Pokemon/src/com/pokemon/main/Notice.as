package com.pokemon.main
{
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.pokemon.event.PokemonEvent;
	import com.pokemon.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class Notice
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		
		private var $noticeLength:int;
		
		private var $itemLength:int = 3;
		
		public function Notice(con:MovieClip)
		{
			$con = con;
			
			$model = Model.getInstance();
			$model.addEventListener(PokemonEvent.POKEMON_XML_LOADED, settingBanner);
			
			$con.mcMask.width = 0;
		}
		
		protected function settingBanner(e:Event):void
		{
			$noticeLength = $model.pokemonXml.info1.children().length();
			
			var checkNum:int;
			while (checkNum < $noticeLength)
			{
				var item:MovieClip = $con.getChildByName("item" + checkNum) as MovieClip;
				item.title.text = $model.pokemonXml.info1.children()[checkNum].title;
				item.date.text = $model.pokemonXml.info1.children()[checkNum].date;
				item.alpha = 1;
				item.no = checkNum;
				item.buttonMode = true;
				item.addEventListener(MouseEvent.CLICK, noticeItemHandler);
				
				checkNum++;
				if(checkNum >= $itemLength) break;
			}
			
			$con.btnMore.buttonMode = true;
			$con.btnMore.addEventListener(MouseEvent.CLICK, noticeMore);
			
			TweenLite.to($con.mcMask, 1, {width:290, ease:Cubic.easeOut});
		}
		
		private function noticeItemHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			navigateToURL(new URLRequest($model.defaulfPath + $model.pokemonXml.info1.children()[target.no].link), "_self");
		}
		
		private function noticeMore(e:MouseEvent):void
		{
			navigateToURL(new URLRequest($model.defaulfPath + $model.pokemonXml.info1.@more), "_self");
		}
	}
}