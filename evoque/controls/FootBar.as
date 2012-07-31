package evoque.controls
{
	import flash.display.*;
	import flash.events.MouseEvent;
	import evoque.events.ActionEvent;

	public class FootBar extends Sprite
	{
		var _bg:Shape;

		public function FootBar()
		{
			init();
		}
		
		private function init():void
		{
			_bg = new Shape();
			_bg.graphics.beginFill(0);
			_bg.graphics.drawRect(0,0,1000,35);
			_bg.graphics.endFill();
			addChildAt(_bg,0);
			_bg.y = -35;
			
			btnlaw.addEventListener(MouseEvent.CLICK, showlaw);
		}
		
		public function wide():void
		{
			_bg.width = stage.stageWidth;
			links.x = _bg.width;
		}
		
		public function thin():void
		{
			_bg.width = 1000;
			links.x = _bg.width;
		}
		
		private function showlaw(e:MouseEvent):void
		{
			var evt:ActionEvent = new ActionEvent(ActionEvent.SHOW_LAW);
			dispatchEvent(evt);
		}
		
	}

}