package evoque.controls
{
	import flash.display.*;
	import flash.events.MouseEvent;
	
	import com.asual.swfaddress.SWFAddress;

	public class NavigateMenu extends Sprite
	{
		private var _list:Vector.<MenuButtonBase>;
		private var _bg:Shape;
		private var _blackBg:Shape;

		public function NavigateMenu()
		{
			init();
		}
		
		private function init():void
		{
			_bg = getChildAt(0) as Shape;
			_blackBg = new Shape();
			_blackBg.graphics.beginFill(0);
			_blackBg.graphics.moveTo(0, 0);
			_blackBg.graphics.lineTo(551, 0);
			_blackBg.graphics.lineTo(603, 52);
			_blackBg.graphics.lineTo(52, 52);
			_blackBg.graphics.lineTo(0, 0);
			_blackBg.graphics.endFill();
			addChildAt(_blackBg, 1);

			_list = new <MenuButtonBase>[navHome,navRules,navPrize,navShowroom,navEvoque,navEvents];
			for each (var it:MenuButtonBase in _list)
			{
				it.addEventListener(MouseEvent.CLICK,gonav);
			}
			_list[0].active = true;
		}
		
		public function get black():Shape
		{
			return _blackBg;
		}
		
		private function gonav(e:MouseEvent):void
		{
			for each (var it:MenuButtonBase in _list)
			{
				if (it != e.currentTarget)
					it.active = false;
			}

			var idx:int = _list.indexOf(e.currentTarget as MenuButtonBase);
			var nav:String;
			switch (idx)
			{
				case 0:
					nav = "home";
					break;
				case 1:
					nav = "#rules";
					break;
				case 2:
					nav = "prize";
					break;
				case 3:
					nav = "showroom";
					break;
				case 4:
					nav = "evoque";
					break;
				case 5:
					nav = "events";
					break;
				default:
					return;
			}
			SWFAddress.setValue(nav);
		}
		
	}

}