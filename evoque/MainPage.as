package evoque
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.utils.*;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import com.greensock.loading.*;
	import com.greensock.layout.*;
	
	import evoque.display.PhotoItem;
	import evoque.animate.FlipItem;
	import evoque.common.*;
	import evoque.controls.*;
	import evoque.events.*;

	public class MainPage extends Sprite
	{
		private var _user:UserAction;
		private var _picpanel:Sprite;
		private var _squares:Vector.<FlipItem>;
		private var _dimension:SquareSize;
		private var _picloader:LoaderMax;

		public function MainPage()
		{
			init();
		}
		
		private function init():void
		{
			stage.align = StageAlign.TOP_LEFT;//will be removed
			
			_user = new UserAction();
			_picpanel = new Sprite();
			_squares = new Vector.<FlipItem>();
			_picloader = new LoaderMax({name:"picQueue"});
			
			addEventListener(Event.ADDED_TO_STAGE,addedToStage);
			stage.addEventListener(Event.RESIZE,adjustPos);
			mainLogin.addEventListener(MouseEvent.CLICK,gologin);
			mainReg.addEventListener(MouseEvent.CLICK,goreg);
			_user.addEventListener(ActionEvent.CLOSE_PANEL,closepanel);
		}
		
		private function addedToStage(e:Event):void
		{
			
		}
		
		private function closepanel(e:ActionEvent):void
		{
			var obj:DisplayObject = e.currentTarget as DisplayObject;
			removeChild(obj);
			if (Shared.UID != "")
			{
				removeChild(mainLogin);
				removeChild(mainReg);
			}
		}
		
		private function gologin(e:MouseEvent):void
		{
			_user.showpanel();
			addChild(_user);
			_user.alpha = 0;
			TweenLite.to(_user, .4, {alpha:1,ease:Quad.easeOut});
		}
		
		private function goreg(e:MouseEvent):void
		{
			_user.showpanel("reg");
			addChild(_user);
			_user.alpha = 0;
			TweenLite.to(_user, .4, {alpha:1,ease:Quad.easeOut});
		}
		
		private function adjustPos(e:Event):void
		{
			_picpanel.x = stage.stageWidth / 2;
			_picpanel.y = stage.stageHeight / 2;
		}
		
		private function goGallery():void
		{
			var w:Number = stage.stageWidth;
			var col:int = Math.floor(w / 100);
			var width:Number = w / col;
			var row:int = Math.floor(stage.stageHeight / width);
			_dimension = new SquareSize(col, row);
			var rect:Rectangle = new Rectangle();
			rect.width = col * width;
			rect.height = row * width;
			rect.x = rect.width / 2 * -1;
			rect.y = rect.height / 2 * -1;
						
			for (var i:int=0; i<_dimension.row; i++)
			{
				for (var j:int=0; j<_dimension.column; j++)
				{
					if (i == _dimension.row-2 && j == _dimension.column-1) continue;
					var p:PhotoItem = new PhotoItem();
					_picloader.append(new ImageLoader("temp/heroes.jpg", {name:"obj"+_squares.length, width:width, height:width, scaleMode:ScaleMode.PROPORTIONAL_INSIDE, onComplete:p.complete}));
					var f:FlipItem = new FlipItem(p, null, width);
					f.x = rect.x + j * width;
					f.y = rect.y + i * width;
					_picpanel.addChild(f);
					_squares.push(f);
				}
			}
			_picloader.load();
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