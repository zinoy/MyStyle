﻿package evoque.display
{
	import flash.display.*;
	import flash.events.Event;
	
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.loading.ImageLoader;

	public class PhotoItem extends Sprite
	{
		private var _category:Shape;
		
		public function PhotoItem(category:int=0)
		{
			init(category);
		}
		
		private function init(cate:int):void
		{
			if (cate > 0)
			{
				_category = new Shape();
				var color:uint;
				switch (cate)
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
		}
		
		public function complete(e:LoaderEvent):void
		{
			var loader:ImageLoader = e.target as ImageLoader;
			var obj:ContentDisplay = loader.content;
			addChild(obj);
			_category.x = _category.y = obj.fitWidth / 2 * -1
			addChild(obj);
			addChild(_category);
			//remove preloader mark
		}
		
	}

}