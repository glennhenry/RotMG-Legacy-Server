package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.ui.panels.Panel;
   import kabam.rotmg.game.view.MysteryBoxPanel;
   
   public class MysteryBoxGround extends GameObject implements IInteractiveObject
   {
      
      public function MysteryBoxGround(param1:XML)
      {
         super(param1);
         isInteractive_ = true;
      }
      
      public function getPanel(param1:GameSprite) : Panel
      {
         return new MysteryBoxPanel(param1,objectType_);
      }
   }
}

