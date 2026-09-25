package kabam.rotmg.pets.view.dialogs.evolving
{
   import flash.display.DisplayObject;
   
   public class TweenProxy
   {
      
      protected var onComplete:Function;
      
      protected var target:DisplayObject;
      
      public function TweenProxy(param1:DisplayObject)
      {
         super();
         this.target = param1;
      }
      
      public function start() : void
      {
      }
      
      public function setOnComplete(param1:Function) : void
      {
         this.onComplete = param1;
      }
   }
}

