package lib.media 
{
	import flash.media.Sound;
	import flash.media.SoundTransform;
	/**
	 * ...
	 * @author Brett Slabaugh
	 */
	public class Audio 
	{
		
		public function Audio() 
		{
			
		}

		private static function play():void
		{
			if ( soundToPlay )
			{
				soundToPlay.play( timeToStart, loops, soundTransform );
			}
		}
		
	}

}