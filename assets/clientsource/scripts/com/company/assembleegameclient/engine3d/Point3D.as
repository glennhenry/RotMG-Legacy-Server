package com.company.assembleegameclient.engine3d
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.util.Trig;
   import flash.display.BitmapData;
   import flash.display.GraphicsBitmapFill;
   import flash.display.GraphicsEndFill;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsPathCommand;
   import flash.display.GraphicsSolidFill;
   import flash.display.IGraphicsData;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Utils3D;
   import flash.geom.Vector3D;
   
   public class Point3D
   {
      
      private static const commands_:Vector.<int> = new <int>[GraphicsPathCommand.MOVE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO];
      
      private static const END_FILL:GraphicsEndFill = new GraphicsEndFill();
      
      public var size_:Number;
      
      public var posS_:Vector3D;
      
      private const data_:Vector.<Number> = new Vector.<Number>();
      
      private const path_:GraphicsPath = new GraphicsPath(commands_,this.data_);
      
      private const bitmapFill_:GraphicsBitmapFill = new GraphicsBitmapFill(null,new Matrix(),false,false);
      
      private const solidFill_:GraphicsSolidFill = new GraphicsSolidFill(0,1);
      
      public function Point3D(param1:Number)
      {
         super();
         this.size_ = param1;
      }
      
      public function setSize(param1:Number) : void
      {
         this.size_ = param1;
      }
      
      public function draw(param1:Vector.<IGraphicsData>, param2:Vector3D, param3:Number, param4:Matrix3D, param5:Camera, param6:BitmapData, param7:uint = 0) : void
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Matrix = null;
         this.posS_ = Utils3D.projectVector(param4,param2);
         if(this.posS_.w < 0)
         {
            return;
         }
         var _loc8_:Number = this.posS_.w * Math.sin(param5.pp_.fieldOfView / 2 * Trig.toRadians);
         var _loc9_:Number = this.size_ / _loc8_;
         this.data_.length = 0;
         if(param3 == 0)
         {
            this.data_.push(this.posS_.x - _loc9_,this.posS_.y - _loc9_,this.posS_.x + _loc9_,this.posS_.y - _loc9_,this.posS_.x + _loc9_,this.posS_.y + _loc9_,this.posS_.x - _loc9_,this.posS_.y + _loc9_);
         }
         else
         {
            _loc10_ = Math.cos(param3);
            _loc11_ = Math.sin(param3);
            this.data_.push(this.posS_.x + (_loc10_ * -_loc9_ + _loc11_ * -_loc9_),this.posS_.y + (_loc11_ * -_loc9_ - _loc10_ * -_loc9_),this.posS_.x + (_loc10_ * _loc9_ + _loc11_ * -_loc9_),this.posS_.y + (_loc11_ * _loc9_ - _loc10_ * -_loc9_),this.posS_.x + (_loc10_ * _loc9_ + _loc11_ * _loc9_),this.posS_.y + (_loc11_ * _loc9_ - _loc10_ * _loc9_),this.posS_.x + (_loc10_ * -_loc9_ + _loc11_ * _loc9_),this.posS_.y + (_loc11_ * -_loc9_ - _loc10_ * _loc9_));
         }
         if(param6 != null)
         {
            this.bitmapFill_.bitmapData = param6;
            _loc12_ = this.bitmapFill_.matrix;
            _loc12_.identity();
            _loc12_.scale(2 * _loc9_ / param6.width,2 * _loc9_ / param6.height);
            _loc12_.translate(-_loc9_,-_loc9_);
            _loc12_.rotate(param3);
            _loc12_.translate(this.posS_.x,this.posS_.y);
            param1.push(this.bitmapFill_);
         }
         else
         {
            this.solidFill_.color = param7;
            param1.push(this.solidFill_);
         }
         param1.push(this.path_);
         param1.push(END_FILL);
      }
   }
}

