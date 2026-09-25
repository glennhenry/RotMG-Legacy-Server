package com.company.assembleegameclient.appengine
{
   import flash.display.BitmapData;
   import flash.net.URLLoaderDataFormat;
   import flash.utils.ByteArray;
   import ion.utils.png.PNGDecoder;
   import kabam.rotmg.appengine.api.RetryLoader;
   import kabam.rotmg.appengine.impl.AppEngineRetryLoader;
   import kabam.rotmg.core.StaticInjectorContext;
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.framework.api.ILogger;
   
   public class RemoteTexture
   {
      
      private static const URL_PATTERN:String = "http://{DOMAIN}/picture/get";
      
      private static const ERROR_PATTERN:String = "Remote Texture Error: {ERROR} (id:{ID}, instance:{INSTANCE})";
      
      private static const START_TIME:int = int(new Date().getTime());
      
      public var id_:String;
      
      public var instance_:String;
      
      public var callback_:Function;
      
      private var logger:ILogger;
      
      public function RemoteTexture(param1:String, param2:String, param3:Function)
      {
         super();
         this.id_ = param1;
         this.instance_ = param2;
         this.callback_ = param3;
         var _loc4_:Injector = StaticInjectorContext.getInjector();
         this.logger = _loc4_.getInstance(ILogger);
      }
      
      public function run() : void
      {
         var _loc1_:String = this.instance_ == "testing" ? "rotmgtesting.appspot.com" : "realmofthemadgod.appspot.com";
         var _loc2_:String = URL_PATTERN.replace("{DOMAIN}",_loc1_);
         var _loc3_:Object = {};
         _loc3_.id = this.id_;
         _loc3_.time = START_TIME;
         var _loc4_:RetryLoader = new AppEngineRetryLoader();
         _loc4_.setDataFormat(URLLoaderDataFormat.BINARY);
         _loc4_.complete.addOnce(this.onComplete);
         _loc4_.sendRequest(_loc2_,_loc3_);
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         if(param1)
         {
            this.makeTexture(param2);
         }
         else
         {
            this.reportError(param2);
         }
      }
      
      public function makeTexture(param1:ByteArray) : void
      {
         var _loc2_:BitmapData = PNGDecoder.decodeImage(param1);
         this.callback_(_loc2_);
      }
      
      public function reportError(param1:String) : void
      {
         param1 = ERROR_PATTERN.replace("{ERROR}",param1).replace("{ID}",this.id_).replace("{INSTANCE}",this.instance_);
         this.logger.warn("RemoteTexture.reportError: {0}",[param1]);
         var _loc2_:BitmapData = new BitmapDataSpy(1,1);
         this.callback_(_loc2_);
      }
   }
}

