package evoque.controls
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	import evoque.common.*;

	public class FriendsList extends Sprite
	{
		private var _panel:Sprite;
		private var _list:Vector.<FriendItem>;
		private var _scroll:ScrollBar;

		public function FriendsList()
		{
			init();
		}
		
		private function init():void
		{
			_panel = new Sprite();
			_list = new Vector.<FriendItem>();
			_scroll = new ScrollBar();
			var sqmsk:Shape = new Shape();
			sqmsk.graphics.beginFill(0x33ff00);
			sqmsk.graphics.drawRect(0,0,159,129);
			sqmsk.graphics.endFill();
			_panel.mask = sqmsk;
			addChild(sqmsk);
			sqmsk.x = sqmsk.y = 5;
			
			if (Shared.friends == null)
			{
				var loader:URLLoader = new URLLoader();
				var req:URLRequest = new URLRequest(Shared.URL_BASE + "User.aspx");
				var d:URLVariables = new URLVariables();
				d.ac = "getfriends";
				d.u = Shared.UID;
				d.hash = Utility.hash(d);
				req.data = d;
				req.method = "post";
				loader.addEventListener(Event.COMPLETE,getfriends);
			}
			else
			{
				fill();
			}
		}
		
		private function getfriends(e:Event):void
		{
			var loader:URLLoader = URLLoader(e.target);
			var xml:XML = XML(loader.data);
			trace(xml);
			if (xml.code == 0)
			{
				Shared.friends = String(xml.friends).split(",");
				fill();
			}
		}
		
		private function fill():void
		{
			if (Shared.friends == null)
			{
				return;
			}
			if (_list.length == 0)
			{
				for each (var f:String in Shared.friends)
				{
					var it:FriendItem = new FriendItem(f);
					_list.push(it);
				}
			}
			
			for (var i:int=0; i<_list.length; i++)
			{
				_panel.addChild(_list[i]);
				_list[i].y = i * 21;
			}
			addChild(_panel);
			_panel.x = _panel.y = 6;
			
			addChild(_scroll);
		}
		
	}

}