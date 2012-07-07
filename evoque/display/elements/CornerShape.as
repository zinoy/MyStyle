package evoque.display.elements
{
	import flash.display.*;
	import flash.events.Event;

	public class CornerShape extends MovieClip
	{

		public function CornerShape()
		{
			init();
		}
		
		private function init():void
		{
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void
		{
			var dot:Shape = new Shape();
			dot.mask = maskobj;
			
			var pattern:Shape = new Shape();
			pattern.graphics.beginFill(0);
			pattern.graphics.drawRect(1,0,1,1);
			pattern.graphics.endFill();
			
			var bm:BitmapData = new BitmapData(2,2,true,0);
			bm.draw(pattern);
			dot.graphics.beginBitmapFill(bm);
			dot.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			dot.graphics.endFill();
			
			addChild(dot);
		}
		
	}

}