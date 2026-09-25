package kabam.rotmg.mysterybox.model
{
   import com.company.assembleegameclient.util.TimeUtil;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   import kabam.display.Loader.LoaderProxy;
   import kabam.display.Loader.LoaderProxyConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class MysteryBoxInfo
   {
      
      public static var chestImageEmbed:Class = MysteryBoxInfo_chestImageEmbed;
      
      public var _id:String;
      
      public var _title:String;
      
      private var _description:String;
      
      public var _weight:String;
      
      public var _contents:String;
      
      public var _priceAmount:String;
      
      public var _priceCurrency:String;
      
      public var _saleAmount:String;
      
      public var _saleCurrency:String;
      
      public var _quantity:String;
      
      public var _saleEnd:Date;
      
      public var _iconImageUrl:String;
      
      private var _iconImage:DisplayObject;
      
      public var _infoImageUrl:String;
      
      private var _infoImage:DisplayObject;
      
      public var _startTime:Date;
      
      public var _endTime:Date;
      
      private var _loader:LoaderProxy = new LoaderProxyConcrete();
      
      private var _infoImageLoader:LoaderProxy = new LoaderProxyConcrete();
      
      public var _rollsWithContents:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
      
      public var _rollsWithContentsUnique:Vector.<int> = new Vector.<int>();
      
      public function MysteryBoxInfo()
      {
         super();
      }
      
      public function get id() : *
      {
         return this._id;
      }
      
      public function set id(param1:String) : void
      {
         this._id = param1;
      }
      
      public function get title() : *
      {
         return this._title;
      }
      
      public function set title(param1:String) : void
      {
         this._title = param1;
      }
      
      public function get description() : *
      {
         return this._description;
      }
      
      public function set description(param1:String) : void
      {
         this._description = param1;
      }
      
      public function get weight() : *
      {
         return this._weight;
      }
      
      public function set weight(param1:String) : void
      {
         this._weight = param1;
      }
      
      public function get contents() : *
      {
         return this._contents;
      }
      
      public function set contents(param1:String) : void
      {
         this._contents = param1;
      }
      
      public function get priceAmount() : *
      {
         return this._priceAmount;
      }
      
      public function set priceAmount(param1:String) : void
      {
         this._priceAmount = param1;
      }
      
      public function get priceCurrency() : *
      {
         return this._priceCurrency;
      }
      
      public function set priceCurrency(param1:String) : void
      {
         this._priceCurrency = param1;
      }
      
      public function get saleAmount() : *
      {
         return this._saleAmount;
      }
      
      public function set saleAmount(param1:String) : void
      {
         this._saleAmount = param1;
      }
      
      public function get saleCurrency() : *
      {
         return this._saleCurrency;
      }
      
      public function set saleCurrency(param1:String) : void
      {
         this._saleCurrency = param1;
      }
      
      public function get quantity() : *
      {
         return this._quantity;
      }
      
      public function set quantity(param1:String) : void
      {
         this._quantity = param1;
      }
      
      public function get saleEnd() : *
      {
         return this._saleEnd;
      }
      
      public function set saleEnd(param1:Date) : void
      {
         this._saleEnd = param1;
      }
      
      public function get iconImageUrl() : *
      {
         return this._iconImageUrl;
      }
      
      public function set iconImageUrl(param1:String) : void
      {
         this._iconImageUrl = param1;
         this.loadIconImageFromUrl(this._iconImageUrl);
      }
      
      private function loadIconImageFromUrl(param1:String) : void
      {
         this._loader && this._loader.unload();
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.DISK_ERROR,this.onError);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR,this.onError);
         this._loader.load(new URLRequest(param1));
      }
      
      private function onError(param1:IOErrorEvent) : void
      {
         this._iconImage = new chestImageEmbed();
      }
      
      private function onComplete(param1:Event) : void
      {
         this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
         this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
         this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.DISK_ERROR,this.onError);
         this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.onError);
         this._iconImage = DisplayObject(this._loader);
      }
      
      public function get iconImage() : DisplayObject
      {
         return this._iconImage;
      }
      
      public function get infoImageUrl() : *
      {
         return this._infoImageUrl;
      }
      
      public function set infoImageUrl(param1:String) : void
      {
         this._infoImageUrl = param1;
         this.loadInfomageFromUrl(this._infoImageUrl);
      }
      
      private function loadInfomageFromUrl(param1:String) : void
      {
         this.loadImageFromUrl(param1,this._infoImageLoader);
      }
      
      private function loadImageFromUrl(param1:String, param2:LoaderProxy) : void
      {
         param2 && param2.unload();
         param2.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onInfoComplete);
         param2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onInfoError);
         param2.contentLoaderInfo.addEventListener(IOErrorEvent.DISK_ERROR,this.onInfoError);
         param2.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR,this.onInfoError);
         param2.load(new URLRequest(param1));
      }
      
      private function onInfoError(param1:IOErrorEvent) : void
      {
      }
      
      private function onInfoComplete(param1:Event) : void
      {
         this._infoImageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onInfoComplete);
         this._infoImageLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onInfoError);
         this._infoImageLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.DISK_ERROR,this.onInfoError);
         this._infoImageLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.onInfoError);
         this._infoImage = DisplayObject(this._infoImageLoader);
      }
      
      public function get startTime() : *
      {
         return this._startTime;
      }
      
      public function set startTime(param1:Date) : void
      {
         this._startTime = param1;
      }
      
      public function get endTime() : *
      {
         return this._endTime;
      }
      
      public function set endTime(param1:Date) : void
      {
         this._endTime = param1;
      }
      
      public function parseContents() : void
      {
         var _loc3_:String = null;
         var _loc4_:Vector.<int> = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc1_:Array = this._contents.split(";");
         var _loc2_:Dictionary = new Dictionary();
         for each(_loc3_ in _loc1_)
         {
            _loc4_ = new Vector.<int>();
            _loc5_ = _loc3_.split(",");
            for each(_loc6_ in _loc5_)
            {
               if(_loc2_[int(_loc6_)] == null)
               {
                  _loc2_[int(_loc6_)] = true;
                  this._rollsWithContentsUnique.push(int(_loc6_));
               }
               _loc4_.push(int(_loc6_));
            }
            this._rollsWithContents.push(_loc4_);
         }
      }
      
      public function isNew() : Boolean
      {
         var _loc1_:Date = new Date();
         return Math.ceil(TimeUtil.secondsToDays((_loc1_.time - this._startTime.time) / 1000)) <= 1;
      }
      
      public function isOnSale() : Boolean
      {
         var _loc1_:Date = null;
         if(this._saleEnd)
         {
            _loc1_ = new Date();
            return _loc1_.time < this._saleEnd.time;
         }
         return false;
      }
      
      public function getSaleTimeLeftStringBuilder() : LineBuilder
      {
         var _loc1_:Date = new Date();
         var _loc3_:Number = (this._saleEnd.time - _loc1_.time) / 1000;
         var _loc4_:LineBuilder = new LineBuilder();
         if(_loc3_ > TimeUtil.DAY_IN_S)
         {
            _loc4_.setParams("MysteryBoxInfo.saleEndStringDays",{"amount":String(Math.ceil(TimeUtil.secondsToDays(_loc3_)))});
         }
         else if(_loc3_ > TimeUtil.HOUR_IN_S)
         {
            _loc4_.setParams("MysteryBoxInfo.saleEndStringHours",{"amount":String(Math.ceil(TimeUtil.secondsToHours(_loc3_)))});
         }
         else
         {
            _loc4_.setParams("MysteryBoxInfo.saleEndStringMinutes",{"amount":String(Math.ceil(TimeUtil.secondsToMins(_loc3_)))});
         }
         return _loc4_;
      }
      
      public function get infoImage() : DisplayObject
      {
         return this._infoImage;
      }
      
      public function set infoImage(param1:DisplayObject) : void
      {
         this._infoImage = param1;
      }
      
      public function get loader() : LoaderProxy
      {
         return this._loader;
      }
      
      public function set loader(param1:LoaderProxy) : void
      {
         this._loader = param1;
      }
      
      public function get infoImageLoader() : LoaderProxy
      {
         return this._infoImageLoader;
      }
      
      public function set infoImageLoader(param1:LoaderProxy) : void
      {
         this._infoImageLoader = param1;
      }
   }
}

