package com.company.assembleegameclient.util
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.util.Trig;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class AnimatedChar
   {
      
      public static const RIGHT:int = 0;
      
      public static const LEFT:int = 1;
      
      public static const DOWN:int = 2;
      
      public static const UP:int = 3;
      
      public static const NUM_DIR:int = 4;
      
      public static const STAND:int = 0;
      
      public static const WALK:int = 1;
      
      public static const ATTACK:int = 2;
      
      public static const NUM_ACTION:int = 3;
      
      private static const SEC_TO_DIRS:Vector.<Vector.<int>> = new <Vector.<int>>[new <int>[LEFT,UP,DOWN],new <int>[UP,LEFT,DOWN],new <int>[UP,RIGHT,DOWN],new <int>[RIGHT,UP,DOWN],new <int>[RIGHT,DOWN],new <int>[DOWN,RIGHT],new <int>[DOWN,LEFT],new <int>[LEFT,DOWN]];
      
      private static const PIOVER4:Number = Math.PI / 4;
      
      public var origImage_:MaskedImage;
      
      private var width_:int;
      
      private var height_:int;
      
      private var firstDir_:int;
      
      private var dict_:Dictionary = new Dictionary();
      
      public function AnimatedChar(param1:MaskedImage, param2:int, param3:int, param4:int)
      {
         super();
         this.origImage_ = param1;
         this.width_ = param2;
         this.height_ = param3;
         this.firstDir_ = param4;
         var _loc5_:Dictionary = new Dictionary();
         var _loc6_:MaskedImageSet = new MaskedImageSet();
         _loc6_.addFromMaskedImage(param1,param2,param3);
         if(param4 == RIGHT)
         {
            this.dict_[RIGHT] = this.loadDir(0,false,false,_loc6_);
            this.dict_[LEFT] = this.loadDir(0,true,false,_loc6_);
            if(_loc6_.images_.length >= 14)
            {
               this.dict_[DOWN] = this.loadDir(7,false,true,_loc6_);
               if(_loc6_.images_.length >= 21)
               {
                  this.dict_[UP] = this.loadDir(14,false,true,_loc6_);
               }
            }
         }
         else if(param4 == DOWN)
         {
            this.dict_[DOWN] = this.loadDir(0,false,true,_loc6_);
            if(_loc6_.images_.length >= 14)
            {
               this.dict_[RIGHT] = this.loadDir(7,false,false,_loc6_);
               this.dict_[LEFT] = this.loadDir(7,true,false,_loc6_);
               if(_loc6_.images_.length >= 21)
               {
                  this.dict_[UP] = this.loadDir(14,false,true,_loc6_);
               }
            }
         }
      }
      
      public function getFirstDirImage() : BitmapData
      {
         var _loc1_:BitmapData = new BitmapDataSpy(this.width_ * 7,this.height_,true,0);
         var _loc2_:Dictionary = this.dict_[this.firstDir_];
         var _loc3_:Vector.<MaskedImage> = _loc2_[STAND];
         if(_loc3_.length > 0)
         {
            _loc1_.copyPixels(_loc3_[0].image_,_loc3_[0].image_.rect,new Point(0,0));
         }
         _loc3_ = _loc2_[WALK];
         if(_loc3_.length > 0)
         {
            _loc1_.copyPixels(_loc3_[0].image_,_loc3_[0].image_.rect,new Point(this.width_,0));
         }
         if(_loc3_.length > 1)
         {
            _loc1_.copyPixels(_loc3_[1].image_,_loc3_[1].image_.rect,new Point(this.width_ * 2,0));
         }
         _loc3_ = _loc2_[ATTACK];
         if(_loc3_.length > 0)
         {
            _loc1_.copyPixels(_loc3_[0].image_,_loc3_[0].image_.rect,new Point(this.width_ * 4,0));
         }
         if(_loc3_.length > 1)
         {
            _loc1_.copyPixels(_loc3_[1].image_,new Rectangle(this.width_,0,this.width_ * 2,this.height_),new Point(this.width_ * 5,0));
         }
         return _loc1_;
      }
      
      public function imageVec(param1:int, param2:int) : Vector.<MaskedImage>
      {
         return this.dict_[param1][param2];
      }
      
      public function imageFromDir(param1:int, param2:int, param3:Number) : MaskedImage
      {
         var _loc4_:Vector.<MaskedImage> = this.dict_[param1][param2];
         param3 = Math.max(0,Math.min(0.99999,param3));
         var _loc5_:int = param3 * _loc4_.length;
         return _loc4_[_loc5_];
      }
      
      public function imageFromAngle(param1:Number, param2:int, param3:Number) : MaskedImage
      {
         var _loc4_:int = int(param1 / PIOVER4 + 4) % 8;
         var _loc5_:Vector.<int> = SEC_TO_DIRS[_loc4_];
         var _loc6_:Dictionary = this.dict_[_loc5_[0]];
         if(_loc6_ == null)
         {
            _loc6_ = this.dict_[_loc5_[1]];
            if(_loc6_ == null)
            {
               _loc6_ = this.dict_[_loc5_[2]];
            }
         }
         var _loc7_:Vector.<MaskedImage> = _loc6_[param2];
         param3 = Math.max(0,Math.min(0.99999,param3));
         var _loc8_:int = param3 * _loc7_.length;
         return _loc7_[_loc8_];
      }
      
      public function imageFromFacing(param1:Number, param2:Camera, param3:int, param4:Number) : MaskedImage
      {
         var _loc5_:Number = Trig.boundToPI(param1 - param2.angleRad_);
         var _loc6_:int = int(_loc5_ / PIOVER4 + 4) % 8;
         var _loc7_:Vector.<int> = SEC_TO_DIRS[_loc6_];
         var _loc8_:Dictionary = this.dict_[_loc7_[0]];
         if(_loc8_ == null)
         {
            _loc8_ = this.dict_[_loc7_[1]];
            if(_loc8_ == null)
            {
               _loc8_ = this.dict_[_loc7_[2]];
            }
         }
         var _loc9_:Vector.<MaskedImage> = _loc8_[param3];
         param4 = Math.max(0,Math.min(0.99999,param4));
         var _loc10_:int = param4 * _loc9_.length;
         return _loc9_[_loc10_];
      }
      
      private function loadDir(param1:int, param2:Boolean, param3:Boolean, param4:MaskedImageSet) : Dictionary
      {
         var _loc14_:Vector.<MaskedImage> = null;
         var _loc15_:BitmapData = null;
         var _loc16_:BitmapData = null;
         var _loc5_:Dictionary = new Dictionary();
         var _loc6_:MaskedImage = param4.images_[param1 + 0];
         var _loc7_:MaskedImage = param4.images_[param1 + 1];
         var _loc8_:MaskedImage = param4.images_[param1 + 2];
         if(_loc8_.amountTransparent() == 1)
         {
            _loc8_ = null;
         }
         var _loc9_:MaskedImage = param4.images_[param1 + 4];
         var _loc10_:MaskedImage = param4.images_[param1 + 5];
         if(_loc9_.amountTransparent() == 1)
         {
            _loc9_ = null;
         }
         if(_loc10_.amountTransparent() == 1)
         {
            _loc10_ = null;
         }
         var _loc11_:MaskedImage = param4.images_[param1 + 6];
         if(_loc10_ != null && _loc11_.amountTransparent() != 1)
         {
            _loc15_ = new BitmapDataSpy(this.width_ * 3,this.height_,true,0);
            _loc15_.copyPixels(_loc10_.image_,new Rectangle(0,0,this.width_,this.height_),new Point(this.width_,0));
            _loc15_.copyPixels(_loc11_.image_,new Rectangle(0,0,this.width_,this.height_),new Point(this.width_ * 2,0));
            _loc16_ = null;
            if(_loc10_.mask_ != null || _loc11_.mask_ != null)
            {
               _loc16_ = new BitmapDataSpy(this.width_ * 3,this.height_,true,0);
            }
            if(_loc10_.mask_ != null)
            {
               _loc16_.copyPixels(_loc10_.mask_,new Rectangle(0,0,this.width_,this.height_),new Point(this.width_,0));
            }
            if(_loc11_.mask_ != null)
            {
               _loc16_.copyPixels(_loc11_.mask_,new Rectangle(0,0,this.width_,this.height_),new Point(this.width_ * 2,0));
            }
            _loc10_ = new MaskedImage(_loc15_,_loc16_);
         }
         var _loc12_:Vector.<MaskedImage> = new Vector.<MaskedImage>();
         _loc12_.push(param2 ? _loc6_.mirror() : _loc6_);
         _loc5_[STAND] = _loc12_;
         var _loc13_:Vector.<MaskedImage> = new Vector.<MaskedImage>();
         _loc13_.push(param2 ? _loc7_.mirror() : _loc7_);
         if(_loc8_ != null)
         {
            _loc13_.push(param2 ? _loc8_.mirror() : _loc8_);
         }
         else if(param3)
         {
            _loc13_.push(!param2 ? _loc7_.mirror(7) : _loc7_);
         }
         else
         {
            _loc13_.push(param2 ? _loc6_.mirror() : _loc6_);
         }
         _loc5_[WALK] = _loc13_;
         if(_loc9_ == null && _loc10_ == null)
         {
            _loc14_ = _loc13_;
         }
         else
         {
            _loc14_ = new Vector.<MaskedImage>();
            if(_loc9_ != null)
            {
               _loc14_.push(param2 ? _loc9_.mirror() : _loc9_);
            }
            if(_loc10_ != null)
            {
               _loc14_.push(param2 ? _loc10_.mirror() : _loc10_);
            }
         }
         _loc5_[ATTACK] = _loc14_;
         return _loc5_;
      }
   }
}

