package interfaces
{
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	
	import mx.core.UIComponent;
	
	public interface IVOD extends IEventDispatcher
	{
		function get isShowBar():Boolean;
		function get controlBar():Sprite;
		
		function start(url:String, data:Object):void;
		function exit():void;
	}
}