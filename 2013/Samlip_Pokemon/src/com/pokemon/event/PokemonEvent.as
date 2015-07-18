package com.pokemon.event
{
	
	import flash.events.Event;
	
	public class PokemonEvent extends Event
	{
		
		/**	포켓몬 XML 로드 완료	*/
		public static const POKEMON_XML_LOADED:String = "pokemonXmlLoaded";
		
		public function PokemonEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}