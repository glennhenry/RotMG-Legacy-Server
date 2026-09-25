package kabam.rotmg.account.web.view
{
   import kabam.lib.tasks.Task;
   import kabam.rotmg.account.web.model.ChangePasswordData;
   import kabam.rotmg.account.web.signals.WebChangePasswordSignal;
   import kabam.rotmg.core.signals.TaskErrorSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.text.model.TextKey;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class WebChangePasswordMediator extends Mediator
   {
      
      [Inject]
      public var view:WebChangePasswordDialog;
      
      [Inject]
      public var change:WebChangePasswordSignal;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var loginError:TaskErrorSignal;
      
      public function WebChangePasswordMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.change.add(this.onChange);
         this.view.cancel.add(this.onCancel);
         this.loginError.add(this.onError);
      }
      
      override public function destroy() : void
      {
         this.view.change.remove(this.onChange);
         this.view.cancel.remove(this.onCancel);
         this.loginError.remove(this.onError);
      }
      
      private function onCancel() : void
      {
         this.openDialog.dispatch(new WebAccountDetailDialog());
      }
      
      private function onChange() : void
      {
         var _loc1_:ChangePasswordData = null;
         if(this.isCurrentPasswordValid() && this.isNewPasswordValid() && this.isNewPasswordVerified())
         {
            this.view.disable();
            this.view.clearError();
            _loc1_ = new ChangePasswordData();
            _loc1_.currentPassword = this.view.password_.text();
            _loc1_.newPassword = this.view.newPassword_.text();
            this.change.dispatch(_loc1_);
         }
      }
      
      private function isCurrentPasswordValid() : Boolean
      {
         var _loc1_:Boolean = this.view.password_.text().length >= 5;
         if(!_loc1_)
         {
            this.view.password_.setError(TextKey.WEB_CHANGE_PASSWORD_INCORRECT);
         }
         return _loc1_;
      }
      
      private function isNewPasswordValid() : Boolean
      {
         var _loc1_:Boolean = this.view.newPassword_.text().length >= 10;
         if(!_loc1_)
         {
            this.view.newPassword_.setError(TextKey.REGISTER_WEB_SHORT_ERROR);
         }
         return _loc1_;
      }
      
      private function isNewPasswordVerified() : Boolean
      {
         var _loc1_:Boolean = this.view.newPassword_.text() == this.view.retypeNewPassword_.text();
         if(!_loc1_)
         {
            this.view.retypeNewPassword_.setError(TextKey.REGISTER_WEB_MATCH_ERROR);
         }
         return _loc1_;
      }
      
      private function onError(param1:Task) : void
      {
         this.view.setError(param1.error);
         this.view.enable();
      }
   }
}

