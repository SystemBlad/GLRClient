package com.utils
{
	import flash.events.Event;
	
	public class DataObjectEvent extends Event
	{
		
		private var _data:Object;
		
		
		public function DataObjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object = null)
		{
			super(type, bubbles, cancelable);
		    _data = data;
		}
		
		public function get data():Object{
			
			return _data;
			
		}
		
	}
}