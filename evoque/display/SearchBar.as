package evoque.display
{
	import flash.display.*;
	import flash.events.*;
	
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
			tbquery.text = "请输入搜索关键字";
			tbquery.addEventListener(TextEvent.TEXT_INPUT, hidetxt);
			btngo.addEventListener(MouseEvent.CLICK,go);
		}
		
		private function go(e:MouseEvent):void
		{
			var val:String = Utility.trim(tbquery.text);
			if (val.length > 0 && val != "请输入搜索关键字")
			{
				SWFAddress.setValue("showroom?q="+val);
			}
		}
		
		private function hidetxt(e:TextEvent):void
		{
			tbquery.removeEventListener(TextEvent.TEXT_INPUT, hidetxt);
			tbquery.text = "";
		}
		
	}

}