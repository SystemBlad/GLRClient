package com.components
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class LoadingPage extends Sprite
	{
		
		var loading:Loading = new Loading();
		
	
		public function LoadingPage()
		{
			
			
			addChild(loading);
			addEventListener(Event.ADDED_TO_STAGE, onAdded);

			
		}
		
		private function onAdded(e:Event):void
		{
			
			trace(this.loading.width)
			this.loading.back.width = this.stage.stageWidth;
			this.loading.back.height = this.stage.stageHeight;
			this.loading.textField.x = (this.loading.back.width - this.loading.textField.width)/2;
			this.loading.textField.y = (this.loading.back.height - this.loading.textField.height)/2;
		
				
		}
		
	}
}