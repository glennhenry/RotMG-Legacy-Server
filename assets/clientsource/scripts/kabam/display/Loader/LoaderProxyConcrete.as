package kabam.display.Loader
{
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import kabam.display.LoaderInfo.LoaderInfoProxy;
   import kabam.display.LoaderInfo.LoaderInfoProxyConcrete;
   
   public class LoaderProxyConcrete extends LoaderProxy
   {
      
      private var loader:Loader = addChild(new Loader()) as Loader;
      
      private var _contentLoaderInfo:LoaderInfoProxy;
      
      public function LoaderProxyConcrete()
      {
         super();
      }
      
      override public function get content() : DisplayObject
      {
         return this.loader.content;
      }
      
      override public function get contentLoaderInfo() : LoaderInfoProxy
      {
         if(this._contentLoaderInfo == null)
         {
            this._contentLoaderInfo = new LoaderInfoProxyConcrete();
            this._contentLoaderInfo.loaderInfo = this.loader.contentLoaderInfo;
         }
         return this._contentLoaderInfo;
      }
      
      override public function load(param1:URLRequest, param2:LoaderContext = null) : void
      {
         this.loader.load(param1,param2);
      }
      
      override public function unload() : void
      {
         this.loader.unload();
      }
   }
}

