package evoque.animate
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.utils.getQualifiedClassName;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import evoque.display.PhotoItem;
	import evoque.common.Shared;

	public class FlipItem extends Sprite
	{
		private var _forntside:DisplayObject;
		private var _backside:DisplayObject;
		//private var _initobj:DisplayObject;
		private var _empty:Bitmap;
		private var _emptyback:Shape;
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
			
			if (_backside == null)
			{
				var bmp:Bitmap = new Bitmap(Shared.blankGrid)
				var ept:Sprite = new Sprite();
				ept.addChild(bmp);
				bmp.x = bmp.y = _itemwidth / 2 * -1;
				_backside = ept;
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
			if (_backside && contains(_backside))
				removeChild(_backside);
			_backside = val;
			if (!val)
			{
				var bmp:Bitmap = new Bitmap(Shared.blankGrid)
				var ept:Sprite = new Sprite();
				ept.addChild(bmp);
				bmp.x = bmp.y = _itemwidth / 2 * -1;
				_backside = ept;
			}
			addChild(_backside);
			_backside.x = _backside.y = _itemwidth / 2;
			_backside.scaleX = 0;
		}
		
		public function turnover(duration:Number=.4):void
		{
			var tl:TimelineLite = new TimelineLite({onComplete:endaction});
			tl.append(new TweenLite(_forntside, duration/2, {scaleX:0}));
			tl.append(new TweenLite(_backside, duration/2, {scaleX:1}));
		}
		
		public function swapside():void
		{
			var t:DisplayObject = _backside;
			_backside = _forntside;
			_forntside = t;
		}
		
		private function endaction():void
		{
			/*if (_initobj == null)
			{
				_initobj = _forntside;
			}*/
			swapside();
		}
				
	}

}