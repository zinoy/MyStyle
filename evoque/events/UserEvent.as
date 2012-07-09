package evoque.events
{
	import flash.events.Event;

	public class UserEvent extends Event
	{
		public static const LOCAL_LOGIN:String = "localLogin";
		public static const LOCAL_REGISTER:String = "localRegister";
		public static const LOGIN_COMPLETE:String = "loginComplete";
		public static const WEIBO_LOGIN:String = "weiboLogin";

		public function UserEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type,bubbles,cancelable);
		}

	}

}