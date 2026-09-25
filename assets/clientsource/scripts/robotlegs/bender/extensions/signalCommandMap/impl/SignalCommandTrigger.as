package robotlegs.bender.extensions.signalCommandMap.impl
{
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   import org.osflash.signals.ISignal;
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
   import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
   import robotlegs.bender.framework.impl.applyHooks;
   import robotlegs.bender.framework.impl.guardsApprove;
   
   public class SignalCommandTrigger implements ICommandTrigger
   {
      
      private const _mappings:Vector.<ICommandMapping> = new Vector.<ICommandMapping>();
      
      private var _signal:ISignal;
      
      private var _signalClass:Class;
      
      private var _once:Boolean;
      
      protected var _injector:Injector;
      
      protected var _signalMap:Dictionary;
      
      protected var _verifiedCommandClasses:Dictionary;
      
      public function SignalCommandTrigger(param1:Injector, param2:Class, param3:Boolean = false)
      {
         super();
         this._injector = param1;
         this._signalClass = param2;
         this._once = param3;
         this._signalMap = new Dictionary(false);
         this._verifiedCommandClasses = new Dictionary(false);
      }
      
      public function addMapping(param1:ICommandMapping) : void
      {
         this.verifyCommandClass(param1);
         this._mappings.push(param1);
         if(this._mappings.length == 1)
         {
            this.addSignal(param1.commandClass);
         }
      }
      
      public function removeMapping(param1:ICommandMapping) : void
      {
         var _loc2_:int = this._mappings.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._mappings.splice(_loc2_,1);
            if(this._mappings.length == 0)
            {
               this.removeSignal(param1.commandClass);
            }
         }
      }
      
      protected function verifyCommandClass(param1:ICommandMapping) : void
      {
         var mapping:ICommandMapping = param1;
         if(this._verifiedCommandClasses[mapping.commandClass])
         {
            return;
         }
         if(describeType(mapping.commandClass).factory.method.(@name == "execute").length() == 0)
         {
            throw new Error("Command Class must expose an execute method");
         }
         this._verifiedCommandClasses[mapping.commandClass] = true;
      }
      
      protected function routeSignalToCommand(param1:ISignal, param2:Array, param3:Class, param4:Boolean) : void
      {
         var _loc6_:ICommandMapping = null;
         var _loc7_:Boolean = false;
         var _loc8_:Object = null;
         var _loc5_:Vector.<ICommandMapping> = this._mappings.concat();
         for each(_loc6_ in _loc5_)
         {
            this.mapSignalValues(param1.valueClasses,param2);
            _loc7_ = guardsApprove(_loc6_.guards,this._injector);
            if(_loc7_)
            {
               this._once && this.removeMapping(_loc6_);
               this._injector.map(_loc6_.commandClass).asSingleton();
               _loc8_ = this._injector.getInstance(_loc6_.commandClass);
               applyHooks(_loc6_.hooks,this._injector);
               this._injector.unmap(_loc6_.commandClass);
            }
            this.unmapSignalValues(param1.valueClasses,param2);
            if(_loc7_)
            {
               _loc8_.execute();
            }
         }
         if(this._once)
         {
            this.removeSignal(param3);
         }
      }
      
      protected function mapSignalValues(param1:Array, param2:Array) : void
      {
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            this._injector.map(param1[_loc3_]).toValue(param2[_loc3_]);
            _loc3_++;
         }
      }
      
      protected function unmapSignalValues(param1:Array, param2:Array) : void
      {
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            this._injector.unmap(param1[_loc3_]);
            _loc3_++;
         }
      }
      
      protected function hasSignalCommand(param1:ISignal, param2:Class) : Boolean
      {
         var _loc3_:Dictionary = this._signalMap[param1];
         if(_loc3_ == null)
         {
            return false;
         }
         var _loc4_:Function = _loc3_[param2];
         return _loc4_ != null;
      }
      
      private function addSignal(param1:Class) : void
      {
         var signalCommandMap:Dictionary;
         var callback:Function;
         var commandClass:Class = param1;
         if(this.hasSignalCommand(this._signal,commandClass))
         {
            return;
         }
         this._signal = this._injector.getInstance(this._signalClass);
         this._injector.map(this._signalClass).toValue(this._signal);
         signalCommandMap = this._signalMap[this._signal] = this._signalMap[this._signal] || new Dictionary(false);
         callback = function():void
         {
            routeSignalToCommand(_signal,arguments,commandClass,_once);
         };
         signalCommandMap[commandClass] = callback;
         this._signal.add(callback);
      }
      
      private function removeSignal(param1:Class) : void
      {
         var _loc2_:Dictionary = this._signalMap[this._signal];
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:Function = _loc2_[param1];
         if(_loc3_ == null)
         {
            return;
         }
         this._signal.remove(_loc3_);
         delete _loc2_[param1];
      }
   }
}

