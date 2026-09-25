package com.company.assembleegameclient.engine3d
{
   public class ModelFace3D
   {
      
      public var model_:Model3D;
      
      public var indicies_:Vector.<int>;
      
      public var useTexture_:Boolean;
      
      public function ModelFace3D(param1:Model3D, param2:Vector.<int>, param3:Boolean)
      {
         super();
         this.model_ = param1;
         this.indicies_ = param2;
         this.useTexture_ = param3;
      }
      
      public static function compare(param1:ModelFace3D, param2:ModelFace3D) : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:Number = Number.MAX_VALUE;
         var _loc6_:Number = Number.MIN_VALUE;
         _loc4_ = 0;
         while(_loc4_ < param1.indicies_.length)
         {
            _loc3_ = param2.model_.vL_[param1.indicies_[_loc4_] * 3 + 2];
            _loc5_ = _loc3_ < _loc5_ ? _loc3_ : _loc5_;
            _loc6_ = _loc3_ > _loc6_ ? _loc3_ : _loc6_;
            _loc4_++;
         }
         var _loc7_:Number = Number.MAX_VALUE;
         var _loc8_:Number = Number.MIN_VALUE;
         _loc4_ = 0;
         while(_loc4_ < param2.indicies_.length)
         {
            _loc3_ = param2.model_.vL_[param2.indicies_[_loc4_] * 3 + 2];
            _loc7_ = _loc3_ < _loc7_ ? _loc3_ : _loc7_;
            _loc8_ = _loc3_ > _loc8_ ? _loc3_ : _loc8_;
            _loc4_++;
         }
         if(_loc7_ > _loc5_)
         {
            return -1;
         }
         if(_loc7_ < _loc5_)
         {
            return 1;
         }
         if(_loc8_ > _loc6_)
         {
            return -1;
         }
         if(_loc8_ < _loc6_)
         {
            return 1;
         }
         return 0;
      }
   }
}

