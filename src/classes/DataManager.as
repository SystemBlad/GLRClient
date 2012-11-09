package classes
{
	import models.Course;
	import models.User;
	
	import mx.core.FlexGlobals;

	public class DataManager
	{
		private static var _instance:DataManager;
		
		[Bindable]
		public var user:User;
		
		public function DataManager()
		{
			this.user = new User();
		}
		
		public static function get instance():DataManager
		{
			if (!_instance)
				_instance = new DataManager();
			return _instance;
		}
		
		public function insertCourseHistory(subject:String, id:Number):void
		{
			var course:Course = new Course();
			course.subject = subject;
			course.id = id;
			var date:Date = new Date();
			course.viewTime = Math.floor(date.getTime()/1000);
			
			var courses:Vector.<Course> = FlexGlobals.topLevelApplication.persistenceManager.getProperty("history") as Vector.<Course>;
			if (!courses)
			{
				courses = new Vector.<Course>();
			}
			else
			{
				for (var i:int=0; i<courses.length; i++)
				{
					if (courses[i].id == course.id)
					{
						courses.splice(i, 1);
						break;
					}
				}
			}
			courses.push(course);
			FlexGlobals.topLevelApplication.persistenceManager.setProperty("history", courses);
		}
		
		public function clearCourseHistory():void
		{
			FlexGlobals.topLevelApplication.persistenceManager.clear();
		}
	}
}