package evoque.controls
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;

	public class ScrollBar extends Sprite
	{
		private var _rect:Rectangle;

		public function ScrollBar(height:Number=127)
		{
			init(height);
		}
		
		private function init(_height:Number):void
		{
			var bar:Shape = new Shape();
			bar.graphics.beginFill(0xe2edc2);
			bar.graphics.drawRect(0,0,7,_height);
			bar.graphics.endFill();
			addChildAt(bar,0);
			_rect = new Rectangle();
			_rect.top = _rect.left = _rect.right = 1;
			_rect.bottom = _height - btn.height - 1;
			btn.y = 1;
			btn.buttonMode = true;
			btn.addEventListener(MouseEvent.MOUSE_DOWN,startdrag);
			btn.addEventListener(MouseEvent.MOUSE_UP,stopdrag);
		}
		
		private function startdrag(e:MouseEvent):void
		{
			btn.startDrag(false,_rect);
		}
		
		private function stopdrag(e:MouseEvent):void
		{
			btn.stopDrag();
		}
		
		private function get scrollTop():Number
		{
			return (btn.y + 1) / _rect.height;
		}
		
	}

}