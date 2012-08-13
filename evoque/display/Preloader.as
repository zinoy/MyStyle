package evoque.display
{
	import flash.display.*;

	public class Preloader extends MovieClip
	{
		private var _mask:Shape;

		public function Preloader(width:Number=0,height:Number=0)
		{
			init(width,height);
		}
		
		private function init(w:Number,h:Number):void
		{
			_mask = new Shape();
			drawMask(w,h);
		}
		
		public function drawSquareMask(val:Number):void
		{
			if (val > 0)
			{
				_mask.graphics.clear();
				_mask.graphics.beginFill(0,.68);
				_mask.graphics.drawRect(0,0,val,val);
				_mask.graphics.endFill();
				addChildAt(_mask, 0);
				_mask.x = _mask.y = val / 2 * -1;
			}
		}
		
		public function drawMask(width:Number,height:Number=0)
		{			
			var h:Number = height;
			if (height == 0)
			{
				h = width;
			}
			_mask.graphics.clear();
			_mask.graphics.beginFill(0,.68);
			_mask.graphics.drawRect(0,0,width,h);
			_mask.graphics.endFill();
			addChildAt(_mask, 0);
			_mask.x = width / 2 * -1;;
			_mask.y = h / 2 * -1;
		}
		
	}

}