package evoque
{
	import flash.display.*;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.net.*;
	import flash.utils.*;
	
	import com.asual.swfaddress.SWFAddress;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.display.ContentDisplay;
	
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
		private var _detail:PhotoInfo;
		private var _rules:RulePanel;
		
		private var _path:Array = ["home", "prize", "showroom", "evoque", "events"];
		private var _current:int = -1;
		private var _home:DisplayObject;
		private var _child:DisplayObject;

		public function MainPage()
		{
			init();
		}
		
		private function init():void
		{
			ExternalInterface.addCallback("set",setuid);
			_user = new UserAction();
			_success = new SuccessPanel();
			
			_user.addEventListener(ActionEvent.CLOSE_PANEL,closepanel);
			_success.addEventListener(ActionEvent.CLOSE_PANEL,closepanel);
			_success.addEventListener(ActionEvent.SHOW_GALLERY,showgallery);

			_detail = new PhotoInfo();
			_detail.addEventListener(MouseEvent.ROLL_OUT,hidedetail);
			_detail.addEventListener(Event.COMPLETE,loaddetail);

			ubtns.mainLogin.addEventListener(MouseEvent.CLICK,gologin);
			ubtns.mainReg.addEventListener(MouseEvent.CLICK,goreg);
			ubtns.mainLogout.addEventListener(MouseEvent.CLICK,goexit);
			ui.addEventListener(ActionEvent.UPLOAD_MORE,goupload);
			ui.addEventListener(ActionEvent.SHOW_RULES,showrules);
			
			_rules = new RulePanel();
			_rules.x = (1000 - _rules.width) / 2;
			_rules.y = (600 - _rules.height) / 2;
			_rules.addEventListener(ActionEvent.CLOSE_PANEL,closepanel);
			
			removeChild(ui);
			ubtns.hide();
			removeChild(foot);
			
			SWFAddress.onChange = swfchange;
		}
		
		private function setuid(val:String):void
		{
			Shared.UID = val;
			removeChild(_user);
			if (Shared.UID != "")
			{
				ubtns.show();
				if (_uploadPicAfterLogin)
				{
					_uploadPicAfterLogin = false;
					goupload(null);
				}
			}
		}
		
		public function showContent():void
		{
			addChild(ui);
			ui.alpha = 0;
			addChildAt(foot, numChildren);
			setChildIndex(border, numChildren - 1);
			foot.alpha = 0;
			TweenLite.to(ui, .4, {alpha:1,ease:Quad.easeOut});
			TweenLite.to(foot, .3, {alpha:1,delay:.3,ease:Quad.easeOut});
			TweenLite.delayedCall(.6, ubtns.show);
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
				var idx:int = _path.indexOf(val[0]);
				if (idx != _current)
				{
					_current = idx;
					_gallery = new PictureGrid();
					_gallery.addEventListener(ActionEvent.HIDE_CHILDREN,hideall);
					_gallery.addEventListener(ActionEvent.SHOW_FOOTBAR,showfoot);
					_gallery.addEventListener(PhotoEvent.SHOW_DETAIL,showdetail);
				}
				ExternalInterface.call("pv", SWFAddress.getValue());
				showgallery(null);
			}
			else
			{
				if (_gallery != null && contains(_gallery))
				{
					removeChild(_gallery);//will use animation instead
					addChild(border);
					foot.thin();
					foot.x = 0;
					foot.y = 635;
					addChild(ubtns);
					ubtns.show();
				}
				loadChild(val[0]);
			}
		}
		
		private function loadChild(path:String):void
		{
			var next:int = _path.indexOf(path);
			if (next == _current)
			{
				return;
			}
			_current = next;
			if (_current < 0)
			{
				return;
			}
			else if (_current == 0 && _home != null)
			{
				showChild(0)
				return;
			}
			var loader:Loader = new Loader();
			var req:URLRequest = new URLRequest(path + ".swf");
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,showChild);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,childProgress);
			loader.load(req);
		}
		
		private function childProgress(e:ProgressEvent):void
		{
			dispatchEvent(e.clone());
		}
		
		private function showChild(e:*):void
		{
			if (_child != null && contains(_child))
				removeChild(_child);
			
			if (e is Event)
			{
				var loader:LoaderInfo = LoaderInfo(e.target);
				_child = loader.content;
				addChildAt(_child, 0);
				if (_current == 0)
				{
					_home = _child;
					_home.alpha = 0;
					TweenLite.to(_home, .4, {alpha:1,ease:Quad.easeOut});
					showContent();
					ui.homeview();
				}
				else
				{
					ui.childview();
				}
				dispatchEvent(e.clone());
			}
			else
			{
				_child = _home;
				addChildAt(_home, 0);
				ui.homeview();
			}
		}
		
		private function gologin(e:MouseEvent):void
		{
			ExternalInterface.call("pe", "EMS", "MainPage", "Login");
			_user.showpanel();
			addChild(_user);
			_user.alpha = 0;
			TweenLite.to(_user, .4, {alpha:1,ease:Quad.easeOut});
		}
		
		private function goreg(e:MouseEvent):void
		{
			ExternalInterface.call("pe", "EMS", "MainPage", "Register");
			_user.showpanel("reg");
			addChild(_user);
			_user.alpha = 0;
			TweenLite.to(_user, .4, {alpha:1,ease:Quad.easeOut});
		}
		
		private function goexit(e:MouseEvent):void
		{
			ExternalInterface.call("pe", "EMS", "MainPage", "Logout");
			Shared.UID = "";
			ubtns.show();
		}
		
		private function showrules(e:ActionEvent):void
		{
			addChild(_rules);
			_rules.alpha = 0;
			TweenLite.to(_rules, .4, {alpha:1,ease:Quad.easeOut});
		}
		
		private function closepanel(e:ActionEvent):void
		{
			var obj:DisplayObject = e.currentTarget as DisplayObject;
			removeChild(obj);
			if (Shared.UID != "")
			{
				ubtns.show();
				if (_uploadPicAfterLogin)
				{
					_uploadPicAfterLogin = false;
					goupload(null);
				}
			}
		}
		
		private function goupload(e:ActionEvent):void
		{
			if (_gallery != null && contains(_gallery))
			{
				SWFAddress.setValue(_path[0]);
				ui.setnav(0);
			}
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
			removeChild(_upload);
			addChild(_success);
			_success.alpha = 0;
			TweenLite.to(_success, .4, {alpha:1,ease:Quad.easeOut});
		}
		
		private function showgallery(e:ActionEvent):void
		{
			addChildAt(_gallery,0);
			_gallery.show();
		}
		
		private function showdetail(e:PhotoEvent):void
		{
			if (!_detail.loading)
			{
				var p:PhotoItem = e.item;
				p.showloader();
				_detail.category = p.params.type;
				_detail.x = e.pos.x;
				_detail.y = e.pos.y;
				_detail.category = p.params.type;
				_detail.params = p.params;
				_detail.item = p;
				_detail.load();
			}
		}
		
		private function loaddetail(e:Event):void
		{
			_detail.x -= (216 - _detail.params.width) / 2;
			_detail.y -= (_detail.height - _detail.params.width) / 2;
			addChild(_detail);
			checkpos(_detail);
			_detail.item.hideloader();
		}
		
		private function checkpos(obj:DisplayObject):void
		{
			var wp:Number = (stage.stageWidth - 1000) / 2;
			if (obj.x < wp * -1)
				obj.x = wp * -1;
			if (obj.x + obj.width > 1000 + wp)
				obj.x = 1000 + wp - obj.width;
			var hp:Number = (stage.stageHeight - 600) / 2;
			if (obj.y < hp * -1)
				obj.y = hp * -1;
			if (obj.y + obj.height > 600 + hp)
				obj.y = 600 + hp - obj.height;
		}
		
		private function hidedetail(e:MouseEvent):void
		{
			removeChild(_detail);
		}
		
		private function hideall(e:ActionEvent):void
		{
			removeChild(border);
			removeChild(foot);
			if (_home != null && contains(_home))
				removeChild(_home);
			if (_child != null && contains(_child))
				removeChild(_child);
			removeChild(ubtns);
			removeChild(ui);
			ubtns.hide();
		}
		
		private function showfoot(e:ActionEvent):void
		{
			foot.x = (stage.stageWidth - 1000) / 2 * -1;
			foot.y = (stage.stageHeight - 600) / 2 + 600 + 35;
			addChild(foot);
			foot.wide();
			TweenLite.to(foot, .4, {y:foot.y - 35,ease:Quad.easeOut,onComplete:showui});
		}
		
		private function showui():void
		{
			addChild(ui);
			swapChildren(ui,foot);
			ui.alpha = 0;
			ui.miniview((stage.stageHeight - 600) / 2 + 600 - 70);
			trace(ui.x, ui.y);
			TweenLite.to(ui, .4, {alpha:1,ease:Quad.easeOut});
		}
		
		private function hidefoot():void
		{
			TweenLite.to(foot, .4, {y:stage.stageHeight+35,ease:Quad.easeOut});
		}
		
	}

}