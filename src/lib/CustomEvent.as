package lib 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Brett Slabaugh
	 */
	public class CustomEvent extends Event 
	{
		public static const EVENT_RESTART:String="Event_Restart";
		
		public function CustomEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new CustomEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("CustomEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}