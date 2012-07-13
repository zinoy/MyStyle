package evoque.controls
{
	import flash.display.*;
	import flash.events.MouseEvent;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	import evoque.events.*;

	public class UserAction extends Sprite
	{
		private var _weibo:WeiboPanel;
		private var _login:LoginPanel;
		private var _reg:RegisterPanel;

		public function UserAction()
		{
			init();
		}
		
		private function init():void
		{
			_weibo = new WeiboPanel();
			_weibo.x = 114.7;
			_weibo.y = 242.85;
			
			_login = new LoginPanel();
			_login.x = 193.5;
			_login.y = 189.25;
			_login.addEventListener(UserEvent.LOGIN_COMPLETE,logined);
			
			_reg = new RegisterPanel();
			_reg.x = 133.25;
			_reg.y = 157.15;
			_reg.addEventListener(UserEvent.LOGIN_COMPLETE,logined);
			
			btnClose.addEventListener(MouseEvent.CLICK,closepanel);
			_weibo.addEventListener(UserEvent.LOCAL_LOGIN,golocal);
			_login.addEventListener(UserEvent.LOCAL_REGISTER,goreg);
			_reg.addEventListener(UserEvent.WEIBO_LOGIN,goweibo);
		}
		
		public function showpanel(type:String=null):void
		{
			if (type == "reg")
			{
				addChild(_reg);
				_reg.alpha = 1;
			}
			else
			{
				addChild(_weibo);
				_weibo.alpha = 1;
			}
		}
		
		private function closepanel(e:MouseEvent):void
		{
			TweenLite.to(this, .4, {alpha:0,ease:Quad.easeOut,onComplete:closed});
		}
		
		private function closed():void
		{
			if (_weibo.parent != null)
			{
				removeChild(_weibo);
			}
			if (_login.parent != null)
			{
				removeChild(_login);
			}
			if (_reg.parent != null)
			{
				removeChild(_reg);
			}
			var evt:ActionEvent = new ActionEvent(ActionEvent.CLOSE_PANEL);
			dispatchEvent(evt);
		}
		
		private function golocal(e:UserEvent):void
		{
			TweenLite.to(_weibo, .3, {alpha:0,ease:Quad.easeOut,onComplete:removeChild,onCompleteParams:[_weibo]});
			addChild(_login);
			_login.alpha = 0;
			TweenLite.to(_login, .4, {alpha:1,delay:.3,ease:Quad.easeOut});
		}
		
		private function goreg(e:UserEvent):void
		{
			TweenLite.to(_login, .3, {alpha:0,ease:Quad.easeOut,onComplete:removeChild,onCompleteParams:[_login]});
			addChild(_reg);
			_reg.alpha = 0;
			TweenLite.to(_reg, .4, {alpha:1,delay:.3,ease:Quad.easeOut});
		}
		
		private function goweibo(e:UserEvent):void
		{
			TweenLite.to(_reg, .3, {alpha:0,ease:Quad.easeOut,onComplete:removeChild,onCompleteParams:[_reg]});
			addChild(_weibo);
			_weibo.alpha = 0;
			TweenLite.to(_weibo, .4, {alpha:1,delay:.3,ease:Quad.easeOut});
		}
		
		private function logined(e:UserEvent):void
		{
			TweenLite.to(this, .4, {alpha:0,ease:Quad.easeOut,onComplete:closed});
		}
		
	}

}