package com.proxies
{
	import com.adobe.serialization.json.JSON;
	
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class ActionProxy extends Object
	{
		
		public var loader:URLLoader = new URLLoader();
		private var _action:Object;
		private var _beforeAction:Array = new Array();;
		
		public var result:Object;
		
		public var before:Array;
		
		public function ActionProxy(url:String)
		{
			super();
			
			var r:URLRequest = new URLRequest(url);
			
			this.loader.load(r);
			
			loader.addEventListener(Event.COMPLETE, onLoadComplete);
			
		}
		
		
		protected function onLoadComplete(e:Event):void
		{
			
			var action:String;
			var actionResult:Object;
	
			action = String((e.target as URLLoader).data);
				
			action = "[" + action.substr(1) + "]";
			actionResult = com.adobe.serialization.json.JSON.decode(action);
			
			regularAction(actionResult)
			result = actionResult;
			
			before = this._beforeAction;
		
		}
		
		
		public function regularAction(arg1:Object):void
		{
			var loc1:*=false;
			var loc2:*=NaN;
			var loc3:*=null;
			var loc4:*=NaN;
			var loc5:*=0;
			var loc6:*=null;
			this._action = arg1 as Array;
			if (this._action && _action.length > 0) 
			{
				loc2 = 0;
				loc3 = APP_DISCONNECT;
				loc4 = 0;
				loc5 = 0;
				while (loc5 < this._action.length) 
				{
					if (this._action[loc5].type != APP_DISCONNECT) 
					{
						if (this._action[loc5].type != APP_CONNECT) 
						{
							if (this._action[loc5].type != STREAM_START) 
							{
								if (loc1) 
								{
									if (loc3 != APP_DISCONNECT) 
									{
										if (loc3 == STREAM_START) 
										{
											this._action[loc5].valid = true;
											this._action[loc5].time = (loc4 + this._action[loc5].time - loc2) / 1000;
										}
									}
									else 
									{
										this._action[loc5].valid = true;
										this._action[loc5].time = loc4 / 1000;
									}
								}
								else 
								{
									if ((loc6 = this._action.splice(loc5, 1)[0]).type == "onSendMsg" || loc6.type == "page") 
									{
										this._beforeAction.push(loc6);
									}
									--loc5;
								}
							}
							else 
							{
								loc1 = true;
								if (loc3 == STREAM_START && loc2 > 0) 
								{
									loc4 = loc4 + (this._action[loc5].time - loc2);
								}
								loc3 = STREAM_START;
								loc2 = this._action[loc5].time;
								this._action.splice(loc5, 1);
								--loc5;
							}
						}
						else 
						{
							this._action.splice(loc5, 1);
							--loc5;
						}
					}
					else 
					{
						if (loc3 == STREAM_START && loc2 > 0) 
						{
							loc4 = loc4 + (this._action[loc5].time - loc2);
						}
						loc3 = APP_DISCONNECT;
						this._action.splice(loc5, 1);
						--loc5;
					}
					++loc5;
				}
			}
			return;
		}
		
		public static const APP_CONNECT:String="appConnect";
		
		public static const APP_DISCONNECT:String="appDisconnect";
		
		public static const STREAM_START:String="streamRecordStart";

		
		
	}
}