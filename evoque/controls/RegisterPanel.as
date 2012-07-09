package evoque.controls
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.*;
	
	import com.adobe.crypto.MD5;
	
	import evoque.common.*;
	import evoque.events.UserEvent;

	public class RegisterPanel extends Sprite
	{
		private var _tbmail:TextBox;
		private var _tbpass:TextBox;
		private var _tbpass2:TextBox;
		private var _errmsg:ErrorPanel;

		public function RegisterPanel()
		{
			init();
		}
		
		private function init():void
		{
			_tbmail = new TextBox(true);
			_tbmail.pattern = BuildInPatterns.EMAIL_ADDRESS;
			addChild(_tbmail);
			_tbmail.x = 216;
			_tbmail.y = 53;
			_tbpass = new TextBox(true,6);
			_tbpass.password = true;
			addChild(_tbpass);
			_tbpass.x = 216;
			_tbpass.y = 79;
			_tbpass2 = new TextBox(true);
			_tbpass2.password = true;
			addChild(_tbpass2);
			_tbpass2.x = 216;
			_tbpass2.y = 105;
			_errmsg = new ErrorPanel();
			_errmsg.x = 427.75;
			_errmsg.y = 191.7;
			
			btnGo.addEventListener(MouseEvent.CLICK,go);
			btnlogin.addEventListener(MouseEvent.CLICK,login);
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
			if (!haserr(_tbpass2.isVaild))
			{
				return;
			}
			if (_tbpass.text != _tbpass2.text)
			{
				_tbpass.highlight();
				_tbpass2.highlight();
				_errmsg.showmsg(ErrorType.PASSWORD_NOT_MATCH);
				addChild(_errmsg);
				return;
			}
			var pass:String = MD5.hash(_tbpass.text);
			var req:URLRequest = new URLRequest(Shared.URL_BASE + "User.aspx");
			var d:URLVariables = new URLVariables();
			d.ac = "adduser";
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
		
		private function login(e:MouseEvent):void
		{
			var evt:UserEvent = new UserEvent(UserEvent.WEIBO_LOGIN);
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
			else if (xml.code == "0300")
			{
				_errmsg.showmsg(ErrorType.EMAIL_EXIST);
				addChild(_errmsg);
			}
			else
			{
				_errmsg.showmsg(ErrorType.REMOTE_ERRORS);
				addChild(_errmsg);
			}
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