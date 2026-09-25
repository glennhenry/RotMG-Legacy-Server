package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.ui.panels.Panel;
   import kabam.rotmg.arena.view.ArenaQueryPanel;
   
   public class ArenaGuard extends GameObject implements IInteractiveObject
   {
      
      public function ArenaGuard(param1:XML)
      {
         super(param1);
         isInteractive_ = true;
      }
      
      public function getPanel(param1:GameSprite) : Panel
      {
         return new ArenaQueryPanel(param1,objectType_);
      }
   }
}

