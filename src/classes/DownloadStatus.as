package classes
{
	public class DownloadStatus
	{
		public static var NONE:Number = 0;
		public static var INITIALIZED:Number = 1;
		public static var CALCULATE_PIC:Number = 2;
		public static var CALCULATE_FLV:Number = 3;
		//public static var CALCULATE_ACTION:Number = 4;
		public static var CALCULATE_SWFS:Number = 4;
		public static var DOWNLOAD_PIC:Number = 5;
		public static var DOWNLOAD_FLV:Number = 6;
		//public static var DOWNLOAD_ACTION:Number = 8;
		public static var DOWNLOAD_SWFS:Number = 7;
		public static var COMPLETED:Number = 8;
		public static var CANCELLED:Number = -1;
	}
}