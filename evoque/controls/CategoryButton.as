package evoque.controls
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;

	public class CategoryButton extends Sprite
	{
		private var _active:Boolean = false;

		public function CategoryButton()
		{
			init();
		}
		
		private function init():void
		{
			hover.alpha = 0;
		}
		
		public function enable():void
		{
			buttonMode = true;
			mouseChildren = false;
			
			addEventListener(MouseEvent.ROLL_OVER,over);
			addEventListener(MouseEvent.ROLL_OUT,out);
		}
		
		private function over(e:MouseEvent):void
		{
			TweenLite.to(hover, .1, {alpha:1, ease:Quad.easeOut});
		}
		
		private function out(e:MouseEvent):void
		{
			if (!_active)
			{
				TweenLite.to(hover, .2, {alpha:0, ease:Quad.easeOut});
			}
		}
		
		public function select():void
		{
			hover.alpha = 1;
			_active = true;
		}
		
		public function reset():void
		{
			hover.alpha = 0;
			_active = false;
		}
		
	}

}