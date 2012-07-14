package evoque.display
{
	import flash.display.*;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.text.*;
	
	import com.greensock.loading.*;
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.ScaleMode;
	import flash.filters.DropShadowFilter;

	[Event(name="complete", type="flash.events.Event")]
	public class PhotoInfo extends Sprite
	{
		private var _category:Shape;
		private var _params:Object;
		private var _message:TextField;
		private var _display:ContentDisplay;
		private var _forward:forward;
		private var _loading:Boolean = false;
		private var _bg:Shape;
		private var _item:PhotoItem;

		public function PhotoInfo()
		{
			init();
		}
		
		private function init():void
		{
			_message = new TextField();
			_message.multiline = true;
			_message.selectable = false;
			_message.autoSize = TextFieldAutoSize.LEFT;
			_message.wordWrap = true;
			var fm:TextFormat = new TextFormat("Arial", 12, 0xffffff);
			_message.defaultTextFormat = fm;
			
			var picbg:Shape = new Shape();
			picbg.graphics.beginFill(0xffffff);
			picbg.graphics.drawRect(0,0,200,200);
			picbg.graphics.endFill();
			addChildAt(picbg,0);
			picbg.x = picbg.y = 8;
			_bg = new Shape();
			addChildAt(_bg,0);
			var sd:DropShadowFilter = new DropShadowFilter(0,0,0,.8,8,8);
			_bg.filters = [sd];
			
			_category = new Shape();
			_forward = new forward();
			_forward.btnforward.addEventListener(MouseEvent.CLICK,share);
		}
		
		public function set category(val:int):void
		{
			if (val > 0)
			{
				_category.graphics.clear();
				var color:uint;
				switch (val)
				{
					case 1:
						color = 0x49dc31;
						break;
					case 2:
						color = 0xff0000;
						break;
					case 3:
						color = 0x02c1ff;
						break;
					case 4:
						color = 0xff00ea;
					default:
						break;
				}
				_category.graphics.beginFill(color);
				_category.graphics.moveTo(0,0);
				_category.graphics.lineTo(10,0);
				_category.graphics.lineTo(0,10);
				_category.graphics.lineTo(0,0);
				_category.graphics.endFill();
			}
		}
		
		public function get loading():Boolean
		{
			return _loading;
		}
		
		public function set params(val:Object):void
		{
			_params = val;
		}
		
		public function get params():Object
		{
			return _params;
		}
		
		public function set item(val:PhotoItem):void
		{
			_item = val;
		}
		
		public function get item():PhotoItem
		{
			return _item;
		}

		public function load()
		{
			if (_display != null)
			{
				removeChild(_display);
				_display.dispose();
			}
			var loader:ImageLoader = new ImageLoader(_params.img + "_big.jpg", {width:200, height:200, scaleMode:ScaleMode.PROPORTIONAL_INSIDE, onComplete:complete})
			loader.load();
			_loading = true;
		}
		
		private function complete(e:LoaderEvent):void
		{
			var loader:ImageLoader = e.target as ImageLoader;
			_display = loader.content;
			_display.x = _display.y = 8;
			_category.x = _category.y = _display.x
			addChild(_display);
			addChild(_category);
			
			_bg.graphics.clear();
			_bg.graphics.beginFill(0xb7d037);
			if (_params != null)
			{
				var txt:String = "";
				if (_params.user != null && _params.user != "")
				{
					txt += "用户名：" + _params.user + "<br>";
				}
				txt += "格调宣言：" + _params.text;
				_message.htmlText = txt;
				addChild(_message);
				_message.width = _display.fitWidth;
				_message.x = 8;
				_message.y = _display.y + _display.fitHeight + 6;
				_bg.graphics.drawRect(0,0,_display.fitWidth + 16, _message.y + _message.textHeight + 45);
			}
			else
			{
				_bg.graphics.drawRect(0,0,_display.fitWidth + 16, _display.y + _display.fitHeight + 45);
			}
			_bg.graphics.endFill();
			addChild(_forward);
			_forward.x = _bg.width;
			_forward.y = _bg.height - 40;
			var evt:Event = new Event(Event.COMPLETE);
			dispatchEvent(evt);
			_loading = false;
		}
		
		private function share(e:MouseEvent):void
		{
			ExternalInterface.call("shareToWeibo","#不趋同 自趋势#",_params.img + "_big.jpg");
		}
		
	}

}