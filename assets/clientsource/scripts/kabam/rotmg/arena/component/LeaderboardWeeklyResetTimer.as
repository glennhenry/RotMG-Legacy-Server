package kabam.rotmg.arena.component
{
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.filters.DropShadowFilter;
   import flash.utils.Timer;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.StaticTextDisplay;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class LeaderboardWeeklyResetTimer extends Sprite
   {
      
      private const MONDAY:Number = 1;
      
      private const UTC_COUNTOFF_HOUR:Number = 7;
      
      private var differenceMilliseconds:Number = this.makeDifferenceMilliseconds();
      
      private var updateTimer:Timer;
      
      private var resetClock:StaticTextDisplay = this.makeResetClockDisplay();
      
      private var resetClockStringBuilder:LineBuilder = new LineBuilder();
      
      public function LeaderboardWeeklyResetTimer()
      {
         super();
         addChild(this.resetClock);
         this.resetClock.setStringBuilder(this.resetClockStringBuilder.setParams(TextKey.ARENA_WEEKLY_RESET_LABEL,{"time":this.getDateString()}));
         this.updateTimer = new Timer(1000);
         this.updateTimer.addEventListener(TimerEvent.TIMER,this.onUpdateTime);
         this.updateTimer.start();
      }
      
      private function onUpdateTime(param1:TimerEvent) : void
      {
         this.differenceMilliseconds -= 1000;
         this.resetClock.setStringBuilder(this.resetClockStringBuilder.setParams(TextKey.ARENA_WEEKLY_RESET_LABEL,{"time":this.getDateString()}));
      }
      
      private function getDateString() : String
      {
         var _loc1_:int = this.differenceMilliseconds;
         var _loc2_:int = Math.floor(_loc1_ / 86400000);
         _loc1_ %= 86400000;
         var _loc3_:int = Math.floor(_loc1_ / 3600000);
         _loc1_ %= 3600000;
         var _loc4_:int = Math.floor(_loc1_ / 60000);
         _loc1_ %= 60000;
         var _loc5_:int = Math.floor(_loc1_ / 1000);
         var _loc6_:String = "";
         if(_loc2_ > 0)
         {
            _loc6_ = _loc2_ + " days, " + _loc3_ + " hours, " + _loc4_ + " minutes";
         }
         else
         {
            _loc6_ = _loc3_ + " hours, " + _loc4_ + " minutes, " + _loc5_ + " seconds";
         }
         return _loc6_;
      }
      
      private function makeDifferenceMilliseconds() : Number
      {
         var _loc1_:Date = new Date();
         var _loc2_:Date = this.makeResetDate();
         return _loc2_.getTime() - _loc1_.getTime();
      }
      
      private function makeResetDate() : Date
      {
         var _loc1_:Date = new Date();
         if(_loc1_.dayUTC == this.MONDAY && _loc1_.hoursUTC < this.UTC_COUNTOFF_HOUR)
         {
            _loc1_.setUTCHours(this.UTC_COUNTOFF_HOUR - _loc1_.hoursUTC);
            return _loc1_;
         }
         _loc1_.setUTCHours(7);
         _loc1_.setUTCMinutes(0);
         _loc1_.setUTCSeconds(0);
         _loc1_.setUTCMilliseconds(0);
         _loc1_.setUTCDate(_loc1_.dateUTC + 1);
         while(_loc1_.dayUTC != this.MONDAY)
         {
            _loc1_.setUTCDate(_loc1_.dateUTC + 1);
         }
         return _loc1_;
      }
      
      private function makeResetClockDisplay() : StaticTextDisplay
      {
         var _loc1_:StaticTextDisplay = new StaticTextDisplay();
         _loc1_.setSize(14).setColor(16567065).setBold(true);
         _loc1_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         return _loc1_;
      }
   }
}

