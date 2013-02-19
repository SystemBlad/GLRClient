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
	import models.User;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.formatters.DateFormatter;

	public class DataManager
	{
		private static var _instance:DataManager;
		
		[Bindable]
		public var user:User;
		
		
		private var notificationManager:NotificationManager;
		private var courseNotificationIDsPool:ArrayCollection;
		private var monitor:URLMonitor;
		
		public function DataManager()
		{
			this.user = new User();
			this.courseNotificationIDsPool = new ArrayCollection();
			
			if (NotificationManager.isSupported)
			{
				notificationManager = new NotificationManager();
				notificationManager.addEventListener(NotificationEvent.NOTIFICATION_ACTION, notificationActionHandler);
				cancelAllNotifications();
			}
		}
		
		public function setupMonitor():void {
			monitor = new URLMonitor(new URLRequest('http://www.glr.cn'));
			monitor.addEventListener(StatusEvent.STATUS, handleMonitorChange);
			monitor.start();
		}
		
		private function handleMonitorChange(event:StatusEvent):void {
			trace('monitor.available=', monitor.available);
			EventManager.instance.dispatchEvent(new NetworkChangeEvent(monitor.available));
		}
		
		public function get online():Boolean {
			return (monitor && monitor.available);
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
		
		[Bindable]
		public function get isPad():Boolean
		{
			var h:Number = Math.min(Capabilities.screenResolutionX, Capabilities.screenResolutionY);
			return (h == 768 || h == 1536);
		}
		
		public function insertCourseHistory(subject:String, id:Number, avatar:String):void
		{
			var course:Course = new Course();
			course.subject = subject;
			course.id = id;
			course.avatar = avatar;
			var date:Date = new Date();
			course.viewTime = Math.floor(date.getTime()/1000);
			
			var courses:Vector.<Course> = FlexGlobals.topLevelApplication.persistenceManager.getProperty("history") as Vector.<Course>;
			if (!courses)
			{
				courses = new Vector.<Course>();
			}
			else
			{
				for (var i:int=0; i<courses.length; i++)
				{
					if (courses[i].id == course.id)
					{
						courses.splice(i, 1);
						break;
					}
				}
			}
			courses.push(course);
			FlexGlobals.topLevelApplication.persistenceManager.setProperty("history", courses);
		}
		
		public function deleteCourseHistoryById(courseId:Number):void
		{
			var courses:Vector.<Course> = FlexGlobals.topLevelApplication.persistenceManager.getProperty("history") as Vector.<Course>;
			if (courses && courseId)
			{
				for (var i:int=0; i<courses.length; i++)
				{
					if (courses[i].id == courseId)
					{
						courses.splice(i, 1);
						FlexGlobals.topLevelApplication.persistenceManager.setProperty("history", courses);
						break;
					}
				}
			}
		}
		
		public function clearCourseHistory():void
		{
			FlexGlobals.topLevelApplication.persistenceManager.setProperty("history", null);
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