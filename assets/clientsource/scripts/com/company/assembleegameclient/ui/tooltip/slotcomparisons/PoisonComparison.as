package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   import com.company.assembleegameclient.ui.tooltip.TooltipHelper;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class PoisonComparison extends SlotComparison
   {
      
      public function PoisonComparison()
      {
         super();
      }
      
      override protected function compareSlots(param1:XML, param2:XML) : void
      {
         var activate:XMLList = null;
         var otherActivate:XMLList = null;
         var damage:int = 0;
         var otherDamage:int = 0;
         var radius:Number = NaN;
         var otherRadius:Number = NaN;
         var duration:Number = NaN;
         var otherDuration:Number = NaN;
         var avg:Number = NaN;
         var otherAvg:Number = NaN;
         var dataLineBuilder:LineBuilder = null;
         var itemXML:XML = param1;
         var curItemXML:XML = param2;
         activate = itemXML.Activate.(text() == "PoisonGrenade");
         otherActivate = curItemXML.Activate.(text() == "PoisonGrenade");
         comparisonStringBuilder = new AppendingLineBuilder();
         if(activate.length() == 1 && otherActivate.length() == 1)
         {
            damage = int(activate[0].@totalDamage);
            otherDamage = int(otherActivate[0].@totalDamage);
            radius = Number(activate[0].@radius);
            otherRadius = Number(otherActivate[0].@radius);
            duration = Number(activate[0].@duration);
            otherDuration = Number(otherActivate[0].@duration);
            avg = 0.33 * damage + 0.33 * radius + 0.33 * duration;
            otherAvg = 0.33 * otherDamage + 0.33 * otherRadius + 0.33 * otherDuration;
            dataLineBuilder = new LineBuilder().setParams(TextKey.POISON_GRENADE_DATA,{
               "damage":damage.toString(),
               "duration":duration.toString(),
               "radius":radius.toString()
            }).setPrefix(TooltipHelper.getOpenTag(getTextColor(avg - otherAvg))).setPostfix(TooltipHelper.getCloseTag());
            comparisonStringBuilder.pushParams(TextKey.POISON_GRENADE,{"data":dataLineBuilder});
            processedTags[activate[0].toXMLString()] = true;
         }
      }
   }
}

