package evoque.common
{

	public class SquareSize
	{
		private var _col:int;
		private var _row:int;

		public function SquareSize(c:int=0, r:int=0)
		{
			_col = c;
			_row = r;
		}
		
		public function get column():int
		{
			return _col;
		}
		
		public function set column(val:int):void
		{
			_col = val;
		}
		
		public function get row():int
		{
			return _row;
		}
		
		public function set row(val:int):void
		{
			_row = val;
		}
		
		public function get length():int
		{
			return _col * _row;
		}
		
		public function get contentLength():int
		{
			return _col * (_row - 2);
		}
		
	}

}