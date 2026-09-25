package com.company.assembleegameclient.account.ui
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.game.events.GuildResultEvent;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.parameters.Parameters;
   import flash.events.MouseEvent;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.game.model.GameModel;
   import kabam.rotmg.text.model.TextKey;
   import org.osflash.signals.Signal;
   
   public class CreateGuildFrame extends Frame
   {
      
      public const close:Signal = new Signal();
      
      private var name_:TextInputField;
      
      private var gs_:GameSprite;
      
      public function CreateGuildFrame(param1:GameSprite)
      {
         super(TextKey.GUILD_TITLE,TextKey.FRAME_CANCEL,TextKey.GUILD_CREATE,"/createGuild");
         this.gs_ = param1;
         this.name_ = new TextInputField(TextKey.GUILD_NAME,false);
         this.name_.inputText_.restrict = "A-Za-z ";
         this.name_.inputText_.maxChars = 20;
         addTextInputField(this.name_);
         addPlainText(TextKey.FRAME_MAX_CHAR,{"maxChars":20});
         addPlainText(TextKey.FRAME_RESTRICT_CHAR);
         addPlainText(TextKey.GUILD_WARNING);
         leftButton_.addEventListener(MouseEvent.CLICK,this.onCancel);
         rightButton_.addEventListener(MouseEvent.CLICK,this.onCreate);
      }
      
      private function onCancel(param1:MouseEvent) : void
      {
         this.close.dispatch();
      }
      
      private function onCreate(param1:MouseEvent) : void
      {
         this.gs_.addEventListener(GuildResultEvent.EVENT,this.onResult);
         this.gs_.gsc_.createGuild(this.name_.text());
         disable();
      }
      
      private function onResult(param1:GuildResultEvent) : void
      {
         var _loc2_:Player = null;
         this.gs_.removeEventListener(GuildResultEvent.EVENT,this.onResult);
         if(param1.success_)
         {
            _loc2_ = StaticInjectorContext.getInjector().getInstance(GameModel).player;
            if(_loc2_ != null)
            {
               _loc2_.fame_ -= Parameters.GUILD_CREATION_PRICE;
            }
            this.close.dispatch();
         }
         else
         {
            this.name_.setError(param1.errorKey,param1.errorTokens);
            enable();
         }
      }
   }
}

