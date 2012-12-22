package com.proxies
{
	
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class ConfigProxy extends Object
	{
		
		public var loader:URLLoader = new URLLoader();
	
		public var flv_path:String;
		public var action_path:String;
		public var photo_path:String;
		
		public function ConfigProxy(url:String)
		{
			super();
			
			var r:URLRequest = new URLRequest(url);
			
			this.loader.load(r);
			
			loader.addEventListener(Event.COMPLETE, onLoadComplete);
			
		}
		
		
		
		private function onLoadComplete(e:Event):void
		{
			var obj:Object = com.adobe.serialization.json.JSON.decode((e.target as URLLoader).data);
			
			var flvFlag:Boolean = obj.hasOwnProperty("flv_path");
			var actionFlag:Boolean = obj.hasOwnProperty("action_path");
			
			
			if (flvFlag && actionFlag) 
			{
				this.flv_path = obj.flv_path;
				this.action_path = obj.action_path;
				//this.photo_path = obj.
			}
			else 
			{
			  trace("init load error");
				
			}
		
		}
		
		
	}
}