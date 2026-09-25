package com.company.assembleegameclient.engine3d
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.GraphicsUtil;
   import com.company.util.Triangle;
   import flash.display.BitmapData;
   import flash.display.GraphicsBitmapFill;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsPathCommand;
   import flash.display.GraphicsSolidFill;
   import flash.display.IGraphicsData;
   import flash.geom.Utils3D;
   import flash.geom.Vector3D;
   
   public class Face3D
   {
      
      private static const blackOutFill_:GraphicsSolidFill = new GraphicsSolidFill(0,1);
      
      public var origTexture_:BitmapData;
      
      public var vin_:Vector.<Number>;
      
      public var uvt_:Vector.<Number>;
      
      public var vout_:Vector.<Number>;
      
      public var backfaceCull_:Boolean;
      
      public var shade_:Number = 1;
      
      public var blackOut_:Boolean = false;
      
      private var needGen_:Boolean = true;
      
      private var textureMatrix_:TextureMatrix = null;
      
      public var bitmapFill_:GraphicsBitmapFill;
      
      private var path_:GraphicsPath;
      
      public function Face3D(param1:BitmapData, param2:Vector.<Number>, param3:Vector.<Number>, param4:Boolean = false, param5:Boolean = false)
      {
         var _loc7_:Vector3D = null;
         this.vout_ = new Vector.<Number>();
         this.bitmapFill_ = new GraphicsBitmapFill(null,null,false,false);
         this.path_ = new GraphicsPath(new Vector.<int>(),null);
         super();
         this.origTexture_ = param1;
         this.vin_ = param2;
         this.uvt_ = param3;
         this.backfaceCull_ = param4;
         if(param5)
         {
            _loc7_ = new Vector3D();
            Plane3D.computeNormalVec(param2,_loc7_);
            this.shade_ = Lighting3D.shadeValue(_loc7_,0.75);
         }
         this.path_.commands.push(GraphicsPathCommand.MOVE_TO);
         var _loc6_:int = 3;
         while(_loc6_ < this.vin_.length)
         {
            this.path_.commands.push(GraphicsPathCommand.LINE_TO);
            _loc6_ += 3;
         }
         this.path_.data = this.vout_;
      }
      
      public function dispose() : void
      {
         this.origTexture_ = null;
         this.vin_ = null;
         this.uvt_ = null;
         this.vout_ = null;
         this.textureMatrix_ = null;
         this.bitmapFill_ = null;
         this.path_.commands = null;
         this.path_.data = null;
         this.path_ = null;
      }
      
      public function setTexture(param1:BitmapData) : void
      {
         if(this.origTexture_ == param1)
         {
            return;
         }
         this.origTexture_ = param1;
         this.needGen_ = true;
      }
      
      public function setUVT(param1:Vector.<Number>) : void
      {
         this.uvt_ = param1;
         this.needGen_ = true;
      }
      
      public function maxY() : Number
      {
         var _loc1_:Number = -Number.MAX_VALUE;
         var _loc2_:int = int(this.vout_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.vout_[_loc3_ + 1] > _loc1_)
            {
               _loc1_ = this.vout_[_loc3_ + 1];
            }
            _loc3_ += 2;
         }
         return _loc1_;
      }
      
      public function draw(param1:Vector.<IGraphicsData>, param2:Camera) : Boolean
      {
         var _loc10_:Vector.<Number> = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:int = 0;
         Utils3D.projectVectors(param2.wToS_,this.vin_,this.vout_,this.uvt_);
         if(this.backfaceCull_)
         {
            _loc10_ = this.vout_;
            _loc11_ = _loc10_[2] - _loc10_[0];
            _loc12_ = _loc10_[3] - _loc10_[1];
            _loc13_ = _loc10_[4] - _loc10_[0];
            _loc14_ = _loc10_[5] - _loc10_[1];
            if(_loc11_ * _loc14_ - _loc12_ * _loc13_ > 0)
            {
               return false;
            }
         }
         var _loc3_:Number = param2.clipRect_.x - 10;
         var _loc4_:Number = param2.clipRect_.y - 10;
         var _loc5_:Number = param2.clipRect_.right + 10;
         var _loc6_:Number = param2.clipRect_.bottom + 10;
         var _loc7_:Boolean = true;
         var _loc8_:int = int(this.vout_.length);
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_)
         {
            _loc15_ = _loc9_ + 1;
            if(this.vout_[_loc9_] >= _loc3_ && this.vout_[_loc9_] <= _loc5_ && this.vout_[_loc15_] >= _loc4_ && this.vout_[_loc15_] <= _loc6_)
            {
               _loc7_ = false;
               break;
            }
            _loc9_ += 2;
         }
         if(_loc7_)
         {
            return false;
         }
         if(this.blackOut_)
         {
            param1.push(blackOutFill_);
            param1.push(this.path_);
            param1.push(GraphicsUtil.END_FILL);
            return true;
         }
         if(this.needGen_)
         {
            this.generateTextureMatrix();
         }
         this.textureMatrix_.calculateTextureMatrix(this.vout_);
         this.bitmapFill_.bitmapData = this.textureMatrix_.texture_;
         this.bitmapFill_.matrix = this.textureMatrix_.tToS_;
         param1.push(this.bitmapFill_);
         param1.push(this.path_);
         param1.push(GraphicsUtil.END_FILL);
         return true;
      }
      
      public function contains(param1:Number, param2:Number) : Boolean
      {
         if(Triangle.containsXY(this.vout_[0],this.vout_[1],this.vout_[2],this.vout_[3],this.vout_[4],this.vout_[5],param1,param2))
         {
            return true;
         }
         if(this.vout_.length == 8 && Triangle.containsXY(this.vout_[0],this.vout_[1],this.vout_[4],this.vout_[5],this.vout_[6],this.vout_[7],param1,param2))
         {
            return true;
         }
         return false;
      }
      
      private function generateTextureMatrix() : void
      {
         var _loc1_:BitmapData = TextureRedrawer.redrawFace(this.origTexture_,this.shade_);
         if(this.textureMatrix_ == null)
         {
            this.textureMatrix_ = new TextureMatrix(_loc1_,this.uvt_);
         }
         else
         {
            this.textureMatrix_.texture_ = _loc1_;
            this.textureMatrix_.calculateUVMatrix(this.uvt_);
         }
         this.needGen_ = false;
      }
   }
}

