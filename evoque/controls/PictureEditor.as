package evoque.controls
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.ui.*;
	
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.display.ContentDisplay;
	
	import evoque.common.Shared;

	public class PictureEditor extends Sprite
	{
		private var _img:ContentDisplay;
		private var _dragstart:Point;
		private var _dragrect:Rectangle;
		private var _dragobj:Sprite;
		private var _zoom:int = 0;
		private var _step:Number;
		private var _offset:Point;

		public function PictureEditor()
		{
			init();
		}
		
		private function init():void
		{
			_dragrect = new Rectangle();
			_dragstart = new Point();
			_offset = new Point();
		}
		
		private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(MouseEvent.ROLL_OVER,over);
			dispatcher.addEventListener(MouseEvent.ROLL_OUT,out);
			dispatcher.addEventListener(MouseEvent.MOUSE_DOWN,startdrag);
			dispatcher.addEventListener(MouseEvent.MOUSE_UP,stopdrag);
        }
		
		private function over(e:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.HAND;
		}
		
		private function out(e:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.AUTO;
			stopdrag(null);
		}
		
		private function startdrag(e:MouseEvent):void
		{
			_dragstart.setTo(e.localX,e.localY);
			addEventListener(MouseEvent.MOUSE_MOVE,drag);
		}
		
		private function stopdrag(e:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_MOVE,drag);
			_offset.x = _img.x - _dragobj.width / 2;
			_offset.y = _img.y - _dragobj.height / 2;
		}
		
		private function drag(e:MouseEvent):void
		{
			var cur:Point = new Point(e.localX,e.localY);
			var dest:Point = cur.subtract(_dragstart);
			_dragstart = cur;
			_img.x += dest.x;
			_img.y += dest.y;
			if (_img.x < _dragrect.left)
				_img.x = _dragrect.left;
			if (_img.x > _dragrect.right)
				_img.x = _dragrect.right;
			if (_img.y < _dragrect.top)
				_img.y = _dragrect.top;
			if (_img.y > _dragrect.bottom)
				_img.y = _dragrect.bottom;
		}
		
		public function load(url:String):void
		{
			var loader:ImageLoader = new ImageLoader(Shared.URL_BASE + url,{container:this,centerRegistration:true,onComplete:showimg});
			loader.load();
		}
		
		private function showimg(e:LoaderEvent):void
		{
			var loader:ImageLoader = ImageLoader(e.target);
			_img = loader.content as ContentDisplay;
			var def:DisplayObject = getChildAt(0);
			var msk:Shape = new Shape();
			msk.graphics.beginFill(0x00ff00,0);
			msk.graphics.drawRect(0,0,def.width,def.height);
			msk.graphics.endFill();
			removeChild(def);
			_img.mask = msk;
			addChild(msk);
			fitscreen(_img,msk.width);
			
			_step = (1 - _img.scaleX) / 5;

			_dragobj = new Sprite();
			_dragobj.graphics.beginFill(0x00ff00);
			_dragobj.graphics.drawRect(0,0,def.width,def.height);
			_dragobj.graphics.endFill();
			addChild(_dragobj);
			_dragobj.alpha = 0;

			center(_img);
			calculate();
			configureListeners(_dragobj);
			var evt:Event = new Event(Event.COMPLETE);
			dispatchEvent(evt);
		}
		
		private function fitscreen(obj:DisplayObject,width:Number):void
		{
			if (obj.height < width || obj.width < width)
				return;
			
			var ratio:Number;
			if (obj.height > obj.width)
			{
				ratio = width / obj.width;
			}
			else
			{
				ratio = width / obj.height;
			}
			obj.scaleX = obj.scaleY = ratio;
		}
		
		private function center(obj:ContentDisplay):void
		{
			obj.x = _dragobj.width / 2;
			obj.y = _dragobj.height / 2;
		}
		
		private function calculate():void
		{
			_dragrect.x = _dragobj.width - _img.width / 2;
			_dragrect.right = _img.width / 2;
			_dragrect.y = _dragobj.height - _img.height / 2;
			_dragrect.bottom = _img.height / 2;
		}
		
		public function zoomin():void
		{
			if (_zoom < 4)
			{
				_zoom++;
				_img.scaleX = _img.scaleY = _img.scaleX + _step;
				calculate();
			}
		}
		
		public function zoomout():void
		{
			if (_zoom > 0)
			{
				_zoom--;
				_img.scaleX = _img.scaleY = _img.scaleX - _step;
				calculate();
				if (_img.x < _dragrect.left)
					_img.x = _dragrect.left;
				if (_img.x > _dragrect.right)
					_img.x = _dragrect.right;
				if (_img.y < _dragrect.top)
					_img.y = _dragrect.top;
				if (_img.y > _dragrect.bottom)
					_img.y = _dragrect.bottom;
			}
		}
		
		public function setangle(angle:Number):void
		{
			_img.rotation += angle;

			var r:Number = Math.sqrt(Math.pow(_offset.x,2) + Math.pow(_offset.y,2));
			var a:Number = Math.atan2(_offset.y,_offset.x);
			var b:Number = a + angle * Math.PI / 180;
			_offset = new Point(Math.cos(b) * r,Math.sin(b) * r);
			_img.x = _offset.x + _dragobj.width / 2;
			_img.y = _offset.y + _dragobj.height / 2;
			calculate();
		}
		
		public function get square():Rectangle
		{
			if (_img)
			{
				var rect:Rectangle = new Rectangle();
				rect.x = _img.width / 2 - (_dragobj.width / 2 + _offset.x);
				rect.y = _img.height / 2 - (_dragobj.height / 2 + _offset.y);
				rect.width = _dragobj.width;
				rect.height = _dragobj.height;
				return rect;
			}
			else
			{
				return null;
			}
		}
		
		public function get angle():Number
		{
			var a:Number = _img.rotation;
			if (a < 0)
			{
				a = 360 - a;
			}
			return a;
		}
		
		public function get scale():Number
		{
			return _img.scaleX;
		}
				
	}

}