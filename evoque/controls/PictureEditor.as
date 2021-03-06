﻿package evoque.controls
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.ui.*;
	import flash.utils.*;
	
	import com.adobe.images.*;
	
	import evoque.common.Shared;
	import evoque.display.Preloader;

	public class PictureEditor extends Sprite
	{
		private const ZOOM_LEVEL:int = 6;
		
		private var _defimg:DisplayObject;
		private var _loading:Preloader;
		private var _img:Sprite;
		private var _dragstart:Point;
		private var _dragrect:Rectangle;
		private var _dragobj:Sprite;
		private var _zoom:int = 0;
		private var _step:Array;
		private var _offset:Point;

		public function PictureEditor()
		{
			init();
		}
		
		private function init():void
		{
			_loading = new Preloader(233);
			_dragrect = new Rectangle();
			_dragstart = new Point();
			_offset = new Point();
		}
		
		private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(MouseEvent.ROLL_OVER,over);
			dispatcher.addEventListener(MouseEvent.ROLL_OUT,out);
			dispatcher.addEventListener(MouseEvent.MOUSE_DOWN,startdrag);
        }
		
		private function over(e:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.HAND;
		}
		
		private function out(e:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.AUTO;
			//stopdrag(null);
		}
		
		public function loading():void
		{
			addChild(_loading);
			_loading.x = _loading.y = 233 / 2;
		}
		
		private function startdrag(e:MouseEvent):void
		{
			_dragstart.x = e.localX;
			_dragstart.y = e.localY;
			addEventListener(MouseEvent.MOUSE_MOVE,drag);
			stage.addEventListener(MouseEvent.MOUSE_UP,stopdrag);
		}
		
		private function stopdrag(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopdrag);
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
		
		public function load(file:FileReference):void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,showimg);
			loader.loadBytes(file.data);
		}
		
		private function showimg(e:Event):void
		{
			var loader:LoaderInfo = LoaderInfo(e.target);
			loader.removeEventListener(Event.COMPLETE,showimg);
			var bmp:Bitmap = loader.content as Bitmap;
			bmp.smoothing = true;
			_img = new Sprite();
			_img.addChild(bmp);
			bmp.x = bmp.width / 2 * -1;
			bmp.y = bmp.height / 2 * -1;
			addChild(_img);
			_defimg = getChildAt(0);
			
			var msk:Shape = new Shape();
			msk.graphics.beginFill(0x00ff00,0);
			msk.graphics.drawRect(0,0,_defimg.width,_defimg.height);
			msk.graphics.endFill();
			_defimg.alpha = 0;
			_img.mask = msk;
			addChild(msk);
			fitscreen(_img,msk.width);
			
			_step = [_img.scaleX];
			for (var i:int=1; i<ZOOM_LEVEL; i++)
			{
				_step.push((1 - Math.cos(Math.PI / 2 / (ZOOM_LEVEL - 1) * i)) / 1 * (1 - _img.scaleX) + _img.scaleX);
			}
			
			_dragobj = new Sprite();
			_dragobj.graphics.beginFill(0x00ff00);
			_dragobj.graphics.drawRect(0,0,_defimg.width,_defimg.height);
			_dragobj.graphics.endFill();
			addChild(_dragobj);
			_dragobj.alpha = 0;

			center(_img);
			calculate();
			if (_img.height > msk.height || _img.width > msk.width)
			{
				configureListeners(_dragobj);
			}
			var evt:Event = new Event(Event.COMPLETE);
			dispatchEvent(evt);
			removeChild(_loading);
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
		
		private function center(obj:DisplayObject):void
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
			if (_zoom < ZOOM_LEVEL - 1)
			{
				_zoom++;
				_img.scaleX = _img.scaleY = _step[_zoom];
				calculate();
			}
		}
		
		public function zoomout():void
		{
			if (_zoom > 0)
			{
				_zoom--;
				_img.scaleX = _img.scaleY = _step[_zoom];
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
			_offset.x = Math.cos(b) * r;
			_offset.y = Math.sin(b) * r;
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