package components
{
	import events.TapEvent;
	
	import flash.events.MouseEvent;
	
	import spark.components.Group;
	
	[Event(name="tap", type="events.TapEvent")]
	public class TapGroup extends Group
	{
		private var moved:Boolean = false;
		private var startX:Number = 0;
		private var startY:Number = 0;
		private var startTime:Number;
		
		public function TapGroup()
		{
			super();
			
			addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
		}
		
		private function handleMouseDown(event:MouseEvent):void
		{
			this.moved = false;
			this.startX = event.localX;
			this.startY = event.localY;
			
			var date:Date = new Date();
			this.startTime = date.getTime();
			
			addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
		}
		
		private function handleMouseMove(event:MouseEvent):void
		{
			var x:Number = event.localX;
			var y:Number = event.localY;
			
			if (Math.abs(x - this.startX) > 10 || Math.abs(y = this.startY) > 10)
				this.moved = true;
		}
		
		private function handleMouseUp(event:MouseEvent):void
		{
			var date:Date = new Date();
			if (!this.moved && date.getTime() - this.startTime > 20)
			{
				var evt:TapEvent = new TapEvent();
				evt.locationX = event.localX;
				evt.locationY = event.localY;
				dispatchEvent(evt);
			}
			
			removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
		}
	}
}