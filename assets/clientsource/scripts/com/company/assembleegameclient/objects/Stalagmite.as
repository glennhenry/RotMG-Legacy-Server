package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.engine3d.Object3D;
   import com.company.assembleegameclient.engine3d.ObjectFace3D;
   
   public class Stalagmite extends GameObject
   {
      
      private static const bs:Number = Math.PI / 6;
      
      private static const cs:Number = Math.PI / 3;
      
      public function Stalagmite(param1:XML)
      {
         super(param1);
         var _loc2_:Number = bs + cs * Math.random();
         var _loc3_:Number = 2 * cs + bs + cs * Math.random();
         var _loc4_:Number = 4 * cs + bs + cs * Math.random();
         obj3D_ = new Object3D();
         obj3D_.vL_.push(Math.cos(_loc2_) * 0.3,Math.sin(_loc2_) * 0.3,0,Math.cos(_loc3_) * 0.3,Math.sin(_loc3_) * 0.3,0,Math.cos(_loc4_) * 0.3,Math.sin(_loc4_) * 0.3,0,0,0,0.6 + 0.6 * Math.random());
         obj3D_.faces_.push(new ObjectFace3D(obj3D_,new <int>[0,1,3]),new ObjectFace3D(obj3D_,new <int>[1,2,3]),new ObjectFace3D(obj3D_,new <int>[2,0,3]));
         obj3D_.uvts_.push(0,1,0,0.5,1,0,1,1,0,0.5,0,0);
      }
   }
}

