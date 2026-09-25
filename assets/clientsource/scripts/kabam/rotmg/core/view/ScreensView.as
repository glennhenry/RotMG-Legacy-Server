package kabam.rotmg.core.view
{
   import flash.display.Sprite;
   
   public class ScreensView extends Sprite
   {
      
      private var current:Sprite;
      
      private var previous:Sprite;
      
      public function ScreensView()
      {
         super();
      }
      
      public function setScreen(param1:Sprite) : void
      {
         if(this.current == param1)
         {
            return;
         }
         this.removePrevious();
         this.current = param1;
         addChild(param1);
      }
      
      private function removePrevious() : void
      {
         if(Boolean(this.current) && contains(this.current))
         {
            this.previous = this.current;
            removeChild(this.current);
         }
      }
      
      public function getPrevious() : Sprite
      {
         return this.previous;
      }
   }
}

