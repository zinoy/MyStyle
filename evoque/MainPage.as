package evoque
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import com.asual.swfaddress.SWFAddress;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import com.greensock.loading.*;
	import com.greensock.layout.*;
	
	import evoque.display.PhotoItem;
	import evoque.animate.FlipItem;
	import evoque.common.*;
	import evoque.controls.*;
	import evoque.events.*;
	import evoque.display.ScreenBlock;

	public class MainPage extends Sprite
	{
		private var _picpanel:Sprite;
		private var _squares:Vector.<FlipItem>;
		private var _dimension:SquareSize;
		private var _picloader:LoaderMax;
		private var _uploadPicAfterLogin:Boolean = false;

		public function MainPage()
		{
			init();
		}
		
		private function init():void
		{
			_picpanel = new Sprite();
			_squares = new Vector.<FlipItem>();
			_picloader = new LoaderMax({name:"picQueue"});
			
			addEventListener(Event.ADDED_TO_STAGE,addedToStage);
			home.addEventListener(ActionEvent.SHOW_GALLERY,goGallery);
		}
		
		private function addedToStage(e:Event):void
		{
			stage.addEventListener(Event.RESIZE,adjustPos);
			SWFAddress.onChange = swfchange;
		}
		
		private function swfchange():void
		{
			var val:Array = SWFAddress.getPathNames();
			if (val[0] == "showroom")
			{
				goGallery(null);
			}
		}
		
		private function adjustPos(e:Event):void
		{
			_picpanel.x = 1000 / 2;
			_picpanel.y = 600 / 2;
		}
		
		private function goGallery(e:ActionEvent):void
		{
			var sc:BitmapData = new BitmapData(stage.stageWidth,stage.stageHeight,true,0);
			sc.draw(stage);
			var shot:Bitmap = new Bitmap(sc);
			
			var w:Number = stage.stageWidth;
			var col:int = Math.floor(w / 100);
			var width:Number = w / col;
			trace("width:",width);
			var row:int = Math.floor(stage.stageHeight / width) + 2;
			_dimension = new SquareSize(col, row);
			var offset:Number = ((_dimension.row - 2) * width - stage.stageHeight) / 2;
			var rect:Rectangle = new Rectangle();
			rect.width = col * width;
			rect.height = row * width;
			rect.x = rect.width / 2 * -1;
			rect.y = rect.height / 2 * -1;
			trace(rect);
			trace(offset);
						
			for (var i:int=0; i<_dimension.row; i++)
			{
				for (var j:int=0; j<_dimension.column; j++)
				{
					//if (i == _dimension.row-2 && j == _dimension.column-1) continue;
					var s:ScreenBlock = new ScreenBlock(sc,width,new Point(j,i),offset);
					var p:PhotoItem = new PhotoItem(1);
					_picloader.append(new ImageLoader("temp/heroes.jpg", {name:"obj"+_squares.length, width:width, height:width, scaleMode:ScaleMode.PROPORTIONAL_INSIDE, onComplete:p.complete}));
					var f:FlipItem;
					if (i > 0 && i < _dimension.row - 1)
					{
						f = new FlipItem(s,p,width);
					}
					else
					{
						f = new FlipItem(s,null,width);
					}
					f.x = rect.x + j * width;
					f.y = rect.y + i * width;
					_picpanel.addChild(f);
					_squares.push(f);
				}
			}
			_picloader.load();
			while (numChildren > 0)
			{
				removeChildAt(0);
			}
			addChild(_picpanel);
			adjustPos(null);
			var idxlist:Array = Utility.shuffle(Utility.fill(_squares.length));
			var interval:Number = 1 / _dimension.length;
			for (var x:int=0; x<idxlist.length; x++)
			{
				var obj:FlipItem = _squares[idxlist[x]];
				TweenLite.delayedCall(x*interval+1, obj.turnover);
			}
		}
		
	}

}