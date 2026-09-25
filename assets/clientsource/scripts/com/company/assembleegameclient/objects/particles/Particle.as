package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.map.Square;
   import com.company.assembleegameclient.objects.BasicObject;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.GraphicsUtil;
   import flash.display.BitmapData;
   import flash.display.GraphicsBitmapFill;
   import flash.display.GraphicsPath;
   import flash.display.IGraphicsData;
   import flash.geom.Matrix;
   
   public class Particle extends BasicObject
   {
      
      public var size_:int;
      
      public var color_:uint;
      
      protected var bitmapFill_:GraphicsBitmapFill = new GraphicsBitmapFill(null,null,false,false);
      
      protected var path_:GraphicsPath = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,null);
      
      protected var vS_:Vector.<Number> = new Vector.<Number>();
      
      protected var fillMatrix_:Matrix = new Matrix();
      
      public function Particle(param1:uint, param2:Number, param3:int)
      {
         super();
         objectId_ = getNextFakeObjectId();
         this.setZ(param2);
         this.setColor(param1);
         this.setSize(param3);
      }
      
      public function moveTo(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:com.company.assembleegameclient.map.Square = null;
         _loc3_ = map_.getSquare(param1,param2);
         if(_loc3_ == null)
         {
            return false;
         }
         x_ = param1;
         y_ = param2;
         square_ = _loc3_;
         return true;
      }
      
      public function moveToInModal(param1:Number, param2:Number) : Boolean
      {
         x_ = param1;
         y_ = param2;
         return true;
      }
      
      public function setColor(param1:uint) : void
      {
         this.color_ = param1;
      }
      
      public function setZ(param1:Number) : void
      {
         z_ = param1;
      }
      
      public function setSize(param1:int) : void
      {
         this.size_ = param1 / 100 * 5;
      }
      
      override public function draw(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : void
      {
         var _loc4_:BitmapData = TextureRedrawer.redrawSolidSquare(this.color_,this.size_);
         var _loc5_:int = _loc4_.width;
         var _loc6_:int = _loc4_.height;
         this.vS_.length = 0;
         this.vS_.push(posS_[3] - _loc5_ / 2,posS_[4] - _loc6_ / 2,posS_[3] + _loc5_ / 2,posS_[4] - _loc6_ / 2,posS_[3] + _loc5_ / 2,posS_[4] + _loc6_ / 2,posS_[3] - _loc5_ / 2,posS_[4] + _loc6_ / 2);
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

