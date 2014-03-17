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
	import lib.PlayerClip;
	import lib.Global;
	import lib.EventUtils;
	import flash.ui.Keyboard;
	
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
		private var playerLoc:Number;
		private var playerSpeed:Number;
		private var mc_player:MovieClip;
		
		private var enemyMovementTimer:Timer = new Timer(2000);
		
		public function Gameplay() 
		{
			zombies = new Array();
		}
		
		public function moveEnemies(e:Event):void {
			// Move zombies to test path finding with tiles
			for (var i:Number = 0; i < zombies.length; i++) {
				var playerFound:Boolean = zombies[i].move(board, playerLoc);
				
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
			
			// init player
			playerLoc = 12;
			playerSpeed = 10;
			mc_player = new PlayerClip();
			mc_player.x = 90 + 130 * Board.getTileX(playerLoc);
			mc_player.y = 90 + 130 * Board.getTileY(playerLoc);
			LayerManager.addToLayer(mc_player, Global.LAYER_ENTITIES);
			
			// init controls
			EventUtils.safeAddListener(LayerManager.stage, KeyboardEvent.KEY_DOWN, onKeyDown);
			
			// init zombies
			// For now, need to spawn a zombie in a static location to test pathfinding
			zombies.push(new Zombie(23, playerLoc));
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
		
		private function onKeyDown(e:KeyboardEvent):void {
			var key:uint = e.keyCode;
			var theTile:Tile = board.getTile(playerLoc);
			if (key == Keyboard.W || key == Keyboard.UP) {
				if (board.isValidWall(playerLoc, "north")) { //edge check
					var northTile:Tile = board.getTile(playerLoc - board.getColumns());
					if (theTile.getWallHealth("north") <= 0 && northTile.getWallHealth("south") <= 0) { //is there a path
						playerLoc = playerLoc - board.getColumns();
						setPlayerLocation(playerLoc);
					}
				}
			}
			if (key == Keyboard.S || key == Keyboard.DOWN) {
				if (board.isValidWall(playerLoc, "south")) { //edge check
					var southTile:Tile = board.getTile(playerLoc + board.getColumns());
					if (theTile.getWallHealth("south") <= 0 && southTile.getWallHealth("north") <= 0) { //is there a path
						playerLoc = playerLoc + board.getColumns();
						setPlayerLocation(playerLoc);
					}
				}
			}
			if (key == Keyboard.A || key == Keyboard.LEFT) {
				if (board.isValidWall(playerLoc, "west")) { //edge check
					var westTile:Tile = board.getTile(playerLoc - 1);
					if (theTile.getWallHealth("west") <= 0 && westTile.getWallHealth("east") <= 0) { //is there a path
						playerLoc = playerLoc - 1;
						setPlayerLocation(playerLoc);
					}
				}
			}
			if (key == Keyboard.D || key == Keyboard.RIGHT) {
				if (board.isValidWall(playerLoc, "east")) { //edge check
					var eastTile:Tile = board.getTile(playerLoc + 1);
					if (theTile.getWallHealth("east") <= 0 && eastTile.getWallHealth("west") <= 0) { //is there a path
						playerLoc = playerLoc + 1;
						setPlayerLocation(playerLoc);
					}
				}
			}
		}
		
		private function setPlayerLocation(newLoc:Number):void {
			playerLoc = newLoc;
			mc_player.x = 90 + 130 * Board.getTileX(newLoc);
			mc_player.y = 90 + 130 * Board.getTileY(newLoc);
		}

	}

}