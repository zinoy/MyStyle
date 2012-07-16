package evoque
{
	import flash.display.*;
	import flash.external.ExternalInterface;
	
	public class HomePage extends Sprite
	{

		public function HomePage()
		{
			init();
		}
		
		private function init():void
		{
			ExternalInterface.call("pv", "home");
		}

	}

}