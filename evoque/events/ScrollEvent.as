package evoque.events
{
	import flash.events.Event;

	public class ScrollEvent extends Event
	{
		public static const SCROLL_UPDATE:String = "scrollUpdate";
		
		private var _scrollTop:Number;

		public function ScrollEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type,bubbles,cancelable);
		}
		
		public function get top():Number
		{
			return _scrollTop;
		}
		
		public function set top(val:Number):void
		{
			_scrollTop = val;
		}

	}

}