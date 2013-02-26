package events
{
	import flash.events.Event;

	public class ChannelChangeEvent extends Event
	{
		public static var name:String = "channelChangeEvent";
		
		public var id:Number;
		public var title:String;
		public function ChannelChangeEvent(id:Number, title:String)
		{
			super(name);
			
			this.id = id;
			this.title = title;
		}
	}
}