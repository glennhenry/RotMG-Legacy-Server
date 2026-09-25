package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   import com.company.assembleegameclient.ui.tooltip.TooltipHelper;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
   
   public class SealComparison extends SlotComparison
   {
      
      private var healingTag:XML;
      
      private var damageTag:XML;
      
      private var otherHealingTag:XML;
      
      private var otherDamageTag:XML;
      
      public function SealComparison()
      {
         super();
      }
      
      override protected function compareSlots(param1:XML, param2:XML) : void
      {
         var tag:XML = null;
         var itemXML:XML = param1;
         var curItemXML:XML = param2;
         comparisonStringBuilder = new AppendingLineBuilder();
         this.healingTag = this.getEffectTag(itemXML,"Healing");
         this.damageTag = this.getEffectTag(itemXML,"Damaging");
         this.otherHealingTag = this.getEffectTag(curItemXML,"Healing");
         this.otherDamageTag = this.getEffectTag(curItemXML,"Damaging");
         if(this.canCompare())
         {
            this.handleHealingText();
            this.handleDamagingText();
            if(itemXML.@id == "Seal of Blasphemous Prayer")
            {
               tag = itemXML.Activate.(text() == "ConditionEffectSelf")[0];
               comparisonStringBuilder.pushParams(TextKey.EFFECT_ON_SELF,{"effect":""});
               comparisonStringBuilder.pushParams(TextKey.EFFECT_FOR_DURATION,{
                  "effect":TextKey.wrapForTokenResolution(TextKey.ACTIVE_EFFECT_INVULERABLE),
                  "duration":tag.@duration
               },TooltipHelper.getOpenTag(UNTIERED_COLOR),TooltipHelper.getCloseTag());
               processedTags[tag.toXMLString()] = true;
            }
         }
      }
      
      private function canCompare() : Boolean
      {
         return this.healingTag != null && this.damageTag != null && this.otherHealingTag != null && this.otherDamageTag != null;
      }
      
      private function getEffectTag(param1:XML, param2:String) : XML
      {
         var matches:XMLList = null;
         var tag:XML = null;
         var xml:XML = param1;
         var effectName:String = param2;
         matches = xml.Activate.(text() == "ConditionEffectAura");
         for each(tag in matches)
         {
            if(tag.@effect == effectName)
            {
               return tag;
            }
         }
         return null;
      }
      
      private function handleHealingText() : void
      {
         var _loc1_:int = int(this.healingTag.@duration);
         var _loc2_:int = int(this.otherHealingTag.@duration);
         var _loc3_:Number = Number(this.healingTag.@range);
         var _loc4_:Number = Number(this.otherHealingTag.@range);
         var _loc5_:Number = 0.5 * _loc1_ * 0.5 * _loc3_;
         var _loc6_:Number = 0.5 * _loc2_ * 0.5 * _loc4_;
         var _loc7_:uint = getTextColor(_loc5_ - _loc6_);
         var _loc8_:AppendingLineBuilder = new AppendingLineBuilder();
         _loc8_.pushParams(TextKey.WITHIN_SQRS,{"range":this.healingTag.@range},TooltipHelper.getOpenTag(_loc7_),TooltipHelper.getCloseTag());
         _loc8_.pushParams(TextKey.EFFECT_FOR_DURATION,{
            "effect":TextKey.wrapForTokenResolution(TextKey.ACTIVE_EFFECT_HEALING),
            "duration":_loc1_.toString()
         },TooltipHelper.getOpenTag(_loc7_),TooltipHelper.getCloseTag());
         comparisonStringBuilder.pushParams(TextKey.PARTY_EFFECT,{"effect":_loc8_});
         processedTags[this.healingTag.toXMLString()] = true;
      }
      
      private function handleDamagingText() : void
      {
         var _loc1_:int = int(this.damageTag.@duration);
         var _loc2_:int = int(this.otherDamageTag.@duration);
         var _loc3_:Number = Number(this.damageTag.@range);
         var _loc4_:Number = Number(this.otherDamageTag.@range);
         var _loc5_:Number = 0.5 * _loc1_ * 0.5 * _loc3_;
         var _loc6_:Number = 0.5 * _loc2_ * 0.5 * _loc4_;
         var _loc7_:uint = getTextColor(_loc5_ - _loc6_);
         var _loc8_:AppendingLineBuilder = new AppendingLineBuilder();
         _loc8_.pushParams(TextKey.WITHIN_SQRS,{"range":this.damageTag.@range},TooltipHelper.getOpenTag(_loc7_),TooltipHelper.getCloseTag());
         _loc8_.pushParams(TextKey.EFFECT_FOR_DURATION,{
            "effect":TextKey.wrapForTokenResolution(TextKey.ACTIVE_EFFECT_DAMAGING),
            "duration":_loc1_.toString()
         },TooltipHelper.getOpenTag(_loc7_),TooltipHelper.getCloseTag());
         comparisonStringBuilder.pushParams(TextKey.PARTY_EFFECT,{"effect":_loc8_});
         processedTags[this.damageTag.toXMLString()] = true;
      }
   }
}

