package robotlegs.bender.framework.impl
{
   import org.hamcrest.Matcher;
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.framework.api.IContext;
   import robotlegs.bender.framework.api.ILifecycle;
   import robotlegs.bender.framework.api.ILogTarget;
   import robotlegs.bender.framework.api.ILogger;
   
   public class Context implements IContext
   {
      
      private const _injector:Injector = new Injector();
      
      private var _lifecycle:Lifecycle;
      
      private const _uid:String = UID.create(Context);
      
      private const _logManager:LogManager = new LogManager();
      
      private const _pin:Pin = new Pin();
      
      private var _configManager:ConfigManager;
      
      private var _extensionInstaller:ExtensionInstaller;
      
      private var _logger:ILogger;
      
      public function Context()
      {
         super();
         this.setup();
      }
      
      public function get injector() : Injector
      {
         return this._injector;
      }
      
      public function get logLevel() : uint
      {
         return this._logManager.logLevel;
      }
      
      public function set logLevel(param1:uint) : void
      {
         this._logManager.logLevel = param1;
      }
      
      public function get lifecycle() : ILifecycle
      {
         return this._lifecycle;
      }
      
      public function initialize() : void
      {
         this._lifecycle.initialize();
      }
      
      public function destroy() : void
      {
         this._lifecycle.destroy();
      }
      
      public function extend(... rest) : IContext
      {
         var _loc2_:Object = null;
         for each(_loc2_ in rest)
         {
            this._extensionInstaller.install(_loc2_);
         }
         return this;
      }
      
      public function configure(... rest) : IContext
      {
         var _loc2_:Object = null;
         for each(_loc2_ in rest)
         {
            this._configManager.addConfig(_loc2_);
         }
         return this;
      }
      
      public function addConfigHandler(param1:Matcher, param2:Function) : IContext
      {
         this._configManager.addConfigHandler(param1,param2);
         return this;
      }
      
      public function getLogger(param1:Object) : ILogger
      {
         return this._logManager.getLogger(param1);
      }
      
      public function addLogTarget(param1:ILogTarget) : IContext
      {
         this._logManager.addLogTarget(param1);
         return this;
      }
      
      public function detain(... rest) : IContext
      {
         var _loc2_:Object = null;
         for each(_loc2_ in rest)
         {
            this._pin.detain(_loc2_);
         }
         return this;
      }
      
      public function release(... rest) : IContext
      {
         var _loc2_:Object = null;
         for each(_loc2_ in rest)
         {
            this._pin.release(_loc2_);
         }
         return this;
      }
      
      public function toString() : String
      {
         return this._uid;
      }
      
      private function setup() : void
      {
         this._injector.map(Injector).toValue(this._injector);
         this._injector.map(IContext).toValue(this);
         this._logger = this._logManager.getLogger(this);
         this._lifecycle = new Lifecycle(this);
         this._configManager = new ConfigManager(this);
         this._extensionInstaller = new ExtensionInstaller(this);
         this._lifecycle.beforeInitializing(this.beforeInitializing);
         this._lifecycle.afterInitializing(this.afterInitializing);
         this._lifecycle.beforeDestroying(this.beforeDestroying);
         this._lifecycle.afterDestroying(this.afterDestroying);
      }
      
      private function beforeInitializing() : void
      {
         this._logger.info("Initializing...");
      }
      
      private function afterInitializing() : void
      {
         this._logger.info("Initialize complete");
      }
      
      private function beforeDestroying() : void
      {
         this._logger.info("Destroying...");
      }
      
      private function afterDestroying() : void
      {
         this._pin.flush();
         this._injector.teardown();
         this._logger.info("Destroy complete");
      }
   }
}

