package classes
{
	import models.User;

	public class DataManager
	{
		private static var _instance:DataManager;
		
		[Bindable]
		public var user:User;
		[Bindable]
		public var currentCourse:Object;
		[Bindable]
		public var searchQuery:String;
		
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
	}
}