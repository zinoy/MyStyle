package evoque.display
{
	import flash.display.*;

	public class Cube extends Sprite
	{
		private var _sides:Vector.<Bitmap>;
		private var _front:Sprite;
		private var _side:Sprite;
		private var _lside:Sprite;

		public function Cube()
		{
			_sides = new Vector.<Bitmap>();
			_front = new Sprite();
			_side = new Sprite();
			_lside = new Sprite();
		}
		
		public function setSides(front:BitmapData, side:BitmapData):void
		{
			_sides.splice(0, int.MAX_VALUE);
			_sides.push(new Bitmap(front));
			_sides.push(new Bitmap(side));
			_sides.push(new Bitmap(side));
			
			for each (var bm:Bitmap in _sides)
			{
				bm.x = bm.width / -2;
				bm.y = bm.height / -2;
			}
			
			while (_front.numChildren > 0)
				_front.removeChildAt(0);
			while (_side.numChildren > 0)
				_side.removeChildAt(0);
			while (_lside.numChildren > 0)
				_lside.removeChildAt(0);
				
			_front.addChild(_sides[0]);
			_side.addChild(_sides[1]);
			_lside.addChild(_sides[2]);
			
			addChild(_lside);
			_lside.x = _front.width / -2;
			_lside.y = _lside.z = 0;
			_lside.rotationY = 90;
			addChild(_side);
			_side.x = _front.width / 2;
			_side.y = _side.z = 0;
			_side.rotationY = -90;
			addChild(_front);
			_front.x = _front.y = 0;
			_front.z = _front.width / -2;
		}
		
		public function swapSides():void
		{
			swapChildren(_front, _side);
		}
		
		public function swapLeft():void
		{
			setChildIndex(_side, 0);
			swapChildren(_front, _lside);
		}

	}

}