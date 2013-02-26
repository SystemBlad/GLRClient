package events
{
	import flash.events.Event;
	
	public class CourseItemEvent extends Event
	{
		public static var Delete:String = "delete";
		public static var Detail:String = "detail";
		public static var Play:String = "play";
		
		public var courseid:Number;
		public var kvidoeid:Number;
		public var pic:String;
		public var subject:String;
		public var avatar:String;
		public var watchSpot:Number = 0;
		
		public function CourseItemEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}