package evoque
{
	import flash.display.*;
	import flash.events.MouseEvent;
	
	import evoque.controls.ColorScrollBar;
	import evoque.events.ScrollEvent;

	public class EventsPage extends Sprite
	{
		private const TOP:Number = 101;
		private var sbar:ColorScrollBar;

		public function EventsPage()
		{
			init();
		}
		
		private function init():void
		{
			sbar = new ColorScrollBar();
			sbar.addEventListener(ScrollEvent.SCROLL_UPDATE, updatescroll);
			addChild(sbar);
			sbar.x = 790;
			sbar.y = TOP;
			
			drag.addEventListener(MouseEvent.MOUSE_WHEEL, scrollcontent);
		}
		
		private function updatescroll(e:ScrollEvent):void
		{
			var len:Number = 311 - cnt.height;
			cnt.y = len * e.top + TOP;
		}

		private function scrollcontent(e:MouseEvent):void
		{
			var len:Number = 311 - cnt.height;
			cnt.y +=  e.delta * 26;
			if (cnt.y > TOP)
			{
				cnt.y = TOP;
			}
			if (cnt.y < len + TOP)
			{
				cnt.y = len + TOP;
			}
			sbar.pos = (cnt.y - TOP) / len;
		}
		
	}

}