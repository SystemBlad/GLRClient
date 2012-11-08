package com.components
{
	import flash.display.Loader;
	import flash.events.Event;
	
	public class PageContanier extends Loader
	{
		public function PageContanier()
		{
			super();
			
			
			this.addEventListener(Event.COMPLETE, loadContentFinish, false, 0, true);
			
		}
		
		
		private function loadContentFinish(e:Event):void{
			
			//trace("LOADED")
			
			//dispatchEvent(new Event("page_loaded"));
			
			
		}
	}
}