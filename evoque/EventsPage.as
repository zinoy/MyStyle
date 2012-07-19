package evoque
{
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	import evoque.controls.*;
	import evoque.events.ScrollEvent;

	public class EventsPage extends Sprite
	{
		private const TOP:Number = 101;
		private var sbar:ColorScrollBar;
		private var td:TestDrivePanel;

		public function EventsPage()
		{
			init();
		}
		
		private function init():void
		{
			td = new TestDrivePanel();
			
			sbar = new ColorScrollBar();
			sbar.addEventListener(ScrollEvent.SCROLL_UPDATE, updatescroll);
			addChild(sbar);
			sbar.x = 790;
			sbar.y = TOP;
			
			drag.addEventListener(MouseEvent.MOUSE_WHEEL, scrollcontent);
			btnGo.addEventListener(MouseEvent.CLICK, showtd);
		}
		
		private function showtd(e:MouseEvent):void
		{
			ExternalInterface.call("pe", "EventsPage", "Open", "TestDrive");
			addChild(td);
			td.alpha = 0;
			TweenLite.to(td, .4, {alpha:1,ease:Quad.easeOut});
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