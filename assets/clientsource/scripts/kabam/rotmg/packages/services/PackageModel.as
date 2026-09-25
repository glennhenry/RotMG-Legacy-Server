package kabam.rotmg.packages.services
{
   import kabam.rotmg.packages.model.*;
   import org.osflash.signals.Signal;
   
   public class PackageModel
   {
      
      public var numSpammed:int = 0;
      
      public var dataChanged:Signal = new Signal();
      
      private var models:Object;
      
      private var initialized:Boolean;
      
      public function PackageModel()
      {
         super();
      }
      
      public function getInitialized() : Boolean
      {
         return this.initialized;
      }
      
      public function getPackageById(param1:int) : PackageInfo
      {
         return this.models[param1];
      }
      
      public function hasPackage(param1:int) : Boolean
      {
         return param1 in this.models;
      }
      
      public function setPackages(param1:Array) : void
      {
         var _loc2_:PackageInfo = null;
         this.models = {};
         for each(_loc2_ in param1)
         {
            _loc2_.dataChanged.add(this.onDataChanged);
            this.models[_loc2_.packageID] = _loc2_;
         }
         this.initialized = true;
         this.dataChanged.dispatch();
      }
      
      private function onDataChanged() : void
      {
         this.dataChanged.dispatch();
      }
      
      public function canPurchasePackage(param1:int) : Boolean
      {
         var _loc2_:PackageInfo = this.models[param1];
         return Boolean(_loc2_) && _loc2_.canPurchase();
      }
      
      public function getPriorityPackage() : PackageInfo
      {
         var _loc2_:PackageInfo = null;
         var _loc1_:PackageInfo = null;
         for each(_loc2_ in this.models)
         {
            if(_loc1_ == null || _loc2_.priority < _loc1_.priority)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc2_;
      }
      
      public function shouldSpam() : Boolean
      {
         return this.numSpammed == 0 && "production".toLowerCase() != "localhost";
      }
      
      public function hasPackages() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:* = this.models;
         for each(_loc1_ in _loc3_)
         {
            return true;
         }
         return false;
      }
   }
}

