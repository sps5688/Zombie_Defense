package game {
	import flash.text.TextField;
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
		
		// spacing constants
		public static const MARGIN:int = 25;
		public static const SPACING:int = 5;
		
		// directions
		public static const NORTH:String = "north";
		public static const EAST:String = "east";
		public static const SOUTH:String = "south";
		public static const WEST:String = "west";
		
		// graphic
		private var mc_tile:TileClip;
		
		// debug fields
		private var northField:TextField = new TextField();
		private var eastField:TextField = new TextField();
		private var southField:TextField = new TextField();
		private var westField:TextField = new TextField();
		
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
			if( Gameplay.DEBUG ) {
				northField.y = -63;
				northField.selectable = false;
				addChild(northField);
				eastField.x = 55;
				eastField.selectable = false;
				addChild(eastField);
				southField.y = 47;
				southField.selectable = false;
				addChild(southField);
				westField.x = -63;
				westField.selectable = false;
				addChild(westField);
			}
			
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
			
			updateDebugFields();
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
			
			updateDebugFields();
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
			
			updateDebugFields();
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
			switch( wallToDamage ) {
				case NORTH:
					healthNorth -= DAMAGE_INCREMENT;
					break;
				case EAST:
					healthEast -= DAMAGE_INCREMENT;
					break;
				case SOUTH:
					healthSouth -= DAMAGE_INCREMENT;
					break;
				case WEST:
					healthWest -= DAMAGE_INCREMENT;
					break;
			}
			
			//TODO move this to a separate function
			switch( globalToLocalDir( wallToDamage ) ) {
				case NORTH:
					if ( mc_tile.getNorthWall() != null ) mc_tile.getNorthWall().nextFrame();
					break;
				case EAST:
					if ( mc_tile.getEastWall() != null ) mc_tile.getEastWall().nextFrame();
					break;
				case SOUTH:
					if ( mc_tile.getSouthWall() != null ) mc_tile.getSouthWall().nextFrame();
					break;
				case WEST:
					if ( mc_tile.getWestWall() != null ) mc_tile.getWestWall().nextFrame();
					break;
					
			}

			updateDebugFields();
		}
		
		public function getWallHealth(wall:String):Number {
			return NORTH == wall ? healthNorth :
				   EAST == wall ? healthEast :
				   SOUTH == wall ? healthSouth :
				   WEST == wall ? healthWest : 0;
		}
		
		public function setWallHealth(wall:String, health:Number):void {
			switch (wall) {
				case NORTH:
					healthNorth = health;
					break;
				case EAST:
					healthEast = health;
					break;
				case SOUTH:
					healthSouth = health;
					break;
				case WEST:
					healthWest = health;
					break;
				default:
					break;
			}
			updateDebugFields();
		}
		
		public function breakWall(wall:String):void {
			switch( globalToLocalDir( wall ) ) {
				case NORTH:
					if ( mc_tile.getNorthWall() != null ) mc_tile.getNorthWall().play();
					break;
				case EAST:
					if ( mc_tile.getEastWall() != null ) mc_tile.getEastWall().play();
					break;
				case SOUTH:
					if ( mc_tile.getSouthWall() != null ) mc_tile.getSouthWall().play();
					break;
				case WEST:
					if ( mc_tile.getWestWall() != null ) mc_tile.getWestWall().play();
					break;
			}
			updateDebugFields();
		}
		
		private function globalToLocalDir( globalDir:String ) : String {
			var dirs:Array = new Array( NORTH, EAST, SOUTH, WEST );
			var dirInt:int = dirs.indexOf( globalDir );
			dirInt = (4 + dirInt - orientation) % 4;
			return dirs[dirInt];
		}
		
		private function updateDebugFields() : void {
			northField.text = ""+healthNorth;
			eastField.text = ""+healthEast;
			southField.text = ""+healthSouth;
			westField.text = ""+healthWest;
		}
		
	}

}