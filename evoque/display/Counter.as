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
		var _count:String;
		var _callback:Function;

		public function Counter()
		{
			init();
		}
		
		private function init():void
		{
			_bg = new Shape();
			num.autoSize = TextFieldAutoSize.LEFT;
			
			var loader:URLLoader = new URLLoader();
			var req:URLRequest = new URLRequest(Shared.URL_BASE + "Action.aspx");
			var d:URLVariables = new URLVariables();
			d.ac = "getcount";
			d.hash = Utility.hash(d);
			req.data = d;
			req.method = "post";
			loader.addEventListener(Event.COMPLETE,setCount);
			loader.addEventListener(IOErrorEvent.IO_ERROR,error);
			loader.load(req);
		}
		
		public function show(dir:String):void
		{
			var loader:URLLoader = new URLLoader();
			if (dir == "right")
			{
				_callback = showright;
			}
			else if (dir == "left")
			{
				_callback = showleft;
			}
			else if (dir == "child")
			{
				_callback = showchild;
			}
			else
			{
				throw new ArgumentError("invaild argument: dir.");
			}
			if (_count != null)
			{
				_callback();
			}
		}
		
		private function setCount(e:Event):void
		{
			var loader:URLLoader = URLLoader(e.target);
			var xml:XML = XML(loader.data);
			trace(xml);
			if (xml.code == 0)
			{
				_count = String(xml.count);
			}
			if (_callback != null)
				_callback();
		}
		
		private function showright():void
		{
			tup.x = 32;
			num.x = 83;
			num.text = _count;
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
		
		private function showleft():void
		{
			tpic.x = -74;
			num.text = _count;
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
		
		private function showchild():void
		{
			tpic.x = -74;
			num.text = _count;
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
		
		private function error(e:IOErrorEvent):void
		{
			trace(e.text);
		}
		
	}

}