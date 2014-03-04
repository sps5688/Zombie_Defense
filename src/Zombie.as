package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.ui.Mouse;
	
	/**
	 * ...
	 * @author Steve Shaw
	 */
	public class Zombie extends Sprite
	{
		private var location:Number;
		
		public function Zombie(location:Number) 
		{
			this.location = location;
		}
		
		public function getLocation():Number {
			return location;
		}
		
		public function setLocation(location:Number):void {
			this.location = location;
		}
		
	}

}