package events
{
	import flash.events.Event;

	public class TapEvent extends Event
	{
		public static var name:String = "tap";
		public var locationX:Number;
		public var locationY:Number;
		
		public function TapEvent():void
		{
			super(name);
		}
	}
}