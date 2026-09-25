package kabam.rotmg.account.web.commands
{
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.web.WebAccount;
   
   public class WebSetPaymentDataCommand
   {
      
      [Inject]
      public var characterListData:XML;
      
      [Inject]
      public var account:Account;
      
      public function WebSetPaymentDataCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var _loc2_:XML = null;
         var _loc1_:WebAccount = this.account as WebAccount;
         if(this.characterListData.hasOwnProperty("KabamPaymentInfo"))
         {
            _loc2_ = XML(this.characterListData.KabamPaymentInfo);
            _loc1_.signedRequest = _loc2_.signedRequest;
            _loc1_.kabamId = _loc2_.naid;
         }
      }
   }
}

