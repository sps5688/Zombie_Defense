package lib {
	// This class is embedded with the TileClip MovieClip in Assets.swc.
	// Any modifications to Tiles should be done in the Tile wrapper class.
	public class TileClipT extends TileClip {	
		public function TileClipT() {}
		override public function getWestWall() : MovieClip { return mc_tile.mc_wall_west; }
	}
}
