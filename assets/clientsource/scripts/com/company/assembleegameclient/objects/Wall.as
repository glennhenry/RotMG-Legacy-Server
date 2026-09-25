package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.engine3d.Face3D;
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.map.Square;
   import com.company.util.BitmapUtil;
   import flash.display.BitmapData;
   import flash.display.IGraphicsData;
   
   public class Wall extends GameObject
   {
      
      private static const UVT:Vector.<Number> = new <Number>[0,0,0,1,0,0,1,1,0,0,1,0];
      
      private static const sqX:Vector.<int> = new <int>[0,1,0,-1];
      
      private static const sqY:Vector.<int> = new <int>[-1,0,1,0];
      
      public var faces_:Vector.<Face3D> = new Vector.<Face3D>();
      
      private var topFace_:Face3D = null;
      
      private var topTexture_:BitmapData = null;
      
      public function Wall(param1:XML)
      {
         super(param1);
         hasShadow_ = false;
         var _loc2_:TextureData = ObjectLibrary.typeToTopTextureData_[objectType_];
         this.topTexture_ = _loc2_.getTexture(0);
      }
      
      override public function setObjectId(param1:int) : void
      {
         super.setObjectId(param1);
         var _loc2_:TextureData = ObjectLibrary.typeToTopTextureData_[objectType_];
         this.topTexture_ = _loc2_.getTexture(param1);
      }
      
      override public function getColor() : uint
      {
         return BitmapUtil.mostCommonColor(this.topTexture_);
      }
      
      override public function draw(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : void
      {
         var _loc6_:BitmapData = null;
         var _loc7_:Face3D = null;
         var _loc8_:com.company.assembleegameclient.map.Square = null;
         if(texture_ == null)
         {
            return;
         }
         if(this.faces_.length == 0)
         {
            this.rebuild3D();
         }
         var _loc4_:BitmapData = texture_;
         if(animations_ != null)
         {
            _loc6_ = animations_.getTexture(param3);
            if(_loc6_ != null)
            {
               _loc4_ = _loc6_;
            }
         }
         var _loc5_:int = 0;
         while(_loc5_ < this.faces_.length)
         {
            _loc7_ = this.faces_[_loc5_];
            _loc8_ = map_.lookupSquare(x_ + sqX[_loc5_],y_ + sqY[_loc5_]);
            if(_loc8_ == null || _loc8_.texture_ == null || _loc8_ != null && _loc8_.obj_ is Wall && !_loc8_.obj_.dead_)
            {
               _loc7_.blackOut_ = true;
            }
            else
            {
               _loc7_.blackOut_ = false;
               if(animations_ != null)
               {
                  _loc7_.setTexture(_loc4_);
               }
            }
            _loc7_.draw(param1,param2);
            _loc5_++;
         }
         this.topFace_.draw(param1,param2);
      }
      
      public function rebuild3D() : void
      {
         this.faces_.length = 0;
         var _loc1_:int = x_;
         var _loc2_:int = y_;
         var _loc3_:Vector.<Number> = new <Number>[_loc1_,_loc2_,1,_loc1_ + 1,_loc2_,1,_loc1_ + 1,_loc2_ + 1,1,_loc1_,_loc2_ + 1,1];
         this.topFace_ = new Face3D(this.topTexture_,_loc3_,UVT,false,true);
         this.topFace_.bitmapFill_.repeat = true;
         this.addWall(_loc1_,_loc2_,1,_loc1_ + 1,_loc2_,1);
         this.addWall(_loc1_ + 1,_loc2_,1,_loc1_ + 1,_loc2_ + 1,1);
         this.addWall(_loc1_ + 1,_loc2_ + 1,1,_loc1_,_loc2_ + 1,1);
         this.addWall(_loc1_,_loc2_ + 1,1,_loc1_,_loc2_,1);
      }
      
      private function addWall(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         var _loc7_:Vector.<Number> = new <Number>[param1,param2,param3,param4,param5,param6,param4,param5,param6 - 1,param1,param2,param3 - 1];
         var _loc8_:Face3D = new Face3D(texture_,_loc7_,UVT,true,true);
         _loc8_.bitmapFill_.repeat = true;
         this.faces_.push(_loc8_);
      }
   }
}

