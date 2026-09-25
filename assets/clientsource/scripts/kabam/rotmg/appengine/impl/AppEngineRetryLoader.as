package kabam.rotmg.appengine.impl
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   import kabam.rotmg.appengine.api.RetryLoader;
   import org.osflash.signals.OnceSignal;
   
   public class AppEngineRetryLoader implements RetryLoader
   {
      
      private const _complete:OnceSignal = new OnceSignal(Boolean);
      
      private var maxRetries:int;
      
      private var dataFormat:String;
      
      private var url:String;
      
      private var params:Object;
      
      private var urlRequest:URLRequest;
      
      private var urlLoader:URLLoader;
      
      private var retriesLeft:int;
      
      private var inProgress:Boolean;
      
      public function AppEngineRetryLoader()
      {
         super();
         this.inProgress = false;
         this.maxRetries = 0;
         this.dataFormat = URLLoaderDataFormat.TEXT;
      }
      
      public function get complete() : OnceSignal
      {
         return this._complete;
      }
      
      public function isInProgress() : Boolean
      {
         return this.inProgress;
      }
      
      public function setDataFormat(param1:String) : void
      {
         this.dataFormat = param1;
      }
      
      public function setMaxRetries(param1:int) : void
      {
         this.maxRetries = param1;
      }
      
      public function sendRequest(param1:String, param2:Object) : void
      {
         this.url = param1;
         this.params = param2;
         this.retriesLeft = this.maxRetries;
         this.inProgress = true;
         this.internalSendRequest();
      }
      
      private function internalSendRequest() : void
      {
         this.cancelPendingRequest();
         this.urlRequest = this.makeUrlRequest();
         this.urlLoader = this.makeUrlLoader();
         this.urlLoader.load(this.urlRequest);
      }
      
      private function makeUrlRequest() : URLRequest
      {
         var _loc1_:URLRequest = new URLRequest(this.url);
         _loc1_.method = URLRequestMethod.POST;
         _loc1_.data = this.makeUrlVariables();
         return _loc1_;
      }
      
      private function makeUrlVariables() : URLVariables
      {
         var _loc2_:String = null;
         var _loc1_:URLVariables = new URLVariables();
         _loc1_.ignore = getTimer();
         for(_loc2_ in this.params)
         {
            _loc1_[_loc2_] = this.params[_loc2_];
         }
         return _loc1_;
      }
      
      private function makeUrlLoader() : URLLoader
      {
         var _loc1_:URLLoader = new URLLoader();
         _loc1_.dataFormat = this.dataFormat;
         _loc1_.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         _loc1_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         _loc1_.addEventListener(Event.COMPLETE,this.onComplete);
         return _loc1_;
      }
      
      private function onIOError(param1:IOErrorEvent) : void
      {
         this.inProgress = false;
         var _loc2_:String = this.urlLoader.data;
         if(_loc2_.length == 0)
         {
            _loc2_ = "Unable to contact server";
         }
         this.retryOrReportError(_loc2_);
      }
      
      private function onSecurityError(param1:SecurityErrorEvent) : void
      {
         this.inProgress = false;
         this.cleanUpAndComplete(false,"Security Error");
      }
      
      private function retryOrReportError(param1:String) : void
      {
         if(this.retriesLeft-- > 0)
         {
            this.internalSendRequest();
         }
         else
         {
            this.cleanUpAndComplete(false,param1);
         }
      }
      
      private function onComplete(param1:Event) : void
      {
         this.inProgress = false;
         if(this.dataFormat == URLLoaderDataFormat.TEXT)
         {
            this.handleTextResponse(this.urlLoader.data);
         }
         else
         {
            this.cleanUpAndComplete(true,ByteArray(this.urlLoader.data));
         }
      }
      
      private function handleTextResponse(param1:String) : void
      {
         if(param1.substring(0,7) == "<Error>")
         {
            this.retryOrReportError(param1);
         }
         else if(param1.substring(0,12) == "<FatalError>")
         {
            this.cleanUpAndComplete(false,param1);
         }
         else
         {
            this.cleanUpAndComplete(true,param1);
         }
      }
      
      private function cleanUpAndComplete(param1:Boolean, param2:*) : void
      {
         if(!param1 && param2 is String)
         {
            param2 = this.parseXML(param2);
         }
         this.cancelPendingRequest();
         this._complete.dispatch(param1,param2);
      }
      
      private function parseXML(param1:String) : String
      {
         var _loc2_:Array = param1.match("<.*>(.*)</.*>");
         return Boolean(_loc2_) && _loc2_.length > 1 ? _loc2_[1] : param1;
      }
      
      private function cancelPendingRequest() : void
      {
         if(this.urlLoader)
         {
            this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this.urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
            this.urlLoader.removeEventListener(Event.COMPLETE,this.onComplete);
            this.closeLoader();
            this.urlLoader = null;
         }
      }
      
      private function closeLoader() : void
      {
         try
         {
            this.urlLoader.close();
         }
         catch(e:Error)
         {
         }
      }
   }
}

