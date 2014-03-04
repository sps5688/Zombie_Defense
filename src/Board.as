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
		private var MOVE_BREAK_P:Number = 0.50;
		private var TILE_TYPES:Array = new Array("T Shape", "L Shape", "Straight"); // No 4 direction to start
		//private var TILE_TYPES:Array = new Array("Straight"); // For wall breaking testing
		private var board:Array = new Array();
		
		// Zombie info
		private var zombies:Array = new Array();
		
		public function Board() {
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
					}
					
					var newTile:Tile = new Tile(id, tileType, west, east, north, south);
					board.push(newTile);
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
					// Path found
					return constructPath(board[PLAYER_TILE]);
				}else {
					vistedNodes.push(curTile);
					
					// Add neighbors
					var curTileWalls:Array = getWalls(curTile, true);
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
			// Path not found, return null
			return null;
		}
		
		public function addZombie(location:Number):void {
			zombies.push(new Zombie(location));
		}
		
		public function getZombies():Number {
			return zombies.length;
		}
		
		public function moveZombies():void {
			for (var i:Number = 0; i < zombies.length; i++) {
				var curZombie:Zombie = zombies[i];
				var curLocation:Number = curZombie.getLocation();
				var curTile:Tile = board[curLocation];
				
				// Compute path
				var path:Array = search(curTile);
				if (path != null) {
					// Move zombie to next tile
					var nextTile:Tile = path.shift();
					trace("Moving zombie " + i + " from " + curTile.getID() + " to " + nextTile.getID() + " - there is a path");
					curZombie.setLocation(nextTile.getID());
					
					if (curZombie.getLocation() == PLAYER_TILE) {
						trace("MMMM PLAYER, removed zombie");
						zombies.splice(i, 1);
					}
				}else {
					// Get open walls from current tile
					var openWalls:Array = getWalls(curTile, true);
					
					// Move or break a wall with a probability
					if (Math.random() < MOVE_BREAK_P) {
						// Find an open adjacent tile
						var tileToMoveTo:Tile;
						do {
							tileToMoveTo = openWalls[Math.floor(Math.random() * openWalls.length)];
						}while (tileToMoveTo == null);
						
						// Move zombie
						trace("Moving zombie " + i + " from " + curTile.getID() + " to " + tileToMoveTo.getID() + " - there is not a path");
						curZombie.setLocation(tileToMoveTo.getID());
					}else {
						// Find a closed wall to start breaking
						var wallToDamage:Tile;
						var index:Number;
						do {
							index = Math.floor(Math.random() * openWalls.length);
							wallToDamage = openWalls[index];
						}while (wallToDamage != null);
						
						var curTileDirection:String;
						
						// Find wall direction
						switch(index) {
							case 0:
								curTileDirection = "west";
								break;
							case 1:
								curTileDirection = "east";
								break;
							case 2:
								curTileDirection = "north";
								break;
							case 3:
								curTileDirection = "south";
								break;
						}
						
						// Damage current wall, in a direction
						if (isValidWall(curTile.getID(), curTileDirection)) {
							curTile.damageWall(curTileDirection);
							trace("Zombie " + i + " is damaging " + curTile.getID() + "'s " + curTileDirection + " wall - there is not a path");
							
							// Check for broken wall (tile type change)
							if (curTile.getWallHealth(curTileDirection) == 0) {
								trace("Wall broken - opening up " + curTile.getID() + "'s " + curTileDirection + " wall");
								curTile.breakWall(curTileDirection);
							}
						}
					}
				}
			}
		}
		
		private function isValidWall(id:Number, direction:String):Boolean {
			var isValid:Boolean = false;
			
			switch(direction) {
				case "west":
					if (id % COLLUMNS != 0) {
						isValid = true;
					}
					break;
				case "east":
					if ((id + 1) / COLLUMNS != 0) {
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
		
		private function getWalls(tile:Tile, open:Boolean):Array {
			var paths:Array = new Array();
			var id:Number = tile.getID();
			
			// WEST
			if (tile.getWestWall() && isValidWall(id,"west")) {
				// Not left collumn
				// Get west tile
				paths.push(board[id - 1]);
			}else {
				paths.push(null);
			}
			
			// EAST
			if (tile.getEastWall() && isValidWall(id,"east")) {
				// Not right collumn
				// Get east tile
				paths.push(board[id + 1]);
			}else {
				paths.push(null);
			}
			
			// NORTH
			if (tile.getNorthWall() && isValidWall(id,"north")) {
				// Not top row
				// Get north tile
				paths.push(board[id - COLLUMNS]);
			}else {
				paths.push(null);
			}
			
			// SOUTH
			if (tile.getSouthWall() && isValidWall(id,"south")) {
				// Not bottom row
				// Get south tile
				paths.push(board[id + COLLUMNS]);
			}else {
				paths.push(null);
			}
			
			return paths;
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