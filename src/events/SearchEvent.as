package events
{
	import flash.events.Event;

	public class SearchEvent extends Event
	{
		public static const name:String = "search";
		public var query:String;
		
		public function SearchEvent(value:String):void
		{
			super(name);
			this.query = value;
		}
	}
}