package evoque.display
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.utils.*;
	
	import com.asual.swfaddress.SWFAddress;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import com.greensock.loading.*;
	import com.greensock.layout.*;
	
	import evoque.animate.FlipItem;
	import evoque.common.*;
	import evoque.controls.*;
	import evoque.events.*;
	import com.greensock.events.LoaderEvent;

	[Event(name="hideChildren", type="evoque.events.ActionEvent")]
	[Event(name="showFootbar", type="evoque.events.ActionEvent")]
	public class PictureGrid extends Sprite
	{
		private var _picpanel:Sprite;
		private var _squares:Vector.<FlipItem>;
		private var _dimension:SquareSize;
		private var _picloader:LoaderMax;
		private var _uploadPicAfterLogin:Boolean = false;
		
		private var _cellwidth:Number;
		private var _pageindex:int = 1;

		public function PictureGrid()
		{
			init();
		}
		
		private function init():void
		{
			_picpanel = new Sprite();
			_squares = new Vector.<FlipItem>();
			_picloader = new LoaderMax({name:"picQueue"});
			
			addEventListener(Event.ADDED_TO_STAGE,addedToStage);
		}
		
		private function addedToStage(e:Event):void
		{
			stage.addEventListener(Event.RESIZE,adjustPos);
		}
		
		private function adjustPos(e:Event):void
		{
			_picpanel.x = 1000 / 2;
			_picpanel.y = 600 / 2;
		}
		
		public function show():void
		{
			var col:int = Math.floor(stage.stageWidth / 100);
			_cellwidth = stage.stageWidth / col;
			var row:int = Math.floor(stage.stageHeight / _cellwidth) + 2;
			_dimension = new SquareSize(col, row);
			
			//prepare blank grid
			var blank:BitmapData = new BitmapData(_cellwidth,_cellwidth);
			var q:Number = Math.PI / 4;
			var empty:Shape = new Shape();
			empty.graphics.beginGradientFill(GradientType.LINEAR, [0x3e3e3e, 0x0c0c0c], [1, 1], [0, 255], new Matrix(Math.cos(q), Math.sin(q), Math.sin(q)*-1, Math.cos(q)));
			empty.graphics.drawRect(0,0,_cellwidth,_cellwidth);
			empty.graphics.endFill();
			blank.draw(empty);
			Shared.blankGrid = blank;
			
			var ca:Object = SWFAddress.getParameter("ca");
			var p:Object = SWFAddress.getParameter("p");
			var uid:Object = SWFAddress.getParameter("self");
			var query:Object = SWFAddress.getParameter("q");
			if (p)
				_pageindex = int(p);
			var loader:URLLoader = new URLLoader();
			var req:URLRequest = new URLRequest(Shared.URL_BASE + "Action.aspx");
			var d:URLVariables = new URLVariables();
			if (query)
			{
				d.ac = "search";
				d.q = query;
			}
			else
			{
				d.ac = "getpics";
				d.ca = ca;
				d.uid = uid == 1 ? Shared.UID : "";
			}
			d.p = _pageindex;
			d.s = _dimension.contentLength;
			d.hash = Utility.hash(d);
			req.data = d;
			req.method = "post";
			if (_squares.length > 0)
				loader.addEventListener(Event.COMPLETE,refreshpic);
			else
				loader.addEventListener(Event.COMPLETE,loadpic);
			loader.addEventListener(IOErrorEvent.IO_ERROR,error);
			loader.load(req);
		}
		
		private function loadpic(e:Event):void
		{
			var loader:URLLoader = URLLoader(e.target);
			loader.removeEventListener(Event.COMPLETE,loadpic);
			var xml:XML = XML(loader.data);
			if (xml.code == 0)
			{
				var sc:BitmapData = new BitmapData(stage.stageWidth,stage.stageHeight,true,0);
				sc.draw(stage);

				var offset:Number = ((_dimension.row - 2) * _cellwidth - stage.stageHeight) / 2;
				var rect:Rectangle = new Rectangle();
				rect.width = _dimension.column * _cellwidth;
				rect.height = _dimension.row * _cellwidth;
				rect.x = rect.width / 2 * -1;
				rect.y = rect.height / 2 * -1;
				
				var imglist:XMLList = xml.list.item;
				if (!imglist)
				{
					trace("empty list");
					return;
				}
				var cpos:Rectangle = Utility.center(_dimension,imglist.length());
				var count:int = 0;
				
				for (var i:int=0; i<_dimension.row; i++)
				{
					for (var j:int=0; j<_dimension.column; j++)
					{
						var s:ScreenBlock = new ScreenBlock(sc,_cellwidth,new Point(j,i),offset);
						var f:FlipItem;
						if (i == _dimension.row-4 && j == _dimension.column-1)
						{
							var pr:PagerBlock = new PagerBlock(_cellwidth,_pageindex,xml.total);
							f = new FlipItem(s,pr,_cellwidth);
						}
						else
						{
							if (cpos.contains(j, i) && count < imglist.length())
							{
								var p:PhotoItem = new PhotoItem(imglist[count].type);//will add more properties
								_picloader.append(new ImageLoader(Shared.IMAGE_PATH + imglist[count].img + "_small.jpg", {name:"obj"+_squares.length, width:_cellwidth, height:_cellwidth, crop:true, scaleMode:ScaleMode.PROPORTIONAL_OUTSIDE, centerRegistration:true, onComplete:p.complete}));
								f = new FlipItem(s,p,_cellwidth);
								count++;
							}
							else
							{
								f = new FlipItem(s,null,_cellwidth);
							}
						}
						f.x = rect.x + j * _cellwidth;
						f.y = rect.y + i * _cellwidth;
						_picpanel.addChild(f);
						_squares.push(f);
					}
				}
				_picloader.load();
				var evt:ActionEvent = new ActionEvent(ActionEvent.HIDE_CHILDREN);
				dispatchEvent(evt);
				
				addChild(_picpanel);
				adjustPos(null);
				var idxlist:Array = Utility.shuffle(Utility.fill(_squares.length));
				var interval:Number = 1.2 / _dimension.length;
				for (var x:int=0; x<idxlist.length; x++)
				{
					var obj:FlipItem = _squares[idxlist[x]];
					TweenLite.delayedCall(x*interval+.6, obj.turnover);
				}
				TweenLite.delayedCall(2,showfootbar);
			}
		}
		
		private function showfootbar():void
		{
			var evt:ActionEvent = new ActionEvent(ActionEvent.SHOW_FOOTBAR);
			dispatchEvent(evt);
		}
		
		private function refreshpic(e:Event):void
		{
			var loader:URLLoader = URLLoader(e.target);
			loader.removeEventListener(Event.COMPLETE,refreshpic);
			var xml:XML = XML(loader.data);
			if (xml.code == 0)
			{
				var imglist:XMLList = xml.list.item;
				if (!imglist)
				{
					trace("empty list");
					return;
				}
				var cpos:Rectangle = Utility.center(_dimension,imglist.length());
				var count:int = 0;
				
				for (var i:int=1; i<_dimension.row - 1; i++)
				{
					for (var j:int=0; j<_dimension.column; j++)
					{
						var f:FlipItem;
						if (i == _dimension.row-4 && j == _dimension.column-1)
						{
							var pr:PagerBlock = new PagerBlock(_cellwidth,_pageindex,xml.total);
							f = _squares[(i * _dimension.column) + j];
							f.backobj = pr;
						}
						else
						{
							if (cpos.contains(j, i) && count < imglist.length())
							{
								var p:PhotoItem = new PhotoItem(imglist[count].type);//will add more properties
								_picloader.append(new ImageLoader(Shared.IMAGE_PATH + imglist[count].img + "_small.jpg", {name:"obj"+_squares.length, width:_cellwidth, height:_cellwidth, crop:true, scaleMode:ScaleMode.PROPORTIONAL_OUTSIDE, centerRegistration:true, onComplete:p.complete}));
								f = _squares[(i * _dimension.column) + j];
								f.backobj = p;
								count++;
							}
							else
							{
								f = _squares[(i * _dimension.column) + j];
								f.backobj = null;
							}
						}
					}
				}
				_picloader.load();
				
				var idxlist:Array = Utility.shuffle(Utility.fill(_squares.length));
				var interval:Number = 1 / _dimension.length;
				for (var x:int=0; x<idxlist.length; x++)
				{
					var obj:FlipItem = _squares[idxlist[x]];
					TweenLite.delayedCall(x*interval, obj.turnover);
				}
			}
		}
		
		private function error(e:IOErrorEvent):void
		{
			trace(e.text);
		}

	}

}