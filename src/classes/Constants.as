package classes
{
	public class Constants
	{
		public static var LOGIN_URL:String = "http://www.glr.cn/appapi/app_login.php";
		public static var GET_COURSE_LIST_URL:String = "http://www.glr.cn/appapi/app_course_list.php";
		public static var GET_COURSE_DETAIL_URL:String = "http://www.glr.cn/appapi/app_course_detail.php";
		
		public static var TYPE_HISTORY:String = "history";
		public static var TYPE_FAVORITE:String = "favorite";
		public static var TYPE_DOWNLOAD:String = "download";
		public static var TYPE_REGISTER:String = "register";
		
		[Bindable]
		public static var COURSE_STATUS_UNAVAILABLE:String = "unavailable";
		[Bindable]
		public static var COURSE_STATUS_LIVE:String = "live";
		[Bindable]
		public static var COURSE_STATUS_CONVERTING:String = "converting";
		[Bindable]
		public static var COURSE_STATUS_AVAILABLE:String = "available";
	}
}