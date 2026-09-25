package kabam.rotmg.promotions.commands
{
   import kabam.lib.tasks.BranchingTask;
   import kabam.lib.tasks.DispatchSignalTask;
   import kabam.lib.tasks.Task;
   import kabam.lib.tasks.TaskMonitor;
   import kabam.lib.tasks.TaskSequence;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.services.GetOffersTask;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.promotions.model.BeginnersPackageModel;
   import kabam.rotmg.promotions.service.GetDaysRemainingTask;
   import kabam.rotmg.promotions.view.AlreadyPurchasedBeginnersPackageDialog;
   import kabam.rotmg.promotions.view.BeginnersPackageOfferDialog;
   
   public class ShowBeginnersPackageCommand
   {
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var model:BeginnersPackageModel;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var getDaysRemaining:GetDaysRemainingTask;
      
      [Inject]
      public var getOffers:GetOffersTask;
      
      [Inject]
      public var monitor:TaskMonitor;
      
      public function ShowBeginnersPackageCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var _loc1_:BranchingTask = new BranchingTask(this.getDaysRemaining,this.makeSuccessTask(),this.makeFailureTask());
         this.monitor.add(_loc1_);
         _loc1_.start();
      }
      
      private function makeSuccessTask() : Task
      {
         var _loc1_:TaskSequence = new TaskSequence();
         this.account.isRegistered() && _loc1_.add(this.getOffers);
         _loc1_.add(new DispatchSignalTask(this.openDialog,new BeginnersPackageOfferDialog()));
         return _loc1_;
      }
      
      private function makeFailureTask() : Task
      {
         var _loc1_:TaskSequence = new TaskSequence();
         _loc1_.add(new DispatchSignalTask(this.openDialog,new AlreadyPurchasedBeginnersPackageDialog()));
         return _loc1_;
      }
   }
}

