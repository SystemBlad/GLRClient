package renderers
{
	import classes.DataManager;
	import classes.EventManager;
	import classes.Utils;
	import classes.DownloadStatus;
	
	
	import events.CourseItemEvent;
	
	import flash.events.MouseEvent;
	
	import models.Course;
	import models.Download;
	
	import spark.components.IconItemRenderer;
	import spark.components.List;
	
	import mx.binding.utils.BindingUtils;
	
	public class DownloadItemRenderer extends DeletableIconItemRenderer
	{
		public function DownloadItemRenderer()
		{
			super();
		}
		
		
		private function clickDetail(event:MouseEvent):void
		{
			var completed:Boolean = data is Course;
			if (!completed)
				completed = (data as Download).status == DownloadStatus.COMPLETED;
			if (completed) {
				var evt:CourseItemEvent = new CourseItemEvent(CourseItemEvent.Detail);
				evt.courseid = Number(data.courseid);
				evt.kvidoeid = Number(data.kvideoid);
				evt.pic = data.picUrl;
				evt.subject = Utils.getHtmlPlainText(data.subject);
				EventManager.instance.dispatchEvent(evt);
			}
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
		    this.addEventListener(MouseEvent.CLICK, clickDetail);
			
		}
		
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (data is Download) {
				var item:Download = data as Download;
			   
				if(this.messageDisplay)
				 BindingUtils.bindProperty(this.messageDisplay, 'text', item, 'statusDescription');
				
			}
			else if (data is Course) {
				if(this.messageDisplay)
				 this.messageDisplay.text  = '已完成下载';
				
			}
			
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