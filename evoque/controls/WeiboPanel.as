package evoque.controls
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.net.*;
	
	import com.asual.swfaddress.SWFAddress;
	
	import evoque.common.*;
	import evoque.events.UserEvent;

	public class WeiboPanel extends Sprite
	{

		public function WeiboPanel()
		{
			init();
		}
		
		private function init():void
		{
			btnGo.addEventListener(MouseEvent.CLICK,go);
			btnlogin.addEventListener(MouseEvent.CLICK,login);
			btnreg.addEventListener(MouseEvent.CLICK,reg);
		}
		
		private function go(e:MouseEvent):void
		{
			//var req:URLRequest = new URLRequest("https://api.weibo.com/oauth2/authorize");
			var d:URLVariables = new URLVariables();
			d.client_id = Shared.APP_KEY;
			d.response_type = "code";
			d.redirect_uri = ExternalInterface.call("getdomain") + Shared.REDIRECT_URL;
			d.state = Math.random();
			//req.data = d;
			//navigateToURL(req);
			SWFAddress.popup("https://api.weibo.com/oauth2/authorize?"+d.toString());
		}
		
		private function login(e:MouseEvent):void
		{
			var evt:UserEvent = new UserEvent(UserEvent.LOCAL_LOGIN);
			dispatchEvent(evt);
		}
		
		private function reg(e:MouseEvent):void
		{
			var evt:UserEvent = new UserEvent(UserEvent.LOCAL_REGISTER);
			dispatchEvent(evt);
		}

	}

}