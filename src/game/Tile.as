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

		public function Tile() {
			mc_tile = new TileClip();
			addChild( mc_tile );
			addEventListener(MouseEvent.CLICK, rotate);
			addEventListener(MouseEvent.RIGHT_CLICK, rotateRight);
			//TODO: right click
		}

		private function rotate( e:MouseEvent ):void 
		{
			//rotateRight();
			mc_tile.gotoAndPlay(mc_tile.currentFrame % 48 + 2 ); //TODO: make label
		}

		private function rotateRight(e:MouseEvent):void 
		{
			mc_tile.gotoAndPlay( mc_tile.currentFrame % 48 + 50 );
		}
		
	}

}