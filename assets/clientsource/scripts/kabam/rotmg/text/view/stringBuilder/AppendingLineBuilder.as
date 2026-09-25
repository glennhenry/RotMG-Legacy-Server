package kabam.rotmg.text.view.stringBuilder
{
   import kabam.rotmg.language.model.StringMap;
   
   public class AppendingLineBuilder implements StringBuilder
   {
      
      private var data:Vector.<LineData> = new Vector.<LineData>();
      
      private var delimiter:String = "\n";
      
      private var provider:StringMap;
      
      public function AppendingLineBuilder()
      {
         super();
      }
      
      public function pushParams(param1:String, param2:Object = null, param3:String = "", param4:String = "") : AppendingLineBuilder
      {
         this.data.push(new LineData().setKey(param1).setTokens(param2).setOpeningTags(param3).setClosingTags(param4));
         return this;
      }
      
      public function setDelimiter(param1:String) : AppendingLineBuilder
      {
         this.delimiter = param1;
         return this;
      }
      
      public function setStringMap(param1:StringMap) : void
      {
         this.provider = param1;
      }
      
      public function getString() : String
      {
         var _loc2_:LineData = null;
         var _loc1_:Vector.<String> = new Vector.<String>();
         for each(_loc2_ in this.data)
         {
            _loc1_.push(_loc2_.getString(this.provider));
         }
         return _loc1_.join(this.delimiter);
      }
      
      public function hasLines() : Boolean
      {
         return this.data.length != 0;
      }
      
      public function clear() : void
      {
         this.data = new Vector.<LineData>();
      }
   }
}

import kabam.rotmg.language.model.StringMap;
import kabam.rotmg.text.model.TextKey;

class LineData
{
   
   public var key:String;
   
   public var tokens:Object;
   
   public var openingHTMLTags:String = "";
   
   public var closingHTMLTags:String = "";
   
   public function LineData()
   {
      super();
   }
   
   public function setKey(param1:String) : LineData
   {
      this.key = param1;
      return this;
   }
   
   public function setTokens(param1:Object) : LineData
   {
      this.tokens = param1;
      return this;
   }
   
   public function setOpeningTags(param1:String) : LineData
   {
      this.openingHTMLTags = param1;
      return this;
   }
   
   public function setClosingTags(param1:String) : LineData
   {
      this.closingHTMLTags = param1;
      return this;
   }
   
   public function getString(param1:StringMap) : String
   {
      var _loc3_:String = null;
      var _loc4_:String = null;
      var _loc5_:StringBuilder = null;
      var _loc6_:String = null;
      var _loc2_:String = this.openingHTMLTags;
      _loc3_ = param1.getValue(TextKey.stripCurlyBrackets(this.key));
      if(_loc3_ == null)
      {
         _loc3_ = this.key;
      }
      _loc2_ = _loc2_.concat(_loc3_);
      for(_loc4_ in this.tokens)
      {
         if(this.tokens[_loc4_] is StringBuilder)
         {
            _loc5_ = StringBuilder(this.tokens[_loc4_]);
            _loc5_.setStringMap(param1);
            _loc2_ = _loc2_.replace("{" + _loc4_ + "}",_loc5_.getString());
         }
         else
         {
            _loc6_ = this.tokens[_loc4_];
            if(_loc6_.length > 0 && _loc6_.charAt(0) == "{" && _loc6_.charAt(_loc6_.length - 1) == "}")
            {
               _loc6_ = param1.getValue(_loc6_.substr(1,_loc6_.length - 2));
            }
            _loc2_ = _loc2_.replace("{" + _loc4_ + "}",_loc6_);
         }
      }
      _loc2_ = _loc2_.replace(/\\n/g,"\n");
      return _loc2_.concat(this.closingHTMLTags);
   }
}
