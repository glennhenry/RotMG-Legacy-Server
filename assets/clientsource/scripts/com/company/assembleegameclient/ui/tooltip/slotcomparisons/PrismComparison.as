package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   import com.company.assembleegameclient.ui.tooltip.TooltipHelper;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class PrismComparison extends SlotComparison
   {
      
      private var decoy:XMLList;
      
      private var otherDecoy:XMLList;
      
      public function PrismComparison()
      {
         super();
      }
      
      override protected function compareSlots(param1:XML, param2:XML) : void
      {
         var duration:Number = NaN;
         var otherDuration:Number = NaN;
         var textColor:uint = 0;
         var test:String = null;
         var itemXML:XML = param1;
         var curItemXML:XML = param2;
         this.decoy = itemXML.Activate.(text() == "Decoy");
         this.otherDecoy = curItemXML.Activate.(text() == "Decoy");
         comparisonStringBuilder = new AppendingLineBuilder();
         if(this.decoy.length() == 1 && this.otherDecoy.length() == 1)
         {
            duration = Number(this.decoy[0].@duration);
            otherDuration = Number(this.otherDecoy[0].@duration);
            textColor = getTextColor(duration - otherDuration);
            comparisonStringBuilder.pushParams(TextKey.DECOY,{"data":new LineBuilder().setParams(TextKey.SEC_COUNT,{"duration":duration.toString()}).setPrefix(TooltipHelper.getOpenTag(textColor)).setPostfix(TooltipHelper.getCloseTag())});
            test = this.decoy[0].toXMLString();
            processedTags[this.decoy[0].toXMLString()] = true;
         }
      }
   }
}

