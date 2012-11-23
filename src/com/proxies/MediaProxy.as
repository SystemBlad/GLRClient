package com.proxies
{
	import com.adobe.serialization.json.JSON;
	import com.components.*;
	import com.proxies.ActionProxy;
	import com.utils.*;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.*;
	import flash.media.SoundTransform;
	
	import mx.core.IVisualElementContainer;

	public class MediaProxy extends Object
	{
		private var _url:String;
		private var _action:Array;
		private var _before:Array;
		
		private var _pageAction:Array = new Array();
		private var _penAction:Array = new Array();
		private var _messageAction:Array = new Array();
		
		private var _pageContainer:PageContanier;
		private var _penContainer:PenContainer;
		private var _messageContainer:MessageContainer;
		
		private var isPageLoaded:Boolean = false;
		private var isMediaLoaded:Boolean = false;
		
		
		private var client:NetClient;
		
		public var eventDispatcher:Sprite =  new Sprite();
	
		public function MediaProxy(url:String, action:ActionProxy, pageContainer:PageContanier, penContainer:PenContainer, messageContainer:MessageContainer)
		{
			super();
			_url = url;
			_action = action.result as Array;
			_before = action.before;
			_pageContainer = pageContainer;
			_penContainer = penContainer;
			_messageContainer = messageContainer;
			client = new NetClient(this);
			//_pageContainer.addEventListener(Event.COMPLETE, onPlayPageLoaded, false, 0, true);
			
			setAction();
			this.setupStream();
			
			initAction();
		
		}
		
		private function initAction():void{
			
			var startPage:Object;
			trace(_before.length)
			for(var i:int=0;i<_before.length;i++)
			{
			   if(_before[i].type == "page")
				   startPage = _before[i];
			}	
			
			_pageContainer.load(new URLRequest(startPage.value.url));
			_pageContainer.contentLoaderInfo.addEventListener(Event.COMPLETE, firstPageLoaded);
		}
		
		private function firstPageLoaded(e:Event):void{
			
			isPageLoaded = true;
			_pageContainer.contentLoaderInfo.removeEventListener(Event.COMPLETE, firstPageLoaded);
			trace(" first pageload")
			
			if(this.isMediaLoaded)
			{
				resume();
				refrashContent(this.videoTime);
				setLoop(true);
			}
			
			
			_pageContainer.dispatchEvent(new Event("page_loaded"));
			trace(_pageContainer.content.width,_pageContainer.content.height)
			_penContainer.cWidth = _pageContainer.content.width;
			_penContainer.cHeight = _pageContainer.content.height;
			
			
		}
		
		private function setAction():void
		{
			var actionLength:*=0;
			var actionValue:*=null;
			var i:*=0;
			var action:*=this._action;
			if (action && action.length > 0) 
			{
				actionLength = action.length;
				i = 0;
				while (i < actionLength) 
				{
					if (action[i].type == "page") 
					{
						_pageAction.push(action[i]);
					}
					
					if (action[i].type == "pen") 
					{
						_penAction.push(action[i]);
						
					}
					
					if(action[i].type == "onSendMsg")
					{
						_messageAction.push(action[i]);
					
					}
					
					++i;
				}
				
			}
			
			trace(_pageAction[0].time, _pageAction[1].time);
			
			return;
		}
		
		private function setLoop(arg1:Boolean):void
		{
			flash.utils.clearInterval(this._loopInter);
			if (arg1) 
			{
				this.onLoop();
				this._loopInter = flash.utils.setInterval(this.onLoop, 50);
			}
			return;
		}
		
		
		private var currentPageActionIndex:Number = 0;
		private var currentPenActionIndex:Number = 0;
		private var currentMessageActionIndex:Number = 0;
		
		protected function onLoop():void
		{
			var duration:Number;
			var currentPercent:*=NaN;
			var playStatus:*=null;
			var actionList:*=null;
			var pageActionListLength:*= _pageAction.length; 
			var penActionListLength:*= _penAction.length; 
			var messageActionListLength:*= _messageAction.length; 
			
			if (this.duration > 0) 
			{
				duration = (this.startTime + this.percent * (this.duration - this.startTime)) / this.duration;
				currentPercent = this.videoTime / this.duration;
				playStatus = {"time":this.videoTime, "load":duration, "play":currentPercent, "total":this.duration};
				actionList = this._action;
					
				this.eventDispatcher.dispatchEvent(new DataObjectEvent("play_status_changed", false, false, playStatus));	
					
				//trace(this.model.setting.action.length)
					
					
				if(currentPageActionIndex < pageActionListLength)	
				{
					//trace( _pageAction[currentPageActionIndex].time, this.videoTime)
					//trace(_pageAction[currentPageActionIndex].value.url);
					if (Math.abs(_pageAction[currentPageActionIndex].time - this.videoTime) <= ACCURACY) 
					{
						//TODO: load swf
						
						_pageContainer.load(new URLRequest(_pageAction[currentPageActionIndex].value.url));
						
						
						//trace(_pageAction[currentPageActionIndex].value.url);
						
						_penContainer.clearGraphic();
						 
						currentPageActionIndex++;
					}
				}
				
				if(currentPenActionIndex < penActionListLength)	
				{
					//trace(Math.abs(_penAction[currentPenActionIndex].time), this.videoTime);
					if (Math.abs(_penAction[currentPenActionIndex].time - this.videoTime) <= ACCURACY) 
					{
						//TODO: draw pen
						
						this._penContainer.penPosition = _penAction[currentPenActionIndex].value;
						//trace(this._penContainer.penX, this._penContainer.penY);
						currentPenActionIndex++;
					}
				
				}
				
				if(currentMessageActionIndex < messageActionListLength)
				{
					
					if (Math.abs(_messageAction[currentMessageActionIndex].time - this.videoTime) <= ACCURACY) 
					{
						//TODO: add message
						
						//trace("=================== add item")
						
						_messageContainer.addMessage(_messageAction[currentMessageActionIndex]);
						currentMessageActionIndex++;
					}
				}
			}
			return;
		}
		
		private function onPlayPageLoaded(e:Event):void{
			
			this.isPageLoaded = true;
			this._penContainer.visible = true;
			if(this.isMediaLoaded)
			{
				resume();
			
				setLoop(true);
			}
			
			_pageContainer.contentLoaderInfo.removeEventListener(Event.COMPLETE, onPlayPageLoaded);
			
		    trace("page loaded")
		}
		
		public function seekTo(time:Number):void
		{
			this._penContainer.visible = false;
			
	        this.isMediaLoaded = false;
			this.isPageLoaded = false;
			
			var keyFrame:*= KeyFrameUtil.getKeyFrame(time, this.metadata);
			
			var loc2:*=this.startTime + this.percent * (this.duration - this.startTime);
			if (keyFrame >= this.startTime && keyFrame < loc2) 
			{
				this.setLoop(false);
				this.seekTime = keyFrame;
				this.stream.seek(this.seekTime);
			}
		}
		
		private function refrashContent(time:Number):void{
			
		  _penContainer.clearGraphic();
	
			for(var i:int = 0;i< _pageAction.length; i++)
			{
				if(_pageAction[i].time > time){
					
					currentPageActionIndex = i;
					if(currentPageActionIndex>0)
					{
					_pageContainer.contentLoaderInfo.removeEventListener(Event.COMPLETE, onPlayPageLoaded);
					_pageContainer.load(new URLRequest(_pageAction[currentPageActionIndex - 1].value.url));
					_pageContainer.contentLoaderInfo.addEventListener(Event.COMPLETE, onPlayPageLoaded);
					}
					break;
				}
				
			}
			
	
			
			for(var j:int = 0;j< _penAction.length; j++)
			{
				if(currentPageActionIndex>0)
				if(_pageAction[currentPageActionIndex-1].time < _penAction[j].time && _penAction[j].time< time){
					
					this._penContainer.penPosition = _penAction[j].value;
					
					//break;
				}
				
			}
			
			for(var h:int = 0;h< _penAction.length; h++)
			{
				if( _penAction[h].time> time){
					
					currentPenActionIndex = h;
					
					break;
				}
				
			}
			
			var currentMessageActions:Array = new Array();
			
			for(var l:int = 0; l<_messageAction.length; l++)
			{
				if( _messageAction[l].time< time){
					
					currentMessageActions.push(_messageAction[l]);
					
					currentMessageActionIndex = l + 1;
					//trace(_messageAction[l].value.value);
					//break;
				}
				
			}
			
			_messageContainer.refreshMessage(currentMessageActions);
			
			
		}


		protected function setupStream():void
		{
			this.closeStream();
			this.conn = new flash.net.NetConnection();
			this.conn.connect(null);
			this.stream = new flash.net.NetStream(this.conn);
			this.stream.bufferTime = 3;
			this.stream.client = this.client;
			this.stream.addEventListener(flash.events.NetStatusEvent.NET_STATUS, this.onNetStatus);
			
			this.play(0);
			this.currentPageActionIndex = 0;
			this.currentPenActionIndex = 0;
			return;
		}
		
		public function closeStream():void
		{
			
			this.setLoop(false);
			if (this.conn) 
			{
				this.conn.close();
				this.conn.removeEventListener(flash.events.NetStatusEvent.NET_STATUS, this.onNetStatus);
			}
			if (this.stream) 
			{
				this.stream.close();
				this.stream.removeEventListener(flash.events.NetStatusEvent.NET_STATUS, this.onNetStatus);
			}
			this.conn = null;
			this.stream = null;
			return;
		}
		
		protected function play(arg1:Number):void
		{
			var time:Number;
			time = arg1;
		    this.stream.close();
			this.stream.play(this._url);
			
		}
		
		protected function onNetStatus(arg1:flash.events.NetStatusEvent):void
		{
			if (arg1.info.code == "NetStream.Buffer.Flush") 
			{
				return;
			}
			//com.glr.vod.Vod.log("Vod Media InfoCode: " + arg1.info.code);
			var loc1:*=arg1.info.code;
			switch (loc1) 
			{
				case "NetStream.Play.Start":
				{
					//this.stream.soundTransform = new flash.media.SoundTransform(0.5);
					break;
				}
				case "NetStream.Play.Stop":
				{
					this.onStop();
					break;
				}
				case "NetStream.Buffer.Empty":
				{
					this.onEmpty();
					break;
				}
				case "NetStream.Buffer.Full":
				{
					this.onFull();
					break;
				}
				case "NetStream.Seek.InvalidTime":
				{
					this.stream.seek(arg1.info.details);
					break;
				}
				case "NetStream.Play.StreamNotFound":
				case "NetStream.Play.FileStructureInvalid":
				{
					
					break;
				}
			}
			return;
		}
		
		protected function onFull():void
		{
			
			    isMediaLoaded = true;
			    trace("buffer full  " + (this.videoTime) );
	
				pause();
				refrashContent(this.videoTime);
				
				if(this.isPageLoaded)
				{
				 resume();
				 
				 setLoop(true);
				}
			
			return;
		}
		
		
		
		
		protected function onEmpty():void
		{
			trace("on empty")
			flash.utils.clearInterval(this._loopInter);
			
			if (this.duration - this.videoTime > this.stream.bufferTime) 
			{
			
			}
			return;
		}
		
		protected function onStop():void
		{
			
			return;
		}
		
		public function onData(arg1:Object):void
		{
			
			trace("on data " + arg1.type)
			var loc1:*=arg1.type;
			switch (loc1) 
			{
				case "metadata":
				{
					this.metadata = arg1;
					//com.glr.vod.Vod.log("onData: " + arg1.type + " " + this.duration);
				
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
				this.setLoop(true);
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
				this.setLoop(false);
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
		
		public function get videoTime():Number
		{
			
			if (this.stream) 
			{
				if (this.seekTime > 0 && Math.abs(this.stream.time - this.seekTime) > this.stream.bufferTime) 
				{
					
					//trace("seek time" + this.stream.time)
					return  this.seekTime;
				}
				
				this.seekTime = 0;
				
				if (this.stream.time > 0) 
				{
					//trace("stream time")
					return this.stream.time;
				}
			}
			return this.startTime;
		}
		
		public function get duration():Number
		{
			var loc1:*;
			try 
			{
				
				return this.metadata.duration;
			}
			catch (e:Error)
			{
			};
			return 0;
		}
		
		public function get percent():Number
		{
			var loc1:*;
			try 
			{
				return this.stream.bytesLoaded / this.stream.bytesTotal;
			}
			catch (e:Error)
			{
			};
			return 0;
		}

		
		public static const ACCURACY:Number=0.2;
		
		//internal var model:com.glr.vod.model.Model;
		
		protected var conn:flash.net.NetConnection;
		
		protected var stream:flash.net.NetStream;
		
		protected var playStart:Boolean;
		
		protected var metadata:Object;
		
		protected var seekTime:Number=0;
		
		protected var startTime:Number=0;
		
		protected var _loopInter:int;
		
		protected var _timeout:int;
		
		internal var ACTION:Object;

		
	}
}