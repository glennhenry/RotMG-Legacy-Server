package kabam.rotmg.startup.control
{
   import kabam.lib.tasks.BaseTask;
   import kabam.lib.tasks.Task;
   import kabam.rotmg.startup.model.api.StartupDelegate;
   import kabam.rotmg.startup.model.impl.SignalTaskDelegate;
   import kabam.rotmg.startup.model.impl.TaskDelegate;
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.framework.api.ILogger;
   
   public class StartupSequence extends BaseTask
   {
      
      public static const LAST:int = int.MAX_VALUE;
      
      [Inject]
      public var injector:Injector;
      
      [Inject]
      public var logger:ILogger;
      
      private const list:Vector.<StartupDelegate> = new Vector.<StartupDelegate>(0);
      
      private var index:int = 0;
      
      public function StartupSequence()
      {
         super();
      }
      
      public function addSignal(param1:Class, param2:int = 0) : void
      {
         var _loc3_:SignalTaskDelegate = new SignalTaskDelegate();
         _loc3_.injector = this.injector;
         _loc3_.signalClass = param1;
         _loc3_.priority = param2;
         this.list.push(_loc3_);
      }
      
      public function addTask(param1:Class, param2:int = 0) : void
      {
         var _loc3_:TaskDelegate = new TaskDelegate();
         _loc3_.injector = this.injector;
         _loc3_.taskClass = param1;
         _loc3_.priority = param2;
         this.list.push(_loc3_);
      }
      
      override protected function startTask() : void
      {
         this.list.sort(this.priorityComparison);
         this.index = 0;
         this.doNextTaskOrComplete();
      }
      
      private function priorityComparison(param1:StartupDelegate, param2:StartupDelegate) : int
      {
         return param1.getPriority() - param2.getPriority();
      }
      
      private function doNextTaskOrComplete() : void
      {
         if(this.isAnotherTask())
         {
            this.doNextTask();
         }
         else
         {
            completeTask(true);
         }
      }
      
      private function isAnotherTask() : Boolean
      {
         return this.index < this.list.length;
      }
      
      private function doNextTask() : void
      {
         var _loc1_:Task = this.list[this.index++].make();
         _loc1_.lastly.addOnce(this.onTaskFinished);
         this.logger.info("StartupSequence start:{0}",[_loc1_]);
         _loc1_.start();
      }
      
      private function onTaskFinished(param1:Task, param2:Boolean, param3:String) : void
      {
         this.logger.info("StartupSequence finish:{0} (isOK: {1})",[param1,param2]);
         if(param2)
         {
            this.doNextTaskOrComplete();
         }
         else
         {
            completeTask(false,param3);
         }
      }
   }
}

