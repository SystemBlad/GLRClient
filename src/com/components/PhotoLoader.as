package com.components
{
	import flash.display.Loader;
	import flash.events.Event;
	import com.greensock.TweenLite;
	
	public class PhotoLoader extends Loader
	{
		public function PhotoLoader()
		{
			super();
			this.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
		}
		
		private function onLoaded(e:Event):void{
			
			TweenLite.to(this, 1, {alpha:0.5, onComplete: tween1})
			
			
		}
		
		private function tween1():void{
			
			TweenLite.to(this, 1, {alpha:1, onComplete: tween2});
			
		}
		
		private function tween2():void{
			
			TweenLite.to(this, 1, {alpha:0.5, onComplete: tween1});
			
		}
	}
}