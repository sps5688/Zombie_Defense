package game 
{
	import game.Board;
	import lib.ZombieClip;
	import flash.display.MovieClip;
	import lib.LayerManager;
	import lib.Global;
	
	/**
	 * ...
	 * @author Brett Slabaugh
	 * @author Steve Shaw
	 */
	public class Zombie extends MovieClip{
		private var mc_zombie:ZombieClip;
		private var location:Number;
		private var player:Player;
		private var startedDamagingWall:Boolean = false;
		private var zombieMoved:Boolean = false;
		private var pursueOptimal:Boolean = false;
		private var previousPosition:Number;
		private var targetX:Number;
		private var targetY:Number;
		
		public function Zombie(location:Number, player:Player) {
			//add movieclip to stage
			mc_zombie = new ZombieClip();
			addChild(mc_zombie);
			this.x = 90 + 130 * Board.getTileX(location);
			this.y = 90 + 130 * Board.getTileY(location);
			targetX = x;
			targetY = y;
			LayerManager.addToLayer(this, Global.LAYER_ENTITIES);
			this.location = location;
			previousPosition = location;
			this.player = player;
		}
		
		public function getLocation():Number {
			return location;
		}
		
		public function getPreviousPosition():Number {
			return previousPosition;
		}
		
		public function setLocation(location:Number, board:Board):void {
			if (!board.getTile(location).isOccupied() || location == player.getLocation()
					|| location == player.getPreviousLocation()) {
				previousPosition = this.location;
				this.location = location;
				board.getTile(location).setOccupied(true);
				targetX = 90 + 130 * Board.getTileX(location);
				targetY = 90 + 130 * Board.getTileY(location);
			}
		}
		
		public function move(board:Board):Boolean {
			// If currently in transit, continue transit
			if ( location != previousPosition ) {
				var diffx:Number = targetX - x;
				var diffy:Number = targetY - y;
				x += diffx == 0 ? 0 : (diffx) / Math.abs(diffx);
				y += diffy == 0 ? 0 : (diffy) / Math.abs(diffy);
				
				// If arrived at destination, unoccupy the previous tile
				if ( x == targetX && y == targetY ) {
					board.getTile(previousPosition).setOccupied(false);
					previousPosition = location;
				}
				return false;
			}
			var tileGrid:Array = board.getTileGrid();
			var curTile:Tile = tileGrid[location];
			var neighborTile:Tile;
			var neighborTileIndex:Number;
			
			// Determine if there's a path to the player
			var path:Array = search(curTile, board, player);
			if (path != null) {
				// If there is a path, move zombie to next tile
				neighborTile = path.shift();
				trace( neighborTile.getID(), path );
				trace("Moving zombie " + " from " + curTile.getID() + " to " + neighborTile.getID() + " - there is a path");
				setLocation(neighborTile.getID(), board);
			}else {
				// No path to player, determine optimal tile to move to
				var optimalDirection:String = getOptimalDirection(board, player.getLocation());
				var oppositeDirection:String = board.getOppositeDirection(optimalDirection);
				var optimalTile:Tile;
				
				// Determine optimal direction to go
				switch(optimalDirection) {
					case "west":
						optimalTile = board.getNeighborTile(location, "west");
						break;
					case "east":
						optimalTile = board.getNeighborTile(location, "east");
						break;
					case "north":
						optimalTile = board.getNeighborTile(location, "north");
						break;
					case "south":
						optimalTile = board.getNeighborTile(location, "south");
						break;
				}
				
				// If zombie is not already damaging a wall and the tiles have not rotated
				if (!startedDamagingWall && !curTile.hasChanged() && !optimalTile.hasChanged()) {			
					// If there is an open tile to move to
					if (optimalTile != null) {
						trace("Optimal move is moving to tile " + optimalTile.getID());
						
						// If the zombie can move to it, move there
						if (board.isValidMove(curTile, optimalTile)) {
							trace("Moving zombie " + " from " + curTile.getID() + " to " + optimalTile.getID() + " - there is not a path");
							setLocation(optimalTile.getID(), board);
							zombieMoved = true;
						}else {
							// Zombie can't move to the optimal tile
							trace("Optimal move to tile " + optimalTile.getID() + " is not possible.");
							zombieMoved = false;
							pursueOptimal = true;
						}
					}else {
						trace("There are no open tiles to move to.");
						// No open tiles to move to
						zombieMoved = false;
						startedDamagingWall = false;
					}
					
					// If the zombie can't move to the optimal tile, begin to damage walls
					if (!zombieMoved) {
						// Damage optimal tile's wall
						if (pursueOptimal) {
							// Check for tile rotations
							if (!curTile.hasChanged() && !optimalTile.hasChanged()) {
								// Damage walls
								trace("Zombie is damaging " + curTile.getID() + "'s " + optimalDirection + " wall and " +
								optimalTile.getID() + "'s " + oppositeDirection + "'s wall - there is not a path");
								
								if (curTile.getWallHealth(optimalDirection) != 0) {
									curTile.damageWall(optimalDirection);
								}
								
								if (optimalTile.getWallHealth(oppositeDirection) != 0) {
									optimalTile.damageWall(oppositeDirection);
								}
									
								startedDamagingWall = true;
							}else {
								// If one of the tiles has rotated, reset and rethink
								if (curTile.hasChanged()) {
									curTile.reset();
								}else if (optimalTile.hasChanged()) {
									optimalTile.reset();
								}
								
								startedDamagingWall = false;
							}
						}
					}
				}else {
					// Zombie is currently damaging a wall
					// If the tiles have not rotated, continue to damage wall
					if (!curTile.hasChanged() && !optimalTile.hasChanged()) {
						//trace("Zombie is damaging " + curTile.getID() + "'s " + optimalDirection + " wall and " +
						//optimalTile.getID() + "'s " + oppositeDirection + "'s wall - there is not a path");
						
						// Damage only if it's not open
						if (curTile.getWallHealth(optimalDirection) != 0) {
							curTile.damageWall(optimalDirection);
						}
						
						// Damage only if it's not open
						if (optimalTile.getWallHealth(oppositeDirection) != 0) {
							optimalTile.damageWall(oppositeDirection);
						}
						
						// Stop damaging when both sides are broken or open
						if (optimalTile.getWallHealth(oppositeDirection) == 0 &&
							curTile.getWallHealth(optimalDirection) == 0) {
							startedDamagingWall = false;
						}
					}else {
						// Tiles have been rotated, stop and rethink
						if (curTile.hasChanged()) {
							curTile.reset();
						}else if (optimalTile.hasChanged()) {
							optimalTile.reset();
						}
						
						startedDamagingWall = false;
					}
				}
			}
			// Player not found
			return false;
		}
		
		public function getOptimalDirection(board:Board, destination:Number):String {
			var optimalDirection:String = "south";
			var minDistance:Number = 100;
			
			var eastDist:Number = Math.abs(destination - (location + 1));
			var westDist:Number = Math.abs(destination - (location - 1));
			var northDist:Number = Math.abs(destination - (location - board.getColumns()));
			var southDist:Number = Math.abs(destination - (location + board.getColumns()));
			
			var east_west:int = (destination % board.getColumns()) - (location % board.getColumns());
			var north_south:int = (destination / board.getColumns()) - (location % board.getColumns());
			
			// Count number of closed walls on each tile
			var possibleMoves:Array = board.getNeighorTiles(location); // Null are borders
			var minClosedWalls:Number = 100;
			for (var i:Number = 0; i < possibleMoves.length; i++) {
				// Current neighbor tile
				var tile:Tile = possibleMoves[i];
				
				// If current tile is not a border tile
				if (tile != null) {
					// Get it's open walls
					var openWalls:Array = board.getOpenWalls(tile);
					
					// Count number of closed walls
					var closedWallCounter:Number = 0;
					for (var j:Number = 0; j < openWalls.length; j++) {
						if (openWalls[j] == null) {
							closedWallCounter++;
						}
					}
					
					// Increase the distance for each closed wall
					switch(i) {
						case 0:
							//trace("Increasing east by " + closedWallCounter);
							eastDist += closedWallCounter;
							break;
						case 1:
							//trace("Increasing west by " + closedWallCounter);
							westDist += closedWallCounter;
							break;
						case 2:
							//trace("Increasing north by " + closedWallCounter);
							northDist += closedWallCounter;
							break;
						case 3:
							//trace("Increasing south by " + closedWallCounter);
							southDist += closedWallCounter;
							break;
					}
				}
			}
			
			if (eastDist < minDistance && board.isValidWall(location, "east") && east_west > 0) {
				// East
				minDistance = eastDist;
				optimalDirection = "east";
			}
						
			if (westDist < minDistance && board.isValidWall(location, "west") && east_west <= 0) {
				// West
				minDistance = westDist;
				optimalDirection = "west";
			}
			
			if (northDist < minDistance && board.isValidWall(location, "north") && north_south > 0) {
				// North
				minDistance = northDist;
				optimalDirection = "north";
			}
			
			if (southDist < minDistance && board.isValidWall(location, "south") && north_south <= 0) {
				// South
				minDistance = southDist
				optimalDirection = "south";
				
			}

			return optimalDirection;
		}
		
		public function search(sourceTile:Tile, board:Board, player:Player):Array {
			var tileGrid:Array = board.getTileGrid();
			
			// List of visited nodes
			var vistedNodes:Array = new Array();
			
			// List of nodes to visit
			var unvisitedNodes:Array = new Array();
			
			// Push initial node
			unvisitedNodes.push(sourceTile);
			
			// First node doesn't have a parent
			sourceTile.setPathParent(null);
			
			// If player is currently moving toward my tile, intercept
			if (sourceTile.getID() == player.getLocation()) {
				var destTile:Tile = board.getTile(player.getPreviousLocation());
				destTile.setPathParent(sourceTile);
				return constructPath(destTile);
			}
			
			// Perform BFS
			while (unvisitedNodes.length != 0) {
				var curTile:Tile = unvisitedNodes.shift();
				
				if (curTile.getID() == player.getLocation()) {
					// Path found
					return constructPath(tileGrid[player.getLocation()]);
				}else {
					vistedNodes.push(curTile);
					
					// Add neighbors
					var curTileWalls:Array = board.getOpenWalls(curTile);
					for (var i:Number = 0; i < curTileWalls.length; i++) {
						var neighborTile:Tile = curTileWalls[i];
						
						if (neighborTile != null) {
							var validMove:Boolean = board.isValidMove(curTile, neighborTile);
							
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
		
		public function foundPlayer( player:MovieClip ):Boolean {
			return player.hitTestPoint( x, y );
		}
	}
}