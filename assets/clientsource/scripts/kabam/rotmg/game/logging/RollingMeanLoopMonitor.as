package kabam.rotmg.game.logging
{
   import kabam.lib.console.signals.ConsoleWatchSignal;
   
   public class RollingMeanLoopMonitor implements LoopMonitor
   {
      
      [Inject]
      public var watch:ConsoleWatchSignal;
      
      private var watchMap:Object;
      
      public function RollingMeanLoopMonitor()
      {
         super();
         this.watchMap = {};
      }
      
      public function recordTime(param1:String, param2:int) : void
      {
         var _loc3_:GameSpriteLoopWatch = this.watchMap[param1] = this.watchMap[param1] || new GameSpriteLoopWatch(param1);
         _loc3_.logTime(param2);
         this.watch.dispatch(_loc3_);
      }
   }
}

