package skins
{
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.geom.Matrix;
	import classes.Utils;
	
	import spark.skins.ios.ActionBarSkin;
	import spark.skins.ios.ThemeConstants;
	
	public class MyActionBarSkin extends ActionBarSkin
	{
		private var borderSize:uint;
		
		public function MyActionBarSkin()
		{
			super();
			borderSize = 2;
		}
		
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			//super.drawBackground(unscaledWidth, unscaledHeight);
			
			var chromeColor:uint = getStyle("chromeColor");
			var backgroundAlphaValue:Number = getStyle("backgroundAlpha");
			var colors:Array = [];
			
			// apply alpha to chromeColor fill only
			var backgroundAlphas:Array = [backgroundAlphaValue, backgroundAlphaValue, backgroundAlphaValue];
			
			// exclude top and bottom 1px borders
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(unscaledWidth, unscaledHeight, Math.PI / 2, 0, 0);
			colors[0] = Utils.adjustBrightness2(chromeColor, 60);
			colors[1] = Utils.adjustBrightness2(chromeColor, 30);
			colors[2] = chromeColor;
			
			// glossy fill
			graphics.beginGradientFill(GradientType.LINEAR, colors, backgroundAlphas, [0, 127, 255], matrix);
			graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
			graphics.endFill();
			
			// top border light
			var borderInset:uint = borderWeight / 2;
			graphics.lineStyle(borderWeight, 0xFFFFFF, 0.3, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);
			graphics.moveTo(0, borderInset);
			graphics.lineTo(unscaledWidth, borderInset);
			
			// bottom border dark
			graphics.lineStyle(borderWeight, 0, 0.6, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);
			graphics.moveTo(0, unscaledHeight - borderInset);
			graphics.lineTo(unscaledWidth, unscaledHeight - borderInset);
		}
	}
}