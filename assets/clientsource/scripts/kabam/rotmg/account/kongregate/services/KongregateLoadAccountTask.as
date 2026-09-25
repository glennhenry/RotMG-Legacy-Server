package kabam.rotmg.account.kongregate.services
{
   import kabam.lib.tasks.BaseTask;
   import kabam.lib.tasks.Task;
   import kabam.lib.tasks.TaskMonitor;
   import kabam.lib.tasks.TaskSequence;
   import kabam.rotmg.account.core.services.LoadAccountTask;
   
   public class KongregateLoadAccountTask extends BaseTask implements LoadAccountTask
   {
      
      [Inject]
      public var loadApi:KongregateLoadApiTask;
      
      [Inject]
      public var getCredentials:KongregateGetCredentialsTask;
      
      [Inject]
      public var monitor:TaskMonitor;
      
      public function KongregateLoadAccountTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         var _loc1_:TaskSequence = new TaskSequence();
         _loc1_.add(this.loadApi);
         _loc1_.add(this.getCredentials);
         _loc1_.lastly.add(this.onTasksComplete);
         this.monitor.add(_loc1_);
         _loc1_.start();
      }
      
      private function onTasksComplete(param1:Task, param2:Boolean, param3:String) : void
      {
         completeTask(true);
      }
   }
}

