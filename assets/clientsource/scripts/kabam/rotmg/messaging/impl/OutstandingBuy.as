package kabam.rotmg.messaging.impl
{
   import com.company.assembleegameclient.util.Currency;
   import com.company.googleanalytics.GA;
   
   internal class OutstandingBuy
   {
      
      private var id_:String;
      
      private var price_:int;
      
      private var currency_:int;
      
      private var converted_:Boolean;
      
      public function OutstandingBuy(param1:String, param2:int, param3:int, param4:Boolean)
      {
         super();
         this.id_ = param1;
         this.price_ = param2;
         this.currency_ = param3;
         this.converted_ = param4;
      }
      
      public function record() : void
      {
         switch(this.currency_)
         {
            case Currency.GOLD:
               GA.global().trackEvent("credits",this.converted_ ? "buyConverted" : "buy",this.id_,this.price_);
               break;
            case Currency.FAME:
               GA.global().trackEvent("credits","buyFame",this.id_,this.price_);
               break;
            case Currency.GUILD_FAME:
               GA.global().trackEvent("credits","buyGuildFame",this.id_,this.price_);
         }
      }
   }
}

