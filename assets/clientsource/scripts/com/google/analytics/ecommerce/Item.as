package com.google.analytics.ecommerce
{
   import com.google.analytics.utils.Variables;
   
   public class Item
   {
      
      private var _price:String;
      
      private var _id:String;
      
      private var _sku:String;
      
      private var _category:String;
      
      private var _quantity:String;
      
      private var _name:String;
      
      public function Item(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String)
      {
         super();
         this._id = param1;
         this._sku = param2;
         this._name = param3;
         this._category = param4;
         this._price = param5;
         this._quantity = param6;
      }
      
      public function set sku(param1:String) : void
      {
         _sku = param1;
      }
      
      public function get price() : String
      {
         return _price;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function get quantity() : String
      {
         return _quantity;
      }
      
      public function set name(param1:String) : void
      {
         _name = param1;
      }
      
      public function set price(param1:String) : void
      {
         _price = param1;
      }
      
      public function get id() : String
      {
         return _id;
      }
      
      public function get sku() : String
      {
         return _sku;
      }
      
      public function set quantity(param1:String) : void
      {
         _quantity = param1;
      }
      
      public function toGifParams() : Variables
      {
         var _loc1_:Variables = new Variables();
         _loc1_.URIencode = true;
         _loc1_.post = ["utmt","utmtid","utmipc","utmipn","utmiva","utmipr","utmiqt"];
         _loc1_.utmt = "item";
         _loc1_.utmtid = _id;
         _loc1_.utmipc = _sku;
         _loc1_.utmipn = _name;
         _loc1_.utmiva = _category;
         _loc1_.utmipr = _price;
         _loc1_.utmiqt = _quantity;
         return _loc1_;
      }
      
      public function set id(param1:String) : void
      {
         _id = param1;
      }
      
      public function set category(param1:String) : void
      {
         _category = param1;
      }
      
      public function get category() : String
      {
         return _category;
      }
   }
}

