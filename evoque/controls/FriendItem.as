package evoque.controls
{
	import flash.display.*;
	import flash.events.MouseEvent;

	public class FriendItem extends ButtonBase
	{
		private var _hover:Shape;

		public function FriendItem(label:String)
		{
			init(label);
		}
		
		private function init(_label:String):void
		{
			_hover = new Shape();
			_hover.graphics.beginFill(0xfff600);
			_hover.graphics.drawRect(0,0,149,20);
			_hover.graphics.endFill();
			addChildAt(_hover,0);
			_hover.alpha = 0;
			
			label.text = _label;
			
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