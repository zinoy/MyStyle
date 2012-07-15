package evoque.display
{
	import flash.display.*;
	import flash.text.*;

	public class ProgressBar extends Sprite
	{
		private var _line:Shape;
		private var _bar:Shape;
		private var _txt:TextField;

		public function ProgressBar()
		{
			init();
		}
		
		private function init():void
		{
			_line = new Shape();
			_line.graphics.lineStyle(1, 0x343434)
			_line.graphics.moveTo(0, 600);
			_line.graphics.lineTo(600, 0);
			addChild(_line);
			
			_bar = new Shape();
			_bar.graphics.lineStyle(1, 0xb7d037, 1, false, LineScaleMode.NONE)
			_bar.graphics.moveTo(0, 0);
			_bar.graphics.lineTo(600, -600);
			addChild(_bar);
			_bar.y = 600;
			
			_txt = new TextField();
			var num:Font = new numfont();
			var tf:TextFormat = new TextFormat(num.fontName, 14, 0xffffff);
			_txt.defaultTextFormat = tf;
			_txt.embedFonts = true;
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.selectable = false;
			addChild(_txt);
			
			setProgress(0);
		}
		
		public function setProgress(p:Number):void
		{
			_bar.scaleX = _bar.scaleY = p;
			_txt.text = String(Math.floor(p * 100));
			_txt.x = 600 * p + 3;
			_txt.y = 600 * (1 - p) - 6;
		}

	}

}