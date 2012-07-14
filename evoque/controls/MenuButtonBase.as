package evoque.controls
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;

	public class MenuButtonBase extends MovieClip
	{
		private var _active:Boolean = false;

		public function MenuButtonBase()
		{
			init();
		}
		
		public function get active():Boolean
		{
			return _active;
		}
		
		public function set active(val:Boolean):void
		{
			_active = val;
			if (_active)
			{
				TweenLite.to(hover, .2, {alpha:1, ease:Quad.easeOut});
			}
			else
			{
				TweenLite.to(hover, .2, {alpha:0, ease:Quad.easeOut});
			}
		}
		
		public function reset():void
		{
			_active = false;
			TweenLite.to(hover, .1, {alpha:0, ease:Quad.easeOut});
		}
		
		private function init():void
		{
			stop();
			hover.alpha = 0;
			buttonMode = true;
			mouseChildren = false;
			
			addEventListener(MouseEvent.ROLL_OVER,over);
			addEventListener(MouseEvent.ROLL_OUT,out);
			addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function over(e:MouseEvent):void
		{
			if (totalFrames > 1)
			{
				gotoAndStop(2);
			}
			TweenLite.to(hover, .3, {alpha:1, ease:Quad.easeOut});
		}
		
		private function out(e:MouseEvent):void
		{
			if (totalFrames > 1)
			{
				gotoAndStop(1);
			}
			if (!_active)
			{
				TweenLite.to(hover, .2, {alpha:0, ease:Quad.easeOut});
			}
		}
		
		private function onClick(e:MouseEvent):void
		{
			_active = true;
			TweenLite.to(hover, .1, {alpha:1, ease:Quad.easeOut});
		}
		
	}

}