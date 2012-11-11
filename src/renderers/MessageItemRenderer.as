package renderers
{
	import mx.controls.Spacer;
	import mx.formatters.DateFormatter;
	
	import spark.components.Group;
	import spark.components.IconItemRenderer;
	import spark.components.Label;
	import spark.components.VGroup;
	import spark.filters.DropShadowFilter;
	import spark.primitives.BitmapImage;

	public class MessageItemRenderer extends IconItemRenderer
	{
		private var group:Group;
		private var lblName:Label;
		private var lblWord:Label;
		
		[Embed(source="assets/dialog-field.png")]
		private var pIcon:Class;
		
		public function CourseItemRenderer()
		{
		}
		
		override protected function createChildren():void
		{
			super.createChildren();

			this.mouseEnabled = false;
			
			this.filters = [new DropShadowFilter(6, 45, 0, 0.7, 8, 8)];
			
		    group = new Group();
			group.percentWidth = 100;
			group.height = 60;
			addChild(group);
			
		
			var picon:BitmapImage = new BitmapImage();
			picon.source = pIcon;
			group.addElement(picon);
			
			
			lblWord = new Label();
			
			lblWord.width = 241;
			lblWord.height = 58;
		
			
			
			lblWord.styleName = "messageListItem";
			group.addElement(lblWord);
			
		
		
		
		
		}
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
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
			//setElementPosition(messageDisplay, messageDisplay.x, unscaledHeight - paddingBottom - 52);
			if (messageDisplay)
				messageDisplay.visible = messageDisplay.includeInLayout = false;
			
			// layout hgroup
			setElementSize(group, getLayoutBoundsWidth()-iconDisplay.getLayoutBoundsWidth()-paddingLeft-paddingRight-horizontalGap, 58);
			setElementPosition(group, iconDisplay.getLayoutBoundsWidth()+paddingLeft+horizontalGap, unscaledHeight - paddingBottom - 58);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (data)
			{
				//lblName.text = data.value.value;
				lblWord.text = data.value.value;
			
				var date:Date = new Date();
				date.setTime(Number(data.start_time)*1000);
				var df:DateFormatter = new DateFormatter();
				df.formatString = "YY年MM月DD日 JJ:NN";
				//lblButton.text = df.format(date);
				
			
			}
		}
	}
}