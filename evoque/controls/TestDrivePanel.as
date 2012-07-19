package evoque.controls
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.*;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	import evoque.common.*;

	public class TestDrivePanel extends Sprite
	{
		private var _tbname:TextBox;
		private var _tbmobile:TextBox;
		private var _tbmail:TextBox;
		private var _errmsg:ErrorPanel;

		public function TestDrivePanel()
		{
			init();
		}
		
		private function init():void
		{
			_tbname = new TextBox(true);
			addChild(_tbname);
			_tbname.x = 414.3;
			_tbname.y = 220.6;
			_tbmobile = new TextBox(true);
			_tbmobile.pattern = BuildInPatterns.MOBILE_PHONE;
			addChild(_tbmobile);
			_tbmobile.x = 414.3;
			_tbmobile.y = 248.6;
			_tbmail = new TextBox(true);
			_tbmail.pattern = BuildInPatterns.EMAIL_ADDRESS;
			addChild(_tbmail);
			_tbmail.x = 414.3;
			_tbmail.y = 276.6;
			_errmsg = new ErrorPanel();
			_errmsg.x = 605;
			_errmsg.y = 361.05;
			
			btnGo.addEventListener(MouseEvent.CLICK, go);
			btnClose.addEventListener(MouseEvent.CLICK, hide);
		}
		
		private function go(e:MouseEvent):void
		{
			if (!haserr(_tbname.isVaild))
			{
				return;
			}
			if (!haserr(_tbmobile.isVaild))
			{
				if (_tbmobile.isVaild == ErrorType.INCORRECT_FORMAT)
				{
					_errmsg.showmsg(8);
				}
				return;
			}
			if (!haserr(_tbmail.isVaild))
			{
				return;
			}
			var req:URLRequest = new URLRequest(Shared.URL_BASE + "Action.aspx");
			var d:URLVariables = new URLVariables();
			d.ac = "td";
			d.user = Utility.trim(_tbname.text);
			d.phone = Utility.trim(_tbmobile.text);
			d.mail = Utility.trim(_tbmail.text);
			d.hash = Utility.hash(d);
			req.method = "post";
			req.data = d;
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, end);
			loader.addEventListener(IOErrorEvent.IO_ERROR, error);
			loader.load(req);
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
		
		private function end(e:Event):void
		{
			var loader:URLLoader = URLLoader(e.target);
			var xml:XML = XML(loader.data);
			trace(xml);
			if (xml.code == 0)
			{
				hide(null);
			}
		}
		
		private function hide(e:MouseEvent):void
		{
			TweenLite.to(this, .4, {alpha:0,ease:Quad.easeOut,onComplete:parent.removeChild,onCompleteParams:[this]});
		}
		
		private function error(e:IOErrorEvent):void
		{
			var loader:URLLoader = URLLoader(e.target);
			trace(loader.data);
		}
		
	}

}