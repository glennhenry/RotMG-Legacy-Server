package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
   
   public class GenericArmorComparison extends SlotComparison
   {
      
      private static const DEFENSE_STAT:String = "21";
      
      private var defTags:XMLList;
      
      private var otherDefTags:XMLList;
      
      public function GenericArmorComparison()
      {
         super();
         comparisonStringBuilder = new AppendingLineBuilder();
      }
      
      override protected function compareSlots(param1:XML, param2:XML) : void
      {
         var defense:int = 0;
         var otherDefense:int = 0;
         var itemXML:XML = param1;
         var curItemXML:XML = param2;
         this.defTags = itemXML.ActivateOnEquip.(@stat == DEFENSE_STAT);
         this.otherDefTags = curItemXML.ActivateOnEquip.(@stat == DEFENSE_STAT);
         if(this.defTags.length() == 1 && this.otherDefTags.length() == 1)
         {
            defense = int(this.defTags.@amount);
            otherDefense = int(this.otherDefTags.@amount);
         }
      }
      
      private function compareDefense(param1:int, param2:int) : String
      {
         var _loc3_:uint = getTextColor(param1 - param2);
         return wrapInColoredFont("+" + param1 + " Defense",_loc3_);
      }
   }
}

