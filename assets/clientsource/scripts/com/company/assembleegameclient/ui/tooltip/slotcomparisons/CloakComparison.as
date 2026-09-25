package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   import com.company.assembleegameclient.ui.tooltip.TooltipHelper;
   import kabam.rotmg.constants.*;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
   
   public class CloakComparison extends SlotComparison
   {
      
      public function CloakComparison()
      {
         super();
      }
      
      override protected function compareSlots(param1:XML, param2:XML) : void
      {
         var _loc3_:XML = null;
         var _loc4_:XML = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         _loc3_ = this.getInvisibleTag(param1);
         _loc4_ = this.getInvisibleTag(param2);
         comparisonStringBuilder = new AppendingLineBuilder();
         if(_loc3_ != null && _loc4_ != null)
         {
            _loc5_ = Number(_loc3_.@duration);
            _loc6_ = Number(_loc4_.@duration);
            this.appendDurationText(_loc5_,_loc6_);
            processedTags[_loc3_.toXMLString()] = true;
         }
         this.handleExceptions(param1);
      }
      
      private function handleExceptions(param1:XML) : void
      {
         var teleportTag:XML = null;
         var itemXML:XML = param1;
         if(itemXML.@id == "Cloak of the Planewalker")
         {
            comparisonStringBuilder.pushParams(TextKey.TELEPORT_TO_TARGET,{},TooltipHelper.getOpenTag(UNTIERED_COLOR),TooltipHelper.getCloseTag());
            teleportTag = XML(itemXML.Activate.(text() == ActivationType.TELEPORT))[0];
            processedTags[teleportTag.toXMLString()] = true;
         }
      }
      
      private function getInvisibleTag(param1:XML) : XML
      {
         var matches:XMLList = null;
         var conditionTag:XML = null;
         var xml:XML = param1;
         matches = xml.Activate.(text() == ActivationType.COND_EFFECT_SELF);
         for each(conditionTag in matches)
         {
            if(conditionTag.(@effect == "Invisible"))
            {
               return conditionTag;
            }
         }
         return null;
      }
      
      private function appendDurationText(param1:Number, param2:Number) : void
      {
         var _loc3_:uint = getTextColor(param1 - param2);
         comparisonStringBuilder.pushParams(TextKey.EFFECT_ON_SELF,{"effect":""});
         comparisonStringBuilder.pushParams(TextKey.EFFECT_FOR_DURATION,{
            "effect":TextKey.wrapForTokenResolution(TextKey.ACTIVE_EFFECT_INVISIBLE),
            "duration":param1.toString()
         },TooltipHelper.getOpenTag(_loc3_),TooltipHelper.getCloseTag());
      }
   }
}

