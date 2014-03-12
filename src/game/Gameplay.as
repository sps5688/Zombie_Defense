package game 
{
	import flash.display.MovieClip;
	import lib.LayerManager;
	import lib.Global;
	import game.Tile;
	import game.Zombie;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author Brett Slabaugh
	 * @author Steve Shaw
	 */
	public class Gameplay 
	{
		public static const DEBUG:Boolean = false;
		// Storage
		private var gameOver:Boolean = false;
		private var zombies:Array = new Array();
		private var board:Board;
		
		private var enemyMovementTimer:Timer = new Timer(2000);
		
		public function Gameplay() 
		{
			zombies = new Array();
		}
		
		public function moveEnemies(e:Event):void {
			// Move zombies to test path finding with tiles
			for (var i:Number = 0; i < zombies.length; i++) {
				var playerFound:Boolean = zombies[i].move(board);
				
				if (playerFound) {
					zombies.splice(i, 1);
					trace("Player has died, game over");
					gameOver = true;
					if ( DEBUG ) {
						LayerManager.stage.removeEventListener(KeyboardEvent.KEY_DOWN, moveEnemies);
					} else {
						enemyMovementTimer.stop();
						enemyMovementTimer.removeEventListener(TimerEvent.TIMER, moveEnemies);
					}
					break;
				}
			}
		}
		
		public function init():void
		{
			// init board
			board = new Board();
			
			// init zombies
			// For now, need to spawn a zombie in a static location to test pathfinding
			zombies.push(new Zombie(23, board.getPlayerTile()));
			var tile:Tile = board.getTile(23);
			tile.setZombieOn(true);
			
			// Move enemies
			if( DEBUG ) {
				LayerManager.stage.addEventListener(KeyboardEvent.KEY_DOWN, moveEnemies);
			} else {
				enemyMovementTimer.addEventListener(TimerEvent.TIMER, moveEnemies);
				enemyMovementTimer.start();
			}
		}

	}

}