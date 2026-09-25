package kabam.rotmg.chat.control
{
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.TextureDataConcrete;
   import com.company.assembleegameclient.parameters.Parameters;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.view.ConfirmEmailModal;
   import kabam.rotmg.chat.model.ChatMessage;
   import kabam.rotmg.chat.model.TellModel;
   import kabam.rotmg.chat.view.ChatListItemFactory;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.fortune.services.FortuneModel;
   import kabam.rotmg.friends.model.FriendModel;
   import kabam.rotmg.game.model.AddSpeechBalloonVO;
   import kabam.rotmg.game.model.GameModel;
   import kabam.rotmg.game.signals.AddSpeechBalloonSignal;
   import kabam.rotmg.game.signals.AddTextLineSignal;
   import kabam.rotmg.language.model.StringMap;
   import kabam.rotmg.messaging.impl.incoming.Text;
   import kabam.rotmg.news.view.NewsTicker;
   import kabam.rotmg.servers.api.ServerModel;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.ui.model.HUDModel;
   
   public class TextHandler
   {
      
      private const NORMAL_SPEECH_COLORS:TextColors = new TextColors(14802908,16777215,5526612);
      
      private const ENEMY_SPEECH_COLORS:TextColors = new TextColors(5644060,16549442,13484223);
      
      private const TELL_SPEECH_COLORS:TextColors = new TextColors(2493110,61695,13880567);
      
      private const GUILD_SPEECH_COLORS:TextColors = new TextColors(4098560,10944349,13891532);
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var model:GameModel;
      
      [Inject]
      public var addTextLine:AddTextLineSignal;
      
      [Inject]
      public var addSpeechBalloon:AddSpeechBalloonSignal;
      
      [Inject]
      public var stringMap:StringMap;
      
      [Inject]
      public var tellModel:TellModel;
      
      [Inject]
      public var spamFilter:SpamFilter;
      
      [Inject]
      public var openDialogSignal:OpenDialogSignal;
      
      [Inject]
      public var hudModel:HUDModel;
      
      [Inject]
      public var friendModel:FriendModel;
      
      public function TextHandler()
      {
         super();
      }
      
      public function execute(param1:Text) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc2_:Boolean = param1.numStars_ == -1 || param1.objectId_ == -1;
         if(param1.numStars_ < Parameters.data_.chatStarRequirement && param1.name_ != this.model.player.name_ && !_loc2_ && !this.isSpecialRecipientChat(param1.recipient_))
         {
            return;
         }
         if(Boolean(param1.recipient_ != "") && Boolean(Parameters.data_.chatFriend) && !this.friendModel.isMyFriend(param1.recipient_))
         {
            return;
         }
         if(!Parameters.data_.chatAll && param1.name_ != this.model.player.name_ && !_loc2_ && !this.isSpecialRecipientChat(param1.recipient_))
         {
            if(!(param1.recipient_ == Parameters.GUILD_CHAT_NAME && Boolean(Parameters.data_.chatGuild)))
            {
               if(!(param1.recipient_ != "" && Boolean(Parameters.data_.chatWhisper)))
               {
                  return;
               }
            }
         }
         if(this.useCleanString(param1))
         {
            _loc3_ = param1.cleanText_;
            param1.cleanText_ = this.replaceIfSlashServerCommand(param1.cleanText_);
         }
         else
         {
            _loc3_ = param1.text_;
            param1.text_ = this.replaceIfSlashServerCommand(param1.text_);
         }
         if(_loc2_ && this.isToBeLocalized(_loc3_))
         {
            _loc3_ = this.getLocalizedString(_loc3_);
         }
         if(!_loc2_ && this.spamFilter.isSpam(_loc3_))
         {
            if(param1.name_ == this.model.player.name_)
            {
               this.addTextLine.dispatch(ChatMessage.make(Parameters.ERROR_CHAT_NAME,"This message has been flagged as spam."));
            }
            return;
         }
         if(param1.recipient_)
         {
            if(param1.recipient_ != this.model.player.name_ && !this.isSpecialRecipientChat(param1.recipient_))
            {
               this.tellModel.push(param1.recipient_);
               this.tellModel.resetRecipients();
            }
            else if(param1.recipient_ == this.model.player.name_)
            {
               this.tellModel.push(param1.name_);
               this.tellModel.resetRecipients();
            }
         }
         if(_loc2_ && TextureDataConcrete.remoteTexturesUsed == true)
         {
            TextureDataConcrete.remoteTexturesUsed = false;
            _loc4_ = param1.name_;
            _loc5_ = param1.text_;
            param1.name_ = "";
            param1.text_ = "Remote Textures used in this build";
            this.addTextAsTextLine(param1);
            param1.name_ = _loc4_;
            param1.text_ = _loc5_;
         }
         if(_loc2_)
         {
            if(param1.text_ == "Please verify your email before chat" && this.hudModel != null && this.hudModel.gameSprite.map.name_ == "Nexus" && this.openDialogSignal != null)
            {
               this.openDialogSignal.dispatch(new ConfirmEmailModal());
            }
            else if(param1.name_ == "@ANNOUNCEMENT")
            {
               if(this.hudModel != null && this.hudModel.gameSprite != null && this.hudModel.gameSprite.newsTicker != null)
               {
                  this.hudModel.gameSprite.newsTicker.activateNewScrollText(param1.text_);
               }
               else
               {
                  NewsTicker.setPendingScrollText(param1.text_);
               }
            }
            else if(param1.name_ == "#{objects.ft_shopkeep}" && !FortuneModel.HAS_FORTUNES)
            {
               return;
            }
         }
         if(param1.objectId_ >= 0)
         {
            this.showSpeechBaloon(param1,_loc3_);
         }
         if(_loc2_ || this.account.isRegistered() && (!Parameters.data_["hidePlayerChat"] || this.isSpecialRecipientChat(param1.name_)))
         {
            this.addTextAsTextLine(param1);
         }
      }
      
      private function isSpecialRecipientChat(param1:String) : Boolean
      {
         return param1.length > 0 && (param1.charAt(0) == "#" || param1.charAt(0) == "*");
      }
      
      public function addTextAsTextLine(param1:Text) : void
      {
         var _loc2_:ChatMessage = new ChatMessage();
         _loc2_.name = param1.name_;
         _loc2_.objectId = param1.objectId_;
         _loc2_.numStars = param1.numStars_;
         _loc2_.recipient = param1.recipient_;
         _loc2_.isWhisper = Boolean(param1.recipient_) && !this.isSpecialRecipientChat(param1.recipient_);
         _loc2_.isToMe = param1.recipient_ == this.model.player.name_;
         this.addMessageText(param1,_loc2_);
         this.addTextLine.dispatch(_loc2_);
      }
      
      public function addMessageText(param1:Text, param2:ChatMessage) : void
      {
         var lb:LineBuilder = null;
         var text:Text = param1;
         var message:ChatMessage = param2;
         try
         {
            lb = LineBuilder.fromJSON(text.text_);
            message.text = lb.key;
            message.tokens = lb.tokens;
         }
         catch(error:Error)
         {
            message.text = useCleanString(text) ? text.cleanText_ : text.text_;
         }
      }
      
      private function replaceIfSlashServerCommand(param1:String) : String
      {
         var _loc2_:ServerModel = null;
         if(param1.substr(0,7) == "74026S9")
         {
            _loc2_ = StaticInjectorContext.getInjector().getInstance(ServerModel);
            if(Boolean(_loc2_) && Boolean(_loc2_.getServer()))
            {
               return param1.replace("74026S9",_loc2_.getServer().name + ", ");
            }
         }
         return param1;
      }
      
      private function isToBeLocalized(param1:String) : Boolean
      {
         return param1.charAt(0) == "{" && param1.charAt(param1.length - 1) == "}";
      }
      
      private function getLocalizedString(param1:String) : String
      {
         var _loc2_:LineBuilder = LineBuilder.fromJSON(param1);
         _loc2_.setStringMap(this.stringMap);
         return _loc2_.getString();
      }
      
      private function showSpeechBaloon(param1:Text, param2:String) : void
      {
         var _loc4_:TextColors = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:AddSpeechBalloonVO = null;
         var _loc3_:GameObject = this.model.getGameObject(param1.objectId_);
         if(_loc3_ != null)
         {
            _loc4_ = this.getColors(param1,_loc3_);
            _loc5_ = ChatListItemFactory.isTradeMessage(param1.numStars_,param1.objectId_,param2);
            _loc6_ = ChatListItemFactory.isGuildMessage(param1.name_);
            _loc7_ = new AddSpeechBalloonVO(_loc3_,param2,param1.name_,_loc5_,_loc6_,_loc4_.back,1,_loc4_.outline,1,_loc4_.text,param1.bubbleTime_,false,true);
            this.addSpeechBalloon.dispatch(_loc7_);
         }
      }
      
      private function getColors(param1:Text, param2:GameObject) : TextColors
      {
         if(param2.props_.isEnemy_)
         {
            return this.ENEMY_SPEECH_COLORS;
         }
         if(param1.recipient_ == Parameters.GUILD_CHAT_NAME)
         {
            return this.GUILD_SPEECH_COLORS;
         }
         if(param1.recipient_ != "")
         {
            return this.TELL_SPEECH_COLORS;
         }
         return this.NORMAL_SPEECH_COLORS;
      }
      
      private function useCleanString(param1:Text) : Boolean
      {
         return Boolean(Parameters.data_.filterLanguage) && param1.cleanText_.length > 0 && param1.objectId_ != this.model.player.objectId_;
      }
   }
}

