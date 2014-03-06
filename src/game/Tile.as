package game {
	import lib.TileClip;
	import lib.TileClipCross;
	import lib.TileClipL;
	import lib.TileClipStraight;
	import lib.TileClipT;
	import lib.TileClipPlayer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import ZombieDefense_fla.TileStraight_2;
	
	/**
	 * ...
	 * @author Brett Slabaugh
	 * @author Steve Shaw
	 * @author David Wilson
	 */
	public class Tile extends MovieClip	{
		
		// Tile types
		public static const STRAIGHT:String = "Straight";
		public static const L_SHAPE:String = "L Shape";
		public static const T_SHAPE:String = "T Shape";
		public static const CROSS:String = "Cross";
		public static const PLAYER:String = "Player";
		
		public static const MARGIN:int = 25;
		public static const SPACING:int = 5;
		
		//private var Prototile:Class;
		private var mc_tile:TileClip;
		
		// ID and type
		private var id:Number;
		private var type:String;
		
		// Wall status
		private var orientation:int;
		
		// Wall health
		private var INIT_HEALTH:Number = 3;
		private var DAMAGE_INCREMENT:Number = 1;
		private var healthWest:Number = INIT_HEALTH;
		private var healthEast:Number = INIT_HEALTH;
		private var healthNorth:Number = INIT_HEALTH;
		private var healthSouth:Number = INIT_HEALTH;
		
		// Path info
		private var pathParent:Tile;

		public function Tile(id:Number, type:String) {
			
			// Init vars
			this.id = id;
			this.type = type;
			
			// Create new TileClip and add to stage
			switch( type ) {
				case STRAIGHT:
					mc_tile = new TileClipStraight();
					healthNorth = 0;
					healthEast = INIT_HEALTH;
					healthSouth = 0;
					healthWest = INIT_HEALTH;
					break;
				case L_SHAPE:
					mc_tile = new TileClipL();
					healthNorth = INIT_HEALTH;
					healthEast = 0;
					healthSouth = 0;
					healthWest = INIT_HEALTH;
					break;
				case T_SHAPE:
					mc_tile = new TileClipT();
					healthNorth = 0;
					healthEast = 0;
					healthSouth = 0;
					healthWest = INIT_HEALTH;
					break;
				case CROSS:
					mc_tile = new TileClipCross();
					healthNorth = 0;
					healthEast = 0;
					healthSouth = 0;
					healthWest = 0;
					break;
				case PLAYER:
					mc_tile = new TileClipPlayer();
					healthNorth = 0;
					healthEast = 0;
					healthSouth = 0;
					healthWest = 0;
					break;
			}
			setOrientation(Math.floor(Math.random() * 4));
			addChild(mc_tile);
			
			// Add event listeners for rotation
			addEventListener(MouseEvent.CLICK, rotateLeft);
			addEventListener(MouseEvent.RIGHT_CLICK, rotateRight);
		}

		private function rotateLeft(e:MouseEvent):void {
			if ( type == PLAYER ) return;
			mc_tile.gotoAndPlay("left" + orientation);
			orientation = (orientation + 3) % 4;
			
			var tmpN:Number = healthNorth;
			healthNorth = healthEast;
			healthEast = healthSouth;
			healthSouth = healthWest;
			healthWest = tmpN;
		}

		private function rotateRight(e:MouseEvent):void {
			if ( type == PLAYER ) return;
			mc_tile.gotoAndPlay("right" + orientation);
			orientation = (orientation + 1) % 4;
			
			var tmpN:Number = healthNorth;
			healthNorth = healthWest;
			healthWest = healthSouth;
			healthSouth = healthEast;
			healthEast = tmpN;
		}
		
		private function setOrientation(o:int):void {
			if ( type == PLAYER ) return;
			mc_tile.gotoAndStop("right" + o); // "right" is arbitrary
			var dirs:Array = new Array(healthNorth, healthEast, healthSouth, healthWest );
			var diff:int = 4 + orientation - o;
			healthNorth = dirs[diff % 4];
			healthEast = dirs[(diff + 1) % 4];
			healthSouth = dirs[(diff + 2) % 4];
			healthWest = dirs[(diff + 3) % 4];
			orientation = o;
		}
		
		// GETTERS
		public function getID():Number {
			return id;
		}
		
		public function getWestWall():Boolean {
			return healthWest <= 0;
		}
		
		public function getEastWall():Boolean {
			return healthEast <= 0;
		}
		
		public function getNorthWall():Boolean {
			return healthNorth <= 0;
		}
		
		public function getSouthWall():Boolean {
			return healthSouth <= 0;
		}
		
		public function getPathParent():Tile {
			return pathParent;
		}
		
		// SETTERS
		public function setPathParent(tile:Tile):void {
			pathParent = tile;
		}
		
		public function damageWall(wallToDamage:String):void {
			var wallInt:int;
			if (wallToDamage == "west") {
				healthWest -= DAMAGE_INCREMENT;
				trace( healthWest );
				wallInt = 3;
			}else if (wallToDamage == "east") {
				healthEast -= DAMAGE_INCREMENT;
				trace( healthEast );
				wallInt = 1;
			}else if (wallToDamage == "north") {
				healthNorth -= DAMAGE_INCREMENT;
				trace( healthNorth );
				wallInt = 0;
			}else {
				healthSouth -= DAMAGE_INCREMENT;
				trace( healthSouth );
				wallInt = 2;
			}
			
			wallInt = (4 + wallInt - orientation) % 4;
			if (wallInt == 0 && mc_tile.getNorthWall() != null)
				mc_tile.getNorthWall().nextFrame();
			else if (wallInt == 1 &&  mc_tile.getEastWall() != null)
				mc_tile.getEastWall().nextFrame();
			else if (wallInt == 2 && mc_tile.getSouthWall() != null)
				mc_tile.getSouthWall().nextFrame();
			else if (wallInt == 3 && mc_tile.getWestWall() != null)
				mc_tile.getWestWall().nextFrame();
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
			var wallInt:int;
			switch (wall) {
				case "west":
					wallInt = 3;
					//healthWest = INIT_HEALTH;
					break;
				case "east":
					wallInt = 1;
					//healthEast = INIT_HEALTH;
					break;
				case "north":
					wallInt = 0;
					//healthNorth = INIT_HEALTH;
					break;
				case "south":
					wallInt = 2;
					//healthSouth = INIT_HEALTH;
					break;
				default:
					break;
			}
			
			wallInt = (4 + wallInt - orientation) % 4;
			if (wallInt == 0 && mc_tile.getNorthWall() != null)
				mc_tile.getNorthWall().play();
			else if (wallInt == 1 &&  mc_tile.getEastWall() != null)
				mc_tile.getEastWall().play();
			else if (wallInt == 2 && mc_tile.getSouthWall() != null)
				mc_tile.getSouthWall().play();
			else if (wallInt == 3 && mc_tile.getWestWall() != null)
				mc_tile.getWestWall().play();
		}
		
	}

}