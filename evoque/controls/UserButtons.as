package evoque.controls
{
	import flash.display.Sprite;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	import evoque.common.Shared;

	public class UserButtons extends Sprite
	{

		public function UserButtons()
		{
			init();
		}
		
		private function init():void
		{
			show();
		}
		
		public function show():void
		{
			if (Shared.UID != "")
			{
				TweenLite.to(mainLogout, .4, {x:-44,y:0,ease:Quad.easeOut});
				TweenLite.to(mainLogin, .4, {x:-116,y:-24,ease:Quad.easeOut});
				TweenLite.to(mainReg, .4, {x:0,y:50,ease:Quad.easeOut});
			}
			else
			{
				TweenLite.to(mainLogin, .4, {x:-92,y:0,ease:Quad.easeOut});
				TweenLite.to(mainReg, .4, {x:-44,y:6,ease:Quad.easeOut});
				TweenLite.to(mainLogout, .4, {x:0,y:-44,ease:Quad.easeOut});
			}
		}
		
		public function hide():void
		{
			TweenLite.to(mainLogin, .4, {x:-116,y:-24,ease:Quad.easeOut});
			TweenLite.to(mainReg, .4, {x:0,y:50,ease:Quad.easeOut});
			TweenLite.to(mainLogout, .4, {x:0,y:-44,ease:Quad.easeOut});
		}
		
	}

}