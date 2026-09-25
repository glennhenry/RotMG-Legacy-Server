package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.ui.panels.Panel;
   import kabam.rotmg.questrewards.view.QuestRewardsPanel;
   
   public class QuestRewards extends GameObject implements IInteractiveObject
   {
      
      public function QuestRewards(param1:XML)
      {
         super(param1);
         isInteractive_ = true;
      }
      
      public function getPanel(param1:GameSprite) : Panel
      {
         return new QuestRewardsPanel(param1);
      }
   }
}

