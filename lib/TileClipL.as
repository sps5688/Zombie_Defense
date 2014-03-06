package lib {
	// This class is embedded with the TileClip MovieClip in Assets.swc.
	// Any modifications to Tiles should be done in the Tile wrapper class.
	public class TileClipL extends TileClip {	
		public function TileClipL() {}
		override public function getNorthWall() : MovieClip { return mc_tile.mc_wall_north; }
		override public function getWestWall() : MovieClip { return mc_tile.mc_wall_west; }
	}
}
