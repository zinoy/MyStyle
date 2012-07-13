package evoque.display
{
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.text.*;

	public class PagerCell extends Sprite
	{
		private var _tf:TextField;
		private var _hover:Shape;
		private var _active:Boolean = false;
		private var _index:int;
		private var _next:Boolean = false;
		private var _prev:Boolean = false;

		public function PagerCell(width:Number,label:String=null)
		{
			init(width,label);
		}

		private function init(w:Number,txt:String):void
		{
			_hover = new Shape();
			_hover.graphics.beginFill(0xb7d037);
			_hover.graphics.drawRect(0,0,w,w);
			_hover.graphics.endFill();
			addChild(_hover);
			_hover.alpha = 0;
			
			_tf = new TextField();
			//_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.embedFonts = true;
			_tf.selectable = false;
			var num:Font = new numfont();
			var fm:TextFormat = new TextFormat(num.fontName, 18, 0xb7d037);
			fm.align = TextFormatAlign.CENTER;
			_tf.defaultTextFormat = fm;
			if (txt)
				this.text = txt;
			addChild(_tf);
			//_tf.x = (w - _tf.textWidth) / 2 - 2;
			_tf.width = w;
			_tf.height = 21.55;
			_tf.y = 5;
			
			buttonMode = true;
			mouseChildren = false;
			addEventListener(MouseEvent.ROLL_OVER,over);
			addEventListener(MouseEvent.ROLL_OUT,out);
		}
		
		public function set text(val:String):void
		{
			var idx:int = int(val);
			if (idx == 0)
			{
				_tf.text = "...";
				switch(val)
				{
					case "next":
						_index = 0;
						_next = true;
						_prev = false;
						break;
					case "prev":
						_index = 0;
						_next = false;
						_prev = true;
						break;
					default:
						_tf.text = "";
						break;
				}
			}
			else
			{
				_tf.text = val;
				_index = idx;
				_next = false;
				_prev = false;
			}
		}
		
		
		
		private function over(e:MouseEvent):void
		{
			_hover.alpha = 1;
			_tf.textColor = 0;
		}
		
		private function out(e:MouseEvent):void
		{
			if (!_active)
			{
				_hover.alpha = 0;
				_tf.textColor = 0xb7d037;
			}
		}
		
		public function active():void
		{
			buttonMode = false;
			_active = true;
			_hover.alpha = 1;
			_tf.textColor = 0;
		}
		
		public function reset():void
		{
			_active = false;
			_hover.alpha = 0;
			_tf.textColor = 0xb7d037;
		}
		
		public function get isActive():Boolean
		{
			return _active;
		}
		
		public function get index():int
		{
			return int(_index);
		}
		
		public function get nextpage():Boolean
		{
			return _next;
		}
		
		public function get prevpage():Boolean
		{
			return _prev;
		}

	}

}