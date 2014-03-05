package lib.media 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	/**
	 * ...
	 * @author Brett Slabaugh
	 */
	public class AudioContainer 
	{
		private var m_sound:Sound;
		private var m_soundId:int;
		private var m_soundTransform:SoundTransform;
		private var m_soundChannel:SoundChannel;
		
		public function AudioContainer( sound:Sound ) 
		{
			m_sound = sound;
		}
		
		public function play( soundToPlay:Sound, timeToStart:Number = 0, loops:uint = 1, soundTransform:SoundTransform = null ):void
		{
			m_soundTransform = soundTransform;
			m_sound.play( soundToPlay, timeToStart, loops, soundTransform );
		}
		
	}

}