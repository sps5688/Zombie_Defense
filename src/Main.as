package {
	import flash.display.Sprite;
	import flash.display.TriangleCulling;
	import flash.events.Event;
	import code.Tile;
	
	public class Main extends Sprite {
		
		public function Main():void  {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void  {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			// Create board
			var b:Board = new Board();
			
			// Create zombies
			for (var i:Number = 0; i < 2; i++) {
				b.addZombie(i);
			}
			
			// Check for path for Zombies
			b.moveZombies();
			b.moveZombies();
		}
		
	}
	
}