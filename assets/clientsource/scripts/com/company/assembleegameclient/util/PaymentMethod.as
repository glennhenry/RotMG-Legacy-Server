package com.company.assembleegameclient.util
{
   import com.company.assembleegameclient.util.offer.Offer;
   import flash.net.URLVariables;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.application.api.ApplicationSetup;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.text.model.TextKey;
   
   public class PaymentMethod
   {
      
      public static const GO_METHOD:PaymentMethod = new PaymentMethod(TextKey.PAYMENTS_GOOGLE_CHECKOUT,"co","");
      
      public static const PAYPAL_METHOD:PaymentMethod = new PaymentMethod(TextKey.PAYMENTS_PAYPAL,"ps","P3");
      
      public static const CREDITS_METHOD:PaymentMethod = new PaymentMethod(TextKey.PAYMENTS_CREDIT_CARDS,"ps","CH");
      
      public static const PAYMENT_METHODS:Vector.<PaymentMethod> = new <PaymentMethod>[GO_METHOD,PAYPAL_METHOD,CREDITS_METHOD];
      
      public var label_:String;
      
      public var provider_:String;
      
      public var paymentid_:String;
      
      public function PaymentMethod(param1:String, param2:String, param3:String)
      {
         super();
         this.label_ = param1;
         this.provider_ = param2;
         this.paymentid_ = param3;
      }
      
      public static function getPaymentMethodByLabel(param1:String) : PaymentMethod
      {
         var _loc2_:PaymentMethod = null;
         for each(_loc2_ in PAYMENT_METHODS)
         {
            if(_loc2_.label_ == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getURL(param1:String, param2:String, param3:Offer) : String
      {
         var _loc4_:Account = StaticInjectorContext.getInjector().getInstance(Account);
         var _loc5_:ApplicationSetup = StaticInjectorContext.getInjector().getInstance(ApplicationSetup);
         var _loc6_:URLVariables = new URLVariables();
         _loc6_["tok"] = param1;
         _loc6_["exp"] = param2;
         _loc6_["guid"] = _loc4_.getUserId();
         _loc6_["provider"] = this.provider_;
         switch(this.provider_)
         {
            case "co":
               _loc6_["jwt"] = param3.jwt_;
               break;
            case "ps":
               _loc6_["jwt"] = param3.jwt_;
               _loc6_["price"] = param3.price_.toString();
               _loc6_["paymentid"] = this.paymentid_;
         }
         return _loc5_.getAppEngineUrl(true) + "/credits/add?" + _loc6_.toString();
      }
   }
}

