package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.ui.panels.GuildBoardPanel;
   import com.company.assembleegameclient.ui.panels.Panel;
   
   public class GuildBoard extends GameObject implements IInteractiveObject
   {
      
      public function GuildBoard(param1:XML)
      {
         super(param1);
         isInteractive_ = true;
      }
      
      public function getPanel(param1:GameSprite) : Panel
      {
         return new GuildBoardPanel(param1);
      }
   }
}

