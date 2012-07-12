package evoque.animate
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.utils.getQualifiedClassName;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import evoque.display.PhotoItem;

	public class FlipItem extends Sprite
	{
		private var _forntside:DisplayObject;
		private var _backside:DisplayObject;
		private var _initobj:DisplayObject;
		private var _empty:Shape;
		private var _itemwidth:Number;

		public function FlipItem(front:DisplayObject, back:DisplayObject=null, itemWidth:Number=100)
		{
			_forntside = front;
			_backside = back;
			_itemwidth = itemWidth;
			init();
		}
		
		private function init():void
		{
			_forntside.x = _forntside.y = _itemwidth / 2;
			addChild(_forntside);
			
			var q:Number = Math.PI / 4;
			_empty = new Shape();
			_empty.graphics.beginGradientFill(GradientType.LINEAR, [0x3e3e3e, 0x0c0c0c], [1, 1], [0, 255], new Matrix(Math.cos(q), Math.sin(q), Math.sin(q)*-1, Math.cos(q)));
			_empty.graphics.drawRect(_itemwidth/2*-1,_itemwidth/2*-1,_itemwidth,_itemwidth);
			_empty.graphics.endFill();
			if (_backside == null)
			{
				_backside = _empty;
			}
			_backside.x = _backside.y = _itemwidth / 2;
			addChild(_backside);
			_backside.scaleX = 0;
			
		}
		
		public function get frontobj():DisplayObject
		{
			return _forntside;
		}
		
		public function get backobj():DisplayObject
		{
			return _backside;
		}
		
		public function set backobj(val:DisplayObject):void
		{
			_backside = val;
		}
		
		public function turnover(duration:Number=.4):void
		{
			var tl:TimelineLite = new TimelineLite({onComplete:endaction});
			tl.append(new TweenLite(_forntside, duration/2, {scaleX:0}));
			if (_backside)
			{
				tl.append(new TweenLite(_backside, duration/2, {scaleX:1}));
				swapside();
			}
			else
			{
				tl.append(new TweenLite(_forntside, duration/2, {scaleX:1}));
			}
		}
		
		public function swapside():void
		{
			var t:DisplayObject = _backside;
			_backside = _forntside;
			_forntside = t;
			_backside.scaleX = 0;
		}
		
		private function endaction():void
		{
			if (_initobj == null)
			{
				_initobj = _forntside;
			}
		}
				
	}

}