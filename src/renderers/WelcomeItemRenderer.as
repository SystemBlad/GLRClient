package renderers
{
	import mx.core.FlexGlobals;
	
	import spark.components.supportClasses.ItemRenderer;
	import spark.primitives.BitmapImage;
	
	public class WelcomeItemRenderer extends ItemRenderer
	{
		public function WelcomeItemRenderer()
		{
			super();
		}
		
		private var _bitmap:BitmapImage;
		
		override public function set data(value:Object):void
		{
			super.data = value;
			
			invalidateDisplayList();
		}
		
		override protected function createChildren():void
		{
			_bitmap = new BitmapImage();
			_bitmap.width = FlexGlobals.topLevelApplication.width;
			_bitmap.height = FlexGlobals.topLevelApplication.height;
			_bitmap.scaleMode = "stretch";
			addElement(_bitmap);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			_bitmap.source = data.pic;
		}
	}
}