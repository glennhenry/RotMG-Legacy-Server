package com.company.util
{
   import flash.external.ExternalInterface;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   import flash.xml.XMLNodeType;
   
   public class HTMLUtil
   {
      
      public function HTMLUtil()
      {
         super();
      }
      
      public static function unescape(param1:String) : String
      {
         return new XMLDocument(param1).firstChild.nodeValue;
      }
      
      public static function escape(param1:String) : String
      {
         return XML(new XMLNode(XMLNodeType.TEXT_NODE,param1)).toXMLString();
      }
      
      public static function refreshPageNoParams() : void
      {
         var _loc1_:String = null;
         var _loc2_:Array = null;
         var _loc3_:String = null;
         if(ExternalInterface.available)
         {
            _loc1_ = ExternalInterface.call("window.location.toString");
            _loc2_ = _loc1_.split("?");
            if(_loc2_.length > 0)
            {
               _loc3_ = _loc2_[0];
               if(_loc3_.indexOf("www.kabam") != -1)
               {
                  _loc3_ = "http://www.realmofthemadgod.com";
               }
               ExternalInterface.call("window.location.assign",_loc3_);
            }
         }
      }
   }
}

