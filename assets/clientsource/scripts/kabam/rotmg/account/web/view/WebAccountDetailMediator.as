package kabam.rotmg.account.web.view
{
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.signals.SendConfirmEmailSignal;
   import kabam.rotmg.account.core.signals.UpdateAccountInfoSignal;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.core.service.TrackingData;
   import kabam.rotmg.core.signals.TrackEventSignal;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class WebAccountDetailMediator extends Mediator
   {
      
      [Inject]
      public var view:WebAccountDetailDialog;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var track:TrackEventSignal;
      
      [Inject]
      public var verify:SendConfirmEmailSignal;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var closeDialog:CloseDialogsSignal;
      
      [Inject]
      public var updateAccount:UpdateAccountInfoSignal;
      
      public function WebAccountDetailMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.setUserInfo(this.account.getUserName(),this.account.isVerified());
         this.view.change.add(this.onChange);
         this.view.logout.add(this.onLogout);
         this.view.cancel.add(this.onDone);
         this.view.verify.add(this.onVerify);
      }
      
      override public function destroy() : void
      {
         this.view.change.remove(this.onChange);
         this.view.logout.remove(this.onLogout);
         this.view.cancel.remove(this.onDone);
         this.view.verify.remove(this.onVerify);
      }
      
      private function onChange() : void
      {
         this.openDialog.dispatch(new WebChangePasswordDialog());
      }
      
      private function onLogout() : void
      {
         this.trackLoggedOut();
         this.account.clear();
         this.updateAccount.dispatch();
         this.openDialog.dispatch(new WebLoginDialog());
      }
      
      private function trackLoggedOut() : void
      {
         var _loc1_:TrackingData = new TrackingData();
         _loc1_.category = "account";
         _loc1_.action = "loggedOut";
         this.track.dispatch(_loc1_);
      }
      
      private function onDone() : void
      {
         this.closeDialog.dispatch();
      }
      
      private function onVerify() : void
      {
         var _loc1_:AppEngineClient = StaticInjectorContext.getInjector().getInstance(AppEngineClient);
         _loc1_.complete.addOnce(this.onComplete);
         _loc1_.sendRequest("/account/sendVerifyEmail",this.account.getCredentials());
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         if(param1)
         {
            this.onSent();
         }
         else
         {
            this.onError(param2);
         }
      }
      
      private function onSent() : void
      {
         this.trackEmailSent();
      }
      
      private function trackEmailSent() : void
      {
         var _loc1_:TrackingData = new TrackingData();
         _loc1_.category = "account";
         _loc1_.action = "verifyEmailSent";
         this.track.dispatch(_loc1_);
      }
      
      private function onError(param1:String) : void
      {
         this.account.clear();
      }
   }
}

