package com.glr.test
{
	import flash.text.TextField;
	
	
	public class DeviceLogger extends TextField
	{
		public function DeviceLogger()
		{
			super();
			
			this.width = 400;
			this.height = 768;
			
		
			
		}
		
		public function log(s:String):void{
			
			this.text += (s + "\n");
			
		}
		
		
		public static function getInstance():DeviceLogger
		{
			if (_instance == null) 
			{
				_instance = new DeviceLogger();
			}
			return _instance;
		}
		
		public static var _instance:DeviceLogger;
		
		
	}
}