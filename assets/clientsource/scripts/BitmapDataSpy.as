package
{
   import flash.display.BitmapData;
   
   public class BitmapDataSpy extends BitmapData
   {
      
      public function BitmapDataSpy(param1:int, param2:int, param3:Boolean = true, param4:uint = 0)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function clone() : BitmapData
      {
         return super.clone();
      }
   }
}

