package events
{
	import flash.events.Event;
	
	public class NetworkChangeEvent extends Event
	{
		public static var name:String = 'networkChangeEvent';
		public var available:Boolean;
		
		public function NetworkChangeEvent(avail:Boolean)
		{
			super(name);
			available = avail;
		}
	}
}