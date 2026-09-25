package kabam.rotmg.account.web.commands
{
   import kabam.lib.tasks.BranchingTask;
   import kabam.lib.tasks.DispatchSignalTask;
   import kabam.lib.tasks.Task;
   import kabam.lib.tasks.TaskMonitor;
   import kabam.lib.tasks.TaskSequence;
   import kabam.rotmg.account.core.services.RegisterAccountTask;
   import kabam.rotmg.account.core.signals.UpdateAccountInfoSignal;
   import kabam.rotmg.account.web.view.WebAccountDetailDialog;
   import kabam.rotmg.core.service.TrackingData;
   import kabam.rotmg.core.signals.TaskErrorSignal;
   import kabam.rotmg.core.signals.TrackEventSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   
   public class WebRegisterAccountCommand
   {
      
      [Inject]
      public var task:RegisterAccountTask;
      
      [Inject]
      public var monitor:TaskMonitor;
      
      [Inject]
      public var taskError:TaskErrorSignal;
      
      [Inject]
      public var updateAccount:UpdateAccountInfoSignal;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var track:TrackEventSignal;
      
      public function WebRegisterAccountCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var _loc1_:BranchingTask = new BranchingTask(this.task,this.makeSuccess(),this.makeFailure());
         this.monitor.add(_loc1_);
         _loc1_.start();
      }
      
      private function makeSuccess() : Task
      {
         var _loc1_:TaskSequence = new TaskSequence();
         _loc1_.add(new DispatchSignalTask(this.track,this.getTrackingData()));
         _loc1_.add(new DispatchSignalTask(this.updateAccount));
         _loc1_.add(new DispatchSignalTask(this.openDialog,new WebAccountDetailDialog()));
         return _loc1_;
      }
      
      private function makeFailure() : DispatchSignalTask
      {
         return new DispatchSignalTask(this.taskError,this.task);
      }
      
      private function getTrackingData() : TrackingData
      {
         var _loc1_:TrackingData = new TrackingData();
         _loc1_.category = "account";
         _loc1_.action = "accountRegistered";
         return _loc1_;
      }
   }
}

