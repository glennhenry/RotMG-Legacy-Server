package kabam.rotmg.account.web.model
{
   import com.company.assembleegameclient.util.offer.Offer;
   import kabam.rotmg.account.core.model.MoneyConfig;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StringBuilder;
   
   public class WebMoneyConfig implements MoneyConfig
   {
      
      public function WebMoneyConfig()
      {
         super();
      }
      
      public function showPaymentMethods() : Boolean
      {
         return true;
      }
      
      public function showBonuses() : Boolean
      {
         return true;
      }
      
      public function parseOfferPrice(param1:Offer) : StringBuilder
      {
         return new LineBuilder().setParams(TextKey.PAYMENTS_WEB_COST,{"cost":param1.price_});
      }
      
      public function jsInitializeFunction() : String
      {
         return "rotmg.KabamPayment.setupRotmgAccount";
      }
   }
}

