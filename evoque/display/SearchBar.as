package evoque.display
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import com.asual.swfaddress.SWFAddress;
	
	import evoque.common.Utility;

	public class SearchBar extends Sprite
	{

		public function SearchBar()
		{
			init();
		}
		
		private function init():void
		{
			btngo.addEventListener(MouseEvent.CLICK,go);
		}
		
		private function go(e:MouseEvent):void
		{
			var val:String = Utility.trim(tbquery.text);
			if (val.length > 0)
			{
				SWFAddress.setValue("showroom?q="+val);
			}
		}
		
	}

}