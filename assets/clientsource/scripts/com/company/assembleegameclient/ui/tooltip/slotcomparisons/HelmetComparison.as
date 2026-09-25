package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   import com.company.assembleegameclient.ui.tooltip.TooltipHelper;
   import kabam.rotmg.constants.*;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
   
   public class HelmetComparison extends SlotComparison
   {
      
      private var berserk:XML;
      
      private var speedy:XML;
      
      private var otherBerserk:XML;
      
      private var otherSpeedy:XML;
      
      private var armored:XML;
      
      private var otherArmored:XML;
      
      public function HelmetComparison()
      {
         super();
      }
      
      override protected function compareSlots(param1:XML, param2:XML) : void
      {
         this.extractDataFromXML(param1,param2);
         comparisonStringBuilder = new AppendingLineBuilder();
         this.handleBerserk();
         this.handleSpeedy();
         this.handleArmored();
      }
      
      private function extractDataFromXML(param1:XML, param2:XML) : void
      {
         this.berserk = this.getAuraTagByType(param1,"Berserk");
         this.speedy = this.getSelfTagByType(param1,"Speedy");
         this.armored = this.getSelfTagByType(param1,"Armored");
         this.otherBerserk = this.getAuraTagByType(param2,"Berserk");
         this.otherSpeedy = this.getSelfTagByType(param2,"Speedy");
         this.otherArmored = this.getSelfTagByType(param2,"Armored");
      }
      
      private function getAuraTagByType(param1:XML, param2:String) : XML
      {
         var matches:XMLList = null;
         var tag:XML = null;
         var xml:XML = param1;
         var typeName:String = param2;
         matches = xml.Activate.(text() == ActivationType.COND_EFFECT_AURA);
         for each(tag in matches)
         {
            if(tag.@effect == typeName)
            {
               return tag;
            }
         }
         return null;
      }
      
      private function getSelfTagByType(param1:XML, param2:String) : XML
      {
         var matches:XMLList = null;
         var tag:XML = null;
         var xml:XML = param1;
         var typeName:String = param2;
         matches = xml.Activate.(text() == ActivationType.COND_EFFECT_SELF);
         for each(tag in matches)
         {
            if(tag.@effect == typeName)
            {
               return tag;
            }
         }
         return null;
      }
      
      private function handleBerserk() : void
      {
         if(this.berserk == null || this.otherBerserk == null)
         {
            return;
         }
         var _loc1_:Number = Number(this.berserk.@range);
         var _loc2_:Number = Number(this.otherBerserk.@range);
         var _loc3_:Number = Number(this.berserk.@duration);
         var _loc4_:Number = Number(this.otherBerserk.@duration);
         var _loc5_:Number = 0.5 * _loc1_ + 0.5 * _loc3_;
         var _loc6_:Number = 0.5 * _loc2_ + 0.5 * _loc4_;
         var _loc7_:uint = getTextColor(_loc5_ - _loc6_);
         var _loc8_:AppendingLineBuilder = new AppendingLineBuilder();
         _loc8_.pushParams(TextKey.WITHIN_SQRS,{"range":_loc1_.toString()},TooltipHelper.getOpenTag(_loc7_),TooltipHelper.getCloseTag());
         _loc8_.pushParams(TextKey.EFFECT_FOR_DURATION,{
            "effect":TextKey.wrapForTokenResolution(TextKey.ACTIVE_EFFECT_BERSERK),
            "duration":_loc3_.toString()
         },TooltipHelper.getOpenTag(_loc7_),TooltipHelper.getCloseTag());
         comparisonStringBuilder.pushParams(TextKey.PARTY_EFFECT,{"effect":_loc8_});
         processedTags[this.berserk.toXMLString()] = true;
      }
      
      private function handleSpeedy() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(this.speedy != null && this.otherSpeedy != null)
         {
            _loc1_ = Number(this.speedy.@duration);
            _loc2_ = Number(this.otherSpeedy.@duration);
            comparisonStringBuilder.pushParams(TextKey.EFFECT_ON_SELF,{"effect":""});
            comparisonStringBuilder.pushParams(TextKey.EFFECT_FOR_DURATION,{
               "effect":TextKey.wrapForTokenResolution(TextKey.ACTIVE_EFFECT_SPEEDY),
               "duration":_loc1_.toString()
            },TooltipHelper.getOpenTag(getTextColor(_loc1_ - _loc2_)),TooltipHelper.getCloseTag());
            processedTags[this.speedy.toXMLString()] = true;
         }
         else if(this.speedy != null && this.otherSpeedy == null)
         {
            comparisonStringBuilder.pushParams(TextKey.EFFECT_ON_SELF,{"effect":""});
            comparisonStringBuilder.pushParams(TextKey.EFFECT_FOR_DURATION,{
               "effect":TextKey.wrapForTokenResolution(TextKey.ACTIVE_EFFECT_SPEEDY),
               "duration":this.speedy.@duration
            },TooltipHelper.getOpenTag(BETTER_COLOR),TooltipHelper.getCloseTag());
            processedTags[this.speedy.toXMLString()] = true;
         }
      }
      
      private function handleArmored() : void
      {
         if(this.armored != null)
         {
            comparisonStringBuilder.pushParams(TextKey.EFFECT_ON_SELF,{"effect":""});
            comparisonStringBuilder.pushParams(TextKey.EFFECT_FOR_DURATION,{
               "effect":TextKey.wrapForTokenResolution(TextKey.ACTIVE_EFFECT_ARMORED),
               "duration":this.armored.@duration
            },TooltipHelper.getOpenTag(UNTIERED_COLOR),TooltipHelper.getCloseTag());
            processedTags[this.armored.toXMLString()] = true;
         }
      }
   }
}

