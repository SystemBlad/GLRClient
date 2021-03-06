package models
{
	import classes.Constants;
	import classes.DataManager;
	
	import events.LoginEvent;
	import events.LogoutEvent;
	
	import flash.events.EventDispatcher;
	
	import mx.core.FlexGlobals;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	[Bindable]
	public class User extends EventDispatcher
	{
		private var _uid:Number;
		private var _name:String;
		private var _displayName:String;
		private var _statusLevel:Number;
		private var _avatarFile:String;
		private var _token:String = "";
		
		public function User()
		{
		}
		
		public function login(name:String, password:String):void
		{
			if (DataManager.instance.online) {
				var service:HTTPService = new HTTPService();
				service.url = Constants.LOGIN_URL + "?username="+name+"&password="+password;
				service.method = "GET";
				service.resultFormat = "text";
				service.addEventListener(ResultEvent.RESULT, resultListener);
				service.send();
			}
		}
		
		private function resultListener(event:ResultEvent):void {
			var json:String = String(event.result);
			trace(json);
			var obj:Object = JSON.parse(json);
			var evt:LoginEvent = new LoginEvent();
			if (obj.error_occurred == false) {
				_uid		= obj.user_info.uid;
				_name		= obj.user_info.username;
				_displayName= obj.user_info.name;
				_statusLevel= Number(obj.user_info.status_levels);
				_avatarFile	= obj.user_info.avatar_file;
				_token		= obj.user_info.token;
				
				evt.success = true;
			}
			else {
				evt.error = obj.error_string;
				trace(evt.error);
			}
			dispatchEvent(evt);
		}
		
		public function logout():void
		{
			_uid		= 0;
			_name		= "";
			_displayName= "";
			_statusLevel= 0;
			_avatarFile	= "";
			_token		= "";
			
			// clear user & pwd
			FlexGlobals.topLevelApplication.persistenceManager.setProperty("username", "");
			FlexGlobals.topLevelApplication.persistenceManager.setProperty("password", "");
			FlexGlobals.topLevelApplication.persistenceManager.save();
			
			var evt:LogoutEvent = new LogoutEvent();
			dispatchEvent(evt);
		}
		
		public function get token():String
		{
			return _token;
		}
		
		[Bindable(event="loginEvent")]
		[Bindable(event="logoutEvent")]
		public function get loggedIn():Boolean
		{
			return (_token != null && _token.length > 0);
		}
	}
}