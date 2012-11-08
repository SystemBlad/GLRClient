package com
{
	import com.components.*;
	import com.proxies.ActionProxy;
	import com.proxies.ConfigProxy;
	import com.proxies.MediaProxy;
	import com.utils.DataObjectEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class GLRPlayer extends Sprite
	{
		var _url;
		
		var configProxy:ConfigProxy;
		var actionProxy:ActionProxy;
		var mediaProxy:MediaProxy;
		
		var pageContainer:PageContanier;
		var penContainer:PenContainer;
		
		var loadingPage:LoadingPage;
		
		var controlPanel:ControlPanelUI;
		
		public function GLRPlayer(url:String)
		{
			super();
			
			_url = url;
			
			
			pageContainer = new PageContanier();
			penContainer = new PenContainer();
			loadingPage = new LoadingPage();
			
			addChild(pageContainer);
			addChild(penContainer);
			
			addChild(loadingPage);
			
			
			
			pageContainer.addEventListener("page_loaded", onPageLoaded);
			this.addEventListener(Event.ADDED_TO_STAGE, onAdd);
			
			configProxy = new ConfigProxy(_url);
			configProxy.loader.addEventListener(Event.COMPLETE, configLoaded);
			
			
		}
		
		private function onAdd(e:Event):void{
			
			
			
		}
		
		private function onPageLoaded(e:Event):void{
			
			trace("page Loaded sclae")
			if(this.contains(this.loadingPage))
			removeChild(this.loadingPage);
			var scale = (this.stage.stageWidth/pageContainer.content.width);
			
			
			
			pageContainer.scaleX = scale;
			pageContainer.scaleY = scale;
			penContainer.scaleX = scale;
			penContainer.scaleY = scale;
			
		}
		
		
		private function configLoaded(e:Event):void{
			
			
			
			actionProxy = new ActionProxy(configProxy.action_path);
			actionProxy.loader.addEventListener(Event.COMPLETE, actionLoaded);
			
			
		}
		
		private function  actionLoaded(e:Event):void{
			
			mediaProxy = new MediaProxy(configProxy.flv_path, actionProxy, pageContainer, penContainer);
			
			
			controlPanel = new ControlPanelUI(mediaProxy);
			addChild(controlPanel);
			controlPanel.visible = false;
			
		}
		
		public function exit():void{
			if (mediaProxy)
				mediaProxy.closeStream();
			
		}
		
		
		
	}
}