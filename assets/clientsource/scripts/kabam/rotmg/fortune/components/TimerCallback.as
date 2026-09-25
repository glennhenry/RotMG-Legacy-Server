package kabam.rotmg.fortune.components
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class TimerCallback
   {
      
      private var f:Function;
      
      private var data1:*;
      
      private var data2:*;
      
      private var data3:*;
      
      private var data4:*;
      
      private var data5:*;
      
      private var data6:*;
      
      private var data7:*;
      
      private var data8:*;
      
      private var tbo:Timer;
      
      public function TimerCallback(param1:Number, param2:Function, param3:* = null, param4:* = null, param5:* = null, param6:* = null, param7:* = null, param8:* = null, param9:* = null, param10:* = null)
      {
         super();
         this.f = param2;
         if(param3 != null)
         {
            this.data1 = param3;
         }
         if(param4 != null)
         {
            this.data2 = param4;
         }
         if(param5 != null)
         {
            this.data3 = param5;
         }
         if(param6 != null)
         {
            this.data4 = param6;
         }
         if(param7 != null)
         {
            this.data5 = param7;
         }
         if(param8 != null)
         {
            this.data6 = param8;
         }
         if(param9 != null)
         {
            this.data7 = param9;
         }
         if(param10 != null)
         {
            this.data8 = param10;
         }
         this.tbo = new Timer(param1 * 1000,1);
         this.tbo.addEventListener(TimerEvent.TIMER_COMPLETE,this.callbackWrapper);
         this.tbo.start();
      }
      
      public function callbackWrapper(param1:TimerEvent) : void
      {
         this.tbo.removeEventListener(TimerEvent.TIMER_COMPLETE,this.callbackWrapper);
         if(this.data8 != null)
         {
            this.f(this.data1,this.data2,this.data3,this.data4,this.data5,this.data6,this.data7,this.data8);
         }
         else if(this.data7 != null)
         {
            this.f(this.data1,this.data2,this.data3,this.data4,this.data5,this.data6,this.data7);
         }
         else if(this.data6 != null)
         {
            this.f(this.data1,this.data2,this.data3,this.data4,this.data5,this.data6);
         }
         else if(this.data5 != null)
         {
            this.f(this.data1,this.data2,this.data3,this.data4,this.data5);
         }
         else if(this.data4 != null)
         {
            this.f(this.data1,this.data2,this.data3,this.data4);
         }
         else if(this.data3 != null)
         {
            this.f(this.data1,this.data2,this.data3);
         }
         else if(this.data2 != null)
         {
            this.f(this.data1,this.data2);
         }
         else if(this.data1 != null)
         {
            this.f(this.data1);
         }
         else
         {
            this.f();
         }
      }
   }
}

