package evoque.display
{
	import flash.display.Sprite;
	import flash.events.*;
	
	import com.asual.swfaddress.SWFAddress;
	
	import evoque.common.Shared;

	public class CategoryTab extends Sprite
	{
		private var _category:int = 0;

		public function CategoryTab()
		{
			init();
		}
		
		private function init():void
		{
			for (var i:int=1; i<5; i++)
			{
				this["btnc_"+i].addEventListener(MouseEvent.CLICK,setcate);
				this["btnc_"+i].enable();
			}
			mypics.btnGo.addEventListener(MouseEvent.CLICK,showmypics);
			if (Shared.UID == "")
			{
				removeChild(mypics);
			}
			else
			{
				addEventListener(Event.ENTER_FRAME,onenter);
			}
		}
		
		private function onenter(e:Event):void
		{
			if (Shared.UID != "")
			{
				addChild(mypics);
				removeEventListener(Event.ENTER_FRAME,onenter);
			}
		}
		
		private function setcate(e:MouseEvent):void
		{
			var obj:Object = e.currentTarget;
			var c:int = Number(obj.name.split("_")[1]);
			trace(c);
			if (_category != c)
			{
				_category = c;
				for (var i:int=1; i<5; i++)
				{
					this["btnc_"+i].reset();
				}
				obj.select();
				
				SWFAddress.setValue("showroom?p=1&ca="+_category);
			}
		}
		
		private function showmypics(e:MouseEvent):void
		{
			if (Shared.UID != "")
			{
				for (var i:int=1; i<5; i++)
				{
					this["btnc_"+i].reset();
				}
				SWFAddress.setValue("showroom?p=1&self=1");
			}
		}
		
	}

}