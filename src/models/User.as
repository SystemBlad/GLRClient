package models
{
	[Bindable]
	public class User
	{
		public var name:String;
		public var email:String;
		public var password:String;
		public var loggedIn:Boolean;
		
		public function User()
		{
		}
	}
}