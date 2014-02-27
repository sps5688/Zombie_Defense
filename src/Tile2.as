package {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Tile extends MovieClip {
		
		[Embed(source = "prototile.png")]
		private var Prototile:Class;
		
		public function Tile() {
			addChild( new Prototile() );
			addEventListener(MouseEvent.CLICK, rotate);
		}
		
		function rotate( e:MouseEvent ) {
			rotateRight();
		}
		
		function rotateRight() {
		}
		
	}

}