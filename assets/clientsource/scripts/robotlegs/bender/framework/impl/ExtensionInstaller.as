package robotlegs.bender.framework.impl
{
   import flash.utils.Dictionary;
   import org.swiftsuspenders.reflection.DescribeTypeReflector;
   import org.swiftsuspenders.reflection.Reflector;
   import robotlegs.bender.framework.api.IContext;
   import robotlegs.bender.framework.api.ILogger;
   
   public class ExtensionInstaller
   {
      
      private const _uid:String = UID.create(ExtensionInstaller);
      
      private const _classes:Dictionary = new Dictionary(true);
      
      private const _reflector:Reflector = new DescribeTypeReflector();
      
      private var _context:IContext;
      
      private var _logger:ILogger;
      
      public function ExtensionInstaller(param1:IContext)
      {
         super();
         this._context = param1;
         this._logger = this._context.getLogger(this);
      }
      
      public function install(param1:Object) : void
      {
         var _loc2_:Class = null;
         if(param1 is Class)
         {
            this._classes[param1] || this.install(new (param1 as Class)());
         }
         else
         {
            _loc2_ = this._reflector.getClass(param1);
            if(this._classes[_loc2_])
            {
               return;
            }
            this._logger.debug("Installing extension {0}",[param1]);
            this._classes[_loc2_] = true;
            param1.extend(this._context);
         }
      }
      
      public function toString() : String
      {
         return this._uid;
      }
   }
}

