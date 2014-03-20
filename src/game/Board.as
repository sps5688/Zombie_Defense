package game 
{
	import lib.Coin;
	import lib.TileClip;
	import flash.display.MovieClip;
	import lib.LayerManager;
	import lib.Global;
	import game.Tile;
	import game.Zombie;
	
	/**
	 * ...
	 * @author Steve Shaw
	 */
	public class Board {
		// Board info
		private var ROWS:Number = 5;
		private var COLUMNS:Number = 5;
		
		private var TILE_TYPES:Array = new Array(Tile.T_SHAPE, Tile.L_SHAPE, Tile.STRAIGHT);
		private var tiles:Array = new Array();
		private var coins:Array = new Array();
		private var coinClips:Array = new Array();
		
		public function Board(levelNum:Number) {
			while (coins.length < levelNum) {
				for (var i:Number = 0; i < ROWS; i++) {
					for (var j:Number = 0; j < COLUMNS; j++) {
						var id:Number = i * COLUMNS  + j
						var tileType:String = (i == 2 && j == 2) ? Tile.CROSS :
							TILE_TYPES[Math.floor(Math.random() * TILE_TYPES.length)];
						
						// Create tile and add to array
						var newTile:Tile = new Tile(id, tileType);
						tiles.push(newTile);
						
						// Add tile to stage
						LayerManager.addToLayer(newTile, Global.LAYER_BG);
						newTile.x = 90 + 130 * j;
						newTile.y = 90 + 130 * i;
					}
				}
				
				// Generate coins
				while (coins.length > 0 ) coins.pop();
				while (coinClips.length > 0 ) coinClips.pop();
				for (var k:Number = 0; k < 100; k++) {
					var targetTile:Tile = getTile(Math.floor(Math.random() * (ROWS * COLUMNS)));
					if (targetTile.getType() == "L Shape" || targetTile.getType() == "T Shape") {
						coins.push(targetTile.getID());
						var mc_coin:Coin = new Coin();
						mc_coin.x = 90 + 130 * getTileX(targetTile.getID());
						mc_coin.y = 90 + 130 * getTileY(targetTile.getID());
						LayerManager.addToLayer(mc_coin, Global.LAYER_ENTITIES);
						coinClips.push(mc_coin);
					}
					if (coins.length == levelNum) break;
				}
			}
		}
		
		public function collectCoin(location:Number):Boolean {
			for (var i:Number = 0; i < coins.length; i++) {
				if (coins[i] == location) {
					coins.splice(i, 1);
					var thisCoin:Coin = coinClips[i];
					LayerManager.removeFromLayer(thisCoin, Global.LAYER_ENTITIES);
					coinClips.splice(i, 1);
				}
			}
			if (coins.length == 0) {
				// new level
				trace("LEVEL COMPLETE!");
				return true;
			}
			return false;
		}
		
		public function getTileGrid():Array {
			return tiles;
		}
		
		public function isValidWall(id:Number, direction:String):Boolean {
			var isValid:Boolean = false;
			
			switch(direction) {
				case "west":
					if (id % COLUMNS != 0) {
						isValid = true;
					}
					break;
				case "east":
					if (id % COLUMNS != COLUMNS - 1) {
						isValid = true;
					}
					break;
				case "north":
					if (id >= COLUMNS) {
						isValid = true;
					}
					break;
				case "south":
					if (id < ((COLUMNS * ROWS) - COLUMNS)) {
						isValid = true;
					}
					break;
				default:
					break;
			}
			
			return isValid;
		}
		
		public function getNeighborDirection(curTile:Tile, neighborTile:Tile):String {
			var direction:String = "";
			var curTileID:Number = curTile.getID();
			var neighborTileID:Number = neighborTile.getID();
			
			if(neighborTileID == curTileID - 1){
				direction = "west";
			}else if (neighborTileID == curTileID + 1) {
				direction = "east";
			}else if (neighborTileID == curTileID - COLUMNS) {
				direction = "north";
			}else if (neighborTileID == curTileID + COLUMNS) {
				direction = "south";
			}
			
			return direction;
		}
		
		public function getNeighborTile(curTileID:Number, direction:String):Tile {
			var neighborTile:Tile;
			
			switch(direction) {
				case "west":
					if (isValidWall(curTileID, direction)) {
						neighborTile = tiles[curTileID - 1];
					}
					break;
				case "east":
					if (isValidWall(curTileID, direction)) {
						neighborTile = tiles[curTileID + 1];
					}
					break;
				case "north":
					if (isValidWall(curTileID, direction)) {
						neighborTile = tiles[curTileID - COLUMNS];
					}
					break;
				case "south":
					if (isValidWall(curTileID, direction)) {
						neighborTile = tiles[curTileID + COLUMNS];
					}
					break;
				default:
					break;
			}
			
			return neighborTile;
		}
		
		public function getOppositeDirection(direction:String):String {
			var oppositeDirection:String = "";
			
			switch(direction) {
				case "west":
					oppositeDirection = "east";
					break;
				case "east":
					oppositeDirection = "west";
					break;
				case "north":
					oppositeDirection = "south";
					break;
				case "south":
					oppositeDirection = "north";
					break;
				default:
					break;
			}
			
			return oppositeDirection;
		}
		
		public function getOpenWalls(tile:Tile):Array {
			var paths:Array = new Array();
			var id:Number = tile.getID();
			
			// WEST
			if (tile.getWestWall() && isValidWall(id, "west")) {
				// Not left column
				// Get west tile
				paths.push(tiles[id - 1]);
			}else {
				paths.push(null);
			}
			
			// EAST
			if (tile.getEastWall() && isValidWall(id, "east")) {
				// Not right column
				// Get east tile
				paths.push(tiles[id + 1]);
			}else {
				paths.push(null);
			}
			
			// NORTH
			if (tile.getNorthWall() && isValidWall(id, "north")) {
				// Not top row
				// Get north tile
				paths.push(tiles[id - COLUMNS]);
			}else {
				paths.push(null);
			}
			
			// SOUTH
			if (tile.getSouthWall() && isValidWall(id, "south")) {
				// Not bottom row
				// Get south tile
				paths.push(tiles[id + COLUMNS]);
			}else {
				paths.push(null);
			}
			
			return paths;
		}
		
		public function isValidMove(direction:String, neighborTile:Tile):Boolean {
			var validMove:Boolean = true;
			
			switch(direction) {
				case "west":
					if (!neighborTile.getEastWall()) {
						validMove = false;
					}
					break;
				case "east":
					if (!neighborTile.getWestWall()) {
						validMove = false;
					}
					break;
				case "north":
					if (!neighborTile.getSouthWall()) {
						validMove = false;
					}
					break;
				case "south":
					if (!neighborTile.getNorthWall()) {
						validMove = false;
					}
					break;
			}
			
			return validMove;
		}
		
		public function getTile(index:Number):Tile {
			return tiles[index];
		}
		
		public function getColumns():Number { return COLUMNS; }
		
		public function getRows():Number { return ROWS; }
		
		public static function getTileX(id:Number):int{
			return id % 5;
		}
		
		public static function getTileY(id:Number):int{
			return id / 5;
		}
	}
}