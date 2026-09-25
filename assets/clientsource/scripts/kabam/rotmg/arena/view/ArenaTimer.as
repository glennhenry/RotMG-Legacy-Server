package kabam.rotmg.arena.view
{
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.filters.DropShadowFilter;
   import flash.utils.Timer;
   import kabam.rotmg.text.view.StaticTextDisplay;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   
   public class ArenaTimer extends Sprite
   {
      
      private const timerText:StaticTextDisplay = this.makeTimerText();
      
      private const timerStringBuilder:StaticStringBuilder = new StaticStringBuilder();
      
      private var secs:Number = 0;
      
      private const timer:Timer = new Timer(1000);
      
      public function ArenaTimer()
      {
         super();
      }
      
      public function start() : void
      {
         this.updateTimer(null);
         this.timer.addEventListener(TimerEvent.TIMER,this.updateTimer);
         this.timer.start();
      }
      
      public function stop() : void
      {
         this.timer.removeEventListener(TimerEvent.TIMER,this.updateTimer);
         this.timer.stop();
      }
      
      private function updateTimer(param1:TimerEvent) : void
      {
         var _loc2_:int = this.secs / 60;
         var _loc3_:int = this.secs % 60;
         var _loc4_:String = _loc2_ < 10 ? "0" : "";
         _loc4_ = _loc4_ + (_loc2_ + ":");
         _loc4_ = _loc4_ + (_loc3_ < 10 ? "0" : "");
         _loc4_ = _loc4_ + _loc3_;
         this.timerText.setStringBuilder(this.timerStringBuilder.setString(_loc4_));
         ++this.secs;
      }
      
      private function makeTimerText() : StaticTextDisplay
      {
         var _loc1_:StaticTextDisplay = new StaticTextDisplay();
         _loc1_.setSize(24).setBold(true).setColor(16777215);
         _loc1_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         addChild(_loc1_);
         return _loc1_;
      }
   }
}

