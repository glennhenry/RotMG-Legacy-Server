package kabam.rotmg.chat.control
{
   import com.company.assembleegameclient.parameters.Parameters;
   import kabam.rotmg.chat.model.ChatMessage;
   import kabam.rotmg.chat.model.ChatModel;
   import kabam.rotmg.text.model.TextAndMapProvider;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import robotlegs.bender.bundles.mvcs.Command;
   
   public class ParseAddTextLineCommand extends Command
   {
      
      [Inject]
      public var chatMessage:ChatMessage;
      
      [Inject]
      public var textStringMap:TextAndMapProvider;
      
      [Inject]
      public var addChat:AddChatSignal;
      
      [Inject]
      public var model:ChatModel;
      
      public function ParseAddTextLineCommand()
      {
         super();
      }
      
      override public function execute() : void
      {
         this.translateMessage();
         this.translateName();
         this.model.pushMessage(this.chatMessage);
         this.addChat.dispatch(this.chatMessage);
      }
      
      private function translateName() : void
      {
         var _loc1_:LineBuilder = null;
         var _loc2_:String = null;
         if(this.chatMessage.name.length > 0 && this.chatMessage.name.charAt(0) == "#")
         {
            _loc1_ = new LineBuilder().setParams(this.chatMessage.name.substr(1,this.chatMessage.name.length - 1),this.chatMessage.tokens);
            _loc1_.setStringMap(this.textStringMap.getStringMap());
            _loc2_ = _loc1_.getString();
            this.chatMessage.name = _loc2_ ? "#" + _loc2_ : this.chatMessage.name;
         }
      }
      
      private function translateMessage() : void
      {
         if(this.chatMessage.name == Parameters.CLIENT_CHAT_NAME || this.chatMessage.name == Parameters.SERVER_CHAT_NAME || this.chatMessage.name == Parameters.ERROR_CHAT_NAME || this.chatMessage.name == Parameters.HELP_CHAT_NAME || this.chatMessage.name.charAt(0) == "#")
         {
            this.translateChatMessage();
         }
      }
      
      public function translateChatMessage() : void
      {
         var _loc1_:LineBuilder = new LineBuilder().setParams(this.chatMessage.text,this.chatMessage.tokens);
         _loc1_.setStringMap(this.textStringMap.getStringMap());
         var _loc2_:String = _loc1_.getString();
         this.chatMessage.text = _loc2_ ? _loc2_ : this.chatMessage.text;
      }
   }
}

