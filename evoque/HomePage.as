package evoque
{
	import flash.display.*;
	import flash.events.*;
	
	import evoque.events.*;

	[Event(name="uploadMore", type="evoque.events.ActionEvent")]
	public class HomePage extends Sprite
	{

		public function HomePage()
		{
			init();
		}
		
		private function init():void
		{
			btnupload.addEventListener(MouseEvent.CLICK,goupload);
		}

		private function goupload(e:Event):void
		{
			var evt:ActionEvent = new ActionEvent(ActionEvent.UPLOAD_MORE);
			dispatchEvent(evt);
		}
		
	}

}