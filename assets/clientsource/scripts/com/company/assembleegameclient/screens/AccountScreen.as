package com.company.assembleegameclient.screens
{
   import com.company.assembleegameclient.ui.GuildText;
   import com.company.assembleegameclient.ui.RankText;
   import com.company.assembleegameclient.ui.tooltip.RankToolTip;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import kabam.rotmg.account.core.view.AccountInfoView;
   import org.osflash.signals.Signal;
   
   public class AccountScreen extends Sprite
   {
      
      public var tooltip:Signal;
      
      private var rankLayer:Sprite;
      
      private var guildLayer:Sprite;
      
      private var accountInfoLayer:Sprite;
      
      private var guildName:String;
      
      private var guildRank:int;
      
      private var stars:int;
      
      private var rankText:RankText;
      
      private var guildText:GuildText;
      
      private var accountInfo:AccountInfoView;
      
      public function AccountScreen()
      {
         super();
         this.tooltip = new Signal();
         this.makeLayers();
      }
      
      private function makeLayers() : void
      {
         addChild(this.rankLayer = new Sprite());
         addChild(this.guildLayer = new Sprite());
         addChild(this.accountInfoLayer = new Sprite());
      }
      
      private function returnHeaderBackground() : DisplayObject
      {
         var _loc1_:Shape = new Shape();
         _loc1_.graphics.beginFill(0,0.5);
         _loc1_.graphics.drawRect(0,0,800,35);
         return _loc1_;
      }
      
      public function setGuild(param1:String, param2:int) : void
      {
         this.guildName = param1;
         this.guildRank = param2;
         this.makeGuildText();
      }
      
      private function makeGuildText() : void
      {
         this.guildText = new GuildText(this.guildName,this.guildRank);
         this.guildText.x = 92;
         this.guildText.y = 6;
         while(this.guildLayer.numChildren > 0)
         {
            this.guildLayer.removeChildAt(0);
         }
         this.guildLayer.addChild(this.guildText);
      }
      
      public function setRank(param1:int) : void
      {
         this.stars = param1;
         this.makeRankText();
      }
      
      private function makeRankText() : void
      {
         this.rankText = new RankText(this.stars,true,false);
         this.rankText.x = 36;
         this.rankText.y = 4;
         this.rankText.mouseEnabled = true;
         this.rankText.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.rankText.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         while(this.rankLayer.numChildren > 0)
         {
            this.rankLayer.removeChildAt(0);
         }
         this.rankLayer.addChild(this.rankText);
      }
      
      public function setAccountInfo(param1:AccountInfoView) : void
      {
         var _loc2_:DisplayObject = null;
         this.accountInfo = param1;
         _loc2_ = param1 as DisplayObject;
         _loc2_.x = stage.stageWidth - 10;
         _loc2_.y = 2;
         while(this.accountInfoLayer.numChildren > 0)
         {
            this.accountInfoLayer.removeChildAt(0);
         }
         this.accountInfoLayer.addChild(_loc2_);
      }
      
      protected function onMouseOver(param1:MouseEvent) : void
      {
         this.tooltip.dispatch(new RankToolTip(this.stars));
      }
      
      protected function onRollOut(param1:MouseEvent) : void
      {
         this.tooltip.dispatch(null);
      }
   }
}

