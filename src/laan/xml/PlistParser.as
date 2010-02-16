package laan.xml
{
	public class PlistParser
	{
		public static function parsePlist(xmlPlist:XML):XML 
		{
			var plist : XML = new XML(<plist></plist>);
			
			for ( var i:int = 0; i < xmlPlist.children().length(); i++ ) {
				if ( xmlPlist.children()[i].name() == "array" ) {						
					parseArray( xmlPlist.children()[i] , plist );
				} else if ( xmlPlist.children()[i].name() == "dict" ) {
					parseDictionary( xmlPlist.children()[i], plist );	
				}
			}
			
			return plist;
		}//end parsePlist()
		
		private static function parseArray(xmlArray:XML, parent:XML):void 
		{
			for ( var i:int = 0; i < xmlArray.children().length(); i++ ) {
				var prop : XML = new XML("<" + i + "></" + i + ">");
				
				var type:String = xmlArray.children()[i].name();
				
				if ( type == "string" ) {
					prop.setChildren( xmlArray.children()[i].toString() );
				} else if ( type == "array" ) {
					parseArray( xmlArray.children()[i], prop );
				} else if ( type == "dict" ) {
					parseDictionary( xmlArray.children()[i], prop );
				} else if ( type == "integer" ) {
					prop.setChildren( int( xmlArray.children()[i] ) );
				} else if ( type == "real" ) {
					prop.setChildren( Number( xmlArray.children()[i] ) );
				}
				
				parent.appendChild( prop );
			}
		}//end parseArrayOfDict()
		
		private static function parseDictionary(xmlDict:XML, parent:XML):void
		{	
			for ( var i:int = 0; i < xmlDict.children().length(); i++ ) {
				var prop : XML = new XML(<name></name>);
				
				if ( xmlDict.children()[i].name() == "key" ) {						
					prop.setName( xmlDict.children()[i].toString() );
				}
				
				i++;
				
				var type:String = xmlDict.children()[i].name();
				 
				if ( type == "string" ) {
					prop.setChildren( xmlDict.children()[i].toString() );
				} else if ( type == "array" ) {
					parseArray( xmlDict.children()[i], prop );
				} else if ( type == "dict" ) {
					parseDictionary( xmlDict.children()[i], prop );
				} else if ( type == "integer" ) {
					prop.setChildren( int( xmlDict.children()[i] ) );
				} else if ( type == "real" ) {
					prop.setChildren( Number( xmlDict.children()[i] ) );
				}
				
				parent.appendChild( prop );
			}
		}//end parseDictionary()
		
	}//end PlistParser
	
}//end laan.xml