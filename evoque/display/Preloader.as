package evoque.display
{
	import flash.display.*;

	public class Preloader extends MovieClip
	{
		private var _mask:Shape;

		public function Preloader(width:Number=0)
		{
			init(width);
		}
		
		private function init(w:Number):void
		{
			this.maskWidth = w;
		}
		
		public function set maskWidth(val:Number):void
		{
			if (val > 0 && _mask == null)
			{
				_mask = new Shape();
				_mask.graphics.beginFill(0,.5);
				_mask.graphics.drawRect(0,0,val,val);
				_mask.graphics.endFill();
				addChildAt(_mask, 0);
				_mask.x = _mask.y = val / 2 * -1;
			}
		}
		
	}

}