﻿package evoque.controls
{
	import flash.events.*;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;

	public class CloseButton extends ButtonBase
	{

		public function CloseButton()
		{
			init();
		}
		
		private function init():void
		{
			hover.alpha = .2;
			
			addEventListener(MouseEvent.ROLL_OVER,over);
			addEventListener(MouseEvent.ROLL_OUT,out);
		}
		
		private function over(e:MouseEvent):void
		{
			TweenLite.to(hover, .1, {alpha:.3, ease:Quad.easeOut});
		}
		
		private function out(e:MouseEvent):void
		{
			TweenLite.to(hover, .2, {alpha:.2, ease:Quad.easeOut});
		}
		
	}

}