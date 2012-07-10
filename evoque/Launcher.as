package evoque
{
	import flash.display.*;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.net.*;

	public class Launcher extends Sprite
	{
		private var _main:DisplayObject;

		public function Launcher()
		{
			init();
		}
		
		private function init():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE,centerpos);
			
			var loader:Loader = new Loader();
			var req:URLRequest = new URLRequest("main5.swf");
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,addmain);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,showprogress);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,error);
			loader.load(req);
		}
		
		private function addmain(e:Event):void
		{
			var loader:LoaderInfo = LoaderInfo(e.target);
			_main = loader.content;
			addChild(_main);
		}
		
		private function centerpos(e:Event):void
		{
			if (_main)
			{
				_main.x = (stage.stageWidth - 1000) / 2;
				_main.y = (stage.stageHeight - 600) / 2;
			}
		}
		
		private function showprogress(e:ProgressEvent):void
		{
			
		}
		
		private function error(e:IOErrorEvent):void
		{
			trace(e.text);
			ExternalInterface.call("alert",e.text);
		}
		
	}

}