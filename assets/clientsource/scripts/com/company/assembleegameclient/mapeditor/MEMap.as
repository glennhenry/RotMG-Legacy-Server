package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.map.GroundLibrary;
   import com.company.assembleegameclient.map.RegionLibrary;
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.util.AssetLibrary;
   import com.company.util.IntPoint;
   import com.company.util.KeyCodes;
   import com.company.util.PointUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   
   internal class MEMap extends Sprite
   {
      
      private static var transbackgroundEmbed_:Class = MEMap_transbackgroundEmbed_;
      
      private static var transbackgroundBD_:BitmapData = new transbackgroundEmbed_().bitmapData;
      
      public static const NUM_SQUARES:int = 512;
      
      public static const SQUARE_SIZE:int = 16;
      
      public static const SIZE:int = 512;
      
      public static const MIN_ZOOM:Number = 0.0625;
      
      public static const MAX_ZOOM:Number = 16;
      
      public var tileDict_:Dictionary = new Dictionary();
      
      public var fullMap_:BigBitmapData = new BigBitmapData(NUM_SQUARES * SQUARE_SIZE,NUM_SQUARES * SQUARE_SIZE,true,0);
      
      public var regionMap_:BitmapData = new BitmapDataSpy(NUM_SQUARES,NUM_SQUARES,true,0);
      
      public var map_:BitmapData = new BitmapDataSpy(SIZE,SIZE,true,0);
      
      public var overlay_:Shape = new Shape();
      
      public var posT_:IntPoint;
      
      public var zoom_:Number = 1;
      
      private var mouseRectAnchorT_:IntPoint = null;
      
      private var mouseMoveAnchorT_:IntPoint = null;
      
      private var rectWidthOverride:int = 0;
      
      private var rectHeightOverride:int = 0;
      
      private var invisibleTexture_:BitmapData;
      
      private var replaceTexture_:BitmapData;
      
      public var anchorLock:Boolean = false;
      
      public function MEMap()
      {
         super();
         graphics.beginBitmapFill(transbackgroundBD_,null,true);
         graphics.drawRect(0,0,SIZE,SIZE);
         addChild(new Bitmap(this.map_));
         addChild(this.overlay_);
         this.posT_ = new IntPoint(NUM_SQUARES / 2 - this.sizeInTiles() / 2,NUM_SQUARES / 2 - this.sizeInTiles() / 2);
         this.invisibleTexture_ = AssetLibrary.getImageFromSet("invisible",0);
         this.replaceTexture_ = AssetLibrary.getImageFromSet("lofiObj3",255);
         this.draw();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function getType(param1:int, param2:int, param3:int) : int
      {
         var _loc4_:METile = this.getTile(param1,param2);
         if(_loc4_ == null)
         {
            return -1;
         }
         return _loc4_.types_[param3];
      }
      
      public function getTile(param1:int, param2:int) : METile
      {
         return this.tileDict_[param1 + param2 * NUM_SQUARES];
      }
      
      public function modifyTile(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:METile = this.getOrCreateTile(param1,param2);
         if(_loc5_.types_[param3] == param4)
         {
            return;
         }
         _loc5_.types_[param3] = param4;
         this.drawTile(param1,param2,_loc5_);
      }
      
      public function getObjectName(param1:int, param2:int) : String
      {
         var _loc3_:METile = this.getTile(param1,param2);
         if(_loc3_ == null)
         {
            return null;
         }
         return _loc3_.objName_;
      }
      
      public function modifyObjectName(param1:int, param2:int, param3:String) : void
      {
         var _loc4_:METile = this.getOrCreateTile(param1,param2);
         _loc4_.objName_ = param3;
      }
      
      public function getAllTiles() : Vector.<IntPoint>
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc1_:Vector.<IntPoint> = new Vector.<IntPoint>();
         for(_loc2_ in this.tileDict_)
         {
            _loc3_ = int(_loc2_);
            _loc1_.push(new IntPoint(_loc3_ % NUM_SQUARES,_loc3_ / NUM_SQUARES));
         }
         return _loc1_;
      }
      
      public function setTile(param1:int, param2:int, param3:METile) : void
      {
         param3 = param3.clone();
         this.tileDict_[param1 + param2 * NUM_SQUARES] = param3;
         this.drawTile(param1,param2,param3);
      }
      
      public function eraseTile(param1:int, param2:int) : void
      {
         this.clearTile(param1,param2);
         this.drawTile(param1,param2,null);
      }
      
      public function clear() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         for(_loc1_ in this.tileDict_)
         {
            _loc2_ = int(_loc1_);
            this.eraseTile(_loc2_ % NUM_SQUARES,_loc2_ / NUM_SQUARES);
         }
      }
      
      public function getTileBounds() : Rectangle
      {
         var _loc5_:String = null;
         var _loc6_:METile = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc1_:int = NUM_SQUARES;
         var _loc2_:int = NUM_SQUARES;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         for(_loc5_ in this.tileDict_)
         {
            _loc6_ = this.tileDict_[_loc5_];
            if(!_loc6_.isEmpty())
            {
               _loc7_ = int(_loc5_);
               _loc8_ = _loc7_ % NUM_SQUARES;
               _loc9_ = _loc7_ / NUM_SQUARES;
               if(_loc8_ < _loc1_)
               {
                  _loc1_ = _loc8_;
               }
               if(_loc9_ < _loc2_)
               {
                  _loc2_ = _loc9_;
               }
               if(_loc8_ + 1 > _loc3_)
               {
                  _loc3_ = _loc8_ + 1;
               }
               if(_loc9_ + 1 > _loc4_)
               {
                  _loc4_ = _loc9_ + 1;
               }
            }
         }
         if(_loc1_ > _loc3_)
         {
            return null;
         }
         return new Rectangle(_loc1_,_loc2_,_loc3_ - _loc1_,_loc4_ - _loc2_);
      }
      
      private function sizeInTiles() : int
      {
         return SIZE / (SQUARE_SIZE * this.zoom_);
      }
      
      private function modifyZoom(param1:Number) : void
      {
         if(param1 > 1 && this.zoom_ >= MAX_ZOOM || param1 < 1 && this.zoom_ <= MIN_ZOOM)
         {
            return;
         }
         var _loc2_:IntPoint = this.mousePosT();
         this.zoom_ *= param1;
         var _loc3_:IntPoint = this.mousePosT();
         this.movePosT(_loc2_.x_ - _loc3_.x_,_loc2_.y_ - _loc3_.y_);
      }
      
      private function canMove() : Boolean
      {
         return this.mouseRectAnchorT_ == null && this.mouseMoveAnchorT_ == null;
      }
      
      private function increaseZoom() : void
      {
         if(!this.canMove())
         {
            return;
         }
         this.modifyZoom(2);
         this.draw();
      }
      
      private function decreaseZoom() : void
      {
         if(!this.canMove())
         {
            return;
         }
         this.modifyZoom(0.5);
         this.draw();
      }
      
      private function moveLeft() : void
      {
         if(!this.canMove())
         {
            return;
         }
         this.movePosT(-1,0);
         this.draw();
      }
      
      private function moveRight() : void
      {
         if(!this.canMove())
         {
            return;
         }
         this.movePosT(1,0);
         this.draw();
      }
      
      private function moveUp() : void
      {
         if(!this.canMove())
         {
            return;
         }
         this.movePosT(0,-1);
         this.draw();
      }
      
      private function moveDown() : void
      {
         if(!this.canMove())
         {
            return;
         }
         this.movePosT(0,1);
         this.draw();
      }
      
      private function movePosT(param1:int, param2:int) : void
      {
         var _loc4_:int = NUM_SQUARES - this.sizeInTiles();
         this.posT_.x_ = Math.max(0,Math.min(_loc4_,this.posT_.x_ + param1));
         this.posT_.y_ = Math.max(0,Math.min(_loc4_,this.posT_.y_ + param2));
      }
      
      private function mousePosT() : IntPoint
      {
         var _loc1_:int = Math.max(0,Math.min(SIZE - 1,mouseX));
         var _loc2_:int = Math.max(0,Math.min(SIZE - 1,mouseY));
         return new IntPoint(this.posT_.x_ + _loc1_ / (SQUARE_SIZE * this.zoom_),this.posT_.y_ + _loc2_ / (SQUARE_SIZE * this.zoom_));
      }
      
      public function mouseRectT() : Rectangle
      {
         var _loc1_:IntPoint = this.mousePosT();
         if(this.mouseRectAnchorT_ == null)
         {
            return new Rectangle(_loc1_.x_,_loc1_.y_,1,1);
         }
         return new Rectangle(Math.min(_loc1_.x_,this.mouseRectAnchorT_.x_),Math.min(_loc1_.y_,this.mouseRectAnchorT_.y_),Math.abs(_loc1_.x_ - this.mouseRectAnchorT_.x_) + 1,Math.abs(_loc1_.y_ - this.mouseRectAnchorT_.y_) + 1);
      }
      
      private function posTToPosP(param1:IntPoint) : IntPoint
      {
         return new IntPoint((param1.x_ - this.posT_.x_) * SQUARE_SIZE * this.zoom_,(param1.y_ - this.posT_.y_) * SQUARE_SIZE * this.zoom_);
      }
      
      private function sizeTToSizeP(param1:int) : Number
      {
         return param1 * this.zoom_ * SQUARE_SIZE;
      }
      
      private function mouseRectP() : Rectangle
      {
         var _loc1_:Rectangle = this.mouseRectT();
         var _loc2_:IntPoint = this.posTToPosP(new IntPoint(_loc1_.x,_loc1_.y));
         _loc1_.x = _loc2_.x_;
         _loc1_.y = _loc2_.y_;
         _loc1_.width = this.sizeTToSizeP(_loc1_.width) - 1;
         _loc1_.height = this.sizeTToSizeP(_loc1_.height) - 1;
         return _loc1_;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         switch(param1.keyCode)
         {
            case Keyboard.SHIFT:
               if(this.mouseRectAnchorT_ != null)
               {
                  break;
               }
               this.mouseRectAnchorT_ = this.mousePosT();
               break;
            case Keyboard.CONTROL:
               if(this.mouseMoveAnchorT_ != null)
               {
                  break;
               }
               this.mouseMoveAnchorT_ = this.mousePosT();
               break;
            case Keyboard.LEFT:
               this.moveLeft();
               break;
            case Keyboard.RIGHT:
               this.moveRight();
               break;
            case Keyboard.UP:
               this.moveUp();
               break;
            case Keyboard.DOWN:
               this.moveDown();
               break;
            case KeyCodes.MINUS:
               this.decreaseZoom();
               break;
            case KeyCodes.EQUAL:
               this.increaseZoom();
         }
         this.draw();
      }
      
      private function onKeyUp(param1:KeyboardEvent) : void
      {
         switch(param1.keyCode)
         {
            case Keyboard.SHIFT:
               this.mouseRectAnchorT_ = null;
               break;
            case Keyboard.CONTROL:
               this.mouseMoveAnchorT_ = null;
         }
         this.draw();
      }
      
      private function onMouseWheel(param1:MouseEvent) : void
      {
         if(param1.delta > 0)
         {
            this.increaseZoom();
         }
         else if(param1.delta < 0)
         {
            this.decreaseZoom();
         }
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         var _loc7_:int = 0;
         var _loc2_:Rectangle = this.mouseRectT();
         var _loc3_:Vector.<IntPoint> = new Vector.<IntPoint>();
         var _loc4_:int = Math.max(_loc2_.x + this.rectWidthOverride,_loc2_.right);
         var _loc5_:int = Math.max(_loc2_.y + this.rectHeightOverride,_loc2_.bottom);
         var _loc6_:int = _loc2_.x;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = _loc2_.y;
            while(_loc7_ < _loc5_)
            {
               _loc3_.push(new IntPoint(_loc6_,_loc7_));
               _loc7_++;
            }
            _loc6_++;
         }
         dispatchEvent(new TilesEvent(_loc3_));
      }
      
      public function freezeSelect() : void
      {
         var _loc1_:Rectangle = this.mouseRectT();
         this.rectWidthOverride = _loc1_.width;
         this.rectHeightOverride = _loc1_.height;
      }
      
      public function clearSelect() : void
      {
         this.rectHeightOverride = 0;
         this.rectWidthOverride = 0;
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:IntPoint = null;
         if(!param1.shiftKey)
         {
            this.mouseRectAnchorT_ = null;
         }
         else if(this.mouseRectAnchorT_ == null)
         {
            this.mouseRectAnchorT_ = this.mousePosT();
         }
         if(!param1.ctrlKey)
         {
            this.mouseMoveAnchorT_ = null;
         }
         else if(this.mouseMoveAnchorT_ == null)
         {
            this.mouseMoveAnchorT_ = this.mousePosT();
         }
         if(param1.buttonDown)
         {
            dispatchEvent(new TilesEvent(new <IntPoint>[this.mousePosT()]));
         }
         if(this.mouseMoveAnchorT_ != null)
         {
            _loc2_ = this.mousePosT();
            this.movePosT(this.mouseMoveAnchorT_.x_ - _loc2_.x_,this.mouseMoveAnchorT_.y_ - _loc2_.y_);
            this.draw();
         }
         else
         {
            this.drawOverlay();
         }
      }
      
      private function getOrCreateTile(param1:int, param2:int) : METile
      {
         var _loc3_:int = param1 + param2 * NUM_SQUARES;
         var _loc4_:METile = this.tileDict_[_loc3_];
         if(_loc4_ != null)
         {
            return _loc4_;
         }
         _loc4_ = new METile();
         this.tileDict_[_loc3_] = _loc4_;
         return _loc4_;
      }
      
      private function clearTile(param1:int, param2:int) : void
      {
         delete this.tileDict_[param1 + param2 * NUM_SQUARES];
      }
      
      private function drawTile(param1:int, param2:int, param3:METile) : void
      {
         var _loc5_:BitmapData = null;
         var _loc6_:BitmapData = null;
         var _loc7_:uint = 0;
         var _loc4_:Rectangle = new Rectangle(param1 * SQUARE_SIZE,param2 * SQUARE_SIZE,SQUARE_SIZE,SQUARE_SIZE);
         this.fullMap_.erase(_loc4_);
         this.regionMap_.setPixel32(param1,param2,0);
         if(param3 == null)
         {
            return;
         }
         if(param3.types_[Layer.GROUND] != -1)
         {
            _loc5_ = GroundLibrary.getBitmapData(param3.types_[Layer.GROUND]);
            this.fullMap_.copyTo(_loc5_,_loc5_.rect,_loc4_);
         }
         if(param3.types_[Layer.OBJECT] != -1)
         {
            _loc6_ = ObjectLibrary.getTextureFromType(param3.types_[Layer.OBJECT]);
            if(_loc6_ == null || _loc6_ == this.invisibleTexture_)
            {
               this.fullMap_.copyTo(this.replaceTexture_,this.replaceTexture_.rect,_loc4_);
            }
            else
            {
               this.fullMap_.copyTo(_loc6_,_loc6_.rect,_loc4_);
            }
         }
         if(param3.types_[Layer.REGION] != -1)
         {
            _loc7_ = RegionLibrary.getColor(param3.types_[Layer.REGION]);
            this.regionMap_.setPixel32(param1,param2,0x5F000000 | _loc7_);
         }
      }
      
      private function drawOverlay() : void
      {
         var _loc1_:Rectangle = this.mouseRectP();
         var _loc2_:Graphics = this.overlay_.graphics;
         _loc2_.clear();
         _loc2_.lineStyle(1,16777215);
         _loc2_.beginFill(16777215,0.1);
         _loc2_.drawRect(_loc1_.x,_loc1_.y,_loc1_.width,_loc1_.height);
         _loc2_.endFill();
         _loc2_.lineStyle();
      }
      
      public function draw() : void
      {
         var _loc2_:Matrix = null;
         var _loc3_:int = 0;
         var _loc4_:BitmapData = null;
         var _loc1_:int = SIZE / this.zoom_;
         this.map_.fillRect(this.map_.rect,0);
         this.fullMap_.copyFrom(new Rectangle(this.posT_.x_ * SQUARE_SIZE,this.posT_.y_ * SQUARE_SIZE,_loc1_,_loc1_),this.map_,this.map_.rect);
         _loc2_ = new Matrix();
         _loc2_.identity();
         _loc3_ = SQUARE_SIZE * this.zoom_;
         if(this.zoom_ > 2)
         {
            _loc4_ = new BitmapDataSpy(SIZE / _loc3_,SIZE / _loc3_);
            _loc4_.copyPixels(this.regionMap_,new Rectangle(this.posT_.x_,this.posT_.y_,_loc1_,_loc1_),PointUtil.ORIGIN);
            _loc2_.scale(_loc3_,_loc3_);
            this.map_.draw(_loc4_,_loc2_);
         }
         else
         {
            _loc2_.translate(-this.posT_.x_,-this.posT_.y_);
            _loc2_.scale(_loc3_,_loc3_);
            this.map_.draw(this.regionMap_,_loc2_,null,null,this.map_.rect);
         }
         this.drawOverlay();
      }
   }
}

