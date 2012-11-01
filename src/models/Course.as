package models
{
	import mx.collections.ArrayCollection;

	public class Course
	{
		public var name:String;
		public var description:String;
		public var date:String;
		public var icon:String;
		public var speaker:String;
		public var capacity:Number;
		public var subscribers:ArrayCollection;
		public var fee:Number;
		
		public function Course()
		{
			subscribers = new ArrayCollection();
		}
	}
}