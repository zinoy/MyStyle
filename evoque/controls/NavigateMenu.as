package evoque.controls
{
	import flash.display.*;
	import flash.events.MouseEvent;
	
	import com.asual.swfaddress.SWFAddress;
	import evoque.events.ActionEvent;

	public class NavigateMenu extends Sprite
	{
		private var _list:Vector.<MenuButtonBase>;
		private var _bg:Shape;
		private var _blackBg:Shape;
		private var _lastActive:int;

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
		
		public function setCurrent(index:int):void
		{
			hideActive();
			_list[index].active = true;
		}
		
		private function gonav(e:MouseEvent):void
		{
			hideActive();

			var idx:int = _list.indexOf(e.currentTarget as MenuButtonBase);
			var nav:String;
			switch (idx)
			{
				case 0:
					nav = "home";
					break;
				case 1:
					//_list[idx].active = false;
					_list[_lastActive].active = true;
					var evt:ActionEvent = new ActionEvent(ActionEvent.SHOW_RULES);
					dispatchEvent(evt);
					return;
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
			_list[idx].active = true;
			SWFAddress.setValue(nav);
		}
		
		private function hideActive():void
		{
			trace("hide");
			for each (var it:MenuButtonBase in _list)
			{
				if (it.active)
				{
					it.active = false;
					_lastActive = _list.indexOf(it);
					break;
				}
			}

		}
		
	}

}