package kabam.rotmg.characters.deletion.control
{
   import com.company.assembleegameclient.screens.CharacterSelectionAndNewsScreen;
   import kabam.lib.tasks.BranchingTask;
   import kabam.lib.tasks.DispatchSignalTask;
   import kabam.lib.tasks.Task;
   import kabam.lib.tasks.TaskMonitor;
   import kabam.lib.tasks.TaskSequence;
   import kabam.rotmg.characters.deletion.service.DeleteCharacterTask;
   import kabam.rotmg.characters.deletion.view.DeletingCharacterView;
   import kabam.rotmg.core.signals.SetScreenSignal;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   
   public class DeleteCharacterCommand
   {
      
      [Inject]
      public var task:DeleteCharacterTask;
      
      [Inject]
      public var monitor:TaskMonitor;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var closeDialogs:CloseDialogsSignal;
      
      [Inject]
      public var setScreen:SetScreenSignal;
      
      public function DeleteCharacterCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var _loc1_:TaskSequence = new TaskSequence();
         _loc1_.add(new DispatchSignalTask(this.openDialog,new DeletingCharacterView()));
         _loc1_.add(new BranchingTask(this.task,this.onSuccess(),this.onFailure()));
         this.monitor.add(_loc1_);
         _loc1_.start();
      }
      
      private function onSuccess() : Task
      {
         var _loc1_:TaskSequence = new TaskSequence();
         _loc1_.add(new DispatchSignalTask(this.setScreen,new CharacterSelectionAndNewsScreen()));
         _loc1_.add(new DispatchSignalTask(this.closeDialogs));
         return _loc1_;
      }
      
      private function onFailure() : Task
      {
         return new DispatchSignalTask(this.openDialog,"Unable to delete character");
      }
   }
}

