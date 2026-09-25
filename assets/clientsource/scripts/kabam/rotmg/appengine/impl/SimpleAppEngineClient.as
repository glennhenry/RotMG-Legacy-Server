package kabam.rotmg.appengine.impl
{
   import flash.net.URLLoaderDataFormat;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.appengine.api.RetryLoader;
   import kabam.rotmg.application.api.ApplicationSetup;
   import org.osflash.signals.OnceSignal;
   
   public class SimpleAppEngineClient implements AppEngineClient
   {
      
      [Inject]
      public var loader:RetryLoader;
      
      [Inject]
      public var setup:ApplicationSetup;
      
      private var isEncrypted:Boolean;
      
      private var maxRetries:int;
      
      private var dataFormat:String;
      
      public function SimpleAppEngineClient()
      {
         super();
         this.isEncrypted = true;
         this.maxRetries = 0;
         this.dataFormat = URLLoaderDataFormat.TEXT;
      }
      
      public function get complete() : OnceSignal
      {
         return this.loader.complete;
      }
      
      public function setDataFormat(param1:String) : void
      {
         this.loader.setDataFormat(param1);
      }
      
      public function setSendEncrypted(param1:Boolean) : void
      {
         this.isEncrypted = param1;
      }
      
      public function setMaxRetries(param1:int) : void
      {
         this.loader.setMaxRetries(param1);
      }
      
      public function sendRequest(param1:String, param2:Object) : void
      {
         this.loader.sendRequest(this.makeURL(param1),param2);
      }
      
      private function makeURL(param1:String) : String
      {
         if(param1.charAt(0) != "/")
         {
            param1 = "/" + param1;
         }
         return this.setup.getAppEngineUrl() + param1;
      }
      
      public function requestInProgress() : Boolean
      {
         return this.loader.isInProgress();
      }
   }
}

