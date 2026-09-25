package kabam.rotmg.pets.view.dialogs.evolving.configuration
{
   import com.gskinner.motion.GTween;
   import flash.display.DisplayObject;
   import kabam.rotmg.pets.view.dialogs.evolving.TweenProxy;
   
   public class AfterOpaqueTween extends TweenProxy
   {
      
      public function AfterOpaqueTween(param1:DisplayObject)
      {
         super(param1);
      }
      
      override public function start() : void
      {
         var _loc1_:GTween = new GTween(target,1,{"alpha":1});
         _loc1_.onComplete = this.pauseComplete;
      }
      
      private function pauseComplete(param1:GTween) : void
      {
         new GTween(target,1,{"alpha":0});
      }
   }
}

