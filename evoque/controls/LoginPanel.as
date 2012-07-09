package evoque.controls
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.*;
	
	import com.adobe.crypto.MD5;
	
	import evoque.events.UserEvent;
	import evoque.common.*;

	public class LoginPanel extends Sprite
	{
		private var _tbmail:TextBox;
		private var _tbpass:TextBox;
		private var _errmsg:ErrorPanel;

		public function LoginPanel()
		{
			init();
		}
		
		private function init():void
		{
			_tbmail = new TextBox(true);
			//_tbmail.pattern = BuildInPatterns.EMAIL_ADDRESS;
			addChild(_tbmail);
			_tbmail.x = 165;
			_tbmail.y = 12;
			_tbpass = new TextBox(true);
			_tbpass.password = true;
			addChild(_tbpass);
			_tbpass.x = 165;
			_tbpass.y = 38;
			_errmsg = new ErrorPanel();
			_errmsg.x = 406.8;
			_errmsg.y = 98.25;
			
			btnGo.addEventListener(MouseEvent.CLICK,go);
			btnReg.addEventListener(MouseEvent.CLICK,reg);
		}
		
		private function go(e:MouseEvent):void
		{
			if (!haserr(_tbmail.isVaild))
			{
				return;
			}
			if (!haserr(_tbpass.isVaild))
			{
				return;
			}
			var pass:String = MD5.hash(_tbpass.text);
			var req:URLRequest = new URLRequest(Shared.URL_BASE + "User.aspx");
			var d:URLVariables = new URLVariables();
			d.ac = "login";
			d.email = _tbmail.text;
			d.pass = pass;
			d.hash = Utility.hash(d);
			req.data = d;
			req.method = "post";
			var loader:URLLoader = new URLLoader()
			loader.addEventListener(Event.COMPLETE,end);
			loader.addEventListener(IOErrorEvent.IO_ERROR,error);
			loader.load(req);
			btnGo.enabled = false;
			btnGo.mouseEnabled = false;
		}
		
		private function haserr(mg:int):Boolean
		{
			if (_errmsg.parent != null)
			{
				removeChild(_errmsg);
			}
			if (mg > 0)
			{
				if (mg > 1)
				{
					_errmsg.showmsg(mg);
					addChild(_errmsg);
				}
				return false;
			}
			else
			{
				return true;
			}
		}
		
		private function reg(e:MouseEvent):void
		{
			var evt:UserEvent = new UserEvent(UserEvent.LOCAL_REGISTER);
			dispatchEvent(evt);
		}
		
		private function end(e:Event):void
		{
			var loader:URLLoader = URLLoader(e.target);
			var xml:XML = XML(loader.data);
			trace(xml);
			if (xml.code == 0)
			{
				Shared.UID = xml.uid;
				var evt:UserEvent = new UserEvent(UserEvent.LOGIN_COMPLETE);
				dispatchEvent(evt);
				return;
			}
			else if (xml.code == "0301")
			{
				_errmsg.showmsg(ErrorType.LOGIN_FAILED);
				addChild(_errmsg);
			}
			else
			{
				_errmsg.showmsg(ErrorType.REMOTE_ERRORS);
				addChild(_errmsg);
			}
			_tbpass.text = "";
			_tbmail.setFocus();
			btnGo.enabled = true;
			btnGo.mouseEnabled = true;
		}
		
		private function error(e:IOErrorEvent):void
		{
			btnGo.enabled = true;
			btnGo.mouseEnabled = true;
			haserr(ErrorType.REMOTE_ERRORS);
			trace(e.text);
		}
		
	}

}