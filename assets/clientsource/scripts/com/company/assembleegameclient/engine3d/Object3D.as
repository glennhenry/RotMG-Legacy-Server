package com.company.assembleegameclient.engine3d
{
   import com.company.assembleegameclient.map.Camera;
   import flash.display.BitmapData;
   import flash.display.IGraphicsData;
   import flash.geom.Matrix3D;
   import flash.geom.Utils3D;
   import flash.geom.Vector3D;
   
   public class Object3D
   {
      
      public var model_:Model3D = null;
      
      public var vL_:Vector.<Number>;
      
      public var uvts_:Vector.<Number>;
      
      public var faces_:Vector.<ObjectFace3D>;
      
      public var vS_:Vector.<Number>;
      
      public var vW_:Vector.<Number>;
      
      public var lToW_:Matrix3D;
      
      public function Object3D(param1:Model3D = null)
      {
         var _loc2_:ModelFace3D = null;
         this.faces_ = new Vector.<ObjectFace3D>();
         this.vS_ = new Vector.<Number>();
         this.vW_ = new Vector.<Number>();
         this.lToW_ = new Matrix3D();
         super();
         if(param1 != null)
         {
            this.model_ = param1;
            this.vL_ = this.model_.vL_;
            this.uvts_ = this.model_.uvts_.concat();
            for each(_loc2_ in this.model_.faces_)
            {
               this.faces_.push(new ObjectFace3D(this,_loc2_.indicies_,_loc2_.useTexture_));
            }
         }
         else
         {
            this.vL_ = new Vector.<Number>();
            this.uvts_ = new Vector.<Number>();
         }
         this.setPosition(0,0,0,0);
      }
      
      public static function getObject(param1:String) : Object3D
      {
         var _loc2_:Model3D = Model3D.getModel(param1);
         return new Object3D(_loc2_);
      }
      
      public function dispose() : void
      {
         var _loc1_:ObjectFace3D = null;
         this.vL_ = null;
         this.uvts_ = null;
         for each(_loc1_ in this.faces_)
         {
            _loc1_.dispose();
         }
         this.faces_.length = 0;
         this.faces_ = null;
         this.vS_ = null;
         this.vW_ = null;
         this.lToW_ = null;
      }
      
      public function setPosition(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:ObjectFace3D = null;
         this.lToW_.identity();
         this.lToW_.appendRotation(param4,Vector3D.Z_AXIS);
         this.lToW_.appendTranslation(param1,param2,param3);
         this.lToW_.transformVectors(this.vL_,this.vW_);
         for each(_loc5_ in this.faces_)
         {
            _loc5_.computeLighting();
         }
      }
      
      public function getVecW(param1:int) : Vector3D
      {
         var _loc2_:int = param1 * 3;
         if(_loc2_ >= this.vW_.length)
         {
            return null;
         }
         return new Vector3D(this.vW_[_loc2_],this.vW_[_loc2_ + 1],this.vW_[_loc2_ + 2]);
      }
      
      public function draw(param1:Vector.<IGraphicsData>, param2:Camera, param3:uint, param4:BitmapData) : void
      {
         var _loc5_:ObjectFace3D = null;
         Utils3D.projectVectors(param2.wToS_,this.vW_,this.vS_,this.uvts_);
         for each(_loc5_ in this.faces_)
         {
            _loc5_.draw(param1,param3,param4);
         }
      }
   }
}

