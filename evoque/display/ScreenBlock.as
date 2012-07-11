package evoque.display
{
	import flash.display.*;
	import flash.geom.Point;
	import flash.text.*;

	public class ScreenBlock extends Sprite
	{
		private var _bmp:Bitmap;

		public function ScreenBlock(bmg:BitmapData,width:Number,pos:Point,offset:Number=0)
		{
			init(bmg,width,pos,offset);
		}
		
		private function init(b:BitmapData,w:Number,p:Point,o:Number):void
		{
			_bmp = new Bitmap(b);
			var msk:Shape = new Shape();
			msk.graphics.beginFill(0x33ff00);
			msk.graphics.drawRect(0,0,w,w);
			msk.graphics.endFill();
			
			_bmp.mask = msk;
			msk.x = msk.y = w / 2 * -1;
			addChild(msk);
			addChild(_bmp);
			_bmp.x = p.x * w * -1 - w / 2;
			_bmp.y = (p.y - 1) * w * -1 - w / 2 + o;
		}

	}

}