package game 
{
	import game.Board;
	
	/**
	 * ...
	 * @author Brett Slabaugh
	 * @author Steve Shaw
	 */
	public class Zombie 
	{
		private var location:Number;
		private var MOVE_BREAK_P:Number = 0.50;
		private var playerLocation:Number;
		
		public function Zombie(location:Number, playerLocation:Number) 
		{
			this.location = location;
			this.playerLocation = playerLocation;
		}
		
		public function getLocation():Number 
		{
			return location;
		}
		
		public function setLocation(location:Number):void 
		{
			this.location = location;
		}
		
		public function move(board:Board):Boolean {
			var tileGrid:Array = board.getTileGrid();
			var curTile:Tile = tileGrid[location];
			var neighborTile:Tile;
			
			// Compute path
			var path:Array = search(curTile, board);
			if (path != null) {
				// Move zombie to next tile
				neighborTile = path.shift();
				trace("Moving zombie " + " from " + curTile.getID() + " to " + neighborTile.getID() + " - there is a path");
				setLocation(neighborTile.getID());
				
				if (location == board.getPlayerTile()) {
					trace("MMMM PLAYER, removed zombie");
					return true; // will be removed
				}
			}else {
				// Get open walls from current tile
				var openWalls:Array = board.getOpenWalls(curTile);
				
				// Move or break a wall with a probability
				if (Math.random() < MOVE_BREAK_P) {
					// Find an open adjacent tile
					var validMove:Boolean = true;
					do {
						neighborTile = openWalls[Math.floor(Math.random() * openWalls.length)];
						
						// Need to see if the neighbor tile is open in the opposite direction
						if (neighborTile != null) {
							var direction:String = board.getNeighborDirection(curTile, neighborTile);
							validMove = board.isValidMove(direction, neighborTile);
						}
					}while (neighborTile == null);
					
					// Move zombie, if valid move
					if (validMove) {
						trace("Moving zombie " + " from " + curTile.getID() + " to " + neighborTile.getID() + " - there is not a path");
						setLocation(neighborTile.getID());
					}else {
						trace("Tile " + neighborTile.getID() + "'s opposite direction not open");
					}
				}else {
					// Find a closed wall to start breaking
					var index:Number;
					do {
						index = Math.floor(Math.random() * openWalls.length);
						var wallToDamage:Tile = openWalls[index];
					}while (wallToDamage != null);
					
					// Find wall direction
					var curTileDirection:String;
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
					
					// Damage current wall, in a direction, not borders
					if (board.isValidWall(curTile.getID(), curTileDirection)) {
						// Get neighbor's opposite wall to damage
						neighborTile = board.getNeighborTile(curTile.getID(), curTileDirection);
						var oppositeDirection:String = board.getOppositeDirection(curTileDirection);
						
						// Damage walls
						neighborTile.damageWall(oppositeDirection);
						curTile.damageWall(curTileDirection);
						
						trace("Zombie is damaging " + curTile.getID() + "'s " + curTileDirection + " wall and " +
						neighborTile.getID() + "'s " + oppositeDirection + "'s wall - there is not a path");
						
						// Check for broken wall (tile type change)
						if (curTile.getWallHealth(curTileDirection) == 0) {
							trace("Wall broken - opening up a path between " + curTile.getID() + "'s " + curTileDirection + " wall and " + 
							neighborTile.getID() + "'s " + oppositeDirection + "'s wall");
							curTile.breakWall(curTileDirection);
							neighborTile.breakWall(oppositeDirection);
						}
					}
				}
			}
			// Player not found
			return false;
		}
		
		public function search(sourceTile:Tile, board:Board):Array {
			var tileGrid:Array = board.getTileGrid();
			
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
				
				if (curTile.getID() == playerLocation) {
					// Path found
					return constructPath(tileGrid[playerLocation]);
				}else {
					vistedNodes.push(curTile);
					
					// Add neighbors
					var curTileWalls:Array = board.getOpenWalls(curTile);
					for (var i:Number = 0; i < curTileWalls.length; i++) {
						var neighborTile:Tile = curTileWalls[i];
						
						if (neighborTile != null) {
							var direction:String = board.getNeighborDirection(curTile, neighborTile);
							var validMove:Boolean = board.isValidMove(direction, neighborTile);
							
							if (validMove && vistedNodes.indexOf(neighborTile) < 0 &&
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