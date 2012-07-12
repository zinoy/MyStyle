package evoque
{
	import flash.display.*;
	import flash.events.*;
	
	import com.asual.swfaddress.SWFAddress;
	
	import evoque.display.*;
	import evoque.events.*;

	public class MainPage extends Sprite
	{
		private var _gallery:PictureGrid;

		public function MainPage()
		{
			init();
		}
		
		private function init():void
		{
			_gallery = new PictureGrid();
			_gallery.addEventListener(ActionEvent.HIDE_CHILDREN,hideall);
			
			home.addEventListener(ActionEvent.SHOW_GALLERY,showgallery);
			SWFAddress.onChange = swfchange;
		}
		
		private function swfchange():void
		{
			var val:Array = SWFAddress.getPathNames();
			if (val[0] == "showroom")
			{
				showgallery(null);
			}
		}
		
		private function showgallery(e:ActionEvent):void
		{
			addChild(_gallery);
			_gallery.show();
		}
		
		private function hideall(e:ActionEvent):void
		{
			removeChild(home);
			removeChild(foot);
		}
		
	}

}