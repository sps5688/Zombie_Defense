package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Steve Shaw
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			// Create board
			var b:Board = new Board();
			
			// Create zombies
			for (var i:Number = 0; i < 2; i++) {
				b.addZombie(i);
			}
			
			// Move zombies until they are all dead
			while (b.getZombies() != 0) {
				b.moveZombies();
			}
		}	
		
	}
	
}