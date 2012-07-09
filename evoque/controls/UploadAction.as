package evoque.controls
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.net.*;
	import flash.text.*;
		
	import evoque.common.*;

	public class UploadAction extends Sprite
	{
		private var _adjustbtns:Vector.<SimpleButton>;
		private var _tempurl:String;
		private var _category:int = 0;

		public function UploadAction()
		{
			init();
		}
		
		private function init():void
		{
			_adjustbtns = new <SimpleButton>[btnZIn, btnZOut, btnacw, btncw];
			for each (var btn:SimpleButton in _adjustbtns)
			{
				toggleButtonStatus(btn);
				btn.addEventListener(MouseEvent.CLICK,edit);
			}
			cate.alpha = .3;
			weibo.alpha = .5;
			weibo.btnupload.enabled = false;
			weibo.btnat.enabled = false;
			weibo.tbweibo.type = TextFieldType.DYNAMIC;
			weibo.tbweibo.selectable = false;
			btnBrowse.addEventListener(MouseEvent.CLICK,browse);
		}
		
		private function browse(e:MouseEvent):void
		{
			var file:FileReference = new FileReference();
			file.addEventListener(Event.SELECT,upload);
			var imageType:Array = [new FileFilter("图片文件 (*.jpg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png")];
			file.browse(imageType);
		}
		
		private function upload(e:Event):void
		{
			var file:FileReference = FileReference(e.target);
			
			var req:URLRequest = new URLRequest(Shared.URL_BASE + "Action.aspx");
			var d:URLVariables = new URLVariables();
			d.ac = "upload";
			d.hash = Utility.hash(d);
			req.method = "post";
			req.data = d;
			file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,step2);
			file.addEventListener(IOErrorEvent.IO_ERROR,error);
			file.upload(req);
			toggleButtonStatus(btnBrowse);
			//add preloader
		}
		
		private function step2(e:DataEvent):void
		{
			var xml:XML = XML(e.data);
			trace(xml);
			if (xml.code == 0)
			{
				_tempurl = xml.url;
				editor.addEventListener(Event.COMPLETE,startedit);
				editor.load(_tempurl);
			}
			for (var i:int=1; i<5; i++)
			{
				cate["btnc_"+i].addEventListener(MouseEvent.CLICK,setcate);
				cate["btnc_"+i].enable();
			}
			cate.alpha = 1;
		}
		
		private function setcate(e:MouseEvent):void
		{
			var obj:Object = e.currentTarget;
			trace(obj);
			_category = Number(obj.name.split("_")[1]);
			for (var i:int=1; i<5; i++)
			{
				cate["btnc_"+i].reset();
			}
			obj.select();
			weibo.alpha = 1;
			weibo.btnupload.enabled = true;
			weibo.btnat.enabled = true;
			weibo.btnupload.addEventListener(MouseEvent.CLICK,save);
			weibo.tbweibo.type = TextFieldType.INPUT;
			weibo.tbweibo.selectable = true;
		}
		
		private function startedit(e:Event):void
		{
			for each (var btn:SimpleButton in _adjustbtns)
			{
				toggleButtonStatus(btn);
			}
		}
		
		private function edit(e:MouseEvent):void
		{
			var idx:int = _adjustbtns.indexOf(e.currentTarget as SimpleButton);
			switch (idx)
			{
				case 0:
					editor.zoomin();
					break;
				case 1:
					editor.zoomout();
					break;
				case 2:
					editor.setangle(-90);
					break;
				case 3:
					editor.setangle(90);
					break;
				default:
					break;
			}
		}
		
		private function save(e:MouseEvent):void
		{
			var loader:URLLoader = new URLLoader();
			var req:URLRequest = new URLRequest(Shared.URL_BASE + "Action.aspx");
			var d:URLVariables = new URLVariables();
			d.ac = "savepic";
			d.uid = Shared.UID;
			d.url = _tempurl;
			var rect:Rectangle = editor.square;
			d.x = rect.x;
			d.y = rect.y;
			d.width = rect.width;
			d.rotate = editor.angle;
			d.ratio = editor.scale;
			d.comment = Utility.trim(weibo.tbweibo.text);
			d.category = _category;
			d.hash = Utility.hash(d);
			req.data = d;
			req.method = "post";
			loader.addEventListener(Event.COMPLETE,end);
			loader.addEventListener(IOErrorEvent.IO_ERROR,error);
			trace(d);
			loader.load(req);			
		}
		
		private function end(e:Event):void
		{
			var loader:URLLoader = URLLoader(e.target);
			trace(loader.data);
		}
		
		private function error(e:IOErrorEvent):void
		{
			trace(e.text);
		}
		
		private function toggleButtonStatus(btn:SimpleButton):void
		{
			if (btn.enabled)
			{
				btn.alpha = .3;
				btn.enabled = false;
				btn.mouseEnabled = false;
			}
			else
			{
				btn.alpha = 1;
				btn.enabled = true;
				btn.mouseEnabled = true;
			}
		}
		
	}

}