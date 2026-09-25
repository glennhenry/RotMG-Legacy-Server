package kabam.rotmg.util
{
   public class GeometricSeries
   {
      
      private var a:Number;
      
      private var r:Number;
      
      public function GeometricSeries(param1:Number, param2:Number)
      {
         super();
         this.a = param1;
         this.r = param2;
      }
      
      public function getSummation(param1:int) : Number
      {
         return this.a * (1 - Math.pow(this.r,param1)) / (1 - this.r);
      }
      
      public function getTerm(param1:int) : Number
      {
         return this.a * Math.pow(this.r,param1);
      }
   }
}

