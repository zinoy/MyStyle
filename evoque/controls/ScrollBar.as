package evoque.controls
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	
	import evoque.events.ScrollEvent;

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
			//btn.addEventListener(MouseEvent.MOUSE_UP,stopdrag);
		}
		
		private function startdrag(e:MouseEvent):void
		{
			addEventListener(Event.ENTER_FRAME,updatedrag);
			stage.addEventListener(MouseEvent.MOUSE_UP,stopdrag);
			btn.startDrag(false,_rect);
		}
		
		private function stopdrag(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopdrag);
			removeEventListener(Event.ENTER_FRAME,updatedrag);
			btn.stopDrag();
		}
		
		private function updatedrag(e:Event):void
		{
			var evt:ScrollEvent = new ScrollEvent(ScrollEvent.SCROLL_UPDATE);
			evt.top = this.pos;
			dispatchEvent(evt);
		}
		
		public function get pos():Number
		{
			var p:Number = (btn.y - 1) / _rect.height;
			return p;
		}
		
		public function set pos(val:Number):void
		{
			btn.y = val * _rect.height + 1;
		}
		
	}

}