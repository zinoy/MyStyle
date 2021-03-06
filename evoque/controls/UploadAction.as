﻿package evoque.controls
{
	import flash.display.*;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.net.*;
	import flash.text.*;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
		
	import evoque.common.*;
	import evoque.events.ActionEvent;

	public class UploadAction extends Sprite
	{
		private var _adjustbtns:Vector.<SimpleButton>;
		private var _tempurl:String;
		private var _category:int = 0;
		private var _friends:FriendsList;
		private var _file:FileReference;

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
			weibo.btnupload.buttonMode = true;
			weibo.btnupload.mouseEnabled = false;
			weibo.tbweibo.text = "#不趋同 自趋势#路虎揽胜极光，融英伦灵感，焕瞩目风潮。";
			if (Shared.isSinaUser)
			{
				weibo.tbweibo.text += " http://t.cn/zWS77v4 ";
				weibo.btnat.enabled = false;
				weibo.btnupload.gotoAndStop(1);
			}
			else
			{
				weibo.removeChild(weibo.btnat);
				weibo.btnupload.gotoAndStop(2);
			}
			weibo.tbweibo.type = TextFieldType.DYNAMIC;
			weibo.tbweibo.selectable = false;
			btnClose.addEventListener(MouseEvent.CLICK,closepanel);
			btnBrowse.addEventListener(MouseEvent.CLICK,browse);
		}
		
		private function browse(e:MouseEvent):void
		{
			_file = new FileReference();
			_file.addEventListener(Event.SELECT,upload);
			var imageType:Array = [new FileFilter("图片文件 (*.jpg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif*.png")];
			_file.browse(imageType);
		}
		
		private function closepanel(e:MouseEvent):void
		{
			TweenLite.to(this, .4, {alpha:0,ease:Quad.easeOut,onComplete:closed});
		}
		
		private function closed():void
		{
			var evt:ActionEvent = new ActionEvent(ActionEvent.CLOSE_PANEL);
			dispatchEvent(evt);
		}
		
		private function upload(e:Event):void
		{
			_file.addEventListener(Event.COMPLETE,startedit);
			_file.load();
			toggleButtonStatus(btnBrowse);
			editor.loading();
		}
		
		private function setcate(e:MouseEvent):void
		{
			var obj:Object = e.currentTarget;
			_category = Number(obj.name.split("_")[1]);
			for (var i:int=1; i<5; i++)
			{
				cate["btnc_"+i].reset();
			}
			obj.select();
			weibo.alpha = 1;
			weibo.btnupload.mouseEnabled = true;
			weibo.btnat.enabled = true;
			weibo.btnupload.addEventListener(MouseEvent.CLICK,save);
			weibo.tbweibo.type = TextFieldType.INPUT;
			weibo.tbweibo.selectable = true;
			weibo.tbweibo.setSelection(28, 28);
			stage.focus = weibo.tbweibo;
			if (Shared.isSinaUser)
			{
				weibo.btnat.addEventListener(MouseEvent.CLICK,togglefriends);
				_friends = new FriendsList();
				_friends.addEventListener(ActionEvent.ITEM_SELECTED,addfriend);
				_friends.x = 286.5;
				_friends.y = 101.45;
			}
		}
		
		private function startedit(e:Event):void
		{
			editor.load(_file);

			for (var i:int=1; i<5; i++)
			{
				cate["btnc_"+i].addEventListener(MouseEvent.CLICK,setcate);
				cate["btnc_"+i].enable();
			}
			cate.alpha = 1;
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
			var ck:RegExp = /@[^@\s]+/g;
			var count:int = 0;
			var result:Object = ck.exec(weibo.tbweibo.text);
			while (result != null)
			{
				count++;
				result = ck.exec(weibo.tbweibo.text);
			}
			if (count > 3)
			{
				ExternalInterface.call("alert", "你最多只能@三位好友。");
				return;
			}
			
			weibo.btnupload.removeEventListener(MouseEvent.CLICK,save);
			var loader:URLLoader = new URLLoader();
			var req:URLRequest = new URLRequest(ExternalInterface.call("getdomain") + "api/Action.aspx");
			var d:URLVariables = new URLVariables();
			d.ac = "uploadpic";
			d.uid = Shared.UID;
			var rect:Rectangle = editor.square;
			d.x = rect.x;
			d.y = rect.y;
			d.width = rect.width;
			d.rotate = editor.angle;
			d.ratio = editor.scale;
			d.comment = Utility.trim(weibo.tbweibo.text);
			d.category = _category;
			d.hash = Utility.hash(d);
			req.contentType = "multipart/form-data; boundary=" + UploadPostHelper.getBoundary();
			var header:URLRequestHeader = new URLRequestHeader( "enctype", "multipart/form-data" );
			req.requestHeaders.push(header);
			req.data = UploadPostHelper.getPostData("file", _file.data, d);
			req.method = "post";
			loader.addEventListener(Event.COMPLETE,end);
			loader.addEventListener(IOErrorEvent.IO_ERROR,error);
			trace(d);
			loader.load(req);
		}
		
		private function addfriend(e:ActionEvent):void
		{
			var ck:RegExp = /@[^@\s]+/g;
			var count:int = 0;
			var result:Object = ck.exec(weibo.tbweibo.text);
			while (result != null)
			{
				count++;
				result = ck.exec(weibo.tbweibo.text);
			}
			if (count >= 3)
			{
				ExternalInterface.call("alert", "你最多只能@三位好友。");
				return;
			}
			
			var idx:int = weibo.tbweibo.selectionBeginIndex;
			if (weibo.tbweibo.text.length + e.text.length + 2 - (weibo.tbweibo.selectionEndIndex - idx) > 140)
				return;
			var org:String = weibo.tbweibo.text;
			weibo.tbweibo.text = org.substring(0,weibo.tbweibo.selectionBeginIndex) + "@" + e.text + " " + org.substring(weibo.tbweibo.selectionEndIndex);
			var nidx:int = idx + e.text.length + 2;
			weibo.tbweibo.setSelection(nidx,nidx);
			stage.focus = weibo.tbweibo;
			//togglefriends(null);
		}
		
		private function end(e:Event):void
		{
			var loader:URLLoader = URLLoader(e.target);
			var xml:XML = XML(loader.data);
			trace(xml);
			if (xml.code == 0)
			{
				TweenLite.to(this, .4, {alpha:0,ease:Quad.easeOut,onComplete:success});
			}
		}
		
		private function success():void
		{
			var evt:ActionEvent = new ActionEvent(ActionEvent.SHOW_SUCCESS);
			dispatchEvent(evt);
		}
		
		private function error(e:IOErrorEvent):void
		{
			weibo.btnupload.addEventListener(MouseEvent.CLICK,save);
			trace(e);
			var loader:URLLoader = URLLoader(e.target);
			trace(loader.data);
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
		
		private function togglefriends(e:MouseEvent):void
		{
			if (_friends.parent != null)
			{
				weibo.removeChild(_friends);
			}
			else
			{
				weibo.addChild(_friends);
			}
		}
		
	}

}