package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   import com.company.assembleegameclient.ui.tooltip.TooltipHelper;
   import kabam.rotmg.constants.*;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class ScepterComparison extends SlotComparison
   {
      
      public function ScepterComparison()
      {
         super();
      }
      
      override protected function compareSlots(param1:XML, param2:XML) : void
      {
         var result:XMLList = null;
         var otherResult:XMLList = null;
         var damage:int = 0;
         var otherDamage:int = 0;
         var textColor:uint = 0;
         var targets:int = 0;
         var otherTargets:int = 0;
         var innerLineBuilder:LineBuilder = null;
         var condition:String = null;
         var duration:Number = NaN;
         var compositeStr:String = null;
         var htmlStr:String = null;
         var itemXML:XML = param1;
         var curItemXML:XML = param2;
         result = itemXML.Activate.(text() == ActivationType.LIGHTNING);
         otherResult = curItemXML.Activate.(text() == ActivationType.LIGHTNING);
         comparisonStringBuilder = new AppendingLineBuilder();
         if(result.length() == 1 && otherResult.length() == 1)
         {
            damage = int(result[0].@totalDamage);
            otherDamage = int(otherResult[0].@totalDamage);
            textColor = getTextColor(damage - otherDamage);
            targets = int(result[0].@maxTargets);
            otherTargets = int(otherResult[0].@maxTargets);
            innerLineBuilder = new LineBuilder().setParams(TextKey.DAMAGE_TO_TARGETS,{
               "damage":damage.toString(),
               "targets":targets.toString()
            }).setPrefix(TooltipHelper.getOpenTag(getTextColor(damage - otherDamage))).setPostfix(TooltipHelper.getCloseTag());
            comparisonStringBuilder.pushParams(TextKey.LIGHTNING,{"data":innerLineBuilder});
            processedTags[result[0].toXMLString()] = true;
         }
         if(String(itemXML.Activate.@condEffect))
         {
            condition = itemXML.Activate.@condEffect;
            duration = Number(itemXML.Activate.@condDuration);
            compositeStr = " " + condition + " for " + duration + " secs\n";
            htmlStr = "Shot Effect:\n" + wrapInColoredFont(compositeStr,NO_DIFF_COLOR);
            comparisonStringBuilder.pushParams(TextKey.SHOT_EFFECT,{"effect":""});
            comparisonStringBuilder.pushParams(TextKey.EFFECT_FOR_DURATION,{
               "effect":condition,
               "duration":duration.toString()
            },TooltipHelper.getOpenTag(NO_DIFF_COLOR),TooltipHelper.getCloseTag());
         }
      }
   }
}

