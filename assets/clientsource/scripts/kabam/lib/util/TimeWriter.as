package kabam.lib.util
{
   public class TimeWriter
   {
      
      private var timeStringStarted:Boolean = false;
      
      private var seconds:int;
      
      private var minutes:int;
      
      private var hours:int;
      
      private var days:int;
      
      private var textValues:Array;
      
      public function TimeWriter()
      {
         super();
      }
      
      public function parseTime(param1:Number) : String
      {
         this.seconds = Math.floor(param1 / 1000);
         this.minutes = Math.floor(this.seconds / 60);
         this.hours = Math.floor(this.minutes / 60);
         this.days = Math.floor(this.hours / 24);
         this.seconds %= 60;
         this.minutes %= 60;
         this.hours %= 24;
         this.timeStringStarted = false;
         this.textValues = [];
         this.formatUnit(this.days,"d");
         this.formatUnit(this.hours,"h");
         this.formatUnit(this.minutes,"m",2);
         this.formatUnit(this.seconds,"s",2);
         this.timeStringStarted = false;
         return this.textValues.join(" ");
      }
      
      private function formatUnit(param1:int, param2:String, param3:int = -1) : void
      {
         if(param1 == 0 && !this.timeStringStarted)
         {
            return;
         }
         this.timeStringStarted = true;
         var _loc4_:String = param1.toString();
         if(param3 == -1)
         {
            param3 = _loc4_.length;
         }
         var _loc5_:String = "";
         var _loc6_:int = _loc4_.length;
         while(_loc6_ < param3)
         {
            _loc5_ += "0";
            _loc6_++;
         }
         _loc4_ = _loc5_ + _loc4_ + param2;
         this.textValues.push(_loc4_);
      }
   }
}

