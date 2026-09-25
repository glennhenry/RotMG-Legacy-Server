package kabam.rotmg.ui.commands
{
   import flash.display.DisplayObjectContainer;
   import kabam.rotmg.ui.view.KeysView;
   
   public class ShowHideKeyUICommand
   {
      
      private static var view:KeysView;
      
      private static var show:Boolean = true;
      
      [Inject]
      public var contextView:DisplayObjectContainer;
      
      public function ShowHideKeyUICommand()
      {
         super();
      }
      
      public function execute() : void
      {
         if(show)
         {
            view = new KeysView();
            view.x = 4;
            view.y = 4;
            this.contextView.addChild(view);
            show = false;
         }
         else
         {
            this.contextView.removeChild(view);
            view = null;
            show = true;
         }
      }
   }
}

