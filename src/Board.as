package  
{
	/**
	 * ...
	 * @author Steve Shaw
	 */
	public class Board {
		// Board info
		private var ROWS:Number = 5;
		private var COLLUMNS:Number = 5;
		private var PLAYER_TILE:Number = 12;
		private var TILE_TYPES:Array = new Array("T Shape", "L Shape", "Straight", "4 Direction");
		private var board:Array = new Array();
		
		// Zombie info
		private var zombies:Array = new Array();
		
		// TESTING
		//private var ROWS:Number = 3;
		//private var COLLUMNS:Number = 3;
		//private var PLAYER_TILE:Number = 4;
		//private var TILE_TYPES:Array = new Array("4 Direction");
		
		public function Board() {
			// Create board as an 2d-array
			for (var i:Number = 0; i < ROWS; i++) {
				for (var j:Number = 0; j < COLLUMNS; j++) {
					var id:Number = i * COLLUMNS  + j
					var tileType:String = TILE_TYPES[Math.floor(Math.random() * TILE_TYPES.length)];
					var west:Boolean;
					var east:Boolean;
					var north:Boolean;
					
					var south:Boolean;
					if (tileType == "T Shape") {
						west = true;
						east = true;
						north = false;
						south = true;
					}else if (tileType == "L Shape") {
						west = false;
						east = true;
						north = true;
						south = false;
					}else if (tileType == "Straight") {
						west = false;
						east = false;
						south = true;
						north = true;
					}else if (tileType == "4 Direction") {
						west = true;
						east = true;
						north = true;
						south = true;
					}
					
					var newTile:Tile = new Tile(id, tileType, west, east, north, south);
					board.push(newTile);
					
					//trace("Created tile with parameters: " + id + " " + tileType + " " + west + " " + east + " " + north + " " + south);
				}
			}
		}
		
		public function getTile(tileNum:Number):Tile {
			return board[tileNum];
		}
		
		public function search(sourceTile:Tile):Array {
			// List of visited nodes
			var vistedNodes:Array = new Array();
			
			// List of nodes to visit
			var unvisitedNodes:Array = new Array();
			
			// Push initial node
			unvisitedNodes.push(sourceTile);
			
			// First node doesn't have a parent
			sourceTile.setPathParent(null);
			
			// Perform BFS
			while (unvisitedNodes.length != 0) {
				var curTile:Tile = unvisitedNodes.shift();
				
				if (curTile.getID() == PLAYER_TILE) {
					//trace("Path found");
					return constructPath(board[PLAYER_TILE]);
				}else {
					vistedNodes.push(curTile);
					
					// Add neighbors
					var curTileWalls:Array = getOpenWalls(curTile);
					for (var i:Number = 0; i < curTileWalls.length; i++) {
						var neighborTile:Tile = curTileWalls[i];
						
						if (neighborTile != null) {
							if (vistedNodes.indexOf(neighborTile) < 0 &&
								unvisitedNodes.indexOf(neighborTile) < 0) {
								neighborTile.setPathParent(curTile);
								unvisitedNodes.push(neighborTile);
							}
						}
					}	
				}
			}
			//trace("Path not found");
			return null;
		}
		
		public function addZombie(location:Number):void {
			zombies.push(new Zombie(location));
		}
		
		public function moveZombies():void {
			for (var i:Number = 0; i < zombies.length; i++) {
				var curZombie:Zombie = zombies[i];
				var curLocation:Number = curZombie.getLocation();
				var tile:Tile = board[curLocation];
				
				// Compute path
				var path:Array = search(tile);
				if (path != null) {
					// Move zombie to next tile
					var nextTile:Tile = path.shift();
					trace("Moving zombie " + i + " from " + curLocation + " to " + nextTile.getID());
					curZombie.setLocation(nextTile.getID());
				}else {
					// Move or break a wall with a probability
				}
			}
		}
		
		private function getOpenWalls(tile:Tile):Array {
			var openPaths:Array = new Array();
			var id:Number = tile.getID();
			
			// WEST
			if (tile.getWestWall() && id % COLLUMNS != 0) {
				// Not 0 5 10 15 20
				// Get west tile
				openPaths.push(board[id - 1]);
			}else {
				openPaths.push(null);
			}
			
			// EAST
			if (tile.getEastWall() && ((id + 1) / COLLUMNS != 0)) {
				// Not 4 9 14 19 24
				// Get east tile
				openPaths.push(board[id + 1]);
			}else {
				openPaths.push(null);
			}
			
			// NORTH
			if (tile.getNorthWall() && id >= COLLUMNS) {
				// Not 0-4
				// Get north tile
				openPaths.push(board[id - COLLUMNS]);
			}else {
				openPaths.push(null);
			}
			
			// SOUTH
			if (tile.getSouthWall() && id < ((COLLUMNS * COLLUMNS) - COLLUMNS)) {
				// Not 20-24
				// Get south tile
				openPaths.push(board[id + COLLUMNS]);
			}else {
				openPaths.push(null);
			}
			
			return openPaths;
		}
		
		private function constructPath(tile:Tile):Array {
			var path:Array = new Array();
			
			while (tile.getPathParent() != null) {
				path.push(tile);
				tile = tile.getPathParent();
			}
			
			path.reverse();
			return path;
		}

	}

}