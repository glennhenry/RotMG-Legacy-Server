package com.company.assembleegameclient.map.mapoverlay
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.objects.GameObject;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.StringBuilder;
   
   public class CharacterStatusText extends Sprite implements IMapOverlayElement
   {
      
      public const MAX_DRIFT:int = 40;
      
      public var go_:GameObject;
      
      public var offset_:Point;
      
      public var color_:uint;
      
      public var lifetime_:int;
      
      public var offsetTime_:int;
      
      private var startTime_:int = 0;
      
      private var textDisplay:TextFieldDisplayConcrete;
      
      public function CharacterStatusText(param1:GameObject, param2:uint, param3:int, param4:int = 0)
      {
         super();
         this.go_ = param1;
         this.offset_ = new Point(0,-param1.texture_.height * (param1.size_ / 100) * 5 - 20);
         this.color_ = param2;
         this.lifetime_ = param3;
         this.offsetTime_ = param4;
         this.textDisplay = new TextFieldDisplayConcrete().setSize(24).setColor(param2).setBold(true);
         this.textDisplay.filters = [new GlowFilter(0,1,4,4,2,1)];
         addChild(this.textDisplay);
         visible = false;
      }
      
      public function draw(param1:Camera, param2:int) : Boolean
      {
         if(this.startTime_ == 0)
         {
            this.startTime_ = param2 + this.offsetTime_;
         }
         if(param2 < this.startTime_)
         {
            visible = false;
            return true;
         }
         var _loc3_:int = param2 - this.startTime_;
         if(_loc3_ > this.lifetime_ || this.go_ != null && this.go_.map_ == null)
         {
            return false;
         }
         if(this.go_ == null || !this.go_.drawn_)
         {
            visible = false;
            return true;
         }
         visible = true;
         x = (this.go_ != null ? this.go_.posS_[0] : 0) + (this.offset_ != null ? this.offset_.x : 0);
         var _loc4_:Number = _loc3_ / this.lifetime_ * this.MAX_DRIFT;
         y = (this.go_ != null ? this.go_.posS_[1] : 0) + (this.offset_ != null ? this.offset_.y : 0) - _loc4_;
         return true;
      }
      
      public function getGameObject() : GameObject
      {
         return this.go_;
      }
      
      public function dispose() : void
      {
         parent.removeChild(this);
      }
      
      public function setStringBuilder(param1:StringBuilder) : void
      {
         this.textDisplay.textChanged.add(this.onTextChanged);
         this.textDisplay.setStringBuilder(param1);
      }
      
      private function onTextChanged() : void
      {
         var _loc2_:Bitmap = null;
         var _loc1_:BitmapData = new BitmapData(this.textDisplay.width,this.textDisplay.height,true,0);
         _loc2_ = new Bitmap(_loc1_);
         _loc1_.draw(this.textDisplay,new Matrix());
         _loc2_.x -= _loc2_.width * 0.5;
         _loc2_.y -= _loc2_.height * 0.5;
         addChild(_loc2_);
         removeChild(this.textDisplay);
         this.textDisplay = null;
      }
   }
}

