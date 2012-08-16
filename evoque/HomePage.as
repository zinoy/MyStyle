package evoque
{
	import flash.display.*;
	import flash.external.ExternalInterface;
	import flash.events.*;
	import flash.net.*;
	
	import com.greensock.TweenLite;
	import com.greensock.TimelineLite;
	import com.greensock.easing.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.*;
	import com.greensock.loading.display.ContentDisplay;
	
	import evoque.common.*;
	import flash.geom.Point;
	
	public class HomePage extends Sprite
	{
		private const ITEM_WIDTH:Number = 25;
		private var _dimension:SquareSize;
		private var _squares:Vector.<Bitmap>;
		private var _picloader:LoaderMax;
		private var _board:Sprite;

		public function HomePage()
		{
			init();
		}
		
		private function init():void
		{
			ExternalInterface.call("pv", "/home");

			var loader:URLLoader = new URLLoader();
			var req:URLRequest = new URLRequest(Shared.URL_BASE + "Action.aspx");
			var d:URLVariables = new URLVariables();
			d.ac = "randpics";
			d.count = 50;
			d.hash = Utility.hash(d);
			req.data = d;
			req.method = "post";
			loader.addEventListener(Event.COMPLETE,loadpic);
			loader.addEventListener(IOErrorEvent.IO_ERROR,error);
			loader.load(req);
			
			_dimension = new SquareSize(40, 24);
		}
		
		private function loadpic(e:Event):void
		{
			var loader:URLLoader = URLLoader(e.target);
			var xml:XML = XML(loader.data);
			if (xml.code == 0)
			{
				_picloader = new LoaderMax({name:"mainQueue", maxConnections:5, onComplete:preparepic, onError:error});
				
				for each (var d:XML in xml.list.item)
				{
					_picloader.append(new ImageLoader(Shared.IMAGE_PATH + d.img + "_small.jpg", {name:"pic"+d.id, width:ITEM_WIDTH, height:ITEM_WIDTH, crop:true, scaleMode:ScaleMode.PROPORTIONAL_OUTSIDE, centerRegistration:false}));
				}
				_picloader.load();
			}
		}
		
		private function preparepic(e:LoaderEvent):void
		{
			var list:Array = _picloader.getChildren(true);
			_squares = new Vector.<Bitmap>();
			_board = new Sprite();
			_board.blendMode = BlendMode.OVERLAY;
			for (var i:int=0; i<_dimension.row; i++)
			{
				for (var j:int=0; j<_dimension.column; j++)
				{
					var index:int = Utility.rand(list.length);
					var raw:Bitmap = list[index].rawContent;
					var pic:Bitmap = new Bitmap(raw.bitmapData);
					pic.width = pic.height = ITEM_WIDTH;
					pic.x = j * pic.width;
					pic.y = i * pic.height;
					pic.alpha = 0;
					_board.addChild(pic);
					_squares.push(pic);
				}
			}
			trace("done:",list[0].content.x,list[0].content.y);
			addChildAt(_board, 1);
			
			var len:int = _dimension.row + _dimension.column - 1;
			for (var n:int=0; n<len; n++)
			{
				TweenLite.delayedCall(n * .1, setline, [n]);
			}
		}
		
		private function setline(line:int):void
		{
			var items:Vector.<Bitmap> = new Vector.<Bitmap>();
			var p:Point = getstartpoint(line);

			while(p.x >= 0 && p.y >= 0)
			{
				var tl:TimelineLite = new TimelineLite();
				var it:DisplayObject = _squares[_dimension.getIndexAt(p)];
				tl.append(new TweenLite(it, .4, {alpha:1}));
				tl.append(new TweenLite(it, 1.8, {alpha:1}));
				tl.append(new TweenLite(it, .4, {alpha:0, onComplete:restart, onCompleteParams:[tl]}));
				p.x--;
				p.y--;
			}
		}
		
		private function getstartpoint(idx:int):Point
		{
			var pt:Point = new Point();
			if (idx < _dimension.column)
			{
				pt.x = idx;
				pt.y = _dimension.row - 1;
			}
			else
			{
				pt.x = _dimension.column - 1;
				pt.y = _dimension.row - (idx - _dimension.column + 1) - 1;
			}
			return pt;
		}
		
		private function restart(obj:TimelineLite):void
		{
			obj.delay = 10;
			obj.restart(true);
		}
		
		private function error(e:*):void
		{
			trace(e);
		}

	}

}