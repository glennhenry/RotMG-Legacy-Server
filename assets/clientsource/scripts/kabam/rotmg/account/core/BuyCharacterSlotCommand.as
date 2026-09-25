package kabam.rotmg.account.core
{
   import com.company.assembleegameclient.screens.CharacterSelectionAndNewsScreen;
   import com.company.assembleegameclient.ui.dialogs.ErrorDialog;
   import kabam.lib.tasks.BranchingTask;
   import kabam.lib.tasks.DispatchSignalTask;
   import kabam.lib.tasks.Task;
   import kabam.lib.tasks.TaskMonitor;
   import kabam.lib.tasks.TaskSequence;
   import kabam.rotmg.account.core.services.BuyCharacterSlotTask;
   import kabam.rotmg.account.core.view.BuyingDialog;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.core.service.TrackingData;
   import kabam.rotmg.core.signals.SetScreenSignal;
   import kabam.rotmg.core.signals.TrackEventSignal;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.ui.view.CharacterSlotNeedGoldDialog;
   
   public class BuyCharacterSlotCommand
   {
      
      [Inject]
      public var price:int;
      
      [Inject]
      public var task:BuyCharacterSlotTask;
      
      [Inject]
      public var monitor:TaskMonitor;
      
      [Inject]
      public var setScreen:SetScreenSignal;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var closeDialog:CloseDialogsSignal;
      
      [Inject]
      public var model:PlayerModel;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var track:TrackEventSignal;
      
      public function BuyCharacterSlotCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         if(this.isSlotUnaffordable())
         {
            this.promptToGetMoreGold();
         }
         else
         {
            this.purchaseSlot();
         }
      }
      
      private function isSlotUnaffordable() : Boolean
      {
         return this.model.getCredits() < this.model.getNextCharSlotPrice();
      }
      
      private function promptToGetMoreGold() : void
      {
         this.openDialog.dispatch(new CharacterSlotNeedGoldDialog());
      }
      
      private function purchaseSlot() : void
      {
         this.openDialog.dispatch(new BuyingDialog());
         var _loc1_:TaskSequence = new TaskSequence();
         _loc1_.add(new BranchingTask(this.task,this.makeSuccessTask(),this.makeFailureTask()));
         _loc1_.add(new DispatchSignalTask(this.closeDialog));
         this.monitor.add(_loc1_);
         _loc1_.start();
      }
      
      private function makeSuccessTask() : Task
      {
         var _loc1_:TaskSequence = new TaskSequence();
         _loc1_.add(new DispatchSignalTask(this.setScreen,new CharacterSelectionAndNewsScreen()));
         _loc1_.add(new DispatchSignalTask(this.track,this.makeTrackingData()));
         return _loc1_;
      }
      
      private function makeTrackingData() : TrackingData
      {
         var _loc1_:TrackingData = new TrackingData();
         _loc1_.category = "credits";
         _loc1_.action = "buyConverted";
         _loc1_.label = "Character Slot";
         _loc1_.value = this.price;
         return _loc1_;
      }
      
      private function makeFailureTask() : Task
      {
         return new DispatchSignalTask(this.openDialog,new ErrorDialog("Unable to complete character slot purchase"));
      }
   }
}

