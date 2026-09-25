package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   import com.company.assembleegameclient.ui.tooltip.TooltipHelper;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class OrbComparison extends SlotComparison
   {
      
      public function OrbComparison()
      {
         super();
      }
      
      override protected function compareSlots(param1:XML, param2:XML) : void
      {
         var _loc3_:XML = null;
         var _loc4_:XML = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         _loc3_ = this.getStasisBlastTag(param1);
         _loc4_ = this.getStasisBlastTag(param2);
         comparisonStringBuilder = new AppendingLineBuilder();
         if(_loc3_ != null && _loc4_ != null)
         {
            _loc5_ = int(_loc3_.@duration);
            _loc6_ = int(_loc4_.@duration);
            _loc7_ = getTextColor(_loc5_ - _loc6_);
            comparisonStringBuilder.pushParams(TextKey.STASIS_GROUP,{"stasis":new LineBuilder().setParams(TextKey.SEC_COUNT,{"duration":_loc5_}).setPrefix(TooltipHelper.getOpenTag(_loc7_)).setPostfix(TooltipHelper.getCloseTag())});
            processedTags[_loc3_.toXMLString()] = true;
            this.handleExceptions(param1);
         }
      }
      
      private function getStasisBlastTag(param1:XML) : XML
      {
         var matches:XMLList = null;
         var orbXML:XML = param1;
         matches = orbXML.Activate.(text() == "StasisBlast");
         return matches.length() == 1 ? matches[0] : null;
      }
      
      private function handleExceptions(param1:XML) : void
      {
         var selfTags:XMLList = null;
         var speedy:XML = null;
         var damaging:XML = null;
         var itemXML:XML = param1;
         if(itemXML.@id == "Orb of Conflict")
         {
            selfTags = itemXML.Activate.(text() == "ConditionEffectSelf");
            speedy = selfTags.(@effect == "Speedy")[0];
            damaging = selfTags.(@effect == "Damaging")[0];
            comparisonStringBuilder.pushParams(TextKey.EFFECT_ON_SELF,{"effect":""});
            comparisonStringBuilder.pushParams(TextKey.EFFECT_FOR_DURATION,{
               "effect":TextKey.wrapForTokenResolution(TextKey.ACTIVE_EFFECT_SPEEDY),
               "duration":speedy.@duration
            },TooltipHelper.getOpenTag(UNTIERED_COLOR),TooltipHelper.getCloseTag());
            comparisonStringBuilder.pushParams(TextKey.EFFECT_ON_SELF,{"effect":""});
            comparisonStringBuilder.pushParams(TextKey.EFFECT_FOR_DURATION,{
               "effect":TextKey.wrapForTokenResolution(TextKey.ACTIVE_EFFECT_DAMAGING),
               "duration":damaging.@duration
            },TooltipHelper.getOpenTag(UNTIERED_COLOR),TooltipHelper.getCloseTag());
            processedTags[speedy.toXMLString()] = true;
            processedTags[damaging.toXMLString()] = true;
         }
      }
   }
}

