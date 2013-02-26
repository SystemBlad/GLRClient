package com.components
{
	import com.proxies.LiveMediaProxy;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.display.Sprite;
	import mx.core.FlexGlobals;
	import flash.events.StageOrientationEvent;
	
	public class LiveControlPanelUI extends Sprite
	{
		
		
		public var realHeight:Number;
		
		private var controlPanel:ControlPanel = new ControlPanel(); 
		
		private var scale:Number = 0.6;
		
		private var _mediaProxy:LiveMediaProxy;
		
		private var _photoLoader:Loader = new Loader();
		private var scaleChange:Number;
		
		public function LiveControlPanelUI(proxy:LiveMediaProxy)
		{
			super();
		}
		
		
		private function onAdded(e:Event):void{
			
			var oW:Number = this.controlPanel.back.width;
			
			this.controlPanel.back.width = FlexGlobals.topLevelApplication.width;//this.stage.stageWidth;
			this.controlPanel.volume.x = FlexGlobals.topLevelApplication.width - this.controlPanel.volume.width;//this.stage.stageWidth - this.controlPanel.volume.width;
			var scaleChange:Number = this.controlPanel.back.width / oW;
			
			this.scaleChange = scaleChange;
			
			this.controlPanel.duration.width = this.controlPanel.duration.width * scaleChange;
			
			this.controlPanel.duration.x = this.controlPanel.duration.x * scaleChange;
			
			
			this.controlPanel.drag.x = 0 + this.controlPanel.duration.x;
			this.controlPanel.drag.tip.visible = false;
			this.controlPanel.loaded.width = 0;
			this.controlPanel.played.width = 0;
			this.controlPanel.loaded.x = this.controlPanel.duration.x;
			
			this.controlPanel.played.x = this.controlPanel.duration.x;
			
			
			
			this._photoLoader.x = FlexGlobals.topLevelApplication.width - 100 - 20;
			
			this._photoLoader.y = FlexGlobals.topLevelApplication.height - this.controlPanel.back.height - 100 - 20;
			
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
		
		
		public function clearEventHandler():void{
			
			stage.removeEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationChanged);
		}
		
	}
}