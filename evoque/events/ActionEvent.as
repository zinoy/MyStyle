package evoque.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class ActionEvent extends Event
	{
		public static const CLOSE_PANEL:String = "closePanel";
		public static const SHOW_SUCCESS:String = "showSuccess";
		public static const SHOW_GALLERY:String = "showGallery";
		public static const UPLOAD_MORE:String = "uploadMore";
		public static const ITEM_SELECTED:String = "itemSelected";
		public static const HIDE_CHILDREN:String = "hideChildren";
		public static const SHOW_FOOTBAR:String = "showFootbar";
		
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