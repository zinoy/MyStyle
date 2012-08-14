package evoque.controls
{
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
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
			_bg = new Shape();
			_bg.graphics.beginFill(0xffffff);
			_bg.graphics.moveTo(0, 0);
			_bg.graphics.lineTo(551, 0);
			_bg.graphics.lineTo(603, 52);
			_bg.graphics.lineTo(52, 52);
			_bg.graphics.lineTo(0, 0);
			_bg.graphics.endFill();
			addChildAt(_bg, 0);
			_blackBg = new Shape();
			_blackBg.graphics.beginFill(0);
			_blackBg.graphics.moveTo(0, 0);
			_blackBg.graphics.lineTo(551, 0);
			_blackBg.graphics.lineTo(603, 52);
			_blackBg.graphics.lineTo(52, 52);
			_blackBg.graphics.lineTo(0, 0);
			_blackBg.graphics.endFill();
			addChildAt(_blackBg, 1);

			_list = new <MenuButtonBase>[navHome,navPrize,navShowroom,navEvoque,navEvents,navRules];
			for each (var it:MenuButtonBase in _list)
			{
				it.addEventListener(MouseEvent.CLICK,gonav);
			}
		}
		
		public function get black():Shape
		{
			return _blackBg;
		}
		
		public function get white():Shape
		{
			return _bg;
		}
		
		public function setCurrent(index:int):void
		{
			hideActive();
			_list[index].active = true;
		}
		
		private function gonav(e:MouseEvent):void
		{
			//hideActive();

			var idx:int = _list.indexOf(e.currentTarget as MenuButtonBase);
			var nav:String;
			switch (idx)
			{
				case 0:
					ExternalInterface.call("pe", "EMS", "MainMenu", "Home");
					nav = "home";
					break;
				case 5:
					ExternalInterface.call("pe", "EMS", "MainMenu", "Rules");
					//_list[idx].active = false;
					_list[_lastActive].active = true;
					var evt:ActionEvent = new ActionEvent(ActionEvent.SHOW_RULES);
					dispatchEvent(evt);
					return;
				case 1:
					ExternalInterface.call("pe", "EMS", "MainMenu", "Prize");
					nav = "prize";
					return;//will update after finish this page
				case 2:
					ExternalInterface.call("pe", "EMS", "MainMenu", "Showroom");
					nav = "showroom";
					break;
				case 3:
					ExternalInterface.call("pe", "EMS", "MainMenu", "Evoque");
					nav = "evoque";
					break;
				case 4:
					ExternalInterface.call("pe", "MainMenu", "Click", "Events");
					nav = "events";
					break;
				default:
					return;
			}
			//_list[idx].active = true;
			SWFAddress.setValue(nav);
		}
		
		private function hideActive():void
		{
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