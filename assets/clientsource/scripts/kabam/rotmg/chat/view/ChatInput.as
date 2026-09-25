package kabam.rotmg.chat.view
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.ui.Keyboard;
   import kabam.rotmg.chat.model.ChatModel;
   import org.osflash.signals.Signal;
   
   public class ChatInput extends Sprite
   {
      
      public const message:Signal = new Signal(String);
      
      public const close:Signal = new Signal();
      
      private var input:TextField;
      
      private var enteredText:Boolean;
      
      public function ChatInput()
      {
         super();
         visible = false;
         this.enteredText = false;
      }
      
      public function setup(param1:ChatModel, param2:TextField) : void
      {
         addChild(this.input = param2);
         param2.width = param1.bounds.width - 2;
         param2.height = param1.lineHeight;
         param2.y = param1.bounds.height - param1.lineHeight;
      }
      
      public function activate(param1:String, param2:Boolean) : void
      {
         this.enteredText = false;
         if(param1 != null)
         {
            this.input.text = param1;
         }
         var _loc3_:int = param1 ? param1.length : 0;
         this.input.setSelection(_loc3_,_loc3_);
         if(param2)
         {
            this.activateEnabled();
         }
         else
         {
            this.activateDisabled();
         }
         visible = true;
      }
      
      public function deactivate() : void
      {
         this.enteredText = false;
         removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.onTextChange);
         visible = false;
         stage && null;
      }
      
      public function hasEnteredText() : Boolean
      {
         return this.enteredText;
      }
      
      private function activateEnabled() : void
      {
         this.input.type = TextFieldType.INPUT;
         this.input.border = true;
         this.input.selectable = true;
         this.input.maxChars = 128;
         this.input.borderColor = 16777215;
         this.input.height = 18;
         this.input.filters = [new GlowFilter(0,1,3,3,2,1)];
         addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onTextChange);
         stage && (stage.focus = this.input);
      }
      
      private function onTextChange(param1:Event) : void
      {
         this.enteredText = true;
      }
      
      private function activateDisabled() : void
      {
         this.input.type = TextFieldType.DYNAMIC;
         this.input.border = false;
         this.input.selectable = false;
         this.input.filters = [new GlowFilter(0,1,3,3,2,1)];
         this.input.height = 18;
         removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.onTextChange);
      }
      
      private function onKeyUp(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            if(this.input.text != "")
            {
               this.message.dispatch(this.input.text);
            }
            else
            {
               this.close.dispatch();
            }
            param1.stopImmediatePropagation();
         }
      }
   }
}

