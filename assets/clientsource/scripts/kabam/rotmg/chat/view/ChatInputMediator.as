package kabam.rotmg.chat.view
{
   import flash.display.Stage;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import kabam.rotmg.chat.control.ParseChatMessageSignal;
   import kabam.rotmg.chat.control.ShowChatInputSignal;
   import kabam.rotmg.chat.model.ChatModel;
   import kabam.rotmg.chat.model.ChatShortcutModel;
   import kabam.rotmg.chat.model.TellModel;
   import kabam.rotmg.text.model.FontModel;
   import kabam.rotmg.text.model.TextAndMapProvider;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class ChatInputMediator extends Mediator
   {
      
      [Inject]
      public var view:ChatInput;
      
      [Inject]
      public var model:ChatModel;
      
      [Inject]
      public var textAndMapProvider:TextAndMapProvider;
      
      [Inject]
      public var fontModel:FontModel;
      
      [Inject]
      public var parseChatMessage:ParseChatMessageSignal;
      
      [Inject]
      public var showChatInput:ShowChatInputSignal;
      
      [Inject]
      public var tellModel:TellModel;
      
      [Inject]
      public var chatShortcutModel:ChatShortcutModel;
      
      public var stage:Stage;
      
      public function ChatInputMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.stage = this.view.stage;
         this.stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         this.view.setup(this.model,this.makeTextfield());
         this.view.message.add(this.onMessage);
         this.view.close.add(this.onDeactivate);
         this.showChatInput.add(this.onShowChatInput);
      }
      
      override public function destroy() : void
      {
         this.view.message.remove(this.onMessage);
         this.view.close.remove(this.onDeactivate);
         this.showChatInput.remove(this.onShowChatInput);
         this.stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
      }
      
      private function onDeactivate() : void
      {
         this.showChatInput.dispatch(false,"");
         this.tellModel.resetRecipients();
      }
      
      private function onMessage(param1:String) : void
      {
         this.parseChatMessage.dispatch(param1);
         this.showChatInput.dispatch(false,"");
      }
      
      private function onShowChatInput(param1:Boolean, param2:String) : void
      {
         if(param1)
         {
            this.view.activate(param2,true);
         }
         else
         {
            this.view.deactivate();
         }
         if(!param1)
         {
            this.tellModel.resetRecipients();
         }
      }
      
      private function makeTextfield() : TextField
      {
         var _loc1_:TextField = this.textAndMapProvider.getTextField();
         this.fontModel.apply(_loc1_,14,16777215,true);
         return _loc1_;
      }
      
      private function onKeyUp(param1:KeyboardEvent) : void
      {
         if(this.view.visible && (param1.keyCode == this.chatShortcutModel.getTellShortcut() || (this.stage.focus == null || this.viewDoesntHaveFocus())))
         {
            this.processKeyUp(param1);
         }
      }
      
      private function viewDoesntHaveFocus() : Boolean
      {
         return this.stage.focus.parent != this.view && this.stage.focus != this.view;
      }
      
      private function processKeyUp(param1:KeyboardEvent) : void
      {
         param1.stopImmediatePropagation();
         var _loc2_:uint = param1.keyCode;
         if(_loc2_ == this.chatShortcutModel.getCommandShortcut())
         {
            this.view.activate("/",true);
         }
         else if(_loc2_ == this.chatShortcutModel.getChatShortcut())
         {
            this.view.activate(null,true);
         }
         else if(_loc2_ == this.chatShortcutModel.getGuildShortcut())
         {
            this.view.activate("/g ",true);
         }
         else if(_loc2_ == this.chatShortcutModel.getTellShortcut())
         {
            this.handleTell();
         }
      }
      
      private function handleTell() : void
      {
         if(!this.view.hasEnteredText())
         {
            this.view.activate("/tell " + this.tellModel.getNext() + " ",true);
         }
      }
   }
}

