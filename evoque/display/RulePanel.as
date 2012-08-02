package evoque.display
{
	import flash.display.*;
	import flash.events.*;
	
	import evoque.events.ActionEvent;

	public class RulePanel extends Sprite
	{
		private var _mask:Shape;

		public function RulePanel()
		{
			init();
		}
		
		private function init():void
		{
			_mask = new Shape();
			addChildAt(_mask, 0);
			
			btnClose.addEventListener(MouseEvent.CLICK, closePanel);
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(e:Event):void
		{
			_mask.graphics.clear();
			_mask.graphics.beginFill(0, .8);
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