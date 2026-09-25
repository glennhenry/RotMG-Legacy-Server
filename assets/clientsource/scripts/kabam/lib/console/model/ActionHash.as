package kabam.lib.console.model
{
   import org.osflash.signals.Signal;
   
   internal final class ActionHash
   {
      
      private var signalMap:Object;
      
      private var descriptionMap:Object;
      
      public function ActionHash()
      {
         super();
         this.signalMap = {};
         this.descriptionMap = {};
      }
      
      public function register(param1:String, param2:String, param3:Signal) : void
      {
         this.signalMap[param1] = param3;
         this.descriptionMap[param1] = param2;
      }
      
      public function getNames() : Vector.<String>
      {
         var _loc2_:String = null;
         var _loc1_:Vector.<String> = new Vector.<String>(0);
         for(_loc2_ in this.signalMap)
         {
            _loc1_.push(_loc2_ + " - " + this.descriptionMap[_loc2_]);
         }
         return _loc1_;
      }
      
      public function execute(param1:String) : void
      {
         var _loc2_:Array = param1.split(" ");
         if(_loc2_.length == 0)
         {
            return;
         }
         var _loc3_:String = _loc2_.shift();
         var _loc4_:Signal = this.signalMap[_loc3_];
         if(!_loc4_)
         {
            return;
         }
         if(_loc2_.length > 0)
         {
            _loc4_.dispatch.apply(this,_loc2_.join(" ").split(","));
         }
         else
         {
            _loc4_.dispatch.apply(this);
         }
      }
      
      public function has(param1:String) : Boolean
      {
         var _loc2_:Array = param1.split(" ");
         return _loc2_.length > 0 && this.signalMap[_loc2_[0]] != null;
      }
   }
}

