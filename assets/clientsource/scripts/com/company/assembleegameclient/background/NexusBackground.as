package com.company.assembleegameclient.background
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.util.GraphicsUtil;
   import flash.display.BitmapData;
   import flash.display.BitmapDataChannel;
   import flash.display.GraphicsBitmapFill;
   import flash.display.GraphicsPath;
   import flash.display.IGraphicsData;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class NexusBackground extends Background
   {
      
      public static const MOVEMENT:Point = new Point(0.01,0.01);
      
      private var water_:BitmapData;
      
      private var islands_:Vector.<Island> = new Vector.<Island>();
      
      protected var graphicsData_:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
      
      private var bitmapFill_:GraphicsBitmapFill = new GraphicsBitmapFill(null,new Matrix(),true,false);
      
      private var path_:GraphicsPath = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,new Vector.<Number>());
      
      public function NexusBackground()
      {
         super();
         this.water_ = new BitmapDataSpy(1024,1024,false,0);
         this.water_.perlinNoise(1024,1024,8,Math.random(),true,true,BitmapDataChannel.BLUE,false,null);
      }
      
      override public function draw(param1:Camera, param2:int) : void
      {
         this.graphicsData_.length = 0;
         var _loc3_:Matrix = this.bitmapFill_.matrix;
         _loc3_.identity();
         _loc3_.translate(param2 * MOVEMENT.x,param2 * MOVEMENT.y);
         _loc3_.rotate(-param1.angleRad_);
         this.bitmapFill_.bitmapData = this.water_;
         this.graphicsData_.push(this.bitmapFill_);
         this.path_.data.length = 0;
         var _loc4_:Rectangle = param1.clipRect_;
         this.path_.data.push(_loc4_.left,_loc4_.top,_loc4_.right,_loc4_.top,_loc4_.right,_loc4_.bottom,_loc4_.left,_loc4_.bottom);
         this.graphicsData_.push(this.path_);
         this.graphicsData_.push(GraphicsUtil.END_FILL);
         this.drawIslands(param1,param2);
         graphics.clear();
         graphics.drawGraphicsData(this.graphicsData_);
      }
      
      private function drawIslands(param1:Camera, param2:int) : void
      {
         var _loc4_:Island = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.islands_.length)
         {
            _loc4_ = this.islands_[_loc3_];
            _loc4_.draw(param1,param2,this.graphicsData_);
            _loc3_++;
         }
      }
   }
}

import com.company.assembleegameclient.map.Camera;
import com.company.util.AssetLibrary;
import com.company.util.GraphicsUtil;
import flash.display.BitmapData;
import flash.display.GraphicsBitmapFill;
import flash.display.GraphicsPath;
import flash.display.IGraphicsData;
import flash.geom.Matrix;
import flash.geom.Point;

class Island
{
   
   public var center_:Point;
   
   public var startTime_:int;
   
   public var bitmapData_:BitmapData;
   
   private var bitmapFill_:GraphicsBitmapFill = new GraphicsBitmapFill(null,new Matrix(),true,false);
   
   private var path_:GraphicsPath = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,new Vector.<Number>());
   
   public function Island(param1:Number, param2:Number, param3:int)
   {
      super();
      this.center_ = new Point(param1,param2);
      this.startTime_ = param3;
      this.bitmapData_ = AssetLibrary.getImage("stars");
   }
   
   public function draw(param1:Camera, param2:int, param3:Vector.<IGraphicsData>) : void
   {
      var _loc4_:int = param2 - this.startTime_;
      var _loc5_:Number = this.center_.x + _loc4_ * NexusBackground.MOVEMENT.x;
      var _loc6_:Number = this.center_.y + _loc4_ * NexusBackground.MOVEMENT.y;
      var _loc7_:Matrix = this.bitmapFill_.matrix;
      _loc7_.identity();
      _loc7_.translate(_loc5_,_loc6_);
      _loc7_.rotate(-param1.angleRad_);
      this.bitmapFill_.bitmapData = this.bitmapData_;
      param3.push(this.bitmapFill_);
      this.path_.data.length = 0;
      var _loc8_:Point = _loc7_.transformPoint(new Point(_loc5_,_loc6_));
      var _loc9_:Point = _loc7_.transformPoint(new Point(_loc5_ + this.bitmapData_.width,_loc6_ + this.bitmapData_.height));
      this.path_.data.push(_loc8_.x,_loc8_.y,_loc9_.x,_loc8_.y,_loc9_.x,_loc9_.y,_loc8_.x,_loc9_.y);
      param3.push(this.path_);
      param3.push(GraphicsUtil.END_FILL);
   }
}
