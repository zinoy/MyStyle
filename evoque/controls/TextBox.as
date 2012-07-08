package evoque.controls
{
	import flash.display.*;
	import flash.text.*;
	
	import evoque.common.Utility;

	public class TextBox extends Sprite
	{
		private var _input:TextField;
		private var _exp:RegExp;
		private var _require:Boolean;
		private var _minLength:int;

		public function TextBox(require:Boolean=false,minLength:int=0)
		{
			_require = require;
			_minLength = minLength;

			init();
		}
		
		private function init():void
		{
			_input = input;
			
			_input.borderColor = 0xf84c00;
		}
		
		public function set maxChars(val:int):void
		{
			_input.maxChars = val;
		}
		
		public function get text():String
		{
			return _input.text;
		}
		
		public function set pattern(val:*):void
		{
			_exp = new RegExp(pattern);
		}
		
		public function get pattern():String
		{
			if (_exp)
				return _exp.source;
			else
				return "";
		}
		
		public function get password():Boolean
		{
			return _input.displayAsPassword;
		}
		
		public function set password(val:Boolean):void
		{
			_input.displayAsPassword = val;
		}
		
		public function isVaild():Boolean
		{
			input.border = false;
			_input.textColor = 0;

			if (_require)
			{
				if (Utility.trim(_input.text).length == 0)
				{
					return false;
				}
			}
			if (_minLength>0)
			{
				if (Utility.trim(_input.text).length < _minLength)
				{
					return false;
				}
			}
			if (_exp)
			{
				return _exp.test(Utility.trim(_input.text));
			}
			return true;
		}
		
		public function highlight():void
		{
			_input.border = true;
			_input.textColor = 0xf84c00;
			_input.setSelection(0,_input.length-1);
		}
		
	}

}