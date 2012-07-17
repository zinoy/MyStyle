﻿package evoque.display
{
	import flash.display.*;
	import flash.events.*;
	import flash.external.ExternalInterface;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	import evoque.events.ActionEvent;

	[Event(name="uploadMore", type="evoque.events.ActionEvent")]
	public class MainUI extends Sprite
	{
		private var _sec:Number;

		public function MainUI()
		{
			init();
		}
		
		private function init():void
		{			
			btnopen.buttonMode = true;
			btnopen.mouseChildren = false;
			
			btnopen.addEventListener(MouseEvent.CLICK, togglemini);
			btnupload.addEventListener(MouseEvent.CLICK, goupload);
			btnmini.addEventListener(MouseEvent.CLICK, goupload);
			nav.addEventListener(ActionEvent.SHOW_RULES,showrules);
		}
		
		public function homeview():void
		{
			count.show("right");
			count.x = count.y = 65;
			nav.x = nav.y = 122;
			nav.black.alpha = 0;
			if (contains(btnopen))
				removeChild(btnopen);
			if (contains(btnmini))
				removeChild(btnmini);
			addChild(count);
			addChild(nav);
			addChild(btnupload);
			this.x = 275;
			this.y = 358;
			removeEventListener(Event.ENTER_FRAME, autohide);
			removeEventListener(MouseEvent.ROLL_OVER, over);
			removeEventListener(MouseEvent.ROLL_OUT, out);
		}
		
		public function childview():void
		{
			count.x = -32;
			count.y = 32;
			nav.x = nav.y = 23;
			nav.black.alpha = 1;
			removeChild(btnupload);
			addChild(btnmini);
			if (stage.stageWidth / 2 + (stage.stageWidth - 1000) / 2 < 626)
				this.x = stage.stageWidth - 626 + (stage.stageWidth - 1000) / 2;
			else
				this.x = 500;
			this.y = 528;
		}
		
		public function miniview(y:Number):void
		{
			childview();
			removeChild(count);
			removeChild(nav);
			removeChild(btnmini);
			addChild(btnopen);
			btnopen.alpha = 1;
			this.y = y;
		}
		
		public function setnav(index:int):void
		{
			nav.setCurrent(index);
		}
		
		private function togglemini(e:MouseEvent):void
		{
			if (contains(btnmini))
			{
				addChild(btnopen);
				btnopen.alpha = 0;
				TweenLite.to(btnopen, .4, {alpha:1,ease:Quad.easeOut});
				TweenLite.to(count, .4, {alpha:0,ease:Quad.easeOut,onComplete:removeChild,onCompleteParams:[count]});
				TweenLite.to(nav, .4, {alpha:0,ease:Quad.easeOut,onComplete:removeChild,onCompleteParams:[nav]});
				TweenLite.to(btnmini, .4, {alpha:0,ease:Quad.easeOut,onComplete:removeChild,onCompleteParams:[btnmini]});
				TweenLite.to(this, .4, {y:this.y + 72,ease:Quad.easeOut});
			}
			else
			{
				addChild(btnmini);
				btnmini.alpha = 0;
				TweenLite.to(btnmini, .4, {alpha:1,ease:Quad.easeOut});
				addChild(count);
				count.show("left");
				count.alpha = 0;
				TweenLite.to(count, .4, {alpha:1,ease:Quad.easeOut});
				addChild(nav);
				nav.alpha = 0;
				TweenLite.to(nav, .4, {alpha:1,ease:Quad.easeOut});
				TweenLite.to(btnopen, .4, {alpha:0,ease:Quad.easeOut,onComplete:removeChild,onCompleteParams:[btnopen]});
				TweenLite.to(this, .4, {y:this.y - 72,ease:Quad.easeOut});
				addEventListener(MouseEvent.ROLL_OVER, over);
				addEventListener(MouseEvent.ROLL_OUT, out);
			}
		}
		
		private function autohide(e:Event):void
		{
			_sec++;
			if (_sec % 60 == 0)
			{
				var pass:Number = Math.floor(_sec / 60);
				if (pass >= 3)
				{
					removeEventListener(Event.ENTER_FRAME, autohide);
					removeEventListener(MouseEvent.ROLL_OVER, over);
					removeEventListener(MouseEvent.ROLL_OUT, out);
					togglemini(null);
				}
			}
		}
		
		private function over(e:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME, autohide);
		}
		
		private function out(e:MouseEvent):void
		{
			_sec = 0;
			addEventListener(Event.ENTER_FRAME, autohide);
		}
		
		private function goupload(e:MouseEvent):void
		{
			ExternalInterface.call("pe", "MainMenu", "Click", "Upload");
			var evt:ActionEvent =  new ActionEvent(ActionEvent.UPLOAD_MORE);
			dispatchEvent(evt);
		}
		
		private function showrules(e:ActionEvent):void
		{
			var evt:ActionEvent = new ActionEvent(ActionEvent.SHOW_RULES);
			dispatchEvent(evt);
		}
		
	}

}