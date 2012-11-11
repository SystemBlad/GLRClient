package com.proxies
{
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import com.adobe.serialization.json.JSON;
	
	public class ConfigProxy extends Object
	{
		
		public var loader = new URLLoader();
	
		public var flv_path; 
		public var action_path; 
		
		
		public function ConfigProxy(url:String)
		{
			super();
			
			var r = new URLRequest(url);
			
			this.loader.load(r);
			
			loader.addEventListener(Event.COMPLETE, onLoadComplete);
			
		}
		
		
		
		private function onLoadComplete(e:Event):void
		{
			var obj = com.adobe.serialization.json.JSON.decode((e.target as URLLoader).data);
			
			var flvFlag = obj.hasOwnProperty("flv_path");
			var actionFlag = obj.hasOwnProperty("action_path");
			
			
			if (flvFlag && actionFlag) 
			{
				this.flv_path = obj.flv_path;
				this.action_path = obj.action_path;
			}
			else 
			{
			  trace("init load error");
				
			}
		
		}
		
		
	}
}