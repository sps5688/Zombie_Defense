package game 
{
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
		private var COLLUMNS:Number = 5;
		private var PLAYER_TILE:Number = 12;
		
		private var TILE_TYPES:Array = new Array(Tile.T_SHAPE, Tile.L_SHAPE, Tile.STRAIGHT);
		private var tiles:Array = new Array();
		
		public function Board() {
			for (var i:Number = 0; i < ROWS; i++) {
				for (var j:Number = 0; j < COLLUMNS; j++) {
					var id:Number = i * COLLUMNS  + j
					var tileType:String = (i == 2 && j == 2) ? Tile.PLAYER :
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
		}
		
		public function getTileGrid():Array {
			return tiles;
		}
		
		public function isValidWall(id:Number, direction:String):Boolean {
			var isValid:Boolean = false;
			
			switch(direction) {
				case "west":
					if (id % COLLUMNS != 0) {
						isValid = true;
					}
					break;
				case "east":
					if (id % COLLUMNS != COLLUMNS - 1) {
						isValid = true;
					}
					break;
				case "north":
					if (id >= COLLUMNS) {
						isValid = true;
					}
					break;
				case "south":
					if (id < ((COLLUMNS * COLLUMNS) - COLLUMNS)) {
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
			}else if (neighborTileID == curTileID - COLLUMNS) {
				direction = "north";
			}else if (neighborTileID == curTileID + COLLUMNS) {
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
						neighborTile = tiles[curTileID - COLLUMNS];
					}
					break;
				case "south":
					if (isValidWall(curTileID, direction)) {
						neighborTile = tiles[curTileID + COLLUMNS];
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
				// Not left collumn
				// Get west tile
				paths.push(tiles[id - 1]);
			}else {
				paths.push(null);
			}
			
			// EAST
			if (tile.getEastWall() && isValidWall(id, "east")) {
				// Not right collumn
				// Get east tile
				paths.push(tiles[id + 1]);
			}else {
				paths.push(null);
			}
			
			// NORTH
			if (tile.getNorthWall() && isValidWall(id, "north")) {
				// Not top row
				// Get north tile
				paths.push(tiles[id - COLLUMNS]);
			}else {
				paths.push(null);
			}
			
			// SOUTH
			if (tile.getSouthWall() && isValidWall(id, "south")) {
				// Not bottom row
				// Get south tile
				paths.push(tiles[id + COLLUMNS]);
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
		
		public function getOptimalDirection(location:Number):String {
			var optimalDirection:String = "south";
			var minDistance:Number = 100;
			
			var eastDist:Number = Math.abs(PLAYER_TILE - (location + 1));
			var westDist:Number = Math.abs(PLAYER_TILE - (location - 1));
			var northDist:Number = Math.abs(PLAYER_TILE - (location - COLLUMNS));
			var southDist:Number = Math.abs(PLAYER_TILE - (location + COLLUMNS));
			
			if (eastDist < minDistance) {
				// East
				minDistance = eastDist;
				optimalDirection = "east";
			}
						
			if (westDist < minDistance) {
				// West
				minDistance = westDist;
				optimalDirection = "west";
			}
			
			if (northDist < minDistance) {
				// North
				minDistance = northDist;
				optimalDirection = "north";
			}
			
			if (southDist < minDistance) {
				// South
				minDistance = southDist
				optimalDirection = "south";
			}
			
			return optimalDirection;
		}
		
		public function getPlayerTile():Number {
			return PLAYER_TILE;
		}
		
		public function getTile(index:Number):Tile {
			return tiles[index];
		}
		
		public static function getTileX(id:Number):int{
			return id % 5;
		}
		
		public static function getTileY(id:Number):int{
			return id / 5;
		}
	}
}