package evoque.events
{
	import flash.events.Event;

	public class PageEvent extends Event
	{
		public static const PAGE_CHANGE:String = "pageChange";
		
		private var _index:int;

		public function PageEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type,bubbles,cancelable);
		}
		
		public function set index(val:int):void
		{
			_index = val;
		}
		
		public function get index():int
		{
			return _index;
		}

	}

}