package com.components
{
	import com.adobe.utils.TimeUtil;
	import com.proxies.MediaProxy;
	import com.utils.DataObjectEvent;
	
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	import flash.geom.Rectangle;
	
	
	
    
	
	
	public class ControlPanelUI extends Sprite
	{
		
		public var realHeight:Number;
		
		private var controlPanel:ControlPanel = new ControlPanel(); 
		
		private var scale:Number = 0.6;
		
		private var _mediaProxy:MediaProxy;
		
		//this should be added after parent be added
		
		public function ControlPanelUI(m:MediaProxy)
		{
			realHeight = controlPanel.back.height;
			_mediaProxy = m;
			
			addChild(controlPanel);
			
			
			controlPanel.playAndPause.gotoAndStop(1);
			controlPanel.volume.gotoAndStop(1);
			
			controlPanel.playAndPause.addEventListener(MouseEvent.CLICK, playAndPauseClicked);
			controlPanel.volume.addEventListener(MouseEvent.CLICK, volumeClicked);
			
		    addEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(Event.RESIZE, onResize);
			_mediaProxy.eventDispatcher.addEventListener("play_status_changed", updateControlPanel, false, 0, true);

			
			
		}
		
		
		private function volumeClicked(e:MouseEvent):void{
			
			//pause
			if(controlPanel.volume.currentFrame == 1)
			{
				
				_mediaProxy.volume = 0;
				controlPanel.volume.gotoAndStop(2)
				return;
			}
			
			//play
			if(controlPanel.volume.currentFrame == 2)
			{
				
				_mediaProxy.volume = 1;
				controlPanel.volume.gotoAndStop(1)
				return;
			}
			
		}
		
		private function playAndPauseClicked(e:MouseEvent):void{
			
			
			//pause
			if(controlPanel.playAndPause.currentFrame == 1)
			{
				
				_mediaProxy.pause();
				controlPanel.playAndPause.gotoAndStop(2)
				return;
			}
			
			//play
			if(controlPanel.playAndPause.currentFrame == 2)
			{
				
				_mediaProxy.resume();
				controlPanel.playAndPause.gotoAndStop(1)
				return;
			}
			
		}
		
		
		private var scaleChange:Number;
		
		private function onAdded(e:Event):void{
			
			var oW:Number = this.controlPanel.back.width;
			
			this.controlPanel.back.width = this.stage.stageWidth;
			this.controlPanel.volume.x = this.stage.stageWidth - this.controlPanel.volume.width;
			var scaleChange:Number = this.controlPanel.back.width / oW;
			
			this.scaleChange = scaleChange;
			
			this.controlPanel.duration.width = this.controlPanel.duration.width * scaleChange;
			
			this.controlPanel.drag.x = 0 + this.controlPanel.duration.x;
			this.controlPanel.drag.tip.visible = false;
			this.controlPanel.loaded.width = 0;
			this.controlPanel.played.width = 0;
			
			this.controlPanel.drag.addEventListener(MouseEvent.MOUSE_DOWN, onStartDrag);
			this.controlPanel.drag.addEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationChanged, false, 0, true);
			
			
		}
		
		private function onResize(e:Event):void{
			
			var oW:Number = this.controlPanel.back.width;
			
			this.controlPanel.back.width = this.stage.stageWidth * scale;
			this.controlPanel.volume.x = this.stage.stageWidth - this.controlPanel.volume.width;
			
			var scaleChange:Number = this.controlPanel.back.width / oW;
			
			this.scaleChange = scaleChange;
			
			this.controlPanel.duration.width = this.controlPanel.duration.width * scaleChange;
			
			
			
			
		}
		
		private function orientationChanged(e:StageOrientationEvent):void{
			
			var oW:Number = this.controlPanel.back.width;
			
			this.controlPanel.back.width = this.stage.stageWidth;
			this.controlPanel.volume.x = this.stage.stageWidth - this.controlPanel.volume.width;
			
			var scaleChange:Number = this.controlPanel.back.width / oW;
			
			this.scaleChange = scaleChange;
			
			this.controlPanel.duration.width = this.controlPanel.duration.width * scaleChange;
			
			
			
			
		}
		
		
		private function onStartDrag(e:MouseEvent):void{
		    this.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			this.controlPanel.drag.tip.visible = true;
			this.controlPanel.drag.startDrag(false, new Rectangle(this.controlPanel.duration.x, this.controlPanel.drag.y, this.controlPanel.duration.width, 0));
			_mediaProxy.eventDispatcher.removeEventListener("play_status_changed", updateControlPanel);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onStopDrag);
		}
		
		
		private function onEnterFrame(e:Event):void{
			var time:Number = (this.controlPanel.drag.x - this.controlPanel.duration.x)  / this.controlPanel.duration.width * this.duration;
			var formatTime:String = TimeUtil.swap2(Math.round(time));
			this.controlPanel.drag.tip.tf.text = formatTime;
			
		}
		
		private function onStopDrag(e:MouseEvent):void{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.controlPanel.drag.tip.visible = false;
			this.controlPanel.drag.stopDrag();
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			_mediaProxy.eventDispatcher.addEventListener("play_status_changed", updateControlPanel, false, 0, true);
			
			var time:Number = (this.controlPanel.drag.x - this.controlPanel.duration.x)  / this.controlPanel.duration.width * this.duration;
			trace(time)
			_mediaProxy.seekTo(time);
			
		}
		
		private var time:Number;
		private var load:Number;
		private var play:Number;
		private var duration:Number;
		
		public function update(data:Object):void{
			
			//this.visible = true;
			
			this.time = data.time;
			this.load = data.load;
			this.play = data.play;
			this.duration = data.total;
			
			
			this.controlPanel.drag.x = data.play * this.controlPanel.duration.width + this.controlPanel.duration.x;
			this.controlPanel.loaded.width = data.load * this.controlPanel.duration.width;
			this.controlPanel.played.width = data.play * this.controlPanel.duration.width;
			
			
		}
		
		private function updateControlPanel(e:DataObjectEvent):void{
			
			this.update(e.data);
			
			var formatTime:String = TimeUtil.swap2(Math.round(this.play * this.duration)) + "/" +  TimeUtil.swap2(Math.round(this.duration));
			
			dispatchEvent(new DataEvent("play_time_changed", false, false, formatTime));
			
			
		}
		
		public function clearEventHandler():void{
			
			stage.removeEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationChanged);
		}
		
		
		
	}
}