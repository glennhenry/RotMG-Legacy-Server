package kabam.rotmg.account.web.commands
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.screens.CharacterSelectionAndNewsScreen;
   import flash.display.Sprite;
   import kabam.lib.tasks.BranchingTask;
   import kabam.lib.tasks.DispatchSignalTask;
   import kabam.lib.tasks.TaskMonitor;
   import kabam.lib.tasks.TaskSequence;
   import kabam.rotmg.account.core.services.LoginTask;
   import kabam.rotmg.account.core.signals.UpdateAccountInfoSignal;
   import kabam.rotmg.account.web.model.AccountData;
   import kabam.rotmg.core.model.ScreenModel;
   import kabam.rotmg.core.service.TrackingData;
   import kabam.rotmg.core.signals.InvalidateDataSignal;
   import kabam.rotmg.core.signals.SetScreenWithValidDataSignal;
   import kabam.rotmg.core.signals.TaskErrorSignal;
   import kabam.rotmg.core.signals.TrackEventSignal;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.packages.services.GetPackagesTask;
   
   public class WebLoginCommand
   {
      
      [Inject]
      public var data:AccountData;
      
      [Inject]
      public var loginTask:LoginTask;
      
      [Inject]
      public var monitor:TaskMonitor;
      
      [Inject]
      public var closeDialogs:CloseDialogsSignal;
      
      [Inject]
      public var loginError:TaskErrorSignal;
      
      [Inject]
      public var updateLogin:UpdateAccountInfoSignal;
      
      [Inject]
      public var track:TrackEventSignal;
      
      [Inject]
      public var invalidate:InvalidateDataSignal;
      
      [Inject]
      public var setScreenWithValidData:SetScreenWithValidDataSignal;
      
      [Inject]
      public var screenModel:ScreenModel;
      
      [Inject]
      public var getPackageTask:GetPackagesTask;
      
      private var setScreenTask:DispatchSignalTask;
      
      public function WebLoginCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         this.setScreenTask = new DispatchSignalTask(this.setScreenWithValidData,this.getTargetScreen());
         var _loc1_:BranchingTask = new BranchingTask(this.loginTask,this.makeSuccessTask(),this.makeFailureTask());
         this.monitor.add(_loc1_);
         _loc1_.start();
      }
      
      private function makeSuccessTask() : TaskSequence
      {
         var _loc1_:TaskSequence = new TaskSequence();
         _loc1_.add(new DispatchSignalTask(this.closeDialogs));
         _loc1_.add(new DispatchSignalTask(this.track,this.getTrackingData()));
         _loc1_.add(new DispatchSignalTask(this.updateLogin));
         _loc1_.add(new DispatchSignalTask(this.invalidate));
         _loc1_.add(this.getPackageTask);
         _loc1_.add(this.setScreenTask);
         return _loc1_;
      }
      
      private function makeFailureTask() : TaskSequence
      {
         var _loc1_:TaskSequence = new TaskSequence();
         _loc1_.add(new DispatchSignalTask(this.loginError,this.loginTask));
         _loc1_.add(this.setScreenTask);
         return _loc1_;
      }
      
      private function getTargetScreen() : Sprite
      {
         var _loc1_:Class = this.screenModel.getCurrentScreenType();
         if(_loc1_ == null || _loc1_ == GameSprite)
         {
            _loc1_ = CharacterSelectionAndNewsScreen;
         }
         return new _loc1_();
      }
      
      private function getTrackingData() : TrackingData
      {
         var _loc1_:TrackingData = new TrackingData();
         _loc1_.category = "account";
         _loc1_.action = "signedIn";
         return _loc1_;
      }
   }
}

