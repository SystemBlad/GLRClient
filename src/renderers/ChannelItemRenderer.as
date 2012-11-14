package renderers
{
	import events.ChannelChangeEvent;
	
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import spark.components.Group;
	import spark.components.IconItemRenderer;
	import spark.components.Label;
	import spark.components.List;
	import spark.components.TileGroup;
	
	[Event(name="channelChangeEvent", type="events.ChannelChangeEvent")]
	public class ChannelItemRenderer extends IconItemRenderer
	{
		private var group:Group;
		private var subChannelSelected:Boolean;
		
		public function ChannelItemRenderer()
		{
			super();
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			
			group.removeAllElements();
			for (var i:int=0; i<data.channels.length; i++)
			{
				var label:Label = new Label();
				label.text = data.channels[i].videoname;
				label.styleName = "subChannelItem";
				label.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				label.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				label.addEventListener(MouseEvent.CLICK, onSubChannelClicked);
				group.addElement(label);
			}
			
			invalidateDisplayList();
			invalidateSize();
		}
		
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			if (!group)
			{
				group = new Group();
				addChild(group);
			}
			addEventListener(MouseEvent.CLICK, onChannelClicked);
		}
		
		override protected function measure():void
		{
			var paddingTop:Number    = getStyle("paddingTop");
			var paddingBottom:Number = getStyle("paddingBottom");
			var verticalGap:Number   = 20;
			
			measuredHeight = labelDisplay.height + group.height + paddingTop + paddingBottom;
		}
		
		override protected function layoutContents(w:Number, h:Number):void
		{
			super.layoutContents(w, h);
			
			var paddingLeft:Number   = getStyle("paddingLeft");
			var paddingRight:Number  = getStyle("paddingRight");
			var paddingTop:Number    = getStyle("paddingTop");
			var paddingBottom:Number = getStyle("paddingBottom");
			var horizontalGap:Number = getStyle("horizontalGap");
			var verticalGap:Number   = 20;
			
			var desireWidth:Number = width - paddingLeft - paddingRight - horizontalGap;
			if (decoratorDisplay)
				desireWidth -= decoratorDisplay.width;
			
			var x:Number = 0;
			var y:Number = 0;
			for (var i:int=0; i<group.numElements; i++)
			{
				var label:Label = Label(group.getElementAt(i));
				label.width = label.measureText(label.text).width + 40;
				label.height = 48;
				
				if (x + label.width > desireWidth)
				{
					x = 0;
					y += label.height + verticalGap;
				}
				label.x = x;
				label.y = y;
				
				x += label.width + horizontalGap;
				//trace('x='+label.x+', width='+label.getPreferredBoundsWidth()+', label='+label.text);
			}
			
			
			setElementPosition(labelDisplay, paddingLeft, paddingTop);
			
			setElementSize(group, desireWidth, y + 48);
			setElementPosition(group, paddingLeft, paddingTop + labelDisplay.height);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
		}
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if (down)
			{
				graphics.beginFill(0x95CDE7, 1);
				graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
				graphics.endFill();
			}
			else
				super.drawBackground(unscaledWidth, unscaledHeight);
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			Label(event.target).setStyle("backgroundColor", "#EC9A2B");
			event.stopPropagation();
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
		}
		
		private function onChannelClicked(event:MouseEvent):void
		{
			if (data && !subChannelSelected)
			{
				var evt:ChannelChangeEvent = new ChannelChangeEvent(Number(data.videoid), data.videoname);
				owner.dispatchEvent(evt);
			}
		}
		
		private function onSubChannelClicked(event:MouseEvent):void
		{
			var label:Label = Label(event.target);
			
			var idx:Number = group.getElementIndex(label);
			var evt:ChannelChangeEvent = new ChannelChangeEvent(Number(data.channels[idx].videoid), data.channels[idx].videoname);
			owner.dispatchEvent(evt);
			
			subChannelSelected = true;
			setTimeout(function():void{subChannelSelected = false;}, 300);
		}
	}
}