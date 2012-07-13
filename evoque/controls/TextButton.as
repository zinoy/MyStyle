package evoque.controls
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.TextField;
	import flash.text.StaticText;
	
	public class TextButton extends ButtonBase
	{
		private var line:Shape;
		private var _color:uint;

		public function TextButton(color:uint=0xb7d037)
		{
			_color = color;
			init();
		}
		
		private function init():void
		{
			var txt:StaticText = getChildAt(0) as StaticText;
			var to:Number = txt.text.length * 9.6;
			
			line = new Shape();
			line.graphics.lineStyle(1,_color);
			line.graphics.moveTo(0,0);
			line.graphics.lineTo(to,0);
			addChild(line);
			line.x = 3;
			line.y = 15;
			line.alpha = 0;
			
			addEventListener(MouseEvent.ROLL_OVER,over);
			addEventListener(MouseEvent.ROLL_OUT,out);
		}
		
		private function over(e:MouseEvent):void
		{
			line.alpha = 1;
		}
		
		private function out(e:MouseEvent):void
		{
			line.alpha = 0;
		}
				
	}

}