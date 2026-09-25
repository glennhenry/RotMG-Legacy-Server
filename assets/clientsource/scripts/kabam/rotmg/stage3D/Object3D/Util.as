package kabam.rotmg.stage3D.Object3D
{
   import flash.geom.Matrix3D;
   import flash.utils.ByteArray;
   
   public class Util
   {
      
      public function Util()
      {
         super();
      }
      
      public static function perspectiveProjection(param1:Number = 90, param2:Number = 1, param3:Number = 1, param4:Number = 2048) : Matrix3D
      {
         var _loc5_:Number = param3 * Math.tan(param1 * Math.PI / 360);
         var _loc6_:Number = -_loc5_;
         var _loc7_:Number = _loc6_ * param2;
         var _loc8_:Number = _loc5_ * param2;
         var _loc9_:Number = 2 * param3 / (_loc8_ - _loc7_);
         var _loc10_:Number = 2 * param3 / (_loc5_ - _loc6_);
         var _loc11_:Number = (_loc8_ + _loc7_) / (_loc8_ - _loc7_);
         var _loc12_:Number = (_loc5_ + _loc6_) / (_loc5_ - _loc6_);
         var _loc13_:Number = -(param4 + param3) / (param4 - param3);
         var _loc14_:Number = -2 * (param4 * param3) / (param4 - param3);
         return new Matrix3D(Vector.<Number>([_loc9_,0,0,0,0,_loc10_,0,0,_loc11_,_loc12_,_loc13_,-1,0,0,_loc14_,0]));
      }
      
      public static function readString(param1:ByteArray, param2:int) : String
      {
         var _loc5_:uint = 0;
         var _loc3_:String = "";
         var _loc4_:int = 0;
         while(_loc4_ < param2)
         {
            _loc5_ = param1.readUnsignedByte();
            if(_loc5_ === 0)
            {
               param1.position += Math.max(0,param2 - (_loc4_ + 1));
               break;
            }
            _loc3_ += String.fromCharCode(_loc5_);
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function upperPowerOfTwo(param1:uint) : uint
      {
         param1--;
         param1 |= param1 >> 1;
         param1 |= param1 >> 2;
         param1 |= param1 >> 4;
         param1 |= param1 >> 8;
         param1 |= param1 >> 16;
         param1++;
         return param1;
      }
   }
}

