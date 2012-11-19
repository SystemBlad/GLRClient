package renderers
{
	import flash.geom.Rectangle;
	
	import mx.controls.Spacer;
	import mx.core.BitmapAsset;
	import mx.events.ResizeEvent;
	import mx.formatters.DateFormatter;
	
	import spark.components.Group;
	import spark.components.IconItemRenderer;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.VGroup;
	import spark.components.supportClasses.StyleableTextField;
	import spark.filters.DropShadowFilter;
	import spark.primitives.BitmapImage;

	public class MessageItemRenderer extends IconItemRenderer
	{
		private var group:Group;
		
		[Embed(source="assets/dialog-field.png",  
               scaleGridTop="20",scaleGridBottom="48",
               scaleGridLeft="20",scaleGridRight="230")]
		[Bindable]
		private var pIcon:Class;
		
		public function MessageItemRenderer()
		{
			mouseEnabled = false;
		}
		
		override protected function createChildren():void
		{
			group = new Group();
			addChild(group);
			
			var picon:BitmapImage = new BitmapImage();
			picon.source = pIcon;
			picon.percentWidth = 100;
			picon.percentHeight = 100;
			group.addElement(picon);
			
			super.createChildren();
			
			this.filters = [new DropShadowFilter(6, 45, 0, 0.7, 8, 8)];
		}
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			//super.drawBackground(unscaledWidth, unscaledHeight);
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			
			invalidateDisplayList();
			invalidateSize();
		}
		
		override protected function measure():void{
			super.measure();
			var paddingTop:Number    = 10;	//getStyle("paddingTop");
			var paddingBottom:Number = 10;	//getStyle("paddingBottom");
			
			measuredHeight = messageDisplay.height + paddingTop + paddingBottom;
			height = measuredHeight;
			trace(messageDisplay.text+", "+height);
		}
		
		override protected function createMessageDisplay():void
		{
			super.createMessageDisplay();
			messageDisplay.mouseEnabled = false;
			messageDisplay.wordWrap = true;
		}
		
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.layoutContents(unscaledWidth, unscaledHeight);
			trace('unscaledWidth='+unscaledWidth+', unscaleHeight='+unscaledHeight);
			if (width == 0) return;
			
			var paddingLeft:Number   = 10;	//getStyle("paddingLeft");
			var paddingRight:Number  = 10;	//getStyle("paddingRight");
			var paddingTop:Number    = 10;	//getStyle("paddingTop");
			var paddingBottom:Number = 10;	//getStyle("paddingBottom");
			var horizontalGap:Number = 10;	//getStyle("horizontalGap");
			
			setElementPosition(iconDisplay, paddingLeft, paddingTop);
			
			// messageDisplay
			setElementPosition(messageDisplay, paddingLeft+iconDisplay.width+horizontalGap+20, paddingTop+10);
			setElementSize(messageDisplay, Math.min(messageDisplay.getPreferredBoundsWidth(), this.width - messageDisplay.x - paddingRight), messageDisplay.getPreferredBoundsHeight());
			
			// group
			setElementPosition(group, paddingLeft+iconDisplay.width+horizontalGap, paddingTop);
			setElementSize(group,
				messageDisplay.width+27,
				messageDisplay.height+14);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (labelDisplay)
				labelDisplay.visible = false;
		}
	}
}