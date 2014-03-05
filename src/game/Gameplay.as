package game 
{
	import flash.display.MovieClip;
	import lib.LayerManager;
	import lib.Global;
	import game.Tile;
	import game.Zombie;
	
	/**
	 * ...
	 * @author Brett Slabaugh
	 */
	public class Gameplay 
	{
		
		//storage
		private var zombies:Array;
		
		public function Gameplay() 
		{
			zombies = new Array();
		}
		
		public function init():void
		{
			buildUI();
			
			//for now, need to spawn a zombie in a static location to test pathfinding
			//ex. Zombie.spawn(0,0);
		}
		
		private function buildUI():void
		{
			//FIXME should be constants - in Tile.as?
			var margin:int = 25;
			var padding:int = 5;
			
			//build 2d array of tiles
			for (var i:int = 0; i < 5; i++)
			{
				for (var j:int = 0; j < 5; j++)
				{
					var newTile:Tile = new Tile();
					LayerManager.addToLayer(newTile, Global.LAYER_BG);
					// 90 + 130 * i;
					newTile.x = margin + newTile.width/2 + (newTile.width + padding) * i;
					newTile.y = margin + newTile.width/2 + (newTile.width + padding) * j;
				}
			}
		}
		
	}

}