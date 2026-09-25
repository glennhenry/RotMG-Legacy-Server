package kabam.lib.loopedprocs
{
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   
   public class LoopedProcess
   {
      
      private static var maxId:uint;
      
      private static var loopProcs:Dictionary = new Dictionary();
      
      public var id:uint;
      
      public var paused:Boolean;
      
      public var interval:uint;
      
      public var lastRun:int;
      
      public function LoopedProcess(param1:uint)
      {
         super();
         this.interval = param1;
      }
      
      public static function addProcess(param1:LoopedProcess) : uint
      {
         if(loopProcs[param1.id] == param1)
         {
            return param1.id;
         }
         loopProcs[++maxId] = param1;
         param1.lastRun = getTimer();
         return maxId;
      }
      
      public static function runProcesses(param1:int) : void
      {
         var _loc2_:LoopedProcess = null;
         var _loc3_:int = 0;
         for each(_loc2_ in loopProcs)
         {
            if(!_loc2_.paused)
            {
               _loc3_ = param1 - _loc2_.lastRun;
               if(_loc3_ >= _loc2_.interval)
               {
                  _loc2_.lastRun = param1;
                  _loc2_.run();
               }
            }
         }
      }
      
      public static function destroyProcess(param1:LoopedProcess) : void
      {
         delete loopProcs[param1.id];
         param1.onDestroyed();
      }
      
      public static function destroyAll() : void
      {
         var _loc1_:LoopedProcess = null;
         for each(_loc1_ in loopProcs)
         {
            _loc1_.destroy();
         }
         loopProcs = new Dictionary();
      }
      
      final public function add() : void
      {
         addProcess(this);
      }
      
      final public function destroy() : void
      {
         destroyProcess(this);
      }
      
      protected function run() : void
      {
      }
      
      protected function onDestroyed() : void
      {
      }
   }
}

