package com.company.assembleegameclient.engine3d
{
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.GraphicsUtil;
   import com.company.util.MoreColorUtil;
   import flash.display.BitmapData;
   import flash.display.GraphicsBitmapFill;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsPathCommand;
   import flash.display.GraphicsSolidFill;
   import flash.display.IGraphicsData;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Vector3D;
   import kabam.rotmg.stage3D.GraphicsFillExtra;
   
   public class ObjectFace3D
   {
      
      public static const blackBitmap:BitmapData = new BitmapData(1,1,true,4278190080);
      
      public var obj_:Object3D;
      
      public var indices_:Vector.<int>;
      
      public var useTexture_:Boolean;
      
      public var softwareException_:Boolean = false;
      
      public var texture_:BitmapData = null;
      
      public var normalL_:Vector3D = null;
      
      public var normalW_:Vector3D;
      
      public var shade_:Number = 1;
      
      private var path_:GraphicsPath;
      
      private var solidFill_:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
      
      public const bitmapFill_:GraphicsBitmapFill = new GraphicsBitmapFill();
      
      private var tToS_:Matrix = new Matrix();
      
      private var tempMatrix_:Matrix = new Matrix();
      
      public function ObjectFace3D(param1:Object3D, param2:Vector.<int>, param3:Boolean = true)
      {
         super();
         this.obj_ = param1;
         this.indices_ = param2;
         this.useTexture_ = param3;
         var _loc4_:Vector.<int> = new Vector.<int>();
         var _loc5_:int = 0;
         while(_loc5_ < this.indices_.length)
         {
            _loc4_.push(_loc5_ == 0 ? GraphicsPathCommand.MOVE_TO : GraphicsPathCommand.LINE_TO);
            _loc5_++;
         }
         var _loc6_:Vector.<Number> = new Vector.<Number>();
         _loc6_.length = this.indices_.length * 2;
         this.path_ = new GraphicsPath(_loc4_,_loc6_);
      }
      
      public function dispose() : void
      {
         this.indices_ = null;
         this.path_.commands = null;
         this.path_.data = null;
         this.path_ = null;
      }
      
      public function computeLighting() : void
      {
         this.normalW_ = new Vector3D();
         Plane3D.computeNormal(this.obj_.getVecW(this.indices_[0]),this.obj_.getVecW(this.indices_[1]),this.obj_.getVecW(this.indices_[this.indices_.length - 1]),this.normalW_);
         this.shade_ = Lighting3D.shadeValue(this.normalW_,0.75);
         if(this.normalL_ != null)
         {
            this.normalW_ = this.obj_.lToW_.deltaTransformVector(this.normalL_);
         }
      }
      
      public function draw(param1:Vector.<IGraphicsData>, param2:uint, param3:BitmapData) : void
      {
         var _loc13_:int = 0;
         var _loc4_:int = this.indices_[0] * 2;
         var _loc5_:int = this.indices_[1] * 2;
         var _loc6_:int = this.indices_[this.indices_.length - 1] * 2;
         var _loc7_:Vector.<Number> = this.obj_.vS_;
         var _loc8_:Number = _loc7_[_loc5_] - _loc7_[_loc4_];
         var _loc9_:Number = _loc7_[_loc5_ + 1] - _loc7_[_loc4_ + 1];
         var _loc10_:Number = _loc7_[_loc6_] - _loc7_[_loc4_];
         var _loc11_:Number = _loc7_[_loc6_ + 1] - _loc7_[_loc4_ + 1];
         if(_loc8_ * _loc11_ - _loc9_ * _loc10_ < 0)
         {
            return;
         }
         if(!Parameters.data_.GPURender && (!this.useTexture_ || param3 == null))
         {
            this.solidFill_.color = MoreColorUtil.transformColor(new ColorTransform(this.shade_,this.shade_,this.shade_),param2);
            param1.push(this.solidFill_);
         }
         else
         {
            if(param3 == null && Boolean(Parameters.data_.GPURender))
            {
               param3 = blackBitmap;
            }
            else
            {
               param3 = TextureRedrawer.redrawFace(param3,this.shade_);
            }
            this.bitmapFill_.bitmapData = param3;
            this.bitmapFill_.matrix = this.tToS(param3);
            param1.push(this.bitmapFill_);
         }
         var _loc12_:int = 0;
         while(_loc12_ < this.indices_.length)
         {
            _loc13_ = this.indices_[_loc12_];
            this.path_.data[_loc12_ * 2] = _loc7_[_loc13_ * 2];
            this.path_.data[_loc12_ * 2 + 1] = _loc7_[_loc13_ * 2 + 1];
            _loc12_++;
         }
         param1.push(this.path_);
         param1.push(GraphicsUtil.END_FILL);
         if(this.softwareException_ && Parameters.isGpuRender() && this.bitmapFill_ != null)
         {
            GraphicsFillExtra.setSoftwareDraw(this.bitmapFill_,true);
         }
      }
      
      private function tToS(param1:BitmapData) : Matrix
      {
         var _loc2_:Vector.<Number> = this.obj_.uvts_;
         var _loc3_:int = this.indices_[0] * 3;
         var _loc4_:int = this.indices_[1] * 3;
         var _loc5_:int = this.indices_[this.indices_.length - 1] * 3;
         var _loc6_:Number = _loc2_[_loc3_] * param1.width;
         var _loc7_:Number = _loc2_[_loc3_ + 1] * param1.height;
         this.tToS_.a = _loc2_[_loc4_] * param1.width - _loc6_;
         this.tToS_.b = _loc2_[_loc4_ + 1] * param1.height - _loc7_;
         this.tToS_.c = _loc2_[_loc5_] * param1.width - _loc6_;
         this.tToS_.d = _loc2_[_loc5_ + 1] * param1.height - _loc7_;
         this.tToS_.tx = _loc6_;
         this.tToS_.ty = _loc7_;
         this.tToS_.invert();
         _loc3_ = this.indices_[0] * 2;
         _loc4_ = this.indices_[1] * 2;
         _loc5_ = this.indices_[this.indices_.length - 1] * 2;
         var _loc8_:Vector.<Number> = this.obj_.vS_;
         this.tempMatrix_.a = _loc8_[_loc4_] - _loc8_[_loc3_];
         this.tempMatrix_.b = _loc8_[_loc4_ + 1] - _loc8_[_loc3_ + 1];
         this.tempMatrix_.c = _loc8_[_loc5_] - _loc8_[_loc3_];
         this.tempMatrix_.d = _loc8_[_loc5_ + 1] - _loc8_[_loc3_ + 1];
         this.tempMatrix_.tx = _loc8_[_loc3_];
         this.tempMatrix_.ty = _loc8_[_loc3_ + 1];
         this.tToS_.concat(this.tempMatrix_);
         return this.tToS_;
      }
   }
}

