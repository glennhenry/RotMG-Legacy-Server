package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.ui.panels.GuildHallPortalPanel;
   import com.company.assembleegameclient.ui.panels.Panel;
   
   public class GuildHallPortal extends GameObject implements IInteractiveObject
   {
      
      public function GuildHallPortal(param1:XML)
      {
         super(param1);
         isInteractive_ = true;
      }
      
      public function getPanel(param1:GameSprite) : Panel
      {
         return new GuildHallPortalPanel(param1,this);
      }
   }
}

