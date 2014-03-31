package game {
	import flash.display.MovieClip;
	import lib.LayerManager;
	import lib.Global;
	import lib.PlayerClip;
	import game.Tile;
	
	/**
	 * ...
	 * @author David Wilson
	 */
	public class Player extends MovieClip {
		private static const PLAYER_SPEED:Number = 3;
		
		private var mc_player:MovieClip;
		private var location:Number;
		private var prevLocation:Number;
		private var targetX:Number;
		private var targetY:Number;
		
		public function Player( loc:Number ) {
			location = loc;
			prevLocation = loc;
			mc_player = new PlayerClip();
			addChild( mc_player );
			x = 90 + 130 * Board.getTileX( loc );
			y = 90 + 130 * Board.getTileY( loc );
			targetX = x;
			targetY = y;
			LayerManager.addToLayer( this, Global.LAYER_ENTITIES );
		}
		
		public function getLocation():Number {
			return location;
		}
		
		public function getPreviousLocation():Number {
			return prevLocation;
		}
		
		public function step( board:Board ):void {
			// If currently in transit, continue transit
			if ( location != prevLocation ) {
				var diffx:Number = targetX - x;
				var diffy:Number = targetY - y;
				x += Math.abs(diffx) <= PLAYER_SPEED ? diffx : diffx / Math.abs(diffx) * PLAYER_SPEED;
				y += Math.abs(diffy) <= PLAYER_SPEED ? diffy : diffy / Math.abs(diffy) * PLAYER_SPEED;
				
				// If arrived at destination, unoccupy the previous tile
				if ( x == targetX && y == targetY ) {
					mc_player.gotoAndStop( "Idle" );
					board.getTile( prevLocation ).setOccupied( false );
					prevLocation = location;
				}
			}
		}
		
		public function move( board:Board, dir:String ):Boolean {
			if ( location != prevLocation ) {
				return false;
			}
			mc_player.rotationZ = dir == Tile.EAST ? 90 :
					dir == Tile.SOUTH ? 180 :
					dir == Tile.WEST ? 270 : 0;
			var origin:Tile = board.getTile( location );
			var destination:Tile = board.getNeighborTile( location, dir );
			if( destination != null && board.isValidMove( origin, destination ) ) {
				location = destination.getID();
				destination.setOccupied( true );
				targetX = 90 + 130 * Board.getTileX(location);
				targetY = 90 + 130 * Board.getTileY(location);
				mc_player.gotoAndPlay( "Walk" );
				return true;
			}
			return false;
		}
		
		public function die():void {
			mc_player.stop();
		}
		
	} // class Player

} // package game