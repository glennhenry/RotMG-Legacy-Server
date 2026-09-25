package com.company.assembleegameclient.ui.panels
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.board.GuildBoardWindow;
   import com.company.assembleegameclient.util.GuildUtil;
   import flash.events.MouseEvent;
   import kabam.rotmg.text.model.TextKey;
   
   public class GuildBoardPanel extends ButtonPanel
   {
      
      public function GuildBoardPanel(param1:GameSprite)
      {
         super(param1,TextKey.GUILD_BOARD_TITLE,TextKey.PANEL_VIEW_BUTTON);
      }
      
      override protected function onButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:Player = gs_.map.player_;
         if(_loc2_ == null)
         {
            return;
         }
         gs_.addChild(new GuildBoardWindow(_loc2_.guildRank_ >= GuildUtil.OFFICER));
      }
   }
}

