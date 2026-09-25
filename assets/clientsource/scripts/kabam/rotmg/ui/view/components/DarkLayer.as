package kabam.rotmg.ui.view.components
{
   import flash.display.Shape;
   
   public class DarkLayer extends Shape
   {
      
      public function DarkLayer()
      {
         super();
         graphics.beginFill(2829099,0.8);
         graphics.drawRect(0,0,800,600);
         graphics.endFill();
      }
   }
}

