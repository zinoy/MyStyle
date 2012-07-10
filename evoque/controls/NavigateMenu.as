package evoque.controls
{
	import flash.display.*;
	
	import com.asual.swfaddress.SWFAddress;
	import flash.events.MouseEvent;

	public class NavigateMenu extends Sprite
	{
		private var _list:Vector.<MenuButtonBase>;

		public function NavigateMenu()
		{
			init();
		}
		
		private function init():void
		{
			_list = new <MenuButtonBase>[navHome,navPrize,navShowroom,navEvoque,navDealers];
			for each (var it:MenuButtonBase in _list)
			{
				it.addEventListener(MouseEvent.CLICK,gonav);
			}
			_list[0].active = true;
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
					nav = "prize";
					break;
				case 2:
					nav = "showroom";
					break;
				case 3:
					nav = "evoque";
					break;
				case 4:
					nav = "dealers";
					break;
				default:
					return;
			}
			SWFAddress.setValue(nav);
		}
		
	}

}