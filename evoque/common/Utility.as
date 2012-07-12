package evoque.common
{
	import flash.geom.Rectangle;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import com.adobe.crypto.SHA1;

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
		
		public static function trim(s:String):String
		{
			return s.replace(/^([\s|\t|\n]+)?(.*)([\s|\t|\n]+)?$/gm, "$2");
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
		/* 
		 * get center rect in given dimension.
		 */
		public static function center(d:SquareSize,count:int):Rectangle
		{
			var row:int = d.row - 2;
			var ws:int = Math.ceil(d.column / 2) - 1;
			var hs:int = Math.ceil(row / 2) - 1;
			var level:int;
			var min:SquareSize;
			if (ws > hs)
			{
				min = new SquareSize(d.column - hs * 2, row - hs * 2);
				level = hs;
			}
			else
			{
				min = new SquareSize(d.column - ws * 2, row - ws * 2);
				level = ws;
			}
			//var dl:Vector.<SquareSize> = new <SquareSize>[min];
			trace("d:",d.column,d.row,count);
			trace(min.column,min.row);
			for (var i:int=0; i<=level; i++)
			{
				var c:int = min.column + i * 2;
				var r:int = min.row + i * 2;
				
				if (count < r * c)
				{
					var pos:Number = level - i;
					return new Rectangle(pos,pos + 1,c,r);
				}
			}
			return null;
			
		}
		
	}

}