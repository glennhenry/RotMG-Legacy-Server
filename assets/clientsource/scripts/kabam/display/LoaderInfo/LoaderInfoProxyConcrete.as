package kabam.display.LoaderInfo
{
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class LoaderInfoProxyConcrete extends EventDispatcher implements LoaderInfoProxy
   {
      
      private var _loaderInfo:LoaderInfo;
      
      public function LoaderInfoProxyConcrete()
      {
         super();
      }
      
      override public function toString() : String
      {
         return this._loaderInfo.toString();
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._loaderInfo.addEventListener(param1,param2,param3,param4,param5);
      }
      
      override public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._loaderInfo.removeEventListener(param1,param2,param3);
      }
      
      override public function dispatchEvent(param1:Event) : Boolean
      {
         return this._loaderInfo.dispatchEvent(param1);
      }
      
      override public function hasEventListener(param1:String) : Boolean
      {
         return this._loaderInfo.hasEventListener(param1);
      }
      
      override public function willTrigger(param1:String) : Boolean
      {
         return this._loaderInfo.willTrigger(param1);
      }
      
      public function set loaderInfo(param1:LoaderInfo) : void
      {
         this._loaderInfo = param1;
      }
   }
}

