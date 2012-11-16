package events
{
	import flash.events.Event;

	public class ScrollingEvent extends Event
	{
		public static const SCROLLING_STARTED:String ="SCROLLING_STARTED"; 
		public static const SCROLLING_STOPPED:String ="SCROLLING_STOPPED";
		public static const TAP_ACTION:String ="TAP_ACTION";
		public static const DELETE_ACTION:String ="DELETE_ACTION";
		
		public function ScrollingEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}