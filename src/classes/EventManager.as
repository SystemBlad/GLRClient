package classes
{
	import flash.events.EventDispatcher;
	
	public class EventManager extends EventDispatcher
	{
		private static var _instance:EventManager;
		
		public function EventManager()
		{
		}
		
		public static function get instance():EventManager
		{
			if (!_instance)
				_instance = new EventManager();
			return _instance;
		}
	}
}