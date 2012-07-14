package evoque.display
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.loading.ImageLoader;
	
	import evoque.events.PhotoEvent;

	public class PhotoItem extends Sprite
	{
		private var _category:Shape;
		private var _parm:Object;
		private var _pos:Point;
		private var _loading:Preloader;
		
		public function PhotoItem(param:Object=null)
		{
			init(param);
		}
		
		private function init(p:Object):void
		{
			_parm = p;
			if (p != null && p.type > 0)
			{
				_category = new Shape();
				var color:uint;
				switch (int(p.type))
				{
					case 1:
						color = 0x49dc31;
						break;
					case 2:
						color = 0xff0000;
						break;
					case 3:
						color = 0x02c1ff;
						break;
					case 4:
						color = 0xff00ea;
					default:
						break;
				}
				_category.graphics.beginFill(color);
				_category.graphics.moveTo(0,0);
				_category.graphics.lineTo(10,0);
				_category.graphics.lineTo(0,10);
				_category.graphics.lineTo(0,0);
				_category.graphics.endFill();
			}
			_loading = new Preloader();
			addChild(_loading);
		}
		
		public function set point(val:Point):void
		{
			_pos = val;
		}
		
		public function get point():Point
		{
			return _pos;
		}
		
		public function get params():Object
		{
			return _parm;
		}
		
		public function complete(e:LoaderEvent):void
		{
			var loader:ImageLoader = e.target as ImageLoader;
			var obj:ContentDisplay = loader.content;
			obj.buttonMode = true;
			obj.mouseChildren = false;
			_category.x = _category.y = obj.fitWidth / 2 * -1
			
			addChild(obj);
			addChild(_category);
			_loading.maskWidth = obj.fitWidth;
			removeChild(_loading);
		}
		
		public function showloader():void
		{
			addChild(_loading);
		}
		
		public function hideloader():void
		{
			if (contains(_loading))
			{
				removeChild(_loading);
			}
		}
		
	}

}