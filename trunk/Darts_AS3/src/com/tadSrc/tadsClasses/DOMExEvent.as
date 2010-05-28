package com.tadSrc.tadsClasses
{
        import flash.events.*;
        
        public class DOMExEvent extends Event
        {
                public static const DOMEX_EVENT:String = "domexEvent";
                public var eventPropertiesArray:Array;
                
                public function DOMExEvent(theEValues:Array):void
                {
                        super(DOMEX_EVENT);
                        eventPropertiesArray = theEValues;
                }
                
        }
}

