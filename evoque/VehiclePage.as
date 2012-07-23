package evoque
{
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.*;

	import evoque.controls.LightScrollBar;
	import evoque.events.ScrollEvent;

	public class VehiclePage extends Sprite
	{
		private const PADDING:Number = 6;
		private const TOP:Number = 274;
		private var _sbar1:LightScrollBar;
		private var _sbar2:LightScrollBar

		public function VehiclePage()
		{
			init();
		}

		private function init():void
		{
			ExternalInterface.call("pv", "/evoque");
			_sbar1 = new LightScrollBar();
			_sbar1.name = "sbar1";
			_sbar1.addEventListener(ScrollEvent.SCROLL_UPDATE, updatescroll);
			addChild(_sbar1);
			_sbar1.x = 313;
			_sbar1.y = 268;
			
			_sbar2 = new LightScrollBar();
			_sbar2.name = "sbar2";
			_sbar2.addEventListener(ScrollEvent.SCROLL_UPDATE, updatescroll);
			addChild(_sbar2);
			_sbar2.x = 629;
			_sbar2.y = 268;

			drag1.addEventListener(MouseEvent.MOUSE_WHEEL, scrollcontent);
			drag2.addEventListener(MouseEvent.MOUSE_WHEEL, scrollcontent);
			btnb1.addEventListener(MouseEvent.CLICK, gobrochure);
			btnb2.addEventListener(MouseEvent.CLICK, gobrochure);
			btnp1.addEventListener(MouseEvent.CLICK, gospec);
			btnp2.addEventListener(MouseEvent.CLICK, gospec);
		}

		private function updatescroll(e:ScrollEvent):void
		{
			var obj:LightScrollBar = e.currentTarget as LightScrollBar;
			var i:String = obj.name.substring(obj.name.length - 1);
			var cnt:DisplayObject = this["copy" + i];
			
			var len:Number = 128 - (cnt.height + PADDING * 2 + 5);
			cnt.y = len * e.top + TOP;
		}

		private function scrollcontent(e:MouseEvent):void
		{
			var obj:DisplayObject = e.currentTarget as DisplayObject;
			var i:String = obj.name.substring(obj.name.length - 1);
			var cnt:DisplayObject = this["copy" + i];

			var len:Number = 128 - (cnt.height + PADDING * 2 + 5);
			cnt.y +=  e.delta * 11;
			if (cnt.y > TOP)
			{
				cnt.y = TOP;
			}
			if (cnt.y < len + TOP)
			{
				cnt.y = len + TOP;
			}
			this["_sbar" + i].pos = (cnt.y - TOP) / len;
		}
		
		private function gobrochure(e:MouseEvent):void
		{
			var req:URLRequest = new URLRequest("files/12my-evoque_brochure.pdf");
			navigateToURL(req);
		}
		
		private function gospec(e:MouseEvent):void
		{
			var req:URLRequest = new URLRequest("files/12my_evoque spec sheet.pdf");
			navigateToURL(req);
		}

	}

}