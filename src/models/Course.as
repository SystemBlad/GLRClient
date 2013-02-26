package models
{
	public class Course
	{
		public var kvideoid:Number;
		public var courseid:Number;
		public var subject:String;
		
		public var picUrl:String;
		public var avatarUrl:String;
		
		public var editing:Boolean = false;
		
		// duration and watchSpot are in minutes
		public var duration:Number;
		public var watchSpot:Number;
		
		public function Course()
		{
		}
	}
}