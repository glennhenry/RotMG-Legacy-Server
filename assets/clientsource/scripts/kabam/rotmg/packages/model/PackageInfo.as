package kabam.rotmg.packages.model
{
   import com.company.assembleegameclient.util.TimeUtil;
   import org.osflash.signals.Signal;
   
   public class PackageInfo
   {
      
      public static const INFINITE:int = -1;
      
      private var _initialized:Boolean = false;
      
      public var dataChanged:Signal = new Signal();
      
      public var packageIDChanged:Signal = new Signal(int);
      
      public var endDateChanged:Signal = new Signal(Date);
      
      public var durationChanged:Signal = new Signal(int);
      
      public var nameChanged:Signal = new Signal(String);
      
      public var quantityChanged:Signal = new Signal(int);
      
      public var maxChanged:Signal = new Signal(int);
      
      public var priceChanged:Signal = new Signal(int);
      
      public var imageURLChanged:Signal = new Signal(String);
      
      private var _packageID:int;
      
      private var _endDate:Date;
      
      private var _name:String;
      
      private var _quantity:int;
      
      private var _max:int;
      
      private var _price:int;
      
      private var _imageURL:String;
      
      private var _priority:int;
      
      private var _numPurchased:int;
      
      public function PackageInfo()
      {
         super();
      }
      
      public function setData(param1:int, param2:Date, param3:String, param4:int, param5:int, param6:int, param7:int, param8:String, param9:int) : void
      {
         this._packageID = param1;
         this._endDate = param2;
         this._name = param3;
         this._quantity = param4;
         this._max = param5;
         this._priority = param6;
         this._price = param7;
         this._imageURL = param8;
         this._numPurchased = param9;
         this._initialized = true;
         this.dataChanged.dispatch();
      }
      
      public function getDuration() : int
      {
         var _loc1_:Date = new Date();
         return this._endDate.time - _loc1_.time;
      }
      
      public function getDaysRemaining() : Number
      {
         return Math.ceil(TimeUtil.secondsToDays(this.getDuration() / 1000));
      }
      
      public function get quantity() : int
      {
         return this._quantity;
      }
      
      public function set quantity(param1:int) : void
      {
         this._quantity = param1;
         this.quantityChanged.dispatch(param1);
      }
      
      public function get priority() : int
      {
         return this._priority;
      }
      
      public function set priority(param1:int) : void
      {
         this._priority = param1;
      }
      
      public function get packageID() : int
      {
         return this._packageID;
      }
      
      public function set packageID(param1:int) : void
      {
         this._packageID = param1;
         this.packageIDChanged.dispatch(param1);
      }
      
      public function get endDate() : Date
      {
         return this._endDate;
      }
      
      public function set endDate(param1:Date) : void
      {
         this._endDate = param1;
         this.endDateChanged.dispatch(param1);
         this.durationChanged.dispatch(this.getDuration());
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
         this.nameChanged.dispatch(param1);
      }
      
      public function get max() : int
      {
         return this._max;
      }
      
      public function set max(param1:int) : void
      {
         this._max = param1;
         this.maxChanged.dispatch(param1);
      }
      
      public function get price() : int
      {
         return this._price;
      }
      
      public function set price(param1:int) : void
      {
         this._price = param1;
         this.priceChanged.dispatch(param1);
      }
      
      public function get imageURL() : String
      {
         return this._imageURL;
      }
      
      public function get numPurchased() : int
      {
         return this._numPurchased;
      }
      
      public function set numPurchased(param1:int) : void
      {
         this._numPurchased = param1;
      }
      
      public function hasPurchased() : Boolean
      {
         return this._numPurchased > 0;
      }
      
      public function canPurchase() : Boolean
      {
         if(this.max == INFINITE)
         {
            return true;
         }
         return this._numPurchased < this._max;
      }
      
      public function toString() : String
      {
         return "[Package name=" + this._name + ", packageId=" + this._packageID + "]";
      }
   }
}

