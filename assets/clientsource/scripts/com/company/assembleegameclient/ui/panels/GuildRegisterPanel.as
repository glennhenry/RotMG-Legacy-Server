package com.company.assembleegameclient.ui.panels
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.DeprecatedTextButton;
   import com.company.assembleegameclient.util.Currency;
   import com.company.assembleegameclient.util.GuildUtil;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.ui.view.SignalWaiter;
   import kabam.rotmg.util.components.LegacyBuyButton;
   import org.osflash.signals.Signal;
   
   public class GuildRegisterPanel extends Panel
   {
      
      private var title_:TextFieldDisplayConcrete;
      
      private var button_:Sprite;
      
      public const openCreateGuildFrame:Signal;
      
      public const waiter:SignalWaiter;
      
      public const renounce:Signal;
      
      public function GuildRegisterPanel(param1:GameSprite)
      {
         var _loc2_:Player = null;
         var _loc3_:String = null;
         var _loc4_:LegacyBuyButton = null;
         this.openCreateGuildFrame = new Signal();
         this.waiter = new SignalWaiter();
         this.renounce = new Signal();
         super(param1);
         if(gs_.map == null || gs_.map.player_ == null)
         {
            return;
         }
         _loc2_ = gs_.map.player_;
         this.title_ = new TextFieldDisplayConcrete().setSize(18).setColor(16777215).setTextWidth(WIDTH).setWordWrap(true).setMultiLine(true).setAutoSize(TextFieldAutoSize.CENTER).setHTML(true);
         this.title_.filters = [new DropShadowFilter(0,0,0)];
         if(_loc2_.guildName_ != null && _loc2_.guildName_.length > 0)
         {
            _loc3_ = GuildUtil.rankToString(_loc2_.guildRank_);
            this.title_.setStringBuilder(new LineBuilder().setParams(TextKey.GUILD_REGISTER_PANEL_RANK,{
               "rank":_loc3_,
               "guildName":_loc2_.guildName_
            }).setPrefix("<p align=\"center\">").setPostfix("</p>"));
            this.title_.y = 0;
            addChild(this.title_);
            this.button_ = new DeprecatedTextButton(16,TextKey.GUILD_REGISTER_PANEL_RENOUNCE);
            this.button_.addEventListener(MouseEvent.CLICK,this.onRenounceClick);
            this.waiter.push(DeprecatedTextButton(this.button_).textChanged);
            addChild(this.button_);
         }
         else
         {
            this.title_.setStringBuilder(new LineBuilder().setParams(TextKey.GUILD_REGISTER_PANEL_CREATE).setPrefix("<p align=\"center\">").setPostfix("</p>"));
            this.title_.y = 0;
            addChild(this.title_);
            _loc4_ = new LegacyBuyButton(TextKey.GUILD_REGISTER_PANEL_BUY,16,Parameters.GUILD_CREATION_PRICE,Currency.FAME);
            _loc4_.addEventListener(MouseEvent.CLICK,this.onCreateClick);
            this.waiter.push(_loc4_.readyForPlacement);
            addChild(_loc4_);
            this.button_ = _loc4_;
         }
         this.waiter.complete.addOnce(this.alignUI);
      }
      
      private function onRenounceClick(param1:MouseEvent) : void
      {
         this.renounce.dispatch();
      }
      
      private function alignUI() : void
      {
         this.button_.x = WIDTH / 2 - this.button_.width / 2;
         this.button_.y = this.button_ is LegacyBuyButton ? HEIGHT - this.button_.height / 2 - 31 : HEIGHT - this.button_.height - 4;
      }
      
      public function onCreateClick(param1:MouseEvent) : void
      {
         visible = false;
         this.openCreateGuildFrame.dispatch();
      }
   }
}

