package events
{
	import flash.events.Event;
	
	public class DownloadChangeEvent extends Event
	{
		public static var name:String = "downloadChangeEvent";
		public var loadedBytes:Number;
		public var totalBytes:Number;
		public var status:Number;
		
		public function DownloadChangeEvent(loaded:Number=0, total:Number=0)
		{
			super(name);
			loadedBytes = loaded;
			totalBytes = total;
		}
	}
}