package kabam.rotmg.game.model
{
   public class StatModel
   {
      
      public var name:String;
      
      public var abbreviation:String;
      
      public var description:String;
      
      public var redOnZero:Boolean;
      
      public function StatModel(param1:String, param2:String, param3:String, param4:Boolean)
      {
         super();
         this.name = param1;
         this.abbreviation = param2;
         this.description = param3;
         this.redOnZero = param4;
      }
   }
}

