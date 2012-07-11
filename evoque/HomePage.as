package evoque
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.utils.*;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	import evoque.common.*;
	import evoque.controls.*;
	import evoque.events.*;


	public class HomePage extends Sprite
	{
		private var _user:UserAction;
		private var _upload:UploadAction;
		private var _success:SuccessPanel;
		private var _uploadPicAfterLogin:Boolean = false;

		public function HomePage()
		{
			init();
		}
		
		private function init():void
		{
			_user = new UserAction();
			_success = new SuccessPanel();
			
			btnupload.addEventListener(MouseEvent.CLICK,goupload);
			mainLogin.addEventListener(MouseEvent.CLICK,gologin);
			mainReg.addEventListener(MouseEvent.CLICK,goreg);
			_user.addEventListener(ActionEvent.CLOSE_PANEL,closepanel);
			_success.addEventListener(ActionEvent.CLOSE_PANEL,closepanel);
			_success.addEventListener(ActionEvent.SHOW_GALLERY,gogallery);
			_success.addEventListener(ActionEvent.UPLOAD_MORE,goupload);
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
		
		private function goupload(e:Event):void
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
		
		private function showsuccess(e:ActionEvent):void
		{
			addChild(_success);
			_success.alpha = 0;
			TweenLite.to(_success, .4, {alpha:1,ease:Quad.easeOut});
		}
		
		private function gogallery(e:MouseEvent):void
		{
			var evt:ActionEvent = new ActionEvent(ActionEvent.SHOW_GALLERY);
			dispatchEvent(evt);
		}
		
	}

}