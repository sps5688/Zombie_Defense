package game 
{
	import assets.TileClip;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Brett Slabaugh
	 * @author Steve Shaw
	 * @author David Wilson
	 */
	public class Tile extends MovieClip
	{
		//private var Prototile:Class;
		private var mc_tile:TileClip;
		
		// ID and type
		private var id:Number;
		private var type:String;
		
		// Wall status
		private var west:Boolean;
		private var east:Boolean;
		private var north:Boolean;
		private var south:Boolean;
		
		// Wall health
		private var INIT_HEALTH:Number = 10;
		private var DAMAGE_INCREMENT:Number = 1;
		private var healthWest:Number = INIT_HEALTH;
		private var healthEast:Number = INIT_HEALTH;
		private var healthNorth:Number = INIT_HEALTH;
		private var healthSouth:Number = INIT_HEALTH;
		
		// Path info
		private var pathParent:Tile;

		public function Tile(id:Number, type:String, west:Boolean, east:Boolean, north:Boolean, south:Boolean) {
			// Create new TileClip and add to stage
			mc_tile = new TileClip();
			addChild(mc_tile);
			
			// Add event listeners for rotation
			addEventListener(MouseEvent.CLICK, rotate);
			addEventListener(MouseEvent.RIGHT_CLICK, rotateRight);
			
			// Init vars
			this.id = id;
			this.type = type;
			
			this.west = west;
			this.east = east;
			this.north = north;
			this.south = south;
		}

		private function rotate(e:MouseEvent):void 
		{
			mc_tile.gotoAndPlay(mc_tile.currentFrame % 48 + 2); //TODO: make label
			
			var tmpW:Boolean = west;
			var tmpE:Boolean = east;
			var tmpN:Boolean = north;
			var tmpS:Boolean = south;
			
			north = tmpW;
			south = tmpE;
			east = tmpN;
			west = tmpS;
		}

		private function rotateRight(e:MouseEvent):void 
		{
			mc_tile.gotoAndPlay(mc_tile.currentFrame % 48 + 50);
			
			var tmpW:Boolean = west;
			var tmpE:Boolean = east;
			var tmpN:Boolean = north;
			var tmpS:Boolean = south;
			
			north = tmpE;
			south = tmpW;
			east = tmpS;
			west = tmpN;
		}
		
		// GETTERS
		public function getID():Number {
			return id;
		}
		
		public function getWestWall():Boolean {
			return west;
		}
		
		public function getEastWall():Boolean {
			return east;
		}
		
		public function getNorthWall():Boolean {
			return north;
		}
		
		public function getSouthWall():Boolean {
			return south;
		}
		
		public function getPathParent():Tile {
			return pathParent;
		}
		
		// SETTERS
		public function setWestWall(status:Boolean):void {
			west = status;
		}
		
		public function setEastWall(status:Boolean):void {
			east = status;
		}
		
		public function setNorthWall(status:Boolean):void {
			north = status;
		}
		
		public function setSouthWall(status:Boolean):void {
			south = status;
		}
		
		public function setPathParent(tile:Tile):void {
			pathParent = tile;
		}
		
		public function damageWall(wallToDamage:String):void {
			if (wallToDamage == "west") {
				healthWest -= DAMAGE_INCREMENT;
			}else if (wallToDamage == "east") {
				healthEast -= DAMAGE_INCREMENT;
			}else if (wallToDamage == "north") {
				healthNorth -= DAMAGE_INCREMENT;
			}else {
				healthSouth -= DAMAGE_INCREMENT;
			}
		}
		
		public function getWallHealth(wall:String):Number {
			switch (wall) {
				case "west":
					return healthWest;
					break;
				case "east":
					return healthEast;
					break;
				case "north":
					return healthNorth;
					break;
				case "south":
					return healthSouth;
					break;
				default:
					break;
			}
			return 0;
		}
		
		public function setWallHealth(wall:String, health:Number):void {
			switch (wall) {
				case "west":
					healthWest = health;
					break;
				case "east":
					healthEast = health;
					break;
				case "north":
					healthNorth = health;
					break;
				case "south":
					healthSouth = health;
					break;
				default:
					break;
			}
		}
		
		public function breakWall(wall:String):void {
			switch (wall) {
				case "west":
					west = true;
					healthWest = INIT_HEALTH;
					break;
				case "east":
					east = true;
					healthEast = INIT_HEALTH;
					break;
				case "north":
					north = true;
					healthNorth = INIT_HEALTH;
					break;
				case "south":
					south = true;
					healthSouth = INIT_HEALTH;
					break;
				default:
					break;
			}
		}
		
	}

}