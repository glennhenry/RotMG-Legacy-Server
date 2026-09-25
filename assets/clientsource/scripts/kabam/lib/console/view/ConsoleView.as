package kabam.lib.console.view
{
   import flash.display.Sprite;
   
   public final class ConsoleView extends Sprite
   {
      
      public var output:ConsoleOutputView;
      
      public var input:ConsoleInputView;
      
      public function ConsoleView()
      {
         super();
         addChild(this.output = new ConsoleOutputView());
         addChild(this.input = new ConsoleInputView());
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(param1 && Boolean(stage))
         {
            stage.focus = this.input;
         }
      }
   }
}

