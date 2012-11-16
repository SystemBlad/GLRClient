package com.components
{
	import com.proxies.MediaProxy;
	import com.utils.DataObjectEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	import flash.geom.Rectangle;
	
	
	
    
	
	
	public class ControlPanelUI extends Sprite
	{
		
		var controlPanel:ControlPanel = new ControlPanel(); 
		
		var scale:Number = 1;
		
		var _mediaProxy;
		
		//this should be added after parent be added
		
		public function ControlPanelUI(m:MediaProxy)
		{
			
			_mediaProxy = m;
			
			addChild(controlPanel);
			
			
			controlPanel.playAndPause.gotoAndStop(1);
			
			controlPanel.playAndPause.addEventListener(MouseEvent.CLICK, playAndPauseClicked);
			
		    addEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(Event.RESIZE, onResize);
			_mediaProxy.eventDispatcher.addEventListener("play_status_changed", updateControlPanel, false, 0, true);

			
			
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
			
			this.controlPanel.back.width = this.stage.stageWidth * scale;
			
			var scaleChange:Number = this.controlPanel.back.width / oW;
			
			this.scaleChange = scaleChange;
			
			this.controlPanel.duration.width = this.controlPanel.duration.width * scaleChange;
			
			this.controlPanel.drag.addEventListener(MouseEvent.MOUSE_DOWN, onStartDrag);
			this.controlPanel.drag.addEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationChanged, false, 0, true);
			
			
		}
		
		private function onResize(e:Event):void{
			
			var oW:Number = this.controlPanel.back.width;
			
			this.controlPanel.back.width = this.stage.stageWidth * scale;
			
			var scaleChange:Number = this.controlPanel.back.width / oW;
			
			this.scaleChange = scaleChange;
			
			this.controlPanel.duration.width = this.controlPanel.duration.width * scaleChange;
			
			
			
			
		}
		
		private function orientationChanged(e:StageOrientationEvent):void{
			
			var oW:Number = this.controlPanel.back.width;
			
			this.controlPanel.back.width = this.stage.stageWidth * scale;
			
			var scaleChange:Number = this.controlPanel.back.width / oW;
			
			this.scaleChange = scaleChange;
			
			this.controlPanel.duration.width = this.controlPanel.duration.width * scaleChange;
			
			
			
			
		}
		
		
		private function onStartDrag(e:MouseEvent):void{
		    
			this.controlPanel.drag.startDrag(false, new Rectangle(this.controlPanel.duration.x, this.controlPanel.drag.y, this.controlPanel.duration.width, 0));
			_mediaProxy.eventDispatcher.removeEventListener("play_status_changed", updateControlPanel);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onStopDrag);
		}
		
		
		private function onStopDrag(e:MouseEvent):void{
			
			this.controlPanel.drag.stopDrag();
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onStopDrag);
			_mediaProxy.eventDispatcher.addEventListener("play_status_changed", updateControlPanel, false, 0, true);
			
			var time:Number = this.controlPanel.drag.x / this.controlPanel.duration.width * this.duration;
			trace(time)
			_mediaProxy.seekTo(time);
			
		}
		
		var time;
		var load;
		var play;
		var duration;
		
		public function update(data:Object):void{
			
			//this.visible = true;
			
			this.time = data.time;
			this.load = data.load;
			this.play = data.play;
			this.duration = data.total;
			
			
			this.controlPanel.drag.x = data.play * this.controlPanel.duration.width;
			this.controlPanel.loaded.width = data.load * this.controlPanel.duration.width;
			this.controlPanel.played.width = data.play * this.controlPanel.duration.width;
			
			
		}
		
		private function updateControlPanel(e:DataObjectEvent):void{
			
			this.update(e.data);
			
		}
		
		public function clearEventHandler():void{
			
			stage.removeEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationChanged);
		}
		
		
		
	}
}