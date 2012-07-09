package evoque.common
{
	import flash.net.URLVariables;
	
	import com.adobe.crypto.SHA1;
	import flash.utils.ByteArray;

	public class Utility
	{

		public function Utility()
		{
			// constructor code
		}

		public static function shuffle(arr:Array):Array
		{
			var arr2:Array = [];
			
			while (arr.length > 0)
			{
				arr2.push(arr.splice(Math.round(Math.random() * (arr.length - 1)), 1)[0]);
			}
			return arr2;
		}
		
		public static function fill(len:int):Array
		{
			var arr:Array = [];
			while (arr.length < len)
			{
				arr.push(arr.length);
			}
			return arr;
		}
		
		public static function trim( s:String ):String
		{
			return s.replace( /^([\s|\t|\n]+)?(.*)([\s|\t|\n]+)?$/gm, "$2" );
		}
		
		public static function hash(data:URLVariables):String
		{
			var list:Array = data.toString().split("&");
			var keys:Array = new Array();
			
			for each (var key:String in list)
			{
				var parts:Array = key.split("=");
				if (parts.length > 0)
				{
					keys.push(parts[0].toLowerCase());
				}
			}
			keys.sort();
			var str:String = "";
			for each (var k:String in keys)
			{
				str += data[k];
			}
			var byteArr:ByteArray = new ByteArray();
			byteArr.writeMultiByte(str + Shared.API_SECRET,"utf-8");
			return SHA1.hashBytes(byteArr);
		}
		
	}

}