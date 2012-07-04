package evoque.display
{
	import flash.display.*;
	import flash.events.Event;
	
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.loading.ImageLoader;

	public class PhotoItem extends Sprite
	{
		private var _bitmap:Bitmap;
		private var _category:String;
		
		public function PhotoItem(category=null)
		{
			init();
		}
		
		private function init():void
		{
			
		}
		
		public function get content():Bitmap
		{
			return _bitmap;
		}
		
		public function complete(e:LoaderEvent):void
		{
			var loader:ImageLoader = e.target as ImageLoader;
			var obj:ContentDisplay = loader.content;
			_bitmap = obj.rawContent as Bitmap;
			//_bitmap.smoothing = true;
			_bitmap.x = _bitmap.width / 2 * -1
			_bitmap.y = _bitmap.x;
			addChild(_bitmap);
			
			//remove preloader mark
		}
				
	}

}