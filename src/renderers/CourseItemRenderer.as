package renderers
{
	import mx.controls.Spacer;
	
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
			hgroup.addElement(picon);
			
			lblPopularity = new Label();
			lblPopularity.styleName = "courseListItemMessage";
			lblPopularity.percentHeight = 100;
			hgroup.addElement(lblPopularity);
			
			lblButton = new Label();
			lblButton.styleName = "courseListItemMessage";
			vgroup.addElement(lblButton);
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
				lblButton.text = data.button_txt;
				
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
	}
}