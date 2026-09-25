package com.company.util
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Triangle
   {
      
      public var x0_:Number;
      
      public var y0_:Number;
      
      public var x1_:Number;
      
      public var y1_:Number;
      
      public var x2_:Number;
      
      public var y2_:Number;
      
      public var vx1_:Number;
      
      public var vy1_:Number;
      
      public var vx2_:Number;
      
      public var vy2_:Number;
      
      public function Triangle(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number)
      {
         super();
         this.x0_ = param1;
         this.y0_ = param2;
         this.x1_ = param3;
         this.y1_ = param4;
         this.x2_ = param5;
         this.y2_ = param6;
         this.vx1_ = this.x1_ - this.x0_;
         this.vy1_ = this.y1_ - this.y0_;
         this.vx2_ = this.x2_ - this.x0_;
         this.vy2_ = this.y2_ - this.y0_;
      }
      
      public static function containsXY(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Boolean
      {
         var _loc9_:Number = param3 - param1;
         var _loc10_:Number = param4 - param2;
         var _loc11_:Number = param5 - param1;
         var _loc12_:Number = param6 - param2;
         var _loc13_:Number = (param7 * _loc12_ - param8 * _loc11_ - (param1 * _loc12_ - param2 * _loc11_)) / (_loc9_ * _loc12_ - _loc10_ * _loc11_);
         var _loc14_:Number = -(param7 * _loc10_ - param8 * _loc9_ - (param1 * _loc10_ - param2 * _loc9_)) / (_loc9_ * _loc12_ - _loc10_ * _loc11_);
         return _loc13_ >= 0 && _loc14_ >= 0 && _loc13_ + _loc14_ <= 1;
      }
      
      public static function intersectTriAABB(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number) : Boolean
      {
         if(param7 > param1 && param7 > param3 && param7 > param5 || param9 < param1 && param9 < param3 && param9 < param5 || param8 > param2 && param8 > param4 && param8 > param6 || param10 < param2 && param10 < param4 && param10 < param6)
         {
            return false;
         }
         if(param7 < param1 && param1 < param9 && param8 < param2 && param2 < param10 || param7 < param3 && param3 < param9 && param8 < param4 && param4 < param10 || param7 < param5 && param5 < param9 && param8 < param6 && param6 < param10)
         {
            return true;
         }
         return lineRectIntersect(param1,param2,param3,param4,param7,param8,param9,param10) || lineRectIntersect(param3,param4,param5,param6,param7,param8,param9,param10) || lineRectIntersect(param5,param6,param1,param2,param7,param8,param9,param10);
      }
      
      private static function lineRectIntersect(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Boolean
      {
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc9_:Number = (param4 - param2) / (param3 - param1);
         var _loc10_:Number = param2 - _loc9_ * param1;
         if(_loc9_ > 0)
         {
            _loc11_ = _loc9_ * param5 + _loc10_;
            _loc12_ = _loc9_ * param7 + _loc10_;
         }
         else
         {
            _loc11_ = _loc9_ * param7 + _loc10_;
            _loc12_ = _loc9_ * param5 + _loc10_;
         }
         if(param2 < param4)
         {
            _loc13_ = param2;
            _loc14_ = param4;
         }
         else
         {
            _loc13_ = param4;
            _loc14_ = param2;
         }
         var _loc15_:Number = _loc11_ > _loc13_ ? _loc11_ : _loc13_;
         var _loc16_:Number = _loc12_ < _loc14_ ? _loc12_ : _loc14_;
         return _loc15_ < _loc16_ && !(_loc16_ < param6 || _loc15_ > param8);
      }
      
      public function aabb() : Rectangle
      {
         var _loc1_:Number = Math.min(this.x0_,this.x1_,this.x2_);
         var _loc2_:Number = Math.max(this.x0_,this.x1_,this.x2_);
         var _loc3_:Number = Math.min(this.y0_,this.y1_,this.y2_);
         var _loc4_:Number = Math.max(this.y0_,this.y1_,this.y2_);
         return new Rectangle(_loc1_,_loc3_,_loc2_ - _loc1_,_loc4_ - _loc3_);
      }
      
      public function area() : Number
      {
         return Math.abs((this.x0_ * (this.y1_ - this.y2_) + this.x1_ * (this.y2_ - this.y0_) + this.x2_ * (this.y0_ - this.y1_)) / 2);
      }
      
      public function incenter(param1:Point) : void
      {
         var _loc2_:Number = PointUtil.distanceXY(this.x1_,this.y1_,this.x2_,this.y2_);
         var _loc3_:Number = PointUtil.distanceXY(this.x0_,this.y0_,this.x2_,this.y2_);
         var _loc4_:Number = PointUtil.distanceXY(this.x0_,this.y0_,this.x1_,this.y1_);
         param1.x = (_loc2_ * this.x0_ + _loc3_ * this.x1_ + _loc4_ * this.x2_) / (_loc2_ + _loc3_ + _loc4_);
         param1.y = (_loc2_ * this.y0_ + _loc3_ * this.y1_ + _loc4_ * this.y2_) / (_loc2_ + _loc3_ + _loc4_);
      }
      
      public function contains(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:Number = (param1 * this.vy2_ - param2 * this.vx2_ - (this.x0_ * this.vy2_ - this.y0_ * this.vx2_)) / (this.vx1_ * this.vy2_ - this.vy1_ * this.vx2_);
         var _loc4_:Number = -(param1 * this.vy1_ - param2 * this.vx1_ - (this.x0_ * this.vy1_ - this.y0_ * this.vx1_)) / (this.vx1_ * this.vy2_ - this.vy1_ * this.vx2_);
         return _loc3_ >= 0 && _loc4_ >= 0 && _loc3_ + _loc4_ <= 1;
      }
      
      public function distance(param1:Number, param2:Number) : Number
      {
         if(this.contains(param1,param2))
         {
            return 0;
         }
         return Math.min(LineSegmentUtil.pointDistance(param1,param2,this.x0_,this.y0_,this.x1_,this.y1_),LineSegmentUtil.pointDistance(param1,param2,this.x1_,this.y1_,this.x2_,this.y2_),LineSegmentUtil.pointDistance(param1,param2,this.x0_,this.y0_,this.x2_,this.y2_));
      }
      
      public function intersectAABB(param1:Number, param2:Number, param3:Number, param4:Number) : Boolean
      {
         return intersectTriAABB(this.x0_,this.y0_,this.x1_,this.y1_,this.x2_,this.y2_,param1,param2,param3,param4);
      }
   }
}

