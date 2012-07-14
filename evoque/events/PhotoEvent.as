package evoque.events
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import evoque.display.PhotoItem;

	public class PhotoEvent extends Event
	{
		public static const SHOW_DETAIL:String = "showDetail";
		
		private var _pos:Point;
		private var _item:PhotoItem;

		public function PhotoEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type,bubbles,cancelable);
		}
		
		public function set pos(val:Point):void
		{
			_pos = val;
		}
		
		public function get pos():Point
		{
			return _pos;
		}
		
		public function set item(val:PhotoItem):void
		{
			_item = val;
		}
		
		public function get item():PhotoItem
		{
			return _item;
		}

	}

}