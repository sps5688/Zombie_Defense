package lib {
	// This class is embedded with the TileClip MovieClip in Assets.swc.
	// Any modifications to Tiles should be done in the Tile wrapper class.
	public class TileClipStraight extends TileClip {	
		public function TileClipStraight() {}
		override public function getEastWall() : MovieClip { return mc_tile.mc_wall_east; }
		override public function getWestWall() : MovieClip { return mc_tile.mc_wall_west; }
	}
}
