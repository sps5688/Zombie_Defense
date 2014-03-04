package code {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Tile extends MovieClip {
		
		//TODO optimize using bitfield or whatever
		private var up:Boolean = false;
		private var right:Boolean = false;
		private var down:Boolean = false;
		private var left:Boolean = false;
		//TODO need some variable to indicate direction
		// either a 'remaining degrees' if rotating
		// programmatically, or something to determine
		// which keyframes to use if using timeline anim.
		
		public function Tile( reverse:Boolean ) {
			if( reverse ) {
				addEventListener( MouseEvent.CLICK, rotateRight );
				addEventListener( MouseEvent.RIGHT_CLICK, rotateLeft );
				this.alpha = 0.9;
			} else {
				addEventListener( MouseEvent.CLICK, rotateLeft );
				addEventListener( MouseEvent.RIGHT_CLICK, rotateRight );
			}
		}
		
		public function rotateRight( e:MouseEvent ) {
			trace( "right" );
			parent.addChild( this );
			gotoAndPlay( currentFrame % 48 + 2 );
		}
		
		public function rotateLeft( e:MouseEvent ) {
			trace( "left" );
			parent.addChild( this );
			gotoAndPlay( currentFrame % 48 + 50 );
		}
		
	}
}