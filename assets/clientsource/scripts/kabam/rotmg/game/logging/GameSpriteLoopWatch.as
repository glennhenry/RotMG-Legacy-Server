package kabam.rotmg.game.logging
{
   import kabam.lib.console.model.Watch;
   
   public class GameSpriteLoopWatch extends Watch
   {
      
      private static const WATCH_PATTERN:String = "[{NAME}] [0x33FF33:{/x {MEAN}ms (min {MIN}ms, max {MAX}ms)]";
      
      private static const COUNT:int = 10;
      
      private var times:Vector.<int>;
      
      private var index:int;
      
      private var count:int;
      
      public var rollingTotal:int;
      
      public var mean:int;
      
      public var max:int;
      
      public var min:int;
      
      public function GameSpriteLoopWatch(param1:String)
      {
         super(param1);
         this.times = new Vector.<int>(COUNT,true);
         this.index = 0;
         this.rollingTotal = 0;
         this.count = 0;
         this.min = int.MAX_VALUE;
         this.max = -1;
      }
      
      public function logTime(param1:int) : void
      {
         if(this.count < COUNT)
         {
            this.rollingTotal += param1;
            ++this.count;
            this.times[this.index] = param1;
         }
         else
         {
            this.rollingTotal -= this.times[this.index];
            this.rollingTotal += param1;
            this.times[this.index] = param1;
         }
         if(++this.index == COUNT)
         {
            this.index = 0;
         }
         this.mean = this.rollingTotal / this.count;
         if(param1 > this.max)
         {
            this.max = param1;
         }
         if(param1 < this.min)
         {
            this.min = param1;
         }
         data = WATCH_PATTERN.replace("{NAME}",name).replace("{MEAN}",this.mean).replace("{MIN}",this.min).replace("{MAX}",this.max);
      }
   }
}

