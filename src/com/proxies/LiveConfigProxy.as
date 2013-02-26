package com.proxies
{
	
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class LiveConfigProxy extends Object
	{
		
		public var loader:URLLoader = new URLLoader();
	
	    public var liveDomain:String = "rtmp://42.121.107.45:1935/oflaDemo";
		                              
		//public var liveDomain:String = "rtmp://210.51.3.25:1935/oflaDemo";
		public var mouseSO = "mouseSO";
		public var pageSO = "pageSO";
		public var chatSO = "chatSO";
		public var amf:String = "amf0";
		public var configObject:Object;
		public var appid:String;
		
		
		
		
		public function LiveConfigProxy(url:String)
		{
			super();
			
			getAppCode(url);
			
			var r:URLRequest = new URLRequest(url);
			
			this.loader.load(r);
			
			loader.addEventListener(Event.COMPLETE, onLoadComplete);
			
		}
		
		private function getAppCode(url:String):void{
			
			var sArr:Array = url.split("?");
			var rArr:Array = (sArr[1] as String).split("=");
			var tmp:Array = (rArr[1] as String).split("&");
			appid = tmp[0]; 
		}
		
		
		
		private function onLoadComplete(e:Event):void
		{
			trace("josn    " + (e.target as URLLoader).data);
			
			var obj:Object = com.adobe.serialization.json.JSON.decode((e.target as URLLoader).data);
			
			configObject = obj;
		
		}
		
		
	}
}