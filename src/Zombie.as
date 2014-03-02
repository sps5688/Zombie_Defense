package  
{
	/**
	 * ...
	 * @author Steve Shaw
	 */
	public class Zombie 
	{
		private var location:Number;
		private var lookedForPath:Boolean = false;
		
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