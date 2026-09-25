package com.company.assembleegameclient.map
{
   import com.company.assembleegameclient.engine3d.TextureMatrix;
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.util.TileRedrawer;
   import flash.display.BitmapData;
   import flash.display.IGraphicsData;
   import flash.geom.Vector3D;
   
   public class Square
   {
      
      public static const UVT:Vector.<Number> = new <Number>[0,0,0,1,0,0,1,1,0,0,1,0];
      
      private static const LOOKUP:Vector.<int> = new <int>[26171,44789,20333,70429,98257,59393,33961];
      
      public var map_:Map;
      
      public var x_:int;
      
      public var y_:int;
      
      public var tileType_:uint = 255;
      
      public var center_:Vector3D;
      
      public var vin_:Vector.<Number>;
      
      public var obj_:GameObject = null;
      
      public var props_:GroundProperties = GroundLibrary.defaultProps_;
      
      public var texture_:BitmapData = null;
      
      public var sink_:int = 0;
      
      public var lastDamage_:int = 0;
      
      public var faces_:Vector.<SquareFace> = new Vector.<SquareFace>();
      
      public var topFace_:SquareFace = null;
      
      public var baseTexMatrix_:TextureMatrix = null;
      
      public var lastVisible_:int;
      
      public function Square(param1:Map, param2:int, param3:int)
      {
         super();
         this.map_ = param1;
         this.x_ = param2;
         this.y_ = param3;
         this.center_ = new Vector3D(this.x_ + 0.5,this.y_ + 0.5,0);
         this.vin_ = new <Number>[this.x_,this.y_,0,this.x_ + 1,this.y_,0,this.x_ + 1,this.y_ + 1,0,this.x_,this.y_ + 1,0];
      }
      
      private static function hash(param1:int, param2:int) : int
      {
         var _loc3_:int = LOOKUP[(param1 + param2) % 7];
         var _loc4_:int = (param1 << 16 | param2) ^ 0x04DA072E;
         return int(_loc4_ * _loc3_ % 65535);
      }
      
      public function dispose() : void
      {
         var _loc1_:SquareFace = null;
         this.map_ = null;
         this.center_ = null;
         this.vin_ = null;
         this.obj_ = null;
         this.texture_ = null;
         for each(_loc1_ in this.faces_)
         {
            _loc1_.dispose();
         }
         this.faces_.length = 0;
         if(this.topFace_ != null)
         {
            this.topFace_.dispose();
            this.topFace_ = null;
         }
         this.faces_ = null;
         this.baseTexMatrix_ = null;
      }
      
      public function setTileType(param1:uint) : void
      {
         this.tileType_ = param1;
         this.props_ = GroundLibrary.propsLibrary_[this.tileType_];
         this.texture_ = GroundLibrary.getBitmapData(this.tileType_,hash(this.x_,this.y_));
         this.baseTexMatrix_ = new TextureMatrix(this.texture_,UVT);
         this.faces_.length = 0;
      }
      
      public function isWalkable() : Boolean
      {
         return !this.props_.noWalk_ && (this.obj_ == null || !this.obj_.props_.occupySquare_);
      }
      
      public function draw(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : void
      {
         var _loc4_:SquareFace = null;
         if(this.texture_ == null)
         {
            return;
         }
         if(this.faces_.length == 0)
         {
            this.rebuild3D();
         }
         for each(_loc4_ in this.faces_)
         {
            if(!_loc4_.draw(param1,param2,param3))
            {
               if(_loc4_.face_.vout_[1] < param2.clipRect_.bottom)
               {
                  this.lastVisible_ = 0;
               }
               return;
            }
         }
      }
      
      public function drawTop(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : void
      {
         this.topFace_.draw(param1,param2,param3);
      }
      
      private function rebuild3D() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:BitmapData = null;
         var _loc5_:Vector.<Number> = null;
         var _loc6_:uint = 0;
         this.faces_.length = 0;
         this.topFace_ = null;
         var _loc1_:BitmapData = null;
         if(this.props_.animate_.type_ != AnimateProperties.NO_ANIMATE)
         {
            this.faces_.push(new SquareFace(this.texture_,this.vin_,this.props_.xOffset_,this.props_.xOffset_,this.props_.animate_.type_,this.props_.animate_.dx_,this.props_.animate_.dy_));
            _loc1_ = TileRedrawer.redraw(this,false);
            if(_loc1_ != null)
            {
               this.faces_.push(new SquareFace(_loc1_,this.vin_,0,0,AnimateProperties.NO_ANIMATE,0,0));
            }
         }
         else
         {
            _loc1_ = TileRedrawer.redraw(this,true);
            _loc2_ = 0;
            _loc3_ = 0;
            if(_loc1_ == null)
            {
               if(this.props_.randomOffset_)
               {
                  _loc2_ = int(this.texture_.width * Math.random()) / this.texture_.width;
                  _loc3_ = int(this.texture_.height * Math.random()) / this.texture_.height;
               }
               else
               {
                  _loc2_ = this.props_.xOffset_;
                  _loc3_ = this.props_.yOffset_;
               }
            }
            this.faces_.push(new SquareFace(_loc1_ != null ? _loc1_ : this.texture_,this.vin_,_loc2_,_loc3_,AnimateProperties.NO_ANIMATE,0,0));
         }
         if(this.props_.sink_)
         {
            this.sink_ = _loc1_ == null ? 12 : 6;
         }
         else
         {
            this.sink_ = 0;
         }
         if(this.props_.topTD_)
         {
            _loc4_ = this.props_.topTD_.getTexture();
            _loc5_ = this.vin_.concat();
            _loc6_ = 2;
            while(_loc6_ < _loc5_.length)
            {
               _loc5_[_loc6_] = 1;
               _loc6_ += 3;
            }
            this.topFace_ = new SquareFace(_loc4_,_loc5_,0,0,this.props_.topAnimate_.type_,this.props_.topAnimate_.dx_,this.props_.topAnimate_.dy_);
         }
      }
   }
}

