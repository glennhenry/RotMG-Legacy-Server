package com.company.assembleegameclient.map
{
   import com.company.assembleegameclient.engine3d.Face3D;
   import com.company.assembleegameclient.parameters.Parameters;
   import flash.display.BitmapData;
   import flash.display.IGraphicsData;
   import kabam.rotmg.stage3D.GraphicsFillExtra;
   
   public class SquareFace
   {
      
      public var animate_:int;
      
      public var face_:Face3D;
      
      public var xOffset_:Number = 0;
      
      public var yOffset_:Number = 0;
      
      public var animateDx_:Number = 0;
      
      public var animateDy_:Number = 0;
      
      public function SquareFace(param1:BitmapData, param2:Vector.<Number>, param3:Number, param4:Number, param5:int, param6:Number, param7:Number)
      {
         super();
         this.face_ = new Face3D(param1,param2,Square.UVT.concat());
         this.xOffset_ = param3;
         this.yOffset_ = param4;
         if(this.xOffset_ != 0 || this.yOffset_ != 0)
         {
            this.face_.bitmapFill_.repeat = true;
         }
         this.animate_ = param5;
         if(this.animate_ != AnimateProperties.NO_ANIMATE)
         {
            this.face_.bitmapFill_.repeat = true;
         }
         this.animateDx_ = param6;
         this.animateDy_ = param7;
      }
      
      public function dispose() : void
      {
         this.face_.dispose();
         this.face_ = null;
      }
      
      public function draw(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : Boolean
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(this.animate_ != AnimateProperties.NO_ANIMATE)
         {
            switch(this.animate_)
            {
               case AnimateProperties.WAVE_ANIMATE:
                  _loc4_ = this.xOffset_ + Math.sin(this.animateDx_ * param3 / 1000);
                  _loc5_ = this.yOffset_ + Math.sin(this.animateDy_ * param3 / 1000);
                  break;
               case AnimateProperties.FLOW_ANIMATE:
                  _loc4_ = this.xOffset_ + this.animateDx_ * param3 / 1000;
                  _loc5_ = this.yOffset_ + this.animateDy_ * param3 / 1000;
            }
         }
         else
         {
            _loc4_ = this.xOffset_;
            _loc5_ = this.yOffset_;
         }
         if(Parameters.isGpuRender())
         {
            GraphicsFillExtra.setOffsetUV(this.face_.bitmapFill_,_loc4_,_loc5_);
            _loc4_ = _loc5_ = 0;
         }
         this.face_.uvt_.length = 0;
         this.face_.uvt_.push(0 + _loc4_,0 + _loc5_,0,1 + _loc4_,0 + _loc5_,0,1 + _loc4_,1 + _loc5_,0,0 + _loc4_,1 + _loc5_,0);
         this.face_.setUVT(this.face_.uvt_);
         return this.face_.draw(param1,param2);
      }
   }
}

