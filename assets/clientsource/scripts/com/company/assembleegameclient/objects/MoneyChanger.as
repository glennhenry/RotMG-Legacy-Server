package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.ui.panels.Panel;
   import kabam.rotmg.game.view.MoneyChangerPanel;
   
   public class MoneyChanger extends GameObject implements IInteractiveObject
   {
      
      public function MoneyChanger(param1:XML)
      {
         super(param1);
         isInteractive_ = true;
      }
      
      public function getPanel(param1:GameSprite) : Panel
      {
         return new MoneyChangerPanel(param1);
      }
   }
}

