package components
{
	import mx.core.DPIClassification;
	import mx.core.mx_internal;
	
	import spark.preloaders.SplashScreen;
	
	use namespace mx_internal;

	public class MultiDPISplashScreen extends SplashScreen
	{
		[Embed(source="Default.png")]
		private var SplashImage160:Class;
		
		[Embed(source="Default@2x.png")]
		private var SplashImage320:Class;
		
		public function MultiDPISplashScreen()
		{
			super();
		}
		
		override mx_internal function getImageClass(aspectRatio:String, dpi:Number, resolution:Number):Class
		{
			if (dpi == DPIClassification.DPI_160)
				return SplashImage160;
			else if (dpi == DPIClassification.DPI_320)
				return SplashImage320;
			return null;
		}
	}
}