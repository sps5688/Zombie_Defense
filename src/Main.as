package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import game.Gameplay;
	import lib.LayerManager;
	import lib.Global;
	
	/**
	 * ...
	 * @author Brett Slabaugh
	 */
	[SWF(backgroundColor="0x000000", width="700", height="700")]
	public class Main extends Sprite 
	{
		private var theGame:Gameplay;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			LayerManager.init(stage);
			LayerManager.addLayer(Global.LAYER_BG);
			LayerManager.addLayer(Global.LAYER_FG);
			LayerManager.addLayer(Global.LAYER_ENTITIES);
			LayerManager.addLayer(Global.LAYER_OVERLAY);
			
			//title screen stuff will go here
			//BGChannel = SFX.BG_MUSIC.play(0, 99999); // once we get the sound object into swc, use this and SFX class
			
			theGame = new Gameplay(); //main game functionality
			theGame.init();
		}
		
	}
	
}