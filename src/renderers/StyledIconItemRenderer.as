package renderers
{
	import flash.display.GradientType;
	import flash.geom.Matrix;
	
	import mx.utils.ColorUtil;
	
	import spark.components.DataGroup;
	import spark.components.IconItemRenderer;
	import spark.components.Label;
	
	/**
	 * Border style: normal or rounded.
	 */
	[Style(name="borderStyle", inherit="no", type="String", enumeration="normal,rounded")]
	
	/**
	 * Border weight.
	 */
	[Style(name="borderWeight", inherit="no", type="Number")]
	
	/**
	 * Border weight.
	 */
	[Style(name="cornerRadius", inherit="no", type="Number")]
	
	/**
	 * Border color
	 */
	[Style(name="borderColor", inherit="no", type="Number")]
	
	/**
	 * Alpha applied to downColor, selectionColor or alternatingItemColors
	 */
	[Style(name="backgroundAlpha", inherit="no", type="Number")]
	
	public class StyledIconItemRenderer extends IconItemRenderer
	{
		private var decoratorLabel:Label;
		
		public function StyledIconItemRenderer()
		{
			super();
		}
		
		override protected function drawBackground(unscaledWidth:Number, 
												   unscaledHeight:Number):void
		{
			// omit super.drawBackground()
			
			var backgroundColor:*;
			var backgroundAlpha:Number = getStyle("backgroundAlpha");
			var opaqueBackgroundColor:* = undefined;
			var downColor:* = getStyle("downColor");
			var drawBackground:Boolean = true;
			
			var borderWeight:Number = getStyle("borderWeight");
			var borderColor:Number = getStyle("borderColor");
			
			var dataGroup:DataGroup = parent as DataGroup;
			var isLastItem:Boolean = (dataGroup && (itemIndex == dataGroup.numElements - 1));
			
			var isRounded:Boolean = getStyle("borderStyle") == "rounded";
			var cornerRadius:Number = (!isRounded) ? 0 : getStyle("cornerRadius");
			var topCornerRadius:Number = (itemIndex == 0) ? cornerRadius : 0;
			var bottomCornerRadius:Number = (isLastItem) ? cornerRadius : 0;
			
			if (down && downColor !== undefined)
			{
				backgroundColor = downColor;
			}
			else if (selected || showsCaret)
			{
				backgroundColor = getStyle("selectionColor");
			}
			else
			{
				var alternatingColors:Array;
				var alternatingColorsStyle:Object = getStyle("alternatingItemColors");
				
				if (alternatingColorsStyle)
					alternatingColors = (alternatingColorsStyle is Array) ? (alternatingColorsStyle as Array) : [alternatingColorsStyle];
				
				if (alternatingColors && alternatingColors.length > 0)
				{
					// translate these colors into uints
					styleManager.getColorNames(alternatingColors);
					
					backgroundColor = alternatingColors[itemIndex % alternatingColors.length];
				}
				else
				{
					// don't draw background if it is the contentBackgroundColor. The
					// list skin handles the background drawing for us. 
					drawBackground = false;
				}
				
			} 
			
			var topSeparatorColor:uint;
			var topSeparatorAlpha:Number;
			var bottomSeparatorColor:uint;
			var bottomSeparatorAlpha:Number;
			
			// Draw background color
			if (selected || down)
			{
				// Selected and down states have a gradient overlay as well
				// as different separators colors/alphas
				var colors:Array = [backgroundColor, ColorUtil.adjustBrightness2(backgroundColor, -20)];
				var alphas:Array = [backgroundAlpha, backgroundAlpha];
				var ratios:Array = [0, 255];
				var matrix:Matrix = new Matrix();
				
				// gradient overlay
				matrix.createGradientBox(unscaledWidth, unscaledHeight, Math.PI / 2, 0, 0 );
				graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
			}
			else
			{
				// Always draw a background for mouse hit testing
				graphics.beginFill(backgroundColor, drawBackground ? backgroundAlpha : 0);
			}
			
			if ((topCornerRadius == 0) && (bottomCornerRadius == 0) &&
				(drawBackground && backgroundAlpha >=1))
			{
				// If our background is a solid color and the item renderer is 
				// rectangular, use it as the opaqueBackground property
				// for this renderer. This makes scrolling considerably faster.
				opaqueBackgroundColor = backgroundColor;
			}
			
			// inset stroke for half-pixel alignment
			var insetBorder:Number = 0;
			
			if (isRounded)
			{
				insetBorder = borderWeight / 2;
				graphics.lineStyle(borderWeight, borderColor);
				
				// bottom border overlaps with next item renderer
				graphics.drawRoundRectComplex(insetBorder, insetBorder,
					unscaledWidth - borderWeight, unscaledHeight,
					topCornerRadius, topCornerRadius,
					bottomCornerRadius, bottomCornerRadius);
			}
			else
			{
				graphics.lineStyle();
				graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
			}
			
			graphics.endFill();
			
			if (!isRounded)
			{
				// TODO (jasonsj): replace the contents of this block with drawBorder() in 4.6
				// separators are a highlight on the top and shadow on the bottom
				topSeparatorColor = 0xFFFFFF;
				topSeparatorAlpha = .3;
				bottomSeparatorColor = 0x000000;
				bottomSeparatorAlpha = .3;
				
				// draw separators
				// don't draw top separator for down and selected states
				if (!down)
				{
					graphics.beginFill(topSeparatorColor, topSeparatorAlpha);
					graphics.drawRect(0, 0, unscaledWidth, 1);
					graphics.endFill();
				}
				
				graphics.beginFill(bottomSeparatorColor, bottomSeparatorAlpha);
				graphics.drawRect(0, unscaledHeight - (isLastItem ? 0 : 1), unscaledWidth, 1);
				graphics.endFill();
				
				// bottom
				if (isLastItem)
				{
					// we want to offset the bottom by 1 so that we don't get
					// a double line at the bottom of the list if there's a 
					// border
					graphics.beginFill(topSeparatorColor, topSeparatorAlpha);
					graphics.drawRect(0, unscaledHeight + 1, unscaledWidth, 1);
					graphics.endFill();	
				}
			}
			
			// TODO (jasonsj): https://bugs.adobe.com/jira/browse/SDK-31958 is 4.5.1 only
			// When 4.6 comes out, uncomment this line.
			// opaqueBackground = opaqueBackgroundColor;
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			if (!decoratorLabel)
			{
				decoratorLabel = new Label();
				decoratorLabel.styleName = "versionNumber";
				addChild(decoratorLabel);
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (data.version)
			{
				decoratorLabel.visible = true;
				decoratorDisplay.visible = false;
				decoratorLabel.text = data.version;
			}
			else
			{
				decoratorLabel.visible = false;
				decoratorDisplay.visible = true;
			}
		}
		
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			var paddingLeft:Number   = getStyle("paddingLeft");
			var paddingRight:Number  = getStyle("paddingRight");
			var paddingTop:Number    = getStyle("paddingTop");
			var paddingBottom:Number = getStyle("paddingBottom");
			
			setElementSize(decoratorLabel, decoratorLabel.measuredWidth, decoratorLabel.measuredHeight);
			setElementPosition(decoratorLabel, width - paddingRight - decoratorLabel.width, (height-decoratorLabel.height)/2+4);
		}
	}
}