package evoque
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.net.*;
	import flash.utils.*;
	
	import com.asual.swfaddress.SWFAddress;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	
	import evoque.display.*;
	import evoque.events.*;
	import evoque.common.*;
	import evoque.controls.*;

	public class MainPage extends Sprite
	{
		private var _user:UserAction;
		private var _upload:UploadAction;
		private var _success:SuccessPanel;
		private var _uploadPicAfterLogin:Boolean = false;
		private var _gallery:PictureGrid;
		
		private var _path:Array = ["home", "prize", "showroom", "evoque", "dealers"];
		private var _current:int;
		private var _dislpay:DisplayObject;

		public function MainPage()
		{
			init();
		}
		
		private function init():void
		{
			_user = new UserAction();
			_success = new SuccessPanel();
			
			_user.addEventListener(ActionEvent.CLOSE_PANEL,closepanel);
			_success.addEventListener(ActionEvent.CLOSE_PANEL,closepanel);
			_success.addEventListener(ActionEvent.SHOW_GALLERY,showgallery);
			_success.addEventListener(ActionEvent.UPLOAD_MORE,goupload);

			_gallery = new PictureGrid();
			_gallery.addEventListener(ActionEvent.HIDE_CHILDREN,hideall);
			_gallery.addEventListener(ActionEvent.SHOW_FOOTBAR,showfoot);
			
			mainLogin.addEventListener(MouseEvent.CLICK,gologin);
			mainReg.addEventListener(MouseEvent.CLICK,goreg);
			SWFAddress.onChange = swfchange;
		}
		
		private function swfchange():void
		{
			trace("URL:",SWFAddress.getValue());
			var val:Array = SWFAddress.getPathNames();
			if (val.length == 0)
			{
				SWFAddress.setValue(_path[0]);
				return;
			}
			if (val[0] == "showroom")
			{
				showgallery(null);
			}
			else
			{
				if (contains(_gallery))
				{
					removeChild(_gallery);//will use animate instead
				}
				loadChild(val[0]);
			}
		}
		
		private function loadChild(path:String):void
		{
			_current = _path.indexOf(path);
			if (_current < 0)
				return;
			var loader:Loader = new Loader();
			var req:URLRequest = new URLRequest(path + ".swf");
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,showChild);
			loader.load(req);
		}
		
		private function showChild(e:Event):void
		{
			var loader:LoaderInfo = LoaderInfo(e.target);
			_dislpay = loader.content;
			addChildAt(_dislpay,0);
			if (_current == 0)
			{
				_dislpay.addEventListener(ActionEvent.UPLOAD_MORE,goupload);
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
		
		private function closepanel(e:ActionEvent):void
		{
			var obj:DisplayObject = e.currentTarget as DisplayObject;
			removeChild(obj);
			if (Shared.UID != "" && mainLogin.parent != null)
			{
				TweenLite.to(mainLogin, .1, {alpha:0,ease:Quad.easeOut,onComplete:removeChild,onCompleteParams:[mainLogin]});
				TweenLite.to(mainReg, .1, {alpha:0,ease:Quad.easeOut,onComplete:removeChild,onCompleteParams:[mainReg]});
				if (_uploadPicAfterLogin)
				{
					_uploadPicAfterLogin = false;
					goupload(null);
				}
			}
		}
		
		private function goupload(e:ActionEvent):void
		{
			_upload = new UploadAction();
			_upload.addEventListener(ActionEvent.CLOSE_PANEL,closepanel);
			_upload.addEventListener(ActionEvent.SHOW_SUCCESS,showsuccess);
			if (Shared.UID != "")
			{
				addChild(_upload);
				_upload.alpha = 0;
				TweenLite.to(_upload, .4, {alpha:1,ease:Quad.easeOut});
			}
			else
			{
				gologin(null);
				_uploadPicAfterLogin = true;
			}
		}
		
		private function showsuccess(e:ActionEvent):void
		{
			addChild(_success);
			_success.alpha = 0;
			TweenLite.to(_success, .4, {alpha:1,ease:Quad.easeOut});
		}
		
		private function showgallery(e:ActionEvent):void
		{
			addChildAt(_gallery,0);
			_gallery.show();
		}
		
		private function hideall(e:ActionEvent):void
		{
			removeChild(border);
			removeChild(foot);
			removeChild(_dislpay);
		}
		
		private function showfoot(e:ActionEvent):void
		{
			trace("show foot:",stage.stageHeight);
			foot.x = (stage.stageWidth - 1000) / 2 * -1;
			foot.y = (stage.stageHeight - 600) / 2 + 600 + 35;
			addChild(foot);
			foot.wide();
			TweenLite.to(foot, .4, {y:foot.y - 35,ease:Quad.easeOut});
		}
		
		private function hidefoot():void
		{
			TweenLite.to(foot, .4, {y:stage.stageHeight+35,ease:Quad.easeOut});
		}
		
	}

}