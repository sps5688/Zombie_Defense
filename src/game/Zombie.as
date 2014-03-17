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
		private var playerLocation:Number;
		private var startedDamagingWall:Boolean = false;
		private var zombieMoved:Boolean = false;
		private var pursueOptimal:Boolean = false;
		
		public function Zombie(location:Number, playerLocation:Number) {
			//add movieclip to stage
			mc_zombie = new ZombieClip();
			addChild(mc_zombie);
			this.x = 90 + 130 * Board.getTileX(location);
			this.y = 90 + 130 * Board.getTileY(location);
			LayerManager.addToLayer(this, Global.LAYER_ENTITIES);
			this.location = location;
			this.playerLocation = playerLocation;
		}
		
		public function getLocation():Number {
			return location;
		}
		
		public function setLocation(location:Number):void {
			this.location = location;
			this.x = 90 + 130 * Board.getTileX(location);
			this.y = 90 + 130 * Board.getTileY(location);
		}
		
		public function move(board:Board, playerLocation:Number):Boolean {
			var tileGrid:Array = board.getTileGrid();
			var curTile:Tile = tileGrid[location];
			var neighborTile:Tile;
			var neighborTileIndex:Number;
			this.playerLocation = playerLocation;
			
			// Determine if there's a path to the player
			var path:Array = search(curTile, board);
			if (path != null) {
				// If there is a path, move zombie to next tile
				neighborTile = path.shift();
				trace("Moving zombie " + " from " + curTile.getID() + " to " + neighborTile.getID() + " - there is a path");
				setLocation(neighborTile.getID());
				
				// Update tiles
				neighborTile.setZombieOn(true);
				curTile.setZombieOn(false);
				
				// Check for player death
				if (location == playerLocation) {
					trace("MMMM PLAYER, removed zombie");
					return true;
				}
			}else {
				// No path to player, determine optimal tile to move to
				var optimalDirection:String = getOptimalDirection(board);
				var optimalTile:Tile;
				var oppositeDirection:String = board.getOppositeDirection(optimalDirection);
				
				// Determine optimal direction to go
				switch(optimalDirection) {
					case "west":
						optimalTile = board.getNeighborTile(location, "west")
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
							
						// Determine if the zombie can move to the optimal tile
						var neighborOpen:Boolean = board.isValidMove(optimalDirection, optimalTile);
						trace("Tile " + curTile.getID() + "'s " + optimalDirection + " is " + neighborOpen);
						var currentOpen:Boolean = board.isValidMove(oppositeDirection, curTile);
						trace("Tile " + optimalTile.getID() + "'s " + oppositeDirection + " is " + currentOpen);
						
						// If the zombie can move to it, move there
						if (neighborOpen && currentOpen) {
							trace("Moving zombie " + " from " + curTile.getID() + " to " + optimalTile.getID() + " - there is not a path");
							setLocation(optimalTile.getID());
							
							// Update tiles
							optimalTile.setZombieOn(true);
							curTile.setZombieOn(false);
							
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
						trace("Zombie is damaging " + curTile.getID() + "'s " + optimalDirection + " wall and " +
						optimalTile.getID() + "'s " + oppositeDirection + "'s wall - there is not a path");
						
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
		
		public function getOptimalDirection(board:Board):String {
			var optimalDirection:String = "south";
			var minDistance:Number = 100;
			
			var eastDist:Number = Math.abs(playerLocation - (location + 1));
			var westDist:Number = Math.abs(playerLocation - (location - 1));
			var northDist:Number = Math.abs(playerLocation - (location - board.getColumns()));
			var southDist:Number = Math.abs(playerLocation - (location + board.getColumns()));
			
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