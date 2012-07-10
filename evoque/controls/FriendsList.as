package evoque.controls
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	import evoque.common.*;
	import evoque.events.*;

	public class FriendsList extends Sprite
	{
		private const PANEL_TOP:Number = 6;
		
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
			var sqmsk:Shape = new Shape();
			sqmsk.graphics.beginFill(0x33ff00);
			sqmsk.graphics.drawRect(0,0,159,129);
			sqmsk.graphics.endFill();
			_panel.mask = sqmsk;
			addChild(sqmsk);
			sqmsk.x = sqmsk.y = 5;
			_panel.addEventListener(MouseEvent.MOUSE_WHEEL,scrollpanel);
			
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
				loader.addEventListener(IOErrorEvent.IO_ERROR,error);
				loader.load(req);
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
					it.addEventListener(MouseEvent.CLICK,selectitem);
					_list.push(it);
				}
			}
			
			for (var i:int=0; i<_list.length; i++)
			{
				_panel.addChild(_list[i]);
				_list[i].y = i * 21;
			}
			addChild(_panel);
			_panel.x = _panel.y = PANEL_TOP;
			
			if (_panel.height > _panel.mask.height)
			{
				_scroll = new ScrollBar();
				_scroll.addEventListener(ScrollEvent.SCROLL_UPDATE,updatescroll);
				addChild(_scroll);
				_scroll.x = 156;
				_scroll.y = PANEL_TOP;
				
				var bg:Shape = new Shape();
				bg.graphics.beginFill(0xffffff);
				bg.graphics.drawRect(0,0,_panel.width,_panel.height + 2);
				bg.graphics.endFill();
				_panel.addChildAt(bg,0);
			}
		}
		
		private function updatescroll(e:ScrollEvent):void
		{
			if (_panel.height > _panel.mask.height)
			{
				var len:Number = _panel.mask.height - _panel.height;
				_panel.y = len * e.top + PANEL_TOP;
			}
		}
		
		private function scrollpanel(e:MouseEvent):void
		{
			if (_panel.height > _panel.mask.height)
			{
				var len:Number = _panel.mask.height - _panel.height;
				_panel.y += e.delta * 21;
				if (_panel.y > PANEL_TOP)
					_panel.y = PANEL_TOP;
				if (_panel.y < len + PANEL_TOP)
					_panel.y = len + PANEL_TOP;
				_scroll.pos = (_panel.y - PANEL_TOP) / len;
			}
		}
		
		private function selectitem(e:MouseEvent):void
		{
			var obj:FriendItem = e.currentTarget as FriendItem;
			var evt:ActionEvent = new ActionEvent(ActionEvent.ITEM_SELECTED);
			evt.text = obj.text;
			dispatchEvent(evt);
		}
		
		private function error(e:IOErrorEvent):void
		{
			trace(e.text);
		}
		
	}

}