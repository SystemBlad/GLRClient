package renderers
{
	import classes.DataManager;
	import classes.EventManager;
	import classes.Utils;
	
	import events.CourseItemEvent;
	
	import flash.events.MouseEvent;
	
	import models.Course;
	
	import spark.components.IconItemRenderer;
	import spark.components.List;
	
	public class HistoryItemRenderer extends DeletableIconItemRenderer
	{
		public function HistoryItemRenderer()
		{
			super();
		}
		
		override protected function measure():void
		{
			var paddingTop:Number    = getStyle("paddingTop");
			var paddingBottom:Number = getStyle("paddingBottom");
			var verticalGap:Number   = 20;
			
			measuredHeight = 90;
		}
		
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			var paddingLeft:Number   = getStyle("paddingLeft");
			var paddingRight:Number  = getStyle("paddingRight");
			var paddingTop:Number    = getStyle("paddingTop");
			var paddingBottom:Number = getStyle("paddingBottom");
			var horizontalGap:Number = getStyle("horizontalGap");
			var verticalGap:Number   = 20;
			
			setElementPosition(labelDisplay, labelDisplay.x, paddingTop);
			setElementPosition(messageDisplay, messageDisplay.x, unscaledHeight - getElementPreferredHeight(messageDisplay) - paddingBottom);
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
		
		override protected function btnDelete_mouseDownHandler(event:MouseEvent):void
		{
			var evt:CourseItemEvent = new CourseItemEvent(CourseItemEvent.Delete);
			evt.courseid = Number(data.courseid);
			evt.kvidoeid = Number(data.kvideoid);
			evt.pic = data.picUrl;
			evt.subject = Utils.getHtmlPlainText(data.subject);
			EventManager.instance.dispatchEvent(evt);
			
			super.btnDelete_mouseDownHandler(event);
		}
	}
}