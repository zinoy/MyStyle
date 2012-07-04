package evoque.common
{

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

	}

}