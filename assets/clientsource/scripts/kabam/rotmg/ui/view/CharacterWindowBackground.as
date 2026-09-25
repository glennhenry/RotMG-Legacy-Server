package kabam.rotmg.ui.view
{
   import flash.display.Sprite;
   
   public class CharacterWindowBackground extends Sprite
   {
      
      public function CharacterWindowBackground()
      {
         super();
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(3552822);
         _loc1_.graphics.drawRect(0,0,200,600);
         addChild(_loc1_);
      }
   }
}

