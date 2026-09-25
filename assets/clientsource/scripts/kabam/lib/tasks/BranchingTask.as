package kabam.lib.tasks
{
   public class BranchingTask extends BaseTask
   {
      
      private var task:Task;
      
      private var success:Task;
      
      private var failure:Task;
      
      public function BranchingTask(param1:Task, param2:Task = null, param3:Task = null)
      {
         super();
         this.task = param1;
         this.success = param2;
         this.failure = param3;
      }
      
      public function addSuccessTask(param1:Task) : void
      {
         this.success = param1;
      }
      
      public function addFailureTask(param1:Task) : void
      {
         this.failure = param1;
      }
      
      override protected function startTask() : void
      {
         this.task.finished.addOnce(this.onTaskFinished);
         this.task.start();
      }
      
      private function onTaskFinished(param1:Task, param2:Boolean, param3:String = "") : void
      {
         if(param2)
         {
            this.handleBranchTask(this.success);
         }
         else
         {
            this.handleBranchTask(this.failure);
         }
      }
      
      private function handleBranchTask(param1:Task) : void
      {
         if(param1)
         {
            param1.finished.addOnce(this.onBranchComplete);
            param1.start();
         }
         else
         {
            completeTask(true);
         }
      }
      
      private function onBranchComplete(param1:Task, param2:Boolean, param3:String = "") : void
      {
         completeTask(param2,param3);
      }
   }
}

