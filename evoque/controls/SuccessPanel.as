package evoque.controls
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import com.asual.swfaddress.SWFAddress;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	import evoque.events.ActionEvent;

	public class SuccessPanel extends Sprite
	{

		public function SuccessPanel()
		{
			init();
		}
		
		private function init():void
		{
			btnClose.addEventListener(MouseEvent.CLICK,closepanel);
			btnEvents.addEventListener(MouseEvent.CLICK,goevents);
			btnUpload.addEventListener(MouseEvent.CLICK,goupload);
			btnGallery.addEventListener(MouseEvent.CLICK,gogallery);
		}
		
		private function closepanel(e:MouseEvent):void
		{
			TweenLite.to(this, .4, {alpha:0,ease:Quad.easeOut,onComplete:closed});
		}
		
		private function closed():void
		{
			var evt:ActionEvent = new ActionEvent(ActionEvent.CLOSE_PANEL);
			dispatchEvent(evt);
		}
		
		private function goevents(e:MouseEvent):void
		{
			TweenLite.to(this, .4, {alpha:0,ease:Quad.easeOut});
		}
		
		private function goupload(e:MouseEvent):void
		{
			TweenLite.to(this, .4, {alpha:0,ease:Quad.easeOut,onComplete:upload});
		}
		
		private function upload():void
		{
			var evt:ActionEvent = new ActionEvent(ActionEvent.UPLOAD_MORE);
			dispatchEvent(evt);
		}
		
		private function gogallery(e:MouseEvent):void
		{
			var evt:ActionEvent = new ActionEvent(ActionEvent.CLOSE_PANEL);
			dispatchEvent(evt);
			SWFAddress.setValue("showroom");
		}
		
	}

}