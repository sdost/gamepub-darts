package com.tadSrc.tadsClasses
{
  import flash.utils.*;
  import flash.events.*;
  import flash.external.ExternalInterface;
  import com.tadSrc.tadsClasses.DOMExEvent;


public class DOMExEventDispatcher extends EventDispatcher
{

        private var onWhat:String;
        private var uniqueNumber:Number;
        private var theLag:Number =  1000;

        private var eventProperties:Array;


public function DOMExEventDispatcher(onWhater:String, propsToGet:Array, lag:Number = 1000)
{

        uniqueNumber = Math.floor(Math.random()*new Date().getTime());
        onWhat = onWhater;
        theLag = lag;

        eventProperties = propsToGet;

        var lagTime:Timer = new Timer(theLag, 1);
        lagTime.addEventListener(TimerEvent.TIMER_COMPLETE, iniDevd);
        lagTime.start();

}


private function iniDevd(e:TimerEvent):void
{
        e.target.stop();

        var callName:String = "DOMExEventDispatcher"+uniqueNumber+"";
        var eventName:String = "domexEvent"+uniqueNumber+"";
        var props:Array = [];
        for (var i:int = 0; i < eventProperties.length; i++)
        { props.push(eventProperties[i]); }

        if (ExternalInterface.available) {

                ExternalInterface.addCallback(callName, theEventDispatcher);
                makeLevelOneMasterTalk(eventName, callName, getIdByIndex());

                //We can not pass events themselves between AS and JS.
                //So instead, whatever uses this class will also pass in the event properties it wants to get
                //A DOMExEvent will then have an Array of the values of those properties

                var theJavaScriptString:String = 
                "<script><![CDATA[function (arr) {"+onWhat+" = "+
                "function (e) {var thee = (e != undefined) ? e : event;"+
                "var propers = arr; var outputinger = []; "+
                "for (var i = 0; i < propers.length; i++)"+
                "{ outputinger.push(thee[propers[i]]); };"+
                eventName+"(outputinger);};}]]></script>";

                var theJavaScript:XML = new XML(theJavaScriptString);
                ExternalInterface.call(theJavaScript, props);
        }

        e.target.removeEventListener(TimerEvent.TIMER_COMPLETE, iniDevd);

}


private function theEventDispatcher(arrayOfEventProperties:Array):void
{
        dispatchEvent(new DOMExEvent(arrayOfEventProperties));
}


private function makeLevelOneMasterTalk(nameToBe:String, funcIs:String, idIs:String):void
{

        /* used to create a javascript function that acts as the callBack function itself. */
        var masterTalkBuild:String = 
        "<script><![CDATA[function(){"+nameToBe+" = function"+
        "() { var fcontenter;"+
        "try {fcontenter=window.document.getElementById('"+idIs+"');}catch(e) {"+
        "try {var theflash='"+idIs+"';fcontenter=window.document.theflash;}catch(e) {var movie='"+idIs+"';"+
        "if (navigator.appName.indexOf('Microsoft')!=-1 || navigator.appName.indexOf('MSIE')!=-1) {"+ 
        "if (window.document[movie]){fcontenter=window.document[movie];}else{fcontenter=window[movie];};"+
        "}else {if (document.embeds[movie]){fcontenter=document.embeds[movie];}else"+
        "{fcontenter=document[movie];};}}}"+
        "if (arguments && arguments.length > 0) {fcontenter['"+funcIs+"'].apply(fcontenter, arguments);}"+
        "else{fcontenter['"+funcIs+"']();} }; }]]></script>";
        if (ExternalInterface.available) {

              var builtFunction:XML = new XML(masterTalkBuild);

            ExternalInterface.marshallExceptions = true;
            ExternalInterface.call(builtFunction);
        }

}

public function getIdByIndex(index:Number = 0):*
{
        var outed:*;
        var idofswfobject:XML = 
        <script>
        <![CDATA[
        function (indexr) {
        
         function getid(indexer) {
          var objects;
          var r = "";
            try {
             
             (document.getElementsByTagName("object")) ? 
             objects = document.getElementsByTagName("object")[indexer] : 
             objects = document.getElementsByTagName("OBJECT")[indexer];
                         
             if (objects.hasAttribute("id") && !objects.id) {r=objects.getAttribute("id");}
             if (objects.id && !objects.hasAttribute("ID")) {r=objects.id+"";}
             if (objects.hasAttribute("ID")) {r=objects.getAttribute("ID");}
 
        
            }catch (e) {

              (document.getElementsByTagName("object")) ? 
              objects = document.getElementsByTagName("object")[indexer] : 
              objects = document.getElementsByTagName("OBJECT")[indexer];

              if (objects && objects.outerHTML) {
                 var ohtml=objects.outerHTML.toString();
                 var idfind = new RegExp("id[ ]{0,}=[ ]{0,}[ a-zA-Z0-9\_\"]{1,}", "i");
                 var ridid = new RegExp("id", "i");
                 var rideq = new RegExp("[=\"]{1,}", "ig");
                 var ridspace = new RegExp("[ ]{1,}", "g");
                 var nocodeBase = new RegExp("codeBase|classid|height|width", "ig");
                 if (ohtml.match(idfind)) { 
                  r = 
                  ohtml.match(idfind).toString().replace(ridid, "").replace(rideq, 
                  "").replace(ridspace, "").replace(nocodeBase, "");
                 }else{r = "";}
               }else {r = "";}

            }
          return r;
         };

         return(getid(indexr));

        }
        ]]>
        </script>;
        if (ExternalInterface.available) {
          outed = ExternalInterface.call(idofswfobject, index);
        }

        return outed;

}

}

}