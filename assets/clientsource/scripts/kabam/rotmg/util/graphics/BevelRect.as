package kabam.rotmg.util.graphics
{
   public class BevelRect
   {
      
      public var topLeftBevel:Boolean = true;
      
      public var topRightBevel:Boolean = true;
      
      public var bottomLeftBevel:Boolean = true;
      
      public var bottomRightBevel:Boolean = true;
      
      public var width:int;
      
      public var height:int;
      
      public var bevel:int;
      
      public function BevelRect(param1:int, param2:int, param3:int)
      {
         super();
         this.width = param1;
         this.height = param2;
         this.bevel = param3;
      }
   }
}

