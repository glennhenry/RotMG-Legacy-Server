package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   import com.company.assembleegameclient.ui.tooltip.TooltipHelper;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class TrapComparison extends SlotComparison
   {
      
      public function TrapComparison()
      {
         super();
      }
      
      private function getTrapTag(param1:XML) : XML
      {
         var matches:XMLList = null;
         var xml:XML = param1;
         matches = xml.Activate.(text() == "Trap");
         if(matches.length() >= 1)
         {
            return matches[0];
         }
         return null;
      }
      
      override protected function compareSlots(param1:XML, param2:XML) : void
      {
         var trap:XML = null;
         var otherTrap:XML = null;
         var tag:XML = null;
         var radius:Number = NaN;
         var otherRadius:Number = NaN;
         var damage:int = 0;
         var otherDamage:int = 0;
         var duration:int = 0;
         var otherDuration:int = 0;
         var avg:Number = NaN;
         var otherAvg:Number = NaN;
         var textColor:uint = 0;
         var itemXML:XML = param1;
         var curItemXML:XML = param2;
         trap = this.getTrapTag(itemXML);
         otherTrap = this.getTrapTag(curItemXML);
         comparisonStringBuilder = new AppendingLineBuilder();
         if(trap != null && otherTrap != null)
         {
            if(itemXML.@id == "Coral Venom Trap")
            {
               tag = itemXML.Activate.(text() == "Trap")[0];
               comparisonStringBuilder.pushParams(TextKey.TRAP,{"data":new LineBuilder().setParams(TextKey.HP_WITHIN_SQRS,{
                  "amount":tag.@totalDamage,
                  "range":tag.@radius
               }).setPrefix(TooltipHelper.getOpenTag(UNTIERED_COLOR)).setPostfix(TooltipHelper.getCloseTag())});
               comparisonStringBuilder.pushParams(TextKey.EFFECT_FOR_DURATION,{
                  "effect":new LineBuilder().setParams(TextKey.CONDITION_EFFECT_PARALYZED),
                  "duration":tag.@condDuration
               },TooltipHelper.getOpenTag(UNTIERED_COLOR),TooltipHelper.getCloseTag());
               processedTags[tag.toXMLString()] = true;
            }
            else
            {
               radius = Number(trap.@radius);
               otherRadius = Number(otherTrap.@radius);
               damage = int(trap.@totalDamage);
               otherDamage = int(otherTrap.@totalDamage);
               duration = int(trap.@condDuration);
               otherDuration = int(otherTrap.@condDuration);
               avg = 0.33 * radius + 0.33 * damage + 0.33 * duration;
               otherAvg = 0.33 * otherRadius + 0.33 * otherDamage + 0.33 * otherDuration;
               textColor = getTextColor(avg - otherAvg);
               comparisonStringBuilder.pushParams(TextKey.TRAP,{"data":new LineBuilder().setParams(TextKey.HP_WITHIN_SQRS,{
                  "amount":trap.@totalDamage,
                  "range":trap.@radius
               }).setPrefix(TooltipHelper.getOpenTag(textColor)).setPostfix(TooltipHelper.getCloseTag())});
               comparisonStringBuilder.pushParams(TextKey.EFFECT_FOR_DURATION,{
                  "effect":new LineBuilder().setParams(TextKey.CONDITION_EFFECT_SLOWED),
                  "duration":trap.@condDuration
               },TooltipHelper.getOpenTag(textColor),TooltipHelper.getCloseTag());
               processedTags[trap.toXMLString()] = true;
            }
         }
      }
   }
}

