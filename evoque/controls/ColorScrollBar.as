package evoque.controls
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	
	import evoque.events.ScrollEvent;
	
	[Event(name="scrollUpdate", type="evoque.events.ScrollEvent")]
	public class ColorScrollBar extends Sprite
	{
		private const PADDING:Number = 5;
		private var _rect:Rectangle;
		private var _btn:Sprite;

		public function ColorScrollBar(height:Number=311)
		{
			init(height);
		}
		
		private function init(_height:Number):void
		{
			var bar:Shape = new Shape();
			bar.graphics.beginFill(0x839527);
			bar.graphics.drawRect(0, 0, 2, _height);
			bar.graphics.endFill();
			addChildAt(bar, 0);
			bar.x = 2;
			
			_btn = new Sprite();
			_btn.graphics.beginFill(0xfff600);
			_btn.graphics.drawRoundRect(0, 0, 6, 40, 6);
			_btn.graphics.endFill();
			
			_rect = new Rectangle();
			_rect.left = _rect.right = 0;
			_rect.top = PADDING;
			_rect.bottom = _height - _btn.height - PADDING;
			
			addChild(_btn);
			_btn.y = PADDING;
			_btn.buttonMode = true;
			_btn.addEventListener(MouseEvent.MOUSE_DOWN, startdrag);
		}
		
		private function startdrag(e:MouseEvent):void
		{
			addEventListener(Event.ENTER_FRAME, updatedrag);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopdrag);
			_btn.startDrag(false, _rect);
		}
		
		private function stopdrag(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopdrag);
			removeEventListener(Event.ENTER_FRAME, updatedrag);
			_btn.stopDrag();
		}
		
		private function updatedrag(e:Event):void
		{
			var evt:ScrollEvent = new ScrollEvent(ScrollEvent.SCROLL_UPDATE);
			evt.top = this.pos;
			dispatchEvent(evt);
		}
		
		public function get pos():Number
		{
			var p:Number = (_btn.y - PADDING) / _rect.height;
			return p;
		}
		
		public function set pos(val:Number):void
		{
			_btn.y = val * _rect.height + PADDING;
		}
		
	}

}