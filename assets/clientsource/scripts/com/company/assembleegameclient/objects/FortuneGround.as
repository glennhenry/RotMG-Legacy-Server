package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.ui.panels.Panel;
   import kabam.rotmg.game.view.FortuneGroundPanel;
   
   public class FortuneGround extends GameObject implements IInteractiveObject
   {
      
      public function FortuneGround(param1:XML)
      {
         super(param1);
         isInteractive_ = true;
      }
      
      public function getPanel(param1:GameSprite) : Panel
      {
         return new FortuneGroundPanel(param1,objectType_);
      }
   }
}

