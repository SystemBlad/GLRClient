package renderers
{
	import flash.events.Event;
	
	import mx.controls.Spacer;
	import mx.formatters.DateFormatter;
	import mx.graphics.BitmapScaleMode;
	
	import spark.components.HGroup;
	import spark.components.IconItemRenderer;
	import spark.components.Label;
	import spark.components.VGroup;
	import spark.primitives.BitmapImage;

	public class CourseItemRenderer extends IconItemRenderer
	{
		private var vgroup:VGroup;
		private var lblSpeaker:Label;
		private var lblPopularity:Label;
		private var lblButton:Label;
		private var lblStatus:Label;
		
		[Embed(source="assets/small-icon-popularity.png")]
		private var pIcon:Class;
		
		public function CourseItemRenderer()
		{
		}
		
		override protected function createChildren():void
		{
			super.createChildren();

			vgroup = new VGroup();
			vgroup.gap = 10;
			addChild(vgroup);
			
			var hgroup:HGroup = new HGroup();
			hgroup.percentWidth = 100;
			hgroup.height = 26;
			vgroup.addElement(hgroup);
			
			lblSpeaker = new Label();
			lblSpeaker.styleName = "courseListItemMessage";
			hgroup.addElement(lblSpeaker);
			
			var spacer:Spacer = new Spacer();
			spacer.percentWidth = 100;
			hgroup.addElement(spacer);
			
			var picon:BitmapImage = new BitmapImage();
			picon.source = pIcon;
			picon.scaleMode = mx.graphics.BitmapScaleMode.STRETCH;
			hgroup.addElement(picon);
			
			lblPopularity = new Label();
			lblPopularity.styleName = "courseListItemMessage";
			lblPopularity.percentHeight = 100;
			hgroup.addElement(lblPopularity);
			
			hgroup = new HGroup();
			hgroup.percentWidth = 100;
			vgroup.addElement(hgroup);
			
			lblButton = new Label();
			lblButton.styleName = "courseListItemMessage";
			hgroup.addElement(lblButton);
			
			spacer = new Spacer();
			spacer.percentWidth = 100;
			hgroup.addElement(spacer);
			
			lblStatus = new Label();
			lblStatus.styleName = "courseListItemMessage";
			lblStatus.setStyle("color", "#FF0000");
			hgroup.addElement(lblStatus);
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
			//setElementPosition(messageDisplay, messageDisplay.x, unscaledHeight - paddingBottom - 52);
			if (messageDisplay)
				messageDisplay.visible = messageDisplay.includeInLayout = false;
			
			// layout hgroup
			setElementSize(vgroup, getLayoutBoundsWidth()-iconDisplay.getLayoutBoundsWidth()-paddingLeft-paddingRight-horizontalGap, 58);
			setElementPosition(vgroup, iconDisplay.getLayoutBoundsWidth()+paddingLeft+horizontalGap, unscaledHeight - paddingBottom - 58);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (data)
			{
				lblSpeaker.text = "主讲人："+data.teacher_realname;
				lblPopularity.text = data.viewnum;
				lblButton.text = data.button_txt == '观看视频' ? '免费观看' : data.button_txt;
				lblStatus.text = (data.button_txt == '观看视频' ? '' : data.button_txt);
				
				var date:Date = new Date();
				date.setTime(Number(data.start_time)*1000);
				var df:DateFormatter = new DateFormatter();
				df.formatString = "YY年MM月DD日 JJ:NN";
				lblButton.text = df.format(date);
				
				switch (data.button_txt)
				{
					case "正在直播":
						lblButton.styleName = "courseListItemMessageLive";
						break;
					case "即将直播":
						lblButton.styleName = "courseListItemMessage";
						break
					default:
						lblButton.styleName = "courseListItemMessageWatchable";
						break;
				}
			}
		}
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if (down || selected)
			{
				graphics.beginFill(0x95CDE7, 1);
				graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
				graphics.endFill();
			}
			else
				super.drawBackground(unscaledWidth, unscaledHeight);
		}
	}
}