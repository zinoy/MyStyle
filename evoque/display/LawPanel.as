package evoque.display
{
	import flash.display.*;
	import flash.events.*;
	
	import evoque.controls.ColorScrollBar;
	import evoque.events.*;

	public class LawPanel extends Sprite
	{
		private const TOP:Number = 68;
		private var sbar:ColorScrollBar;
		private var _mask:Shape;

		public function LawPanel()
		{
			init();
		}
		
		private function init():void
		{
			sbar = new ColorScrollBar(340);
			sbar.addEventListener(ScrollEvent.SCROLL_UPDATE, updatescroll);
			addChild(sbar);
			sbar.x = 570;
			sbar.y = TOP - 6;

			_mask = new Shape();
			addChildAt(_mask, 0);
			
			drag.alpha = 0;
			drag.addEventListener(MouseEvent.MOUSE_WHEEL, scrollcontent);
			
			btnClose.addEventListener(MouseEvent.CLICK, closePanel);
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function updatescroll(e:ScrollEvent):void
		{
			var len:Number = 322 - cnt.height;
			cnt.y = len * e.top + TOP;
		}

		private function scrollcontent(e:MouseEvent):void
		{
			var len:Number = 322 - cnt.height;
			cnt.y +=  e.delta * 14;
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
		
		private function addedToStage(e:Event):void
		{
			_mask.graphics.clear();
			_mask.graphics.beginFill(0, .5);
			_mask.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_mask.graphics.endFill();
			
			_mask.x = (stage.stageWidth - 1000) / 2 * -1 - this.x;
			_mask.y = (stage.stageHeight - 600) / 2 * -1 - this.y;
		}
		
		private function closePanel(e:MouseEvent):void
		{
			var evt:ActionEvent =  new ActionEvent(ActionEvent.CLOSE_PANEL);
			dispatchEvent(evt);
		}
		
	}

}