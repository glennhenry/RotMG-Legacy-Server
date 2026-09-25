package com.company.util
{
   public class Extents2D
   {
      
      public var minX_:Number;
      
      public var minY_:Number;
      
      public var maxX_:Number;
      
      public var maxY_:Number;
      
      public function Extents2D()
      {
         super();
         this.clear();
      }
      
      public function add(param1:Number, param2:Number) : void
      {
         if(param1 < this.minX_)
         {
            this.minX_ = param1;
         }
         if(param2 < this.minY_)
         {
            this.minY_ = param2;
         }
         if(param1 > this.maxX_)
         {
            this.maxX_ = param1;
         }
         if(param2 > this.maxY_)
         {
            this.maxY_ = param2;
         }
      }
      
      public function clear() : void
      {
         this.minX_ = Number.MAX_VALUE;
         this.minY_ = Number.MAX_VALUE;
         this.maxX_ = Number.MIN_VALUE;
         this.maxY_ = Number.MIN_VALUE;
      }
      
      public function toString() : String
      {
         return "min:(" + this.minX_ + ", " + this.minY_ + ") max:(" + this.maxX_ + ", " + this.maxY_ + ")";
      }
   }
}

