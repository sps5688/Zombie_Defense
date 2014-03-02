package  
{
	/**
	 * ...
	 * @author Steve Shaw
	 */
	public class Tile 
	{
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
		
		// Constructor
		public function Tile(id:Number, type:String, west:Boolean, east:Boolean, north:Boolean, south:Boolean) 
		{
			this.id = id;
			this.type = type;
			
			this.west = west;
			this.east = east;
			this.north = north;
			this.south = south;
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
	}

}