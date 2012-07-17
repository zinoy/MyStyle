package evoque.display
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.TextFieldAutoSize;
	
	import evoque.common.*;

	public class Counter extends Sprite
	{
		var _bg:Shape;

		public function Counter()
		{
			init();
		}
		
		private function init():void
		{
			_bg = new Shape();
			num.autoSize = TextFieldAutoSize.LEFT
		}
		
		public function show(dir:String):void
		{
			var loader:URLLoader = new URLLoader();
			if (dir == "right")
			{
				loader.addEventListener(Event.COMPLETE,showright);
			}
			else if (dir == "left")
			{
				loader.addEventListener(Event.COMPLETE,showleft);
			}
			else if (dir == "child")
			{
				loader.addEventListener(Event.COMPLETE,showchild);
			}
			else
			{
				throw new ArgumentError("invaild argument: dir.");
			}
			var req:URLRequest = new URLRequest(Shared.URL_BASE + "Action.aspx");
			var d:URLVariables = new URLVariables();
			d.ac = "getcount";
			d.hash = Utility.hash(d);
			req.data = d;
			req.method = "post";
			loader.addEventListener(IOErrorEvent.IO_ERROR,error);
			loader.load(req);
		}
		
		private function showright(e:Event):void
		{
			var loader:URLLoader = URLLoader(e.target);
			var xml:XML = XML(loader.data);
			trace(xml);
			if (xml.code == 0)
			{
				tup.x = 32;
				num.x = 83;
				num.text = xml.count;
				tpic.x = num.x + num.textWidth + 4;
				
				_bg.graphics.clear();
				_bg.graphics.beginFill(0xffffff,.1);
				_bg.graphics.moveTo(0, 0);
				_bg.graphics.lineTo(tpic.x + 46, 0);
				_bg.graphics.lineTo(tpic.x + 46 + 28, 28);
				_bg.graphics.lineTo(28, 28);
				_bg.graphics.lineTo(0, 0);
				_bg.graphics.endFill();
				addChildAt(_bg, 0);
			}
		}
		
		private function showleft(e:Event):void
		{
			var loader:URLLoader = URLLoader(e.target);
			var xml:XML = XML(loader.data);
			trace(xml);
			if (xml.code == 0)
			{
				tpic.x = -74;
				num.text = xml.count;
				num.x = tpic.x - num.textWidth - 5;
				tup.x = num.x - 52;
				
				_bg.graphics.clear();
				_bg.graphics.beginFill(0);
				_bg.graphics.moveTo(0, 0);
				_bg.graphics.lineTo(-28, 28);
				_bg.graphics.lineTo(tup.x - 36, 28);
				_bg.graphics.lineTo(tup.x - 36 + 28, 0);
				_bg.graphics.lineTo(0, 0);
				_bg.graphics.endFill();
				addChildAt(_bg, 0);
			}
		}
		
		private function showchild(e:Event):void
		{
			var loader:URLLoader = URLLoader(e.target);
			var xml:XML = XML(loader.data);
			trace(xml);
			if (xml.code == 0)
			{
				tpic.x = -74;
				num.text = xml.count;
				num.x = tpic.x - num.textWidth - 5;
				tup.x = num.x - 52;
				
				_bg.graphics.clear();
				_bg.graphics.beginFill(0, .3);
				_bg.graphics.moveTo(0, 0);
				_bg.graphics.lineTo(-28, 28);
				_bg.graphics.lineTo(tup.x - 36, 28);
				_bg.graphics.lineTo(tup.x - 36 + 28, 0);
				_bg.graphics.lineTo(0, 0);
				_bg.graphics.endFill();
				addChildAt(_bg, 0);
			}
		}
		
		private function error(e:IOErrorEvent):void
		{
			trace(e.text);
		}
		
	}

}