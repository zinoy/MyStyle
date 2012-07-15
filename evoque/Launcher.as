package evoque
{
	import flash.display.*;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.net.*;
	
	import evoque.display.ProgressBar;

	public class Launcher extends Sprite
	{
		private var _main:DisplayObject;
		private var _border:Shape;
		private var _progressbar:ProgressBar;

		public function Launcher()
		{
			init();
		}
		
		private function init():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_border = new Shape();
			_border.graphics.lineStyle(1);
			_border.graphics.lineGradientStyle(GradientType.LINEAR, [0x6b6b6b, 0x131313, 0x6b6b6b], [1, 1, .6], [0, 128, 255]);
			_border.graphics.moveTo(0, 0);
			_border.graphics.lineTo(1000, 0);
			_border.graphics.lineTo(1000, 600);
			_border.graphics.lineTo(0, 600);
			_border.graphics.lineTo(0, 0);
			addChild(_border);
			
			_progressbar = new ProgressBar();
			addChild(_progressbar);
			
			var loader:Loader = new Loader();
			var req:URLRequest = new URLRequest("main.swf");
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,addmain);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,showprogress);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,error);
			loader.load(req);
			
			centerpos(null);
			stage.addEventListener(Event.RESIZE,centerpos);
		}
		
		private function addmain(e:Event):void
		{
			var loader:LoaderInfo = LoaderInfo(e.target);
			_main = loader.content;
			_main.addEventListener(ProgressEvent.PROGRESS,mainProgress);
			_main.addEventListener(Event.COMPLETE,mainComplete);
			addChild(_main);
			_main.alpha = 0;
			centerpos(null);
		}
		
		private function centerpos(e:Event):void
		{
			if (_main != null)
			{
				_main.x = (stage.stageWidth - 1000) / 2;
				_main.y = (stage.stageHeight - 600) / 2;
			}
			if (_border != null && contains(_border))
			{
				_border.x = (stage.stageWidth - 1000) / 2;
				_border.y = (stage.stageHeight - 600) / 2;
				if (contains(_progressbar))
				{
					_progressbar.x = _border.x + (1000 - 600) / 2;
					_progressbar.y = _border.y;
				}
			}
		}
		
		private function showprogress(e:ProgressEvent):void
		{
			_progressbar.setProgress(e.bytesLoaded / e.bytesTotal * .65);
		}
		
		private function mainProgress(e:ProgressEvent):void
		{
			var p:Number = e.bytesLoaded / e.bytesTotal;
			_progressbar.setProgress(p * .35 + .65);
			
			_main.alpha = p;
			_border.alpha = 1 - p;
		}
		
		private function mainComplete(e:Event):void
		{
			removeChild(_border);
			removeChild(_progressbar);
		}
		
		private function error(e:IOErrorEvent):void
		{
			trace(e.text);
			ExternalInterface.call("alert",e.text);
		}
		
	}

}