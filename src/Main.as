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
			for ( var i:int = 75; i <= 675; i += 150 ) {
				for ( var j:int = 75; j <= 675; j += 150 ) {
					var tile:Tile = new Tile( j % 4 == 1 );
					tile.x = i;
					tile.y = j;
					addChild( tile );
				}
			}
			
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