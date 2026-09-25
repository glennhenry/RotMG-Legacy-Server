package com.company.assembleegameclient.account.ui.components
{
   public class SelectionGroup
   {
      
      private var selectables:Vector.<Selectable>;
      
      private var selected:Selectable;
      
      public function SelectionGroup(param1:Vector.<Selectable>)
      {
         super();
         this.selectables = param1;
      }
      
      public function setSelected(param1:String) : void
      {
         var _loc2_:Selectable = null;
         for each(_loc2_ in this.selectables)
         {
            if(_loc2_.getValue() == param1)
            {
               this.replaceSelected(_loc2_);
               return;
            }
         }
      }
      
      public function getSelected() : Selectable
      {
         return this.selected;
      }
      
      private function replaceSelected(param1:Selectable) : void
      {
         if(this.selected != null)
         {
            this.selected.setSelected(false);
         }
         this.selected = param1;
         this.selected.setSelected(true);
      }
   }
}

