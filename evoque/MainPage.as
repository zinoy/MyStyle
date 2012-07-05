package evoque
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	import com.greensock.TweenLite;
	import com.greensock.loading.*;
	import com.greensock.layout.*;
	
	import evoque.display.PhotoItem;
	import evoque.animate.FlipItem;
	import evoque.common.*;
	import flash.geom.Rectangle;

	public class MainPage extends Sprite
	{
		private var panel:Sprite;
		private var squares:Vector.<FlipItem>;
		private var dimension:SquareSize;
		private var picloader:LoaderMax;

		public function MainPage()
		{
			init();
		}
		
		private function init():void
		{
			stage.align = StageAlign.TOP_LEFT;//will be removed
			panel = new Sprite();
			squares = new Vector.<FlipItem>();
			picloader = new LoaderMax({name:"picQueue"});
			
			addEventListener(Event.ADDED_TO_STAGE,addedToStage);
			stage.addEventListener(Event.RESIZE,adjustPos);
		}
		
		private function addedToStage(e:Event):void
		{
			
		}
		
		private function adjustPos(e:Event):void
		{
			panel.x = stage.stageWidth / 2;
			panel.y = stage.stageHeight / 2;
		}
		
		private function goGallery():void
		{
			var w:Number = stage.stageWidth;
			var col:int = Math.floor(w / 100);
			var width:Number = w / col;
			var row:int = Math.floor(stage.stageHeight / width);
			dimension = new SquareSize(col, row);
			var rect:Rectangle = new Rectangle();
			rect.width = col * width;
			rect.height = row * width;
			rect.x = rect.width / 2 * -1;
			rect.y = rect.height / 2 * -1;
						
			for (var i:int=0; i<dimension.row; i++)
			{
				for (var j:int=0; j<dimension.column; j++)
				{
					if (i == dimension.row-2 && j == dimension.column-1) continue;
					var p:PhotoItem = new PhotoItem();
					picloader.append(new ImageLoader("temp/heroes.jpg", {name:"obj"+squares.length, width:width, height:width, scaleMode:ScaleMode.PROPORTIONAL_INSIDE, onComplete:p.complete}));
					var f:FlipItem = new FlipItem(p, null, width);
					f.x = rect.x + j * width;
					f.y = rect.y + i * width;
					panel.addChild(f);
					squares.push(f);
				}
			}
			picloader.load();
			addChild(panel);
			adjustPos(null);
			var idxlist:Array = Utility.shuffle(Utility.fill(squares.length));
			var interval:Number = 1 / dimension.length;
			for (var x:int=0; x<idxlist.length; x++)
			{
				var obj:FlipItem = squares[idxlist[x]];
				TweenLite.delayedCall(x*interval+1, obj.turnover);
			}
		}
		
	}

}