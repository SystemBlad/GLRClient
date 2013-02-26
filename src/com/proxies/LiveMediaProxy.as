package com.proxies
{
	import com.adobe.serialization.json.JSON;
	import com.components.*;
	import com.proxies.*;
	import com.utils.*;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Microphone;
	import flash.net.NetConnection;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.*;
	

	
	
	public class LiveMediaProxy extends Object
	{
		
		protected var _config:LiveConfigProxy;
		
		private var _pageContainer:PageContanier;
		private var _penContainer:PenContainer;
		private var _messageContainer:MessageContainer;
		private var _tf:TextField;
		
		public function LiveMediaProxy(config:LiveConfigProxy ,pageContainer:PageContanier, penContainer:PenContainer, messageContainer:MessageContainer)
		{
			super();
			_config = config;
			_pageContainer = pageContainer;
			_penContainer = penContainer;
			_messageContainer = messageContainer;
			
			_messageContainer.addEventListener("send_message", sendMessage);
			_pageContainer.contentLoaderInfo.addEventListener(Event.COMPLETE, pageLoaded);
			//_tf = tf;
			
		
			setupStream();
		}
		
		protected function overClass():void
		{
			this.closeStream();
			//com.glr.live.facade.Notifier.sendNotification(com.glr.live.notify.ErrorNotify.ERROR_MEDIA, this.model.isPub ? "辛苦老师,该课堂已经结束" : "该课堂已经结束");
			return;
		}
		
		protected function classFull():void
		{
			this.closeStream();
			//com.glr.live.facade.Notifier.sendNotification(com.glr.live.notify.ErrorNotify.ERROR_MEDIA, "对不起，教室人数已满,\n您可以在课程结束后观看录像");
			return;
		}
		
		protected function setLoop(arg1:Boolean):void
		{
			flash.utils.clearInterval(this._loopInter);
			if (arg1) 
			{
				
				this._loopInter = flash.utils.setInterval(this.onLoop, 500);
			}
			return;
		}
		
		protected function onLoop():void
		{
			//com.glr.live.facade.Notifier.sendNotification(com.glr.live.notify.LogicNotify.UPDATE_TIME, this.stream.time);
			return;
		}
		

		protected function setupStream():void
		{
		
			//ß_tf.text = "setup stream" + _config.liveDomain + " "  +  _config.configObject.uid ;
			
			this.closeStream();
			this.conn = new flash.net.NetConnection();
			this.conn.client =  new NetClient(this);
			this.conn.objectEncoding = parseInt(_config.amf.charAt(_config.amf.length-1));
			this.conn.addEventListener(flash.events.NetStatusEvent.NET_STATUS, this.onNetStatus);
			trace("con" + _config.appid + "   " + _config.configObject.uid +  "  " +  _config.configObject.uname + "   " + _config.configObject.swf_path + "   " + _config.configObject.roomNum + "  " + _config.liveDomain   )
			this.conn.connect(_config.liveDomain, _config.appid, "0", _config.configObject.uid, _config.configObject.uname, {}, _config.configObject.roomNum.toString());
			
			//this.conn.connect(_config.liveDomain, "25514", "0", "36149", "雷平",{},"30");

			
			return;
		}
		
		public function closeStream():void
		{
			
			this.setLoop(false);
			if (this.conn) 
			{
				this.conn.removeEventListener(flash.events.NetStatusEvent.NET_STATUS, this.onNetStatus);
				this.conn.close();
			}
			if (this.stream) 
			{
				this.stream.removeEventListener(flash.events.NetStatusEvent.NET_STATUS, this.onNetStatus);
				this.stream.close();
			}
			if (this.recordStream) 
			{
				this.recordStream.removeEventListener(flash.events.NetStatusEvent.NET_STATUS, this.onNetStatus);
				this.recordStream.close();
			}
			this.conn = null;
			this.stream = null;
			this.recordStream = null;
			return;
		}
		
		protected function onNetStatus(arg1:flash.events.NetStatusEvent):void
		{
			var classState:Number=0;
			
			
			
			var code:*=arg1.info.code;
			
			//_tf.text += "  net status ";//code;
			switch (code) 
			{
				case "NetConnection.Connect.Success":
				{
					
					//trace("net connect okokok"+_config.appid)
					
					//_tf.text += "\nsetup stream succc"
						
					
					this.initSO();
				
					this.stream = new flash.net.NetStream(this.conn);
					this.stream.client = new NetClient(this);
					this.stream.addEventListener(flash.events.NetStatusEvent.NET_STATUS, this.onNetStatus);
					this.stream.play(_config.appid + "_live");
					
					break;
				}
				case "NetStream.Publish.Start":
				{
					
					
					this.setLoop(true);
					//com.glr.live.facade.Notifier.sendNotification(com.glr.live.notify.LogicNotify.GOT_CLASS_CONNECT);
					break;
				}
				case "NetStream.Play.Start":
				{
					
					trace("streeam play start");
					this.setLoop(true);
					//com.glr.live.facade.Notifier.sendNotification(com.glr.live.notify.LogicNotify.GOT_CLASS_CONNECT);
					break;
				}
				case "NetStream.Buffer.Full":
				{
					trace("buffer full");
					
					
					//this.stream.soundTransform = new flash.media.SoundTransform(this.model.setting.volume);
					break;
				}
				case "NetConnection.Connect.Rejected":
				{
					this.classFull();
					break;
				}
				case "NetConnection.Connect.Failed":
					
				{
					//_tf.text += "\nsetup stream  ncfail"
				}
				case "NetConnection.Connect.Closed":
				{
					
				}
				case "NetStream.Failed":
				{
					
					//_tf.text += "\nsetup stream fail"
					this.closeStream();
					
					//trace("connect fail" + arg1.info.toString())
					//com.glr.live.facade.Notifier.sendNotification(com.glr.live.notify.ErrorNotify.ERROR_MEDIA);
					break;
				}
			}
			return;
		}
		
		protected function onRecordNetStatus(arg1:flash.events.NetStatusEvent):void
		{
			return;
		}
		
		protected function initSO():void
		{
		   
			trace("init  so"    +  _config.pageSO + "_" + _config.appid + "    " + this.conn.uri);
			
			this.mouseSO = flash.net.SharedObject.getRemote(_config.mouseSO + "_" + _config.appid, this.conn.uri, true);
			this.pageSO = flash.net.SharedObject.getRemote(_config.pageSO + "_" + _config.appid, this.conn.uri, true);
			this.pageSO.fps = 10;
			this.chatSO = flash.net.SharedObject.getRemote(_config.chatSO + "_" + _config.appid, this.conn.uri, true);
			this.chatSO.client = new NetClient(this);
			
			this.mouseSO.addEventListener(flash.events.SyncEvent.SYNC, this.onMouseSOSync);
			this.pageSO.addEventListener(flash.events.SyncEvent.SYNC, this.onPageSOSync);
			this.chatSO.addEventListener(flash.events.SyncEvent.SYNC, this.onChatSOSync);
			
			this.pageSO.addEventListener(flash.events.NetStatusEvent.NET_STATUS, this.onNetStatus);
			this.pageSO.connect(this.conn);
			this.mouseSO.connect(this.conn);
			this.chatSO.connect(this.conn);
			return;
		}
		
		
		
		protected function onMouseSOSync(arg1:flash.events.SyncEvent):void
		{
			var penData =this.mouseSO.data.pen;
			
			this._penContainer.penPosition = penData;
			//trace("shared object mouse : " + this.mouseSO.data.pen.penScaleX);
			//com.glr.live.facade.Notifier.sendNotification(com.glr.live.notify.LogicNotify.MOUSE_SO_CHANGE, loc1);
			return;
		}
		
		protected function onPageSOSync(arg1:flash.events.SyncEvent):void
		{
			var pageData =this.pageSO.data.page;
			if (pageData) 
			{
				_penContainer.clearGraphic();
				_pageContainer.load(new URLRequest(pageData.url));
			
			}
			
			//trace("shared object: page " + pageData)
			return;
		}
		
		
		private function pageLoaded(e:Event):void{
			
			this._pageContainer.dispatchEvent(new Event("page_loaded"));
			
			_penContainer.cWidth = _pageContainer.content.width;
			_penContainer.cHeight = _pageContainer.content.height;
			
			_pageContainer.contentLoaderInfo.removeEventListener(Event.COMPLETE, pageLoaded);
			
		}
		
		
		
		
		protected function onChatSOSync(arg1:flash.events.SyncEvent):void
		{
			
			//_tf.text += "\nso snc"
			
			var chatList = this.chatSO.data.list;
			trace("chat" + chatList);
			//_messageContainer.refreshMessage(chatList);
			
			//com.glr.live.facade.Notifier.sendNotification(com.glr.live.notify.LogicNotify.SET_SHUTUP, this.model.setting.shutup);
			return;
		}
		
		protected function getMicrophone():flash.media.Microphone
		{
			var mic=flash.media.Microphone.getMicrophone();
			mic.setSilenceLevel(0, 5000);
			return mic;
		}
		
		public function setMouseProperty(arg1:Object):void
		{
			if (this.mouseSO) 
			{
				this.mouseSO.setProperty("pen", arg1);
				this.mouseSO.setDirty("page");
			}
			return;
		}
		
		public function setPageProperty(arg1:Object=null):void
		{
			if (this.pageSO) 
			{
				if (arg1) 
				{
					this.pageSO.setProperty("page", arg1);
				}
			}
			return;
		}
		
		public function setShutupProperty(arg1:Object):void
		{
			var loc1:*=null;
			if (this.chatSO) 
			{
				loc1 = this.chatSO.data.list;
				if (loc1 == null) 
				{
					loc1 = {};
				}
				if (arg1.set != false) 
				{
					loc1[arg1.userid] = arg1.set;
				}
				else 
				{
					delete loc1[arg1.userid];
				}
				this.chatSO.setProperty("list", loc1);
				this.chatSO.setDirty("list");
			}
			return;
		}
		
		public function clearAllShutup():void
		{
			if (this.chatSO) 
			{
				this.chatSO.setProperty("list", null);
				this.chatSO.setDirty("list");
			}
			return;
		}
		
		
		private function sendMessage(e:DataEvent):void{
			
			if(e.data != "")
			{
			
			  sendMsg(e.data, "msg");
			}
			
		}
		
		public function sendMsg(arg1:Object, arg2:String="msg"):void
		{
			var message:*=null;
			if (this.chatSO) 
			{
				
				trace(_config.configObject.uid +  "  " + _config.configObject.uname + "  " + _config.configObject.avatar )
				message = {"id":_config.configObject.uid, "name":_config.configObject.uname, "identity":_config.configObject.identity, "avatar":_config.configObject.avatar, "space":_config.configObject.space, "school":_config.configObject.user_school, "grade":_config.configObject.user_grade, "major":_config.configObject.user_major, "value":arg1};
				var type:*=arg2;
				switch (type) 
				{
					case "msg":
					{
						this.chatSO.send("onSendMsg", message);
						break;
					}
					case "text":
					{
						this.chatSO.send("onSendText", message);
						break;
					}
					case "empty":
					{
						this.chatSO.send("onSendEmpty", message);
						break;
					}
					case "clear":
					{
						this.chatSO.send("onSendClear", message);
						break;
					}
					case "clap":
					{
						
						
						
						this.chatSO.send("onSendClap", message);
						break;
					}
					case "startclass":
					{
						//this.startClass();
						break;
					}
					case "overclass":
					{
						this.overClassToHttp();
						this.chatSO.send("onSendOverClass", message);
						break;
					}
				}
			}
			return;
		}
		
		public function onData(arg1:Object):void
		{
			
			var loc1:*=arg1.type;
			switch (loc1) 
			{
				case "onSendMsg":
				{
					
					_messageContainer.addMessage( {"value": arg1.info});
					//com.glr.live.facade.Notifier.sendNotification(com.glr.live.notify.LogicNotify.GOT_USER_SAY, arg1.info);
					break;
				}
				case "onSendText":
				{
					
					//trace("txt " + arg1.info);
					//com.glr.live.facade.Notifier.sendNotification(com.glr.live.notify.LogicNotify.GOT_TEXT_PEN, arg1.info);
					break;
				}
				case "onSendEmpty":
				{
					
					
					//com.glr.live.facade.Notifier.sendNotification(com.glr.live.notify.LogicNotify.CLEAR_GRAPHICS, arg1.info);
					break;
				}
				case "onSendClear":
				{
					//com.glr.live.facade.Notifier.sendNotification(com.glr.live.notify.LogicNotify.CLEAR_MSG, arg1.info);
					break;
				}
				case "onSendClap":
				{
					//com.glr.live.facade.Notifier.sendNotification(com.glr.live.notify.LogicNotify.GOT_CLAP, arg1.info);
					break;
				}
				case "onSendOverClass":
				{
					this.overClass();
					break;
				}
				case "onUserListChange":
				{
					//com.glr.live.facade.Notifier.sendNotification(com.glr.live.notify.LogicNotify.GOT_USER_CHANGE, arg1.info);
					break;
				}
				case "onClassFull":
				{
					this.classFull();
					break;
				}
					
				case "onGetLatestChat":
				{
					//trace("chat  info "  + arg1.info);
					
					var obj:Array = com.adobe.serialization.json.JSON.decode(arg1.info);
			
					_messageContainer.refreshMessage(obj);
					
					break;
				}
				case "metadata":
				{
					break;
				}
			}
			return;
		}
		
		public function resume():void
		{
			var loc1:*;
			try 
			{
				this.stream.resume();
			}
			catch (e:Error)
			{
			};
			return;
		}
		
		public function pause():void
		{
			var loc1:*;
			try 
			{
				this.stream.pause();
			}
			catch (e:Error)
			{
			};
			return;
		}
		
		public function set volume(arg1:Number):void
		{
			var value:Number;
			
			var loc1:*;
			value = arg1;
			try 
			{
				this.stream.soundTransform = new flash.media.SoundTransform(value);
			}
			catch (e:Error)
			{
			};
			return;
		}
		
		public function get time():Number
		{
			var loc1:*;
			try 
			{
				return this.stream.time;
			}
			catch (e:Error)
			{
			};
			return 0;
		}
		
		protected function overClassToHttp():void
		{
			var url:String;
			
			
			return;
		}
		
	
		
		
		protected var conn:flash.net.NetConnection;
		
		protected var stream:flash.net.NetStream;
		
		protected var recordStream:flash.net.NetStream;
		
		protected var mouseSO:flash.net.SharedObject;
		
		protected var pageSO:flash.net.SharedObject;
		
		protected var chatSO:flash.net.SharedObject;
		
		protected var _timeout:int;
		
		
		protected var _loopInter:int;
		
	}
}