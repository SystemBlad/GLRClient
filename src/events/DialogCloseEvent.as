package events
{
	import classes.ButtonType;
	
	import flash.events.Event;
	
	public class DialogCloseEvent extends Event
	{
		public static var name:String = 'dialogCloseEvent';
		public var buttonType:Number;
		
		public function DialogCloseEvent(buttontype:Number = 0)
		{
			super(name);
			buttonType = buttontype;
		}
	}
}