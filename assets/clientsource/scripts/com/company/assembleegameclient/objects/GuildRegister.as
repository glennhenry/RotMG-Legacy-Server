package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.ui.panels.GuildRegisterPanel;
   import com.company.assembleegameclient.ui.panels.Panel;
   
   public class GuildRegister extends GameObject implements IInteractiveObject
   {
      
      public function GuildRegister(param1:XML)
      {
         super(param1);
         isInteractive_ = true;
      }
      
      public function getPanel(param1:GameSprite) : Panel
      {
         return new GuildRegisterPanel(param1);
      }
   }
}

