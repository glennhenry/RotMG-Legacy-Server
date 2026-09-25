package kabam.rotmg.language.model
{
   import kabam.rotmg.text.model.DebugTextInfo;
   
   public class DebugStringMap implements StringMap
   {
      
      [Inject]
      public var delegate:StringMap;
      
      [Inject]
      public var languageModel:LanguageModel;
      
      public var debugTextInfos:Vector.<DebugTextInfo> = new Vector.<DebugTextInfo>();
      
      public function DebugStringMap()
      {
         super();
      }
      
      public function hasKey(param1:String) : Boolean
      {
         return true;
      }
      
      public function getValue(param1:String) : String
      {
         if(param1 != "" && this.isInvalid(param1))
         {
            return param1;
         }
         return this.delegate.getValue(param1);
      }
      
      private function isInvalid(param1:String) : Boolean
      {
         return this.hasNo(param1) || this.hasWrongLanguage(param1);
      }
      
      private function hasNo(param1:String) : Boolean
      {
         return !this.delegate.hasKey(param1);
      }
      
      private function pushDebugInfo(param1:String) : void
      {
         var _loc2_:String = this.getLanguageFamily(param1);
         var _loc3_:DebugTextInfo = new DebugTextInfo();
         _loc3_.key = param1;
         _loc3_.hasKey = this.delegate.hasKey(param1);
         _loc3_.languageFamily = _loc2_;
         _loc3_.value = this.delegate.getValue(param1);
         this.debugTextInfos.push(_loc3_);
      }
      
      private function hasWrongLanguage(param1:String) : Boolean
      {
         return this.getLanguageFamily(param1) != this.languageModel.getLanguage();
      }
      
      public function clear() : void
      {
      }
      
      public function setValue(param1:String, param2:String, param3:String) : void
      {
         this.delegate.setValue(param1,param2,param3);
      }
      
      public function getLanguageFamily(param1:String) : String
      {
         return this.delegate.getLanguageFamily(param1);
      }
   }
}

