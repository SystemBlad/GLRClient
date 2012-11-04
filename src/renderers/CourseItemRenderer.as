package renderers
{
	import spark.components.IconItemRenderer;

	public class CourseItemRenderer extends IconItemRenderer
	{
		public function CourseItemRenderer()
		{
		}
		
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			var hasMessage:Boolean = messageDisplay && messageDisplay.text != "";
			
			var paddingLeft:Number   = getStyle("paddingLeft");
			var paddingRight:Number  = getStyle("paddingRight");
			var paddingTop:Number    = getStyle("paddingTop");
			var paddingBottom:Number = getStyle("paddingBottom");
			var horizontalGap:Number = getStyle("horizontalGap");
			var verticalGap:Number   = (hasMessage) ? getStyle("verticalGap") : 5;
			
			setElementPosition(labelDisplay, labelDisplay.x, paddingTop+10);
			setElementPosition(messageDisplay, messageDisplay.x, unscaledHeight - paddingBottom - 52);
		}
	}
}