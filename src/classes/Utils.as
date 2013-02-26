package classes
{
	import mx.formatters.DateFormatter;

	public class Utils
	{
		public static function adjustBrightness2(rgb:uint, brite:Number):uint
		{
			var r:Number;
			var g:Number;
			var b:Number;
			
			if (brite == 0)
				return rgb;
			
			if (brite < 0)
			{
				brite = (100 + brite) / 100;
				r = ((rgb >> 16) & 0xFF) * brite;
				g = ((rgb >> 8) & 0xFF) * brite;
				b = (rgb & 0xFF) * brite;
			}
			else // bright > 0
			{
				brite /= 100;
				r = ((rgb >> 16) & 0xFF);
				g = ((rgb >> 8) & 0xFF);
				b = (rgb & 0xFF);
				
				r += ((0xFF - r) * brite);
				g += ((0xFF - g) * brite);
				b += ((0xFF - b) * brite);
				
				r = Math.min(r, 255);
				g = Math.min(g, 255);
				b = Math.min(b, 255);
			}
			
			return (r << 16) | (g << 8) | b;
		}
		
		public static function getTimeDuration(start_time:Object, over_time:Object):String
		{
			var date:Date = new Date();
			date.setTime(Number(start_time)*1000);
			var df:DateFormatter = new DateFormatter();
			df.formatString = "MM月DD日 JJ:NN";
			
			var ret:String = df.format(date);
			date.setTime(Number(over_time)*1000);
			df.formatString = "JJ:NN";
			return ret + " - " + df.format(date);
		}
		
		public static function getFileSize(size:Number):String
		{
			
			var m:Number = Math.floor(size/(1024*1024));
			if (m > 0) {
				size = size - m * 1024 * 1024;
				var mm:Number = Math.round(size*100/(1024*1024));
				mm = Math.min(99, mm);
				return (mm<=0 ? m : m+"."+mm) + "MB";
			}
			else
				return Math.round(size/1024) + "KB";
		}
		
		public static function getHtmlPlainText(html:String):String
		{
			if (html) {
				html = html.split('&amp;').join('&');
				html = html.split('&gt;').join('>');
				html = html.split('&lt;').join('<');
				html = html.split('&nbsp;').join(' ');
			}
			return html;
		}
	}
}