package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   import com.company.assembleegameclient.ui.tooltip.TooltipHelper;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class TomeComparison extends SlotComparison
   {
      
      public function TomeComparison()
      {
         super();
      }
      
      override protected function compareSlots(param1:XML, param2:XML) : void
      {
         var nova:XMLList = null;
         var otherNova:XMLList = null;
         var tag:XML = null;
         var range:Number = NaN;
         var otherRange:Number = NaN;
         var amount:Number = NaN;
         var otherAmount:Number = NaN;
         var wavg:Number = NaN;
         var otherWavg:Number = NaN;
         var innerStringBuilder:LineBuilder = null;
         var itemXML:XML = param1;
         var curItemXML:XML = param2;
         nova = itemXML.Activate.(text() == "HealNova");
         otherNova = curItemXML.Activate.(text() == "HealNova");
         comparisonStringBuilder = new AppendingLineBuilder();
         if(nova.length() == 1 && otherNova.length() == 1)
         {
            range = Number(nova.@range);
            otherRange = Number(otherNova.@range);
            amount = Number(nova.@amount);
            otherAmount = Number(otherNova.@amount);
            wavg = 0.5 * range + 0.5 * amount;
            otherWavg = 0.5 * otherRange + 0.5 * otherAmount;
            innerStringBuilder = new LineBuilder().setParams(TextKey.HP_WITHIN_SQRS,{
               "amount":amount.toString(),
               "range":range.toString()
            }).setPrefix(TooltipHelper.getOpenTag(getTextColor(wavg - otherWavg))).setPostfix(TooltipHelper.getCloseTag());
            comparisonStringBuilder.pushParams(TextKey.PARTY_HEAL,{"effect":innerStringBuilder});
            processedTags[nova.toXMLString()] = true;
         }
         if(itemXML.@id == "Tome of Purification")
         {
            tag = itemXML.Activate.(text() == "RemoveNegativeConditions")[0];
            comparisonStringBuilder.pushParams(TextKey.REMOVES_NEGATIVE,{},TooltipHelper.getOpenTag(UNTIERED_COLOR),TooltipHelper.getCloseTag());
            processedTags[tag.toXMLString()] = true;
         }
         else if(itemXML.@id == "Tome of Holy Protection")
         {
            tag = itemXML.Activate.(text() == "ConditionEffectSelf")[0];
            comparisonStringBuilder.pushParams(TextKey.EFFECT_ON_SELF,{"effect":""});
            comparisonStringBuilder.pushParams(TextKey.EFFECT_FOR_DURATION,{
               "effect":TextKey.wrapForTokenResolution(TextKey.ACTIVE_EFFECT_ARMORED),
               "duration":tag.@duration
            },TooltipHelper.getOpenTag(UNTIERED_COLOR),TooltipHelper.getCloseTag());
            processedTags[tag.toXMLString()] = true;
         }
      }
   }
}

