package evoque.controls
{
	import flash.display.*;
	import flash.events.*;
	
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
			line = new Shape();
			line.graphics.lineStyle(1,_color);
			line.graphics.moveTo(0,0);
			line.graphics.lineTo(38,0);
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