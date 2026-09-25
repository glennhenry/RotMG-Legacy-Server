package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.map.Square;
   import com.company.assembleegameclient.objects.BasicObject;
   import com.company.assembleegameclient.objects.animation.Animations;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.GraphicsUtil;
   import flash.display.BitmapData;
   import flash.display.GraphicsBitmapFill;
   import flash.display.GraphicsPath;
   import flash.display.IGraphicsData;
   import flash.geom.Matrix;
   import flash.geom.Vector3D;
   
   public class XMLParticle extends BasicObject
   {
      
      public var texture_:BitmapData = null;
      
      public var animations_:Animations = null;
      
      public var size_:int;
      
      public var durationLeft_:Number;
      
      public var moveVec_:Vector3D;
      
      protected var bitmapFill_:GraphicsBitmapFill = new GraphicsBitmapFill(null,null,false,false);
      
      protected var path_:GraphicsPath = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,null);
      
      protected var vS_:Vector.<Number> = new Vector.<Number>();
      
      protected var uvt_:Vector.<Number> = new Vector.<Number>();
      
      protected var fillMatrix_:Matrix = new Matrix();
      
      public function XMLParticle(param1:ParticleProperties)
      {
         super();
         objectId_ = getNextFakeObjectId();
         this.size_ = param1.size_;
         z_ = param1.z_;
         this.durationLeft_ = param1.duration_;
         this.texture_ = param1.textureData_.getTexture(objectId_);
         if(param1.animationsData_ != null)
         {
            this.animations_ = new Animations(param1.animationsData_);
         }
         this.moveVec_ = new Vector3D();
         var _loc2_:Number = Math.PI * 2 * Math.random();
         this.moveVec_.x = Math.cos(_loc2_) * 0.1 * 5;
         this.moveVec_.y = Math.sin(_loc2_) * 0.1 * 5;
      }
      
      public function moveTo(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:com.company.assembleegameclient.map.Square = map_.getSquare(param1,param2);
         if(_loc3_ == null)
         {
            return false;
         }
         x_ = param1;
         y_ = param2;
         square_ = _loc3_;
         return true;
      }
      
      override public function update(param1:int, param2:int) : Boolean
      {
         var _loc3_:Number = param2 / 1000;
         this.durationLeft_ -= _loc3_;
         if(this.durationLeft_ <= 0)
         {
            return false;
         }
         x_ += this.moveVec_.x * _loc3_;
         y_ += this.moveVec_.y * _loc3_;
         return true;
      }
      
      override public function draw(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : void
      {
         var _loc7_:BitmapData = null;
         var _loc4_:BitmapData = this.texture_;
         if(this.animations_ != null)
         {
            _loc7_ = this.animations_.getTexture(param3);
            if(_loc7_ != null)
            {
               _loc4_ = _loc7_;
            }
         }
         _loc4_ = TextureRedrawer.redraw(_loc4_,this.size_,true,0);
         var _loc5_:int = _loc4_.width;
         var _loc6_:int = _loc4_.height;
         this.vS_.length = 0;
         this.vS_.push(posS_[3] - _loc5_ / 2,posS_[4] - _loc6_,posS_[3] + _loc5_ / 2,posS_[4] - _loc6_,posS_[3] + _loc5_ / 2,posS_[4],posS_[3] - _loc5_ / 2,posS_[4]);
         this.path_.data = this.vS_;
         this.bitmapFill_.bitmapData = _loc4_;
         this.fillMatrix_.identity();
         this.fillMatrix_.translate(this.vS_[0],this.vS_[1]);
         this.bitmapFill_.matrix = this.fillMatrix_;
         param1.push(this.bitmapFill_);
         param1.push(this.path_);
         param1.push(GraphicsUtil.END_FILL);
      }
   }
}

