package com.components
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;

	public class LoadingPage extends Sprite
	{
		
		private var loading:Loading = new Loading();
		
	
		public function LoadingPage()
		{
			
			
			addChild(loading);
			addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);
			
			addEventListener(Event.RESIZE, onResize, false, 0, true);
			
			
		}
		
		private function onAdded(e:Event):void
		{
			
			trace(this.loading.width)
			this.loading.back.width = this.stage.stageWidth;
			this.loading.back.height = this.stage.stageHeight;
			this.loading.logo.x = (this.loading.back.width - this.loading.logo.width)/2;
			this.loading.logo.y = (this.loading.back.height - this.loading.logo.height)/2;
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationChanged, false, 0, true);
		
				
		}
		
		private function onResize(e:Event):void
		{
			
			trace(this.loading.width)
			if(this.stage)
			{
			 this.loading.back.width = this.stage.stageWidth;
			 this.loading.back.height = this.stage.stageHeight;
			 this.loading.logo.x = (this.loading.back.width - this.loading.logo.width)/2;
			 this.loading.logo.y = (this.loading.back.height - this.loading.logo.height)/2;
			}
			
		}
		
		private function orientationChanged(e:StageOrientationEvent):void
		{
			
			if(this.stage)
			{
			 this.loading.back.width = this.stage.stageWidth;
			 this.loading.back.height = this.stage.stageHeight;
			 this.loading.logo.x = (this.loading.back.width - this.loading.logo.width)/2;
			 this.loading.logo.y = (this.loading.back.height - this.loading.logo.height)/2;
			}
			
		}
		
	}
}