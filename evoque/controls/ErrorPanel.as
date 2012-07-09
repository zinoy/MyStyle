package evoque.controls
{
	import flash.display.MovieClip;
	
	public class ErrorPanel extends MovieClip
	{

		public function ErrorPanel()
		{
			init();
		}
		
		private function init():void
		{
			
		}
		
		public function showmsg(id:int):void
		{
			this.gotoAndStop(id);
		}
		
	}

}