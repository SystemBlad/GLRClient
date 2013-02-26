package classes
{
	import air.net.URLMonitor;
	
	import com.juankpro.ane.localnotif.Notification;
	import com.juankpro.ane.localnotif.NotificationEvent;
	import com.juankpro.ane.localnotif.NotificationManager;
	
	import events.NetworkChangeEvent;
	
	import flash.events.StatusEvent;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
	import models.Course;
	import models.Download;
	import models.User;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.formatters.DateFormatter;
	
	import spark.managers.PersistenceManager;

	public class DataManager
	{
		private static var _instance:DataManager;
		
		[Bindable]
		public var user:User;
		public var persistenceManager:PersistenceManager;
		
		[Bindable]
		public var downloads:ArrayCollection = new ArrayCollection();
		
		private var notificationManager:NotificationManager;
		private var courseNotificationIDsPool:ArrayCollection;
		private var monitor:URLMonitor;
		private var _online:Boolean = true;
		
		public function DataManager()
		{
			flash.net.registerClassAlias("course", models.Course);
			
			this.user = new User();
			this.persistenceManager = new PersistenceManager();
			persistenceManager.load();
			this.courseNotificationIDsPool = new ArrayCollection();
			
			if (NotificationManager.isSupported)
			{
				notificationManager = new NotificationManager();
				notificationManager.addEventListener(NotificationEvent.NOTIFICATION_ACTION, notificationActionHandler);
				cancelAllNotifications();
			}
			
			// populate downloads
			var courses:Vector.<Course> = getCoursesByType(Constants.TYPE_DOWNLOAD);
			if (courses) {
				for (var i:int=0; i<courses.length; i++) {
					courses[i].editing = false;
					downloads.addItem(courses[i]);
				}
			}
		}
		
		public function setupMonitor():void {
			monitor = new URLMonitor(new URLRequest('http://www.glr.cn'));
			monitor.addEventListener(StatusEvent.STATUS, handleMonitorChange);
			monitor.start();
		}
		
		private function handleMonitorChange(event:StatusEvent):void {
			trace('monitor.available=', monitor.available);
			_online = monitor.available;
			EventManager.instance.dispatchEvent(new NetworkChangeEvent(monitor.available));
		}
		
		public function get online():Boolean {
			return _online;
			//return (monitor && monitor.available);
		}
		
		private function notificationActionHandler(event:NotificationEvent):void
		{
			trace("Notification Code: " + event.notificationCode + ", Sample Data: {" + event.actionData.sampleData + "}");
		}
		
		public static function get instance():DataManager
		{
			if (!_instance)
				_instance = new DataManager();
			return _instance;
		}
		
		public function getCourseDownloadStatus(courseid:Number):Number
		{
			for (var i:int=0; i<downloads.length; i++) {
				var item:Object = downloads.getItemAt(i);
				trace('param id=', courseid, ', current id=', item.courseid);
				if (item.courseid == courseid) {
					if (item is Course) {
						return CourseDownloadStatus.DOWNLOADED;
					}
					else if (item is Download) {
						switch ((item as Download).status) {
							case DownloadStatus.CANCELLED:
								return CourseDownloadStatus.NOT_DOWNLOADED;
							case DownloadStatus.COMPLETED:
								return CourseDownloadStatus.DOWNLOADED;
							default:
								return CourseDownloadStatus.DOWNLOADING;
						}
					}
				}
			}
			return CourseDownloadStatus.NOT_DOWNLOADED;
		}
		
		public function getCoursesByType(type:String):Vector.<Course>
		{
			var courses:Vector.<Course> =  persistenceManager.getProperty(type) as Vector.<Course>;
			return courses;
		}
		
		public function insertCourse(type:String, subject:String, kvideoid:Number, courseid:Number, pic:String, avatar:String, duration:Number=0, watchSpot:Number=0):void
		{
			var course:Course = new Course();
			course.subject = Utils.getHtmlPlainText(subject);
			course.courseid = courseid;
			course.kvideoid = kvideoid;
			course.picUrl = pic;
			course.avatarUrl = avatar;
			course.duration = duration;
			course.watchSpot = watchSpot;
			
			var courses:Vector.<Course> = persistenceManager.getProperty(type) as Vector.<Course>;
			if (!courses)
			{
				courses = new Vector.<Course>();
			}
			else
			{
				for (var i:int=0; i<courses.length; i++)
				{
					if (courses[i].courseid == course.courseid)
					{
						courses.splice(i, 1);
						break;
					}
				}
			}
			courses.push(course);
			persistenceManager.setProperty(type, courses);
			persistenceManager.save();
		}
		
		public function deleteCourseById(type:String, courseid:Number):void
		{
			var courses:Vector.<Course> = persistenceManager.getProperty(type) as Vector.<Course>;
			if (courses && courseid)
			{
				for (var i:int=0; i<courses.length; i++)
				{
					if (courses[i].courseid == courseid)
					{
						courses.splice(i, 1);
						persistenceManager.setProperty(type, courses);
						persistenceManager.save();
						break;
					}
				}
			}
		}
		
		public function clearCourse(type:String):void
		{
			persistenceManager.setProperty(type, null);
			persistenceManager.save();
		}
		
		public function isCourseOfType(type:String, courseid:Number):Boolean
		{
			var courses:Vector.<Course> = persistenceManager.getProperty(type) as Vector.<Course>;
			if (courses && courseid)
			{
				for (var i:int=0; i<courses.length; i++)
				{
					if (courses[i].courseid == courseid)
					{
						return true;
					}
				}
			}
			return false;
		}
		
		// notifications
		protected function cancelAllNotifications():void
		{
			if (notificationManager)
			{
				notificationManager.applicationBadgeNumber = 0;
				notificationManager.cancelAll();
				courseNotificationIDsPool.removeAll();
			}
		}
		
		public function scheduleCourseNotification(course:Object):void
		{
			var kvideoid:Number = Number(course.kvideoid);
			if (courseNotificationIDsPool.getItemIndex(kvideoid) > -1)
				return;
			
			var date:Date = new Date();
			var diffSeconds:Number = Number(course.start_time) - Math.floor(date.getTime()/1000);
			if (diffSeconds <= 1) return;
			diffSeconds = Math.min(diffSeconds, 30*60);
			
			// schedule noti
			courseNotificationIDsPool.addItem(kvideoid);
			var desireDate:Date = new Date();
			desireDate.setTime(Number(course.start_time) * 1000);
			var fireDate:Date = new Date();
			fireDate.setTime((Number(course.start_time) - diffSeconds) * 1000);
			
			
			var df:DateFormatter = new DateFormatter();
			df.formatString = "JJ:NN";
			//trace(course.subject, 'fire at: ', df.format(fireDate));
			//trace(course.subject, 'live on: ', df.format(desireDate));
			
			if (notificationManager)
			{
				df.formatString = "JJ:NN";
				var notification:Notification = new Notification();
				notification.actionLabel = "OK";
				notification.body = course.teacher_realname + "老师的" + course.subject + "将在" + df.format(desireDate) + "开始直播";
				notification.fireDate = fireDate;
				notification.numberAnnotation = 1;
				notification.actionData = {sampleData:"Hello World!"};
				
				notificationManager.notifyUser(kvideoid.toString(), notification);
			}
		}
	}
}