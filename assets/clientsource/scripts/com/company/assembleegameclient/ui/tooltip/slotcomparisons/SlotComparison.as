package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   import flash.utils.Dictionary;
   import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
   
   public class SlotComparison
   {
      
      internal static const BETTER_COLOR:uint = 65280;
      
      internal static const WORSE_COLOR:uint = 16711680;
      
      internal static const NO_DIFF_COLOR:uint = 16777103;
      
      internal static const LABEL_COLOR:uint = 11776947;
      
      internal static const UNTIERED_COLOR:uint = 9055202;
      
      public var processedTags:Dictionary;
      
      public var processedActivateOnEquipTags:AppendingLineBuilder;
      
      public var comparisonStringBuilder:AppendingLineBuilder;
      
      public function SlotComparison()
      {
         super();
      }
      
      public function compare(param1:XML, param2:XML) : void
      {
         this.resetFields();
         this.compareSlots(param1,param2);
      }
      
      protected function compareSlots(param1:XML, param2:XML) : void
      {
      }
      
      private function resetFields() : void
      {
         this.processedTags = new Dictionary();
         this.processedActivateOnEquipTags = new AppendingLineBuilder();
      }
      
      protected function getTextColor(param1:Number) : uint
      {
         if(param1 < 0)
         {
            return WORSE_COLOR;
         }
         if(param1 > 0)
         {
            return BETTER_COLOR;
         }
         return NO_DIFF_COLOR;
      }
      
      protected function wrapInColoredFont(param1:String, param2:uint = 16777103) : String
      {
         return "<font color=\"#" + param2.toString(16) + "\">" + param1 + "</font>";
      }
      
      protected function getMpCostText(param1:String) : String
      {
         return this.wrapInColoredFont("MP Cost: ",LABEL_COLOR) + this.wrapInColoredFont(param1,NO_DIFF_COLOR) + "\n";
      }
   }
}

