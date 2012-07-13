package evoque.display
{
	import flash.display.*;
	import flash.events.MouseEvent;
	import evoque.events.PageEvent;
	
	[Event(name="pageChange", type="evoque.events.PageEvent")]
	public class PagerBlock extends Sprite
	{
		private var _items:Vector.<PagerCell>;
		private var _total:int;

		public function PagerBlock(width:Number,current:int,total:int)
		{
			init(width,current,total);
		}
		
		private function init(w:Number,cur:int,total:int):void
		{
			_total = total;
			_items = new Vector.<PagerCell>();
			var count:int = total > 9 ? 9 : total;
			for (var i:int=0; i<count; i++)
			{
				var cw:Number = w / 3;
				var cell:PagerCell = new PagerCell(cw);
				cell.addEventListener(MouseEvent.CLICK,onChange);
				addChild(cell);
				cell.x = i % 3 * cw - w / 2;
				cell.y = Math.floor(i / 3) * cw - w / 2;
				if (i + 1 == cur)
					cell.active();
				_items.push(cell);
			}
			var list:Array = [];
			var p:int, end:int, n:int;
			if (total <= 9)
			{
				for (n=0; n<total; n++)
				{
					list.push(String(n + 1));
				}
			}
			else if (total <= 16)
			{
				p = Math.ceil(cur / 8);
				end = 8;
				if (p > 1)
				{
					end = total - 8;
					list.push("prev");
				}
				for (n=(p - 1) * 8; n<end; n++)
				{
					list.push(String(n + 1));
				}
				if (p == 1)
				{
					list.push("next");
				}
			}
			else
			{
				p = Math.ceil(cur / 7);
				end = 7;
				if (p == Math.ceil(total % 7))
				{
					end = total - 7;
				}
				if (p > 1)
				{
					list.push("prev");
				}
				for (n=(p - 1) * 7; n<end; n++)
				{
					list.push(String(n + 1));
				}
				if (p == 1)
				{
					list.push("next");
				}
			}
			setlabel(list);
		}
		
		private function setlabel(list:Array):void
		{
			for (var i:int=0; i<_items.length; i++)
			{
				_items[i].text = list[i];
			}
		}
		
		private function onChange(e:MouseEvent):void
		{
			
			var obj:PagerCell = e.currentTarget as PagerCell;
			if (obj.isActive)
				return;
			reset();
			obj.active();
			var evt:PageEvent = new PageEvent(PageEvent.PAGE_CHANGE);
			if (obj.index == 0)
			{
				if (_items.indexOf(obj) == 0)
				{
					evt.index = _items[1].index - 1;
				}
				else
				{
					evt.index = _items[_items.length - 2].index + 1;
				}
			}
			else
			{
				evt.index = obj.index;
			}
			dispatchEvent(evt);
		}
		
		private function reset():void
		{
			for each (var cell:PagerCell in _items)
			{
				cell.reset();
			}
		}

	}

}