package evoque.display
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.*;

	public class BottomLinks extends Sprite
	{

		public function BottomLinks()
		{
			init();
		}
		
		private function init():void
		{
			lwebsite.addEventListener(MouseEvent.CLICK,goWebsite);
			ltd.addEventListener(MouseEvent.CLICK,goTd);
			lkmi.addEventListener(MouseEvent.CLICK,goKmi);
			ldealer.addEventListener(MouseEvent.CLICK,goDealer);
			
			sweibo.addEventListener(MouseEvent.CLICK,shareWeibo);
			skaixin.addEventListener(MouseEvent.CLICK,shareKaixin);
			srenren.addEventListener(MouseEvent.CLICK,shareRenren);
			sdouban.addEventListener(MouseEvent.CLICK,shareDouban);
		}
		
		private function goWebsite(e:MouseEvent):void
		{
			var req:URLRequest = new URLRequest("http://www.landrover.com/cn/zh/lr/?utm_campaign=Evoque_My_Style&utm_source=Evoque_My_Style&utm_medium=BANNER");
			navigateToURL(req, "_blank");
		}

		private function goTd(e:MouseEvent):void
		{
			var req:URLRequest = new URLRequest("http://www.landroverchina.com.cn/shijia.html?utm_campaign=Evoque_My_Style&utm_source=Evoque_My_Style&utm_medium=BANNER");
			navigateToURL(req, "_blank");
		}

		private function goKmi(e:MouseEvent):void
		{
			var req:URLRequest = new URLRequest("http://www.landroverchina.com.cn/tanchuss.html?utm_campaign=Evoque_My_Style&utm_source=Evoque_My_Style&utm_medium=BANNER");
			navigateToURL(req, "_blank");
		}

		private function goDealer(e:MouseEvent):void
		{
			var req:URLRequest = new URLRequest("http://www.landroverchina.com.cn/retailers.asp?utm_campaign=Evoque_My_Style&utm_source=Evoque_My_Style&utm_medium=BANNER");
			navigateToURL(req, "_blank");
		}
		
		private function shareWeibo(e:MouseEvent):void
		{
			ExternalInterface.call("pe", "BottomShare", "Click", "Weibo");
			ExternalInterface.call("shareToWeibo", "#不趋同 自趋势#路虎揽胜极光，融英伦灵感，焕瞩目风潮。上传专属您风格的英伦图片，成功转发并@ 好友，赢取限量版路虎好礼！");
		}

		private function shareKaixin(e:MouseEvent):void
		{
			ExternalInterface.call("pe", "BottomShare", "Click", "Kaixin");
			ExternalInterface.call("shareToKaixin", "#不趋同 自趋势#路虎揽胜极光，融英伦灵感，焕瞩目风潮。上传专属您风格的英伦图片，成功转发并@ 好友，赢取限量版路虎好礼！");
		}

		private function shareRenren(e:MouseEvent):void
		{
			ExternalInterface.call("pe", "BottomShare", "Click", "Renren");
			ExternalInterface.call("shareToRenren", "不趋同 自趋势", "路虎揽胜极光，融英伦灵感，焕瞩目风潮。上传专属您风格的英伦图片，成功转发并@ 好友，赢取限量版路虎好礼！");
		}

		private function shareDouban(e:MouseEvent):void
		{
			ExternalInterface.call("pe", "BottomShare", "Click", "Douban");
			ExternalInterface.call("shareToDouban", "#不趋同 自趋势#路虎揽胜极光，融英伦灵感，焕瞩目风潮。上传专属您风格的英伦图片，成功转发并@ 好友，赢取限量版路虎好礼！");
		}

	}

}