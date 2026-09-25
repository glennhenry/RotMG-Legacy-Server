package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.ui.panels.Panel;
   import kabam.rotmg.characters.reskin.view.ReskinPanel;
   
   public class ReskinVendor extends GameObject implements IInteractiveObject
   {
      
      public function ReskinVendor(param1:XML)
      {
         super(param1);
         isInteractive_ = true;
      }
      
      public function getPanel(param1:GameSprite) : Panel
      {
         return new ReskinPanel(param1);
      }
   }
}

