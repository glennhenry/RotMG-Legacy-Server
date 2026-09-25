package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.engine3d.ObjectFace3D;
   import com.company.assembleegameclient.parameters.Parameters;
   import flash.display.BitmapData;
   import flash.geom.Vector3D;
   import kabam.rotmg.stage3D.GraphicsFillExtra;
   
   public class CaveWall extends ConnectedObject
   {
      
      public function CaveWall(param1:XML)
      {
         super(param1);
      }
      
      override protected function buildDot() : void
      {
         var _loc6_:ObjectFace3D = null;
         var _loc1_:Vector3D = new Vector3D(-0.25 - Math.random() * 0.25,-0.25 - Math.random() * 0.25,0);
         var _loc2_:Vector3D = new Vector3D(0.25 + Math.random() * 0.25,-0.25 - Math.random() * 0.25,0);
         var _loc3_:Vector3D = new Vector3D(0.25 + Math.random() * 0.25,0.25 + Math.random() * 0.25,0);
         var _loc4_:Vector3D = new Vector3D(-0.25 - Math.random() * 0.25,0.25 + Math.random() * 0.25,0);
         var _loc5_:Vector3D = new Vector3D(-0.25 + Math.random() * 0.5,-0.25 + Math.random() * 0.5,1);
         this.faceHelper(null,texture_,_loc5_,_loc1_,_loc2_);
         this.faceHelper(null,texture_,_loc5_,_loc2_,_loc3_);
         this.faceHelper(null,texture_,_loc5_,_loc3_,_loc4_);
         this.faceHelper(null,texture_,_loc5_,_loc4_,_loc1_);
         if(Parameters.isGpuRender())
         {
            for each(_loc6_ in obj3D_.faces_)
            {
               GraphicsFillExtra.setSoftwareDraw(_loc6_.bitmapFill_,true);
            }
         }
      }
      
      override protected function buildShortLine() : void
      {
         var _loc9_:ObjectFace3D = null;
         var _loc1_:Vector3D = this.getVertex(0,0);
         var _loc2_:Vector3D = this.getVertex(0,3);
         var _loc3_:Vector3D = new Vector3D(0.25 + Math.random() * 0.25,0.25 + Math.random() * 0.25,0);
         var _loc4_:Vector3D = new Vector3D(-0.25 - Math.random() * 0.25,0.25 + Math.random() * 0.25,0);
         var _loc5_:Vector3D = this.getVertex(0,1);
         var _loc6_:Vector3D = this.getVertex(0,2);
         var _loc7_:Vector3D = new Vector3D(Math.random() * 0.25,Math.random() * 0.25,0.5);
         var _loc8_:Vector3D = new Vector3D(Math.random() * -0.25,Math.random() * 0.25,0.5);
         this.faceHelper(null,texture_,_loc5_,_loc8_,_loc4_,_loc1_);
         this.faceHelper(null,texture_,_loc8_,_loc7_,_loc3_,_loc4_);
         this.faceHelper(null,texture_,_loc7_,_loc6_,_loc2_,_loc3_);
         this.faceHelper(null,texture_,_loc5_,_loc6_,_loc7_,_loc8_);
         if(Parameters.isGpuRender())
         {
            for each(_loc9_ in obj3D_.faces_)
            {
               GraphicsFillExtra.setSoftwareDraw(_loc9_.bitmapFill_,true);
            }
         }
      }
      
      override protected function buildL() : void
      {
         var _loc11_:ObjectFace3D = null;
         var _loc1_:Vector3D = this.getVertex(0,0);
         var _loc2_:Vector3D = this.getVertex(0,3);
         var _loc3_:Vector3D = this.getVertex(1,0);
         var _loc4_:Vector3D = this.getVertex(1,3);
         var _loc5_:Vector3D = new Vector3D(-Math.random() * 0.25,Math.random() * 0.25,0);
         var _loc6_:Vector3D = this.getVertex(0,1);
         var _loc7_:Vector3D = this.getVertex(0,2);
         var _loc8_:Vector3D = this.getVertex(1,1);
         var _loc9_:Vector3D = this.getVertex(1,2);
         var _loc10_:Vector3D = new Vector3D(Math.random() * 0.25,-Math.random() * 0.25,1);
         this.faceHelper(null,texture_,_loc6_,_loc10_,_loc5_,_loc1_);
         this.faceHelper(null,texture_,_loc10_,_loc9_,_loc4_,_loc5_);
         this.faceHelper(N2,texture_,_loc8_,_loc7_,_loc2_,_loc3_);
         this.faceHelper(null,texture_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_);
         if(Parameters.isGpuRender())
         {
            for each(_loc11_ in obj3D_.faces_)
            {
               GraphicsFillExtra.setSoftwareDraw(_loc11_.bitmapFill_,true);
            }
         }
      }
      
      override protected function buildLine() : void
      {
         var _loc9_:ObjectFace3D = null;
         var _loc1_:Vector3D = this.getVertex(0,0);
         var _loc2_:Vector3D = this.getVertex(0,3);
         var _loc3_:Vector3D = this.getVertex(2,3);
         var _loc4_:Vector3D = this.getVertex(2,0);
         var _loc5_:Vector3D = this.getVertex(0,1);
         var _loc6_:Vector3D = this.getVertex(0,2);
         var _loc7_:Vector3D = this.getVertex(2,2);
         var _loc8_:Vector3D = this.getVertex(2,1);
         this.faceHelper(N7,texture_,_loc5_,_loc8_,_loc4_,_loc1_);
         this.faceHelper(N3,texture_,_loc7_,_loc6_,_loc2_,_loc3_);
         this.faceHelper(null,texture_,_loc5_,_loc6_,_loc7_,_loc8_);
         if(Parameters.isGpuRender())
         {
            for each(_loc9_ in obj3D_.faces_)
            {
               GraphicsFillExtra.setSoftwareDraw(_loc9_.bitmapFill_,true);
            }
         }
      }
      
      override protected function buildT() : void
      {
         var _loc13_:ObjectFace3D = null;
         var _loc1_:Vector3D = this.getVertex(0,0);
         var _loc2_:Vector3D = this.getVertex(0,3);
         var _loc3_:Vector3D = this.getVertex(1,0);
         var _loc4_:Vector3D = this.getVertex(1,3);
         var _loc5_:Vector3D = this.getVertex(3,3);
         var _loc6_:Vector3D = this.getVertex(3,0);
         var _loc7_:Vector3D = this.getVertex(0,1);
         var _loc8_:Vector3D = this.getVertex(0,2);
         var _loc9_:Vector3D = this.getVertex(1,1);
         var _loc10_:Vector3D = this.getVertex(1,2);
         var _loc11_:Vector3D = this.getVertex(3,2);
         var _loc12_:Vector3D = this.getVertex(3,1);
         this.faceHelper(N2,texture_,_loc9_,_loc8_,_loc2_,_loc3_);
         this.faceHelper(null,texture_,_loc11_,_loc10_,_loc4_,_loc5_);
         this.faceHelper(N0,texture_,_loc7_,_loc12_,_loc6_,_loc1_);
         this.faceHelper(null,texture_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_);
         if(Parameters.isGpuRender())
         {
            for each(_loc13_ in obj3D_.faces_)
            {
               GraphicsFillExtra.setSoftwareDraw(_loc13_.bitmapFill_,true);
            }
         }
      }
      
      override protected function buildCross() : void
      {
         var _loc17_:ObjectFace3D = null;
         var _loc1_:Vector3D = this.getVertex(0,0);
         var _loc2_:Vector3D = this.getVertex(0,3);
         var _loc3_:Vector3D = this.getVertex(1,0);
         var _loc4_:Vector3D = this.getVertex(1,3);
         var _loc5_:Vector3D = this.getVertex(2,3);
         var _loc6_:Vector3D = this.getVertex(2,0);
         var _loc7_:Vector3D = this.getVertex(3,3);
         var _loc8_:Vector3D = this.getVertex(3,0);
         var _loc9_:Vector3D = this.getVertex(0,1);
         var _loc10_:Vector3D = this.getVertex(0,2);
         var _loc11_:Vector3D = this.getVertex(1,1);
         var _loc12_:Vector3D = this.getVertex(1,2);
         var _loc13_:Vector3D = this.getVertex(2,2);
         var _loc14_:Vector3D = this.getVertex(2,1);
         var _loc15_:Vector3D = this.getVertex(3,2);
         var _loc16_:Vector3D = this.getVertex(3,1);
         this.faceHelper(N2,texture_,_loc11_,_loc10_,_loc2_,_loc3_);
         this.faceHelper(N4,texture_,_loc13_,_loc12_,_loc4_,_loc5_);
         this.faceHelper(N6,texture_,_loc15_,_loc14_,_loc6_,_loc7_);
         this.faceHelper(N0,texture_,_loc9_,_loc16_,_loc8_,_loc1_);
         this.faceHelper(null,texture_,_loc9_,_loc10_,_loc11_,_loc12_,_loc13_,_loc14_,_loc15_,_loc16_);
         if(Parameters.isGpuRender())
         {
            for each(_loc17_ in obj3D_.faces_)
            {
               GraphicsFillExtra.setSoftwareDraw(_loc17_.bitmapFill_,true);
            }
         }
      }
      
      protected function getVertex(param1:int, param2:int) : Vector3D
      {
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc3_:int = x_;
         var _loc4_:int = y_;
         var _loc5_:int = (param1 + rotation_) % 4;
         switch(_loc5_)
         {
            case 1:
               _loc3_++;
               break;
            case 2:
               _loc4_++;
         }
         switch(param2)
         {
            case 0:
            case 3:
               _loc6_ = 15 + (_loc3_ * 1259 ^ _loc4_ * 2957) % 35;
               break;
            case 1:
            case 2:
               _loc6_ = 3 + (_loc3_ * 2179 ^ _loc4_ * 1237) % 35;
         }
         switch(param2)
         {
            case 0:
               _loc7_ = -_loc6_ / 100;
               _loc8_ = 0;
               break;
            case 1:
               _loc7_ = -_loc6_ / 100;
               _loc8_ = 1;
               break;
            case 2:
               _loc7_ = _loc6_ / 100;
               _loc8_ = 1;
               break;
            case 3:
               _loc7_ = _loc6_ / 100;
               _loc8_ = 0;
         }
         switch(param1)
         {
            case 0:
               return new Vector3D(_loc7_,-0.5,_loc8_);
            case 1:
               return new Vector3D(0.5,_loc7_,_loc8_);
            case 2:
               return new Vector3D(_loc7_,0.5,_loc8_);
            case 3:
               return new Vector3D(-0.5,_loc7_,_loc8_);
            default:
               return null;
         }
      }
      
      protected function faceHelper(param1:Vector3D, param2:BitmapData, ... rest) : void
      {
         var _loc5_:Vector3D = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc4_:int = obj3D_.vL_.length / 3;
         for each(_loc5_ in rest)
         {
            obj3D_.vL_.push(_loc5_.x,_loc5_.y,_loc5_.z);
         }
         _loc6_ = int(obj3D_.faces_.length);
         if(rest.length == 4)
         {
            obj3D_.uvts_.push(0,0,0,1,0,0,1,1,0,0,1,0);
            if(Math.random() < 0.5)
            {
               obj3D_.faces_.push(new ObjectFace3D(obj3D_,new <int>[_loc4_,_loc4_ + 1,_loc4_ + 3]),new ObjectFace3D(obj3D_,new <int>[_loc4_ + 1,_loc4_ + 2,_loc4_ + 3]));
            }
            else
            {
               obj3D_.faces_.push(new ObjectFace3D(obj3D_,new <int>[_loc4_,_loc4_ + 2,_loc4_ + 3]),new ObjectFace3D(obj3D_,new <int>[_loc4_,_loc4_ + 1,_loc4_ + 2]));
            }
         }
         else if(rest.length == 3)
         {
            obj3D_.uvts_.push(0,0,0,0,1,0,1,1,0);
            obj3D_.faces_.push(new ObjectFace3D(obj3D_,new <int>[_loc4_,_loc4_ + 1,_loc4_ + 2]));
         }
         else if(rest.length == 5)
         {
            obj3D_.uvts_.push(0.2,0,0,0.8,0,0,1,0.2,0,1,0.8,0,0,0.8,0);
            obj3D_.faces_.push(new ObjectFace3D(obj3D_,new <int>[_loc4_,_loc4_ + 1,_loc4_ + 2,_loc4_ + 3,_loc4_ + 4]));
         }
         else if(rest.length == 6)
         {
            obj3D_.uvts_.push(0,0,0,0.2,0,0,1,0.2,0,1,0.8,0,0,0.8,0,0,0.2,0);
            obj3D_.faces_.push(new ObjectFace3D(obj3D_,new <int>[_loc4_,_loc4_ + 1,_loc4_ + 2,_loc4_ + 3,_loc4_ + 4,_loc4_ + 5]));
         }
         else if(rest.length == 8)
         {
            obj3D_.uvts_.push(0,0,0,0.2,0,0,1,0.2,0,1,0.8,0,0.8,1,0,0.2,1,0,0,0.8,0,0,0.2,0);
            obj3D_.faces_.push(new ObjectFace3D(obj3D_,new <int>[_loc4_,_loc4_ + 1,_loc4_ + 2,_loc4_ + 3,_loc4_ + 4,_loc4_ + 5,_loc4_ + 6,_loc4_ + 7]));
         }
         if(param1 != null || param2 != null)
         {
            _loc7_ = _loc6_;
            while(_loc7_ < obj3D_.faces_.length)
            {
               obj3D_.faces_[_loc7_].normalL_ = param1;
               obj3D_.faces_[_loc7_].texture_ = param2;
               _loc7_++;
            }
         }
      }
   }
}

