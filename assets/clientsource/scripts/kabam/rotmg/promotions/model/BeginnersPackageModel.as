package kabam.rotmg.promotions.model
{
   import com.company.assembleegameclient.util.TimeUtil;
   import com.company.assembleegameclient.util.offer.Offer;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.model.OfferModel;
   import org.osflash.signals.Signal;
   
   public class BeginnersPackageModel
   {
      
      private static const REALM_GOLD_FOR_BEGINNERS_PKG:int = 2600;
      
      private static const ONE_WEEK_IN_SECONDS:int = 604800;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var model:OfferModel;
      
      public var markedAsPurchased:Signal = new Signal();
      
      private var beginnersOfferSecondsLeft:Number;
      
      private var beginnersOfferSetTimestamp:Number;
      
      public function BeginnersPackageModel()
      {
         super();
      }
      
      public function isBeginnerAvailable() : Boolean
      {
         return this.getBeginnersOfferSecondsLeft() > 0;
      }
      
      public function setBeginnersOfferSecondsLeft(param1:Number) : void
      {
         this.beginnersOfferSecondsLeft = param1;
         this.beginnersOfferSetTimestamp = this.getNowTimeSeconds();
      }
      
      private function getNowTimeSeconds() : Number
      {
         var _loc1_:Date = new Date();
         return Math.round(_loc1_.time * 0.001);
      }
      
      public function getBeginnersOfferSecondsLeft() : Number
      {
         return this.beginnersOfferSecondsLeft - (this.getNowTimeSeconds() - this.beginnersOfferSetTimestamp);
      }
      
      public function getUserCreatedAt() : Number
      {
         return this.getNowTimeSeconds() + this.getBeginnersOfferSecondsLeft() - ONE_WEEK_IN_SECONDS;
      }
      
      public function getDaysRemaining() : Number
      {
         return Math.ceil(TimeUtil.secondsToDays(this.getBeginnersOfferSecondsLeft()));
      }
      
      public function getOffer() : Offer
      {
         var _loc1_:Offer = null;
         if(!this.model.offers)
         {
            return null;
         }
         for each(_loc1_ in this.model.offers.offerList)
         {
            if(_loc1_.realmGold_ == REALM_GOLD_FOR_BEGINNERS_PKG)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function markAsPurchased() : void
      {
         this.setBeginnersOfferSecondsLeft(-1);
         this.markedAsPurchased.dispatch();
      }
   }
}

