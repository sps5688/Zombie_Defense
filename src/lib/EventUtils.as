package lib
{
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Brett Slabaugh
	 */
	public class EventUtils 
	{
		public static function safeAddListener( objectListener:EventDispatcher, eventType:String, callbackFunction:Function ):void
		{
			if ( objectListener && callbackFunction != null )
			{
				objectListener.removeEventListener( eventType, callbackFunction );
				objectListener.addEventListener( eventType, callbackFunction );
			}
			else
			{
				trace( "Cannot add listener to null object reference" );
			}
		}
		
		public static function safeRemoveListener( objectListener:EventDispatcher, eventType:String, callbackFunction:Function ):void
		{
			if ( objectListener && callbackFunction != null )
			{
				objectListener.removeEventListener( eventType, callbackFunction );
			}
			else
			{
				trace( "Cannot remove listener to null object reference" );
			}
		}
		
	}

}