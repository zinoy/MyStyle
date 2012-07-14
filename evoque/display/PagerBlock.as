package evoque.display
{
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	
	import com.asual.swfaddress.SWFAddress;
	
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
			var list:Array = getlist(cur);
			_items = new Vector.<PagerCell>();
			for (var i:int=0; i<list.length; i++)
			{
				var cw:Number = w / 3;
				var cell:PagerCell = new PagerCell(cw);
				cell.addEventListener(MouseEvent.CLICK,onChange);
				addChild(cell);
				cell.x = i % 3 * cw - w / 2;
				cell.y = Math.floor(i / 3) * cw - w / 2;
				cell.text = list[i];
				if (int(list[i]) == cur)
					cell.active();
				_items.push(cell);
			}
		}
		
		private function getlist(cur:int):Array
		{
			var list:Array = [];
			if (_total <= 9)
			{
				for (var i:int=0; i<_total; i++)
				{
					list.push(String(i+1));
				}
				return list;
			}
			var st:int;
			var tp:Number = 1;
			tp += Math.ceil((_total - 8) / 7);
			if (_total - (tp-1)*7+8 == 1)
			{
				tp--;
			}
			var p:Number
			if (cur > 8)
			{
				p = Math.ceil((cur - 8) / 7) + 1;
				if (p > tp)
				{
					p = tp;
				}
				st = (p - 1) * 7 + 1;
			}
			else
			{
				p = 1;
				st = 0;
			}
			var end:int = st + 7;
			if (p == tp)
			{
				end = st + (_total - ((p - 2) * 7 + 8));
			}
			if (p > 1)
			{
				list.push("prev");
			}
			for (var n:int=st; n<end; n++)
			{
				list.push(String(n + 1));
			}
			if (p == 1)
			{
				list.push(String(st + 8));
			}
			if (p < tp)
			{
				list.push("next");
			}
			return list;
		}
		
		private function onChange(e:MouseEvent):void
		{
			
			var obj:PagerCell = e.currentTarget as PagerCell;
			if (obj.isActive)
				return;
			reset();
			var pidx:int;
			if (obj.index == 0)
			{
				if (_items.indexOf(obj) == 0)
				{
					pidx = _items[1].index - 1;
				}
				else
				{
					pidx = _items[_items.length - 2].index + 1;
				}
			}
			else
			{
				pidx = obj.index;
			}
			var qs:String = SWFAddress.getQueryString();
			var d:URLVariables = new URLVariables(qs);
			d.p = pidx;
			var ca:Object = SWFAddress.getParameter("ca");
			var self:Object = SWFAddress.getParameter("self");
			if (ca)
				d.ca = ca;
			if (self)
				d.self = 1;
			var path:String = "showroom?";
			SWFAddress.setValue(path+d);
		}
		
		private function reset():void
		{
			for each (var cell:PagerCell in _items)
			{
				cell.removeEventListener(MouseEvent.CLICK,onChange);
				//cell.reset();
			}
		}

	}

}