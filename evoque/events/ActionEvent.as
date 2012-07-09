package evoque.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class ActionEvent extends Event
	{
		public static var CLOSE_PANEL:String = "closePanel";
		
		public function ActionEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type,bubbles,cancelable);
		}

	}

}