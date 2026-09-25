package com.company.util
{
   public class Random
   {
      
      public var seed:uint;
      
      public function Random(param1:uint = 1)
      {
         super();
         this.seed = param1;
      }
      
      public static function randomSeed() : uint
      {
         return Math.round(Math.random() * (uint.MAX_VALUE - 1) + 1);
      }
      
      public function nextInt() : uint
      {
         return this.gen();
      }
      
      public function nextDouble() : Number
      {
         return this.gen() / 2147483647;
      }
      
      public function nextNormal(param1:Number = 0, param2:Number = 1) : Number
      {
         var _loc3_:Number = this.gen() / 2147483647;
         var _loc4_:Number = this.gen() / 2147483647;
         var _loc5_:Number = Math.sqrt(-2 * Math.log(_loc3_)) * Math.cos(2 * _loc4_ * Math.PI);
         return param1 + _loc5_ * param2;
      }
      
      public function nextIntRange(param1:uint, param2:uint) : uint
      {
         return param1 == param2 ? param1 : uint(param1 + this.gen() % (param2 - param1));
      }
      
      public function nextDoubleRange(param1:Number, param2:Number) : Number
      {
         return param1 + (param2 - param1) * this.nextDouble();
      }
      
      private function gen() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = 16807 * (this.seed & 0xFFFF);
         _loc1_ = 16807 * (this.seed >> 16);
         _loc2_ += (_loc1_ & 0x7FFF) << 16;
         _loc2_ += _loc1_ >> 15;
         if(_loc2_ > 2147483647)
         {
            _loc2_ -= 2147483647;
         }
         return this.seed = _loc2_;
      }
   }
}

