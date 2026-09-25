package kabam.rotmg.pets.view.dialogs.evolving.configuration
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class EvolveTransitionConfiguration
   {
      
      public function EvolveTransitionConfiguration()
      {
         super();
      }
      
      public static function makeBackground() : DisplayObject
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215);
         _loc1_.graphics.drawRect(0,0,262,183);
         _loc1_.graphics.endFill();
         return _loc1_;
      }
   }
}

