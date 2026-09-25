package kabam.rotmg.account.steam.services
{
   import com.company.assembleegameclient.ui.dialogs.DebugDialog;
   import com.company.assembleegameclient.util.offer.Offer;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.PaymentData;
   import kabam.rotmg.account.core.services.MakePaymentTask;
   import kabam.rotmg.account.steam.SteamApi;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import robotlegs.bender.framework.api.ILogger;
   
   public class SteamMakePaymentTask extends BaseTask implements MakePaymentTask
   {
      
      [Inject]
      public var steam:SteamApi;
      
      [Inject]
      public var payment:PaymentData;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var logger:ILogger;
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var second:AppEngineClient;
      
      private var offer:Offer;
      
      public function SteamMakePaymentTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.logger.debug("start task");
         this.offer = this.payment.offer;
         this.client.setMaxRetries(2);
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/steamworks/purchaseOffer",{
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
            this.onPurchaseOfferError(param2);
         }
      }
      
      private function onPurchaseOfferComplete() : void
      {
         this.logger.debug("purchaseOffer complete");
         this.steam.paymentAuthorized.addOnce(this.onPaymentAuthorized);
      }
      
      private function onPaymentAuthorized(param1:uint, param2:String, param3:Boolean) : void
      {
         this.logger.debug("payment authorized {0},{1},{2}",[param1,param2,param3]);
         this.second.setMaxRetries(2);
         this.client.complete.addOnce(this.onAuthorized);
         this.second.sendRequest("/steamworks/finalizePurchase",{
            "appid":param1,
            "orderid":param2,
            "authorized":(param3 ? 1 : 0)
         });
      }
      
      private function onAuthorized(param1:Boolean, param2:*) : void
      {
         if(param1)
         {
            this.onPurchaseFinalizeComplete();
         }
         else
         {
            this.onPurchaseFinalizeError(param2);
         }
      }
      
      private function onPurchaseFinalizeComplete() : void
      {
         this.logger.debug("purchaseFinalized complete");
         completeTask(true);
      }
      
      private function onPurchaseFinalizeError(param1:String) : void
      {
         this.logger.debug("purchaseFinalized error {0}",[param1]);
         this.openDialog.dispatch(new DebugDialog("Error: " + param1));
         completeTask(false);
      }
      
      private function onPurchaseOfferError(param1:String) : void
      {
         this.logger.debug("purchaseOffer request error {0}",[param1]);
         this.openDialog.dispatch(new DebugDialog("Error: " + param1));
         completeTask(false);
      }
   }
}

