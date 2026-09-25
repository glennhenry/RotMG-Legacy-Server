package com.company.assembleegameclient.ui
{
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.tooltip.EquipmentToolTip;
   import flash.display.Sprite;
   
   public class EquipmentToolTipFactory
   {
      
      public function EquipmentToolTipFactory()
      {
         super();
      }
      
      public function make(param1:int, param2:Player, param3:int, param4:String, param5:uint) : Sprite
      {
         return new EquipmentToolTip(param1,param2,param3,param4);
      }
   }
}

