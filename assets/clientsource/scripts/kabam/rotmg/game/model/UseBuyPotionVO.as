package kabam.rotmg.game.model
{
   public class UseBuyPotionVO
   {
      
      public static var SHIFTCLICK:String = "shift_click";
      
      public static var CONTEXTBUY:String = "context_buy";
      
      public var objectId:int;
      
      public var source:String;
      
      public function UseBuyPotionVO(param1:int, param2:String)
      {
         super();
         this.objectId = param1;
         this.source = param2;
      }
   }
}

