package evoque.common
{

	public class BuildInPatterns
	{
		
		public static const EMAIL_ADDRESS:* = /\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/;
		public static const MOBILE_PHONE:* = /1[3458]\d{0}/;
		//public static const HTML_TAG:* = /<(\S*?)[^>]*>.*?</\1>|<.*? />/;
		public static const CHINESE_CHARACTER:* = /[\u4e00-\u9fa5]/;

	}

}