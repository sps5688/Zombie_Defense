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
	 */
	public class Tile extends MovieClip
	{
		//private var Prototile:Class;
		private var mc_tile:TileClip;
		private var orientation:int = 0;

		public function Tile() {
			mc_tile = new TileClip();
			addChild( mc_tile );
			addEventListener(MouseEvent.CLICK, rotateLeft);
			addEventListener(MouseEvent.RIGHT_CLICK, rotateRight);
		}

		private function rotateLeft(e:MouseEvent):void 
		{
			parent.addChild( this ); // move to front
			mc_tile.gotoAndPlay(mc_tile.currentFrame % 48 + 50 );
			//mc_tile.gotoAndPlay( "left" + orientation ); //TODO: make label
			orientation = (orientation + 3) % 4;
		}

		private function rotateRight(e:MouseEvent):void 
		{
			parent.addChild( this ); // move to front
			mc_tile.gotoAndPlay( mc_tile.currentFrame % 48 + 2 );
			//mc_tile.gotoAndPlay( "right" + orientation ); //TODO: make label
			orientation = (orientation + 1) % 4;
		}
		
	}

}