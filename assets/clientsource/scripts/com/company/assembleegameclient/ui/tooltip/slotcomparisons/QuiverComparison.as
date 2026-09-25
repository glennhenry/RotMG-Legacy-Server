package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   import com.company.assembleegameclient.ui.tooltip.TooltipHelper;
   import com.company.assembleegameclient.util.*;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class QuiverComparison extends SlotComparison
   {
      
      private var projectileComparison:GeneralProjectileComparison = new GeneralProjectileComparison();
      
      private var condition:XMLList;
      
      private var otherCondition:XMLList;
      
      public function QuiverComparison()
      {
         super();
      }
      
      override protected function compareSlots(param1:XML, param2:XML) : void
      {
         var tagStr:String = null;
         var duration:Number = NaN;
         var conditionEffect:ConditionEffect = null;
         var itemXML:XML = param1;
         var curItemXML:XML = param2;
         this.condition = itemXML.Projectile.ConditionEffect.(text() == "Slowed" || text() == "Paralyzed" || text() == "Dazed");
         this.otherCondition = curItemXML.Projectile.ConditionEffect.(text() == "Slowed" || text() == "Paralyzed" || text() == "Dazed");
         this.projectileComparison.compare(itemXML,curItemXML);
         comparisonStringBuilder = this.projectileComparison.comparisonStringBuilder;
         for(tagStr in this.projectileComparison.processedTags)
         {
            processedTags[tagStr] = true;
         }
         if(this.condition.length() == 1 && this.otherCondition.length() == 1)
         {
            duration = Number(this.condition[0].@duration);
            conditionEffect = ConditionEffect.getConditionEffectEnumFromName(this.condition.text());
            comparisonStringBuilder.pushParams(TextKey.SHOT_EFFECT,{"effect":""});
            comparisonStringBuilder.pushParams(TextKey.EFFECT_FOR_DURATION,{
               "effect":new LineBuilder().setParams(conditionEffect.localizationKey_),
               "duration":duration
            },TooltipHelper.getOpenTag(NO_DIFF_COLOR),TooltipHelper.getCloseTag());
            processedTags[this.condition[0].toXMLString()] = true;
         }
      }
   }
}

