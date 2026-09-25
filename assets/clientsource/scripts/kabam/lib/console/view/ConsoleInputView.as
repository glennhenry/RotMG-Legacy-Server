package kabam.lib.console.view
{
   import flash.events.KeyboardEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import kabam.lib.resizing.view.Resizable;
   import kabam.lib.util.StageLifecycleUtil;
   
   public final class ConsoleInputView extends TextField implements Resizable
   {
      
      public static const HEIGHT:int = 20;
      
      private var lifecycle:StageLifecycleUtil;
      
      public function ConsoleInputView()
      {
         super();
         background = true;
         backgroundColor = 13056;
         border = true;
         borderColor = 3355443;
         defaultTextFormat = new TextFormat("_sans",14,16777215,true);
         text = "";
         type = TextFieldType.INPUT;
         restrict = "^`";
         this.lifecycle = new StageLifecycleUtil(this);
         this.lifecycle.addedToStage.add(this.onAddedToStage);
         this.lifecycle.removedFromStage.add(this.onRemovedFromStage);
      }
      
      private function onAddedToStage() : void
      {
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      private function onRemovedFromStage() : void
      {
         removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:String = text;
         switch(param1.keyCode)
         {
            case Keyboard.ENTER:
               text = "";
               dispatchEvent(new ConsoleEvent(ConsoleEvent.INPUT,_loc2_));
               break;
            case Keyboard.UP:
               dispatchEvent(new ConsoleEvent(ConsoleEvent.GET_PREVIOUS));
               break;
            case Keyboard.DOWN:
               dispatchEvent(new ConsoleEvent(ConsoleEvent.GET_NEXT));
         }
      }
      
      public function resize(param1:Rectangle) : void
      {
         var _loc2_:int = param1.height * 0.5;
         if(_loc2_ > HEIGHT)
         {
            _loc2_ = HEIGHT;
         }
         width = param1.width;
         height = _loc2_;
         x = param1.x;
         y = param1.bottom - height;
      }
   }
}

