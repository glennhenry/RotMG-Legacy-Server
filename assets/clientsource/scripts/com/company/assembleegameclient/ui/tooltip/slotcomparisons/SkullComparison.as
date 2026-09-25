package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   import com.company.assembleegameclient.ui.tooltip.TooltipHelper;
   import kabam.rotmg.constants.*;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class SkullComparison extends SlotComparison
   {
      
      public function SkullComparison()
      {
         super();
      }
      
      override protected function compareSlots(param1:XML, param2:XML) : void
      {
         var _loc3_:XML = null;
         var _loc4_:XML = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         _loc3_ = this.getVampireBlastTag(param1);
         _loc4_ = this.getVampireBlastTag(param2);
         comparisonStringBuilder = new AppendingLineBuilder();
         if(_loc3_ != null && _loc4_ != null)
         {
            _loc5_ = Number(_loc3_.@radius);
            _loc6_ = Number(_loc4_.@radius);
            _loc7_ = int(_loc3_.@totalDamage);
            _loc8_ = int(_loc4_.@totalDamage);
            _loc9_ = 0.5 * _loc5_ + 0.5 * _loc7_;
            _loc10_ = 0.5 * _loc6_ + 0.5 * _loc8_;
            comparisonStringBuilder.pushParams(TextKey.STEAL,{"effect":new LineBuilder().setParams(TextKey.HP_WITHIN_SQRS,{
               "amount":_loc7_,
               "range":_loc5_
            }).setPrefix(TooltipHelper.getOpenTag(getTextColor(_loc9_ - _loc10_))).setPostfix(TooltipHelper.getCloseTag())});
            processedTags[_loc3_.toXMLString()] = true;
         }
      }
      
      private function getVampireBlastTag(param1:XML) : XML
      {
         var matches:XMLList = null;
         var xml:XML = param1;
         matches = xml.Activate.(text() == ActivationType.VAMPIRE_BLAST);
         return matches.length() >= 1 ? matches[0] : null;
      }
   }
}

