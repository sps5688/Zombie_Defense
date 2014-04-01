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
	import lib.Coin;
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
		private var player:Player;
		private var board:Board;
		private var currentLevel:Number = 1;
		
		private var enemyMovementTimer:Timer = new Timer(20);
		private var enemySpawnTimer:Timer = new Timer (15 * 1000);
		
		public function Gameplay() 
		{
		}
		
		public function moveEnemies(e:Event):void {
			if (!gameOver) {
				// Move player toward its destination tile
				player.step( board );
				if ( board.collectCoin( player.getPreviousLocation() ) ) {
					nextLevel();
				}
				
				// Move zombies to test path finding with tiles
				for (var i:Number = 0; i < zombies.length; i++) {
					var playerFound:Boolean = zombies[i].move(board);
					
					if (zombies[i].foundPlayer( player )) {
//						zombies.splice(i, 1);
						trace("Player has died, game over");
						player.die();
						for ( var j:Number = 0; j < zombies.length; j++) {
							zombies[j].die();
						}
						zombies[i].braaaaaiiinzzzzz();
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
		}
		
		private function spawnEnemies(e:TimerEvent):void {
			if (!gameOver) {
				var edgeTiles:Array = [ 0, 1, 2, 3, 4, 5, 9, 10, 14, 15, 19, 20, 24 ];
				var tileToSpawnIn:Number = edgeTiles[Math.floor(Math.random() * 13)];
				while (board.getTile(tileToSpawnIn).isOccupied()) {
					tileToSpawnIn = edgeTiles[Math.floor(Math.random() * 13)];
				}
				zombies.push(new Zombie(tileToSpawnIn, player));
				board.getTile(tileToSpawnIn).setOccupied(true);
			}
		}
		
		public function init():void
		{
			// init board
			board = new Board(currentLevel);
			
			// init player
			player = new Player(12);
			board.getTile(player.getLocation()).setOccupied(true);
			
			// init controls
			EventUtils.safeAddListener(LayerManager.stage, KeyboardEvent.KEY_DOWN, onKeyDown);
			
			// init zombies
			// For now, need to spawn a zombie in a static location to test pathfinding
			zombies = new Array();
			zombies.push(new Zombie(23, player));
			var tile:Tile = board.getTile(23);
			tile.setOccupied(true);
			
			// init zombie spawner
			EventUtils.safeAddListener( enemySpawnTimer, TimerEvent.TIMER, spawnEnemies );
			enemySpawnTimer.start();
			
			// Move enemies
			if ( DEBUG ) {
				EventUtils.safeAddListener( LayerManager.stage, KeyboardEvent.KEY_DOWN, moveEnemies );
			} else {
				EventUtils.safeAddListener( enemyMovementTimer, TimerEvent.TIMER, moveEnemies );
				enemyMovementTimer.start();
			}
		}
		
		private function onKeyDown(e:KeyboardEvent):void {
			if (!gameOver){
				var key:uint = e.keyCode;
				switch( e.keyCode ) {
					case Keyboard.W:
					case Keyboard.UP:
						player.move( board, Tile.NORTH );
						break;
					case Keyboard.S:
					case Keyboard.DOWN:
						player.move( board, Tile.SOUTH );
						break;
					case Keyboard.A:
					case Keyboard.LEFT:
						player.move( board, Tile.WEST );
						break;
					case Keyboard.D:
					case Keyboard.RIGHT:
						player.move( board, Tile.EAST );
						break;
					case Keyboard.R:
						currentLevel = 0;
						nextLevel();
						break;
				}
			}
		}
		
		private function nextLevel():void {
			LayerManager.clearLayer( Global.LAYER_ENTITIES );
			LayerManager.clearLayer( Global.LAYER_BG );
			enemySpawnTimer.stop();
			enemyMovementTimer.stop();
			zombies = new Array();
			currentLevel++;
			init();
		}

	}

}