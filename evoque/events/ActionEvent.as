package evoque.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class ActionEvent extends Event
	{
		public static const CLOSE_PANEL:String = "closePanel";
		public static const ITEM_SELECTED:String = "itemSelected";
		
		private var _text:String;
		
		public function ActionEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type,bubbles,cancelable);
		}
		
		public function get text():String
		{
			return _text;
		}
		
		public function set text(val:String):void
		{
			_text = val;
		}

	}

}