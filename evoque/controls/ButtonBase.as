package evoque.controls
{
	import flash.display.Sprite;

	public class ButtonBase extends Sprite
	{

		public function ButtonBase()
		{
			init();
		}

		private function init():void
		{
			this.buttonMode = true;
			this.mouseChildren = false;
		}

	}

}