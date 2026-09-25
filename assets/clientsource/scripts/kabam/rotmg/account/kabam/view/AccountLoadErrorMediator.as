package kabam.rotmg.account.kabam.view
{
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class AccountLoadErrorMediator extends Mediator
   {
      
      private static const GET_KABAM_PAGE_JS:String = "rotmg.KabamDotComLib.getKabamGamePage";
      
      private static const KABAM_DOT_COM:String = "https://www.kabam.com";
      
      private static const TOP:String = "_top";
      
      [Inject]
      public var view:AccountLoadErrorDialog;
      
      public function AccountLoadErrorMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.close.addOnce(this.onClose);
      }
      
      private function onClose() : void
      {
         navigateToURL(new URLRequest(this.getUrl()),TOP);
      }
      
      private function getUrl() : String
      {
         var _loc2_:String = null;
         var _loc1_:String = KABAM_DOT_COM;
         try
         {
            _loc2_ = ExternalInterface.call(GET_KABAM_PAGE_JS);
            if(Boolean(_loc2_) && Boolean(_loc2_.length))
            {
               _loc1_ = _loc2_;
            }
         }
         catch(error:Error)
         {
         }
         return _loc1_;
      }
   }
}

