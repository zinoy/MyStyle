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
			throw new SecurityError("Unable to instantiation class.");
		}

		public static function rand(High:int,Low:int=0):Number
		{
			High--;
			return Math.floor(Math.random()*(1+High-Low))+Low;
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
		
		public static function fill(min:int,max:int=0):Array
		{
			if (max > 0 && max <= min)
			{
				throw new ArgumentError("Param max must bigger than min.");
			}
			var arr:Array = [];
			var len:int;
			var offset:int;
			if (max == 0)
			{
				len = min;
				offset = 0;
			}
			else
			{
				len = max - min;
				offset = min;
			}
			while (arr.length < len)
			{
				arr.push(arr.length + offset);
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