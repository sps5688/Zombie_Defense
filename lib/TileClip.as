package lib {
	import flash.display.MovieClip;
	// This class is embedded with the TileClip MovieClip in Assets.swc.
	// Any modifications to Tiles should be done in the Tile wrapper class.
	public class TileClip extends MovieClip {
		public function TileClip() {}
		public function getNorthWall() : MovieClip { return null; }
		public function getEastWall() : MovieClip { return null; }
		public function getSouthWall() : MovieClip { return null; }
		public function getWestWall() : MovieClip { return null; }
		
	}
}
