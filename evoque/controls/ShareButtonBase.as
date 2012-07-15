package evoque.controls
{
	import flash.display.*;
	import flash.events.MouseEvent;

	public class ShareButtonBase extends Sprite
	{
		private var _hover:Shape;

		public function ShareButtonBase()
		{
			init();
		}
		
		private function init():void
		{
			buttonMode = true;
			mouseChildren = false;
			
			_hover = new Shape();
			_hover.graphics.beginFill(0xffffff,.3);
			_hover.graphics.drawRect(0,0,13,13);
			_hover.graphics.endFill();
			addChild(_hover);
			_hover.alpha = 0;
			
			addEventListener(MouseEvent.ROLL_OVER,over);
			addEventListener(MouseEvent.ROLL_OUT,out);
		}
		
		private function over(e:MouseEvent):void
		{
			_hover.alpha = 1;
		}
		
		private function out(e:MouseEvent):void
		{
			_hover.alpha = 0;
		}

	}

}