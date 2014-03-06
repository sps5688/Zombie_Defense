package game 
{
	import flash.display.MovieClip;
	import lib.LayerManager;
	import lib.Global;
	import game.Tile;
	import game.Zombie;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	 * ...
	 * @author Brett Slabaugh
	 * @author Steve Shaw
	 */
	public class Gameplay 
	{
		// Storage
		private var gameOver:Boolean = false;
		private var zombies:Array = new Array();
		private var board:Board;
		
		private var enemyMovementTimer:Timer = new Timer(2000);
		
		public function Gameplay() 
		{
			zombies = new Array();
		}
		
		public function moveEnemies(e:TimerEvent):void {
			// Move zombies to test path finding with tiles
			for (var i:Number = 0; i < zombies.length; i++) {
				var playerFound:Boolean = zombies[i].move(board);
				
				if (playerFound) {
					zombies.splice(i, 1);
					trace("Player has died, game over");
					gameOver = true;
					enemyMovementTimer.stop();
					enemyMovementTimer.removeEventListener(TimerEvent.TIMER, moveEnemies);
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
			zombies.push(new Zombie(1, board.getPlayerTile()));
			
			// Move enemies
			enemyMovementTimer.addEventListener(TimerEvent.TIMER, moveEnemies);
			enemyMovementTimer.start();
		}

	}

}