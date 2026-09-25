package kabam.rotmg.account.steam.services
{
   import com.company.assembleegameclient.ui.dialogs.DebugDialog;
   import com.company.assembleegameclient.util.offer.Offer;
   import flash.utils.setTimeout;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.services.PurchaseGoldTask;
   import kabam.rotmg.account.steam.SteamApi;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.core.signals.MoneyFrameEnableCancelSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.external.command.RequestPlayerCreditsSignal;
   import robotlegs.bender.framework.api.ILogger;
   
   public class SteamPurchaseGoldTask extends BaseTask implements PurchaseGoldTask
   {
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var steam:SteamApi;
      
      [Inject]
      public var offer:Offer;
      
      [Inject]
      public var paymentMethod:String;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var moneyFrameEnableCancelSignal:MoneyFrameEnableCancelSignal;
      
      [Inject]
      public var logger:ILogger;
      
      [Inject]
      public var first:AppEngineClient;
      
      [Inject]
      public var second:AppEngineClient;
      
      [Inject]
      public var requestPlayerCredits:RequestPlayerCreditsSignal;
      
      public function SteamPurchaseGoldTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.logger.debug("SteamPurchaseGoldTask startTask");
         this.steam.paymentAuthorized.addOnce(this.onPaymentAuthorized);
         this.first.setMaxRetries(2);
         this.first.complete.addOnce(this.onComplete);
         this.first.sendRequest("/steamworks/purchaseOffer",{
            "steamid":this.steam.getSteamId(),
            "data":this.offer.data_
         });
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         if(param1)
         {
            this.onPurchaseOfferComplete();
         }
         else
         {
            this.reportError(param2);
         }
      }
      
      private function onPurchaseOfferComplete() : void
      {
         this.logger.debug("SteamPurchaseGoldTask purchaseOffer confirmed by AppEngine");
         setTimeout(function():void
         {
            moneyFrameEnableCancelSignal.dispatch();
         },1100);
      }
      
      private function onPaymentAuthorized(param1:uint, param2:String, param3:Boolean) : void
      {
         if(param3 == false)
         {
            this.logger.debug("SteamPurchaseGoldTask payment canceled by user");
            completeTask(true);
            this.second.setMaxRetries(2);
            this.second.sendRequest("/steamworks/finalizePurchase",{
               "appid":param1,
               "orderid":param2,
               "authorized":0
            });
         }
         else
         {
            this.logger.debug("SteamPurchaseGoldTask payment authorized by Steam");
            this.second.setMaxRetries(2);
            this.second.complete.addOnce(this.onAuthorized);
            this.second.sendRequest("/steamworks/finalizePurchase",{
               "appid":param1,
               "orderid":param2,
               "authorized":(param3 ? 1 : 0)
            });
         }
      }
      
      private function onAuthorized(param1:Boolean, param2:*) : void
      {
         if(param1)
         {
            this.onPurchaseFinalizeComplete();
         }
         else
         {
            this.reportError(param2);
         }
      }
      
      private function onPurchaseFinalizeComplete() : void
      {
         this.logger.debug("SteamPurchaseGoldTask purchase finalized");
         this.requestPlayerCredits.dispatch();
         completeTask(true);
      }
      
      private function reportError(param1:String) : void
      {
         var _loc2_:String = "Error: " + param1;
         this.logger.debug("finalize error {0}",[_loc2_]);
         this.openDialog.dispatch(new DebugDialog(_loc2_));
         completeTask(false);
      }
   }
}

