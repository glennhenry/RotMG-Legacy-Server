package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.ui.panels.Panel;
   import kabam.rotmg.game.view.NameChangerPanel;
   
   public class NameChanger extends GameObject implements IInteractiveObject
   {
      
      public var rankRequired_:int = 0;
      
      public function NameChanger(param1:XML)
      {
         super(param1);
         isInteractive_ = true;
      }
      
      public function setRankRequired(param1:int) : void
      {
         this.rankRequired_ = param1;
      }
      
      public function getPanel(param1:GameSprite) : Panel
      {
         return new NameChangerPanel(param1,this.rankRequired_);
      }
   }
}

