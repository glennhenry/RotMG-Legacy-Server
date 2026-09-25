package kabam.lib.tasks
{
   public class TaskSequence extends BaseTask
   {
      
      private var tasks:Vector.<Task>;
      
      private var index:int;
      
      private var continueOnFail:Boolean;
      
      public function TaskSequence()
      {
         super();
         this.tasks = new Vector.<Task>();
      }
      
      public function getContinueOnFail() : Boolean
      {
         return this.continueOnFail;
      }
      
      public function setContinueOnFail(param1:Boolean) : void
      {
         this.continueOnFail = param1;
      }
      
      public function add(param1:Task) : void
      {
         this.tasks.push(param1);
      }
      
      override protected function startTask() : void
      {
         this.index = 0;
         this.doNextTaskOrComplete();
      }
      
      override protected function onReset() : void
      {
         var _loc1_:Task = null;
         for each(_loc1_ in this.tasks)
         {
            _loc1_.reset();
         }
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
         return this.index < this.tasks.length;
      }
      
      private function doNextTask() : void
      {
         var _loc1_:Task = this.tasks[this.index++];
         _loc1_.lastly.addOnce(this.onTaskFinished);
         _loc1_.start();
      }
      
      private function onTaskFinished(param1:Task, param2:Boolean, param3:String) : void
      {
         if(param2 || this.continueOnFail)
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

