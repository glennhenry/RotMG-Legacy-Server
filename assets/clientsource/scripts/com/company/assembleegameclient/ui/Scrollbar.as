package com.company.assembleegameclient.ui
{
   import com.company.util.GraphicsUtil;
   import flash.display.Graphics;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.IGraphicsData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   
   public class Scrollbar extends Sprite
   {
      
      private var width_:int;
      
      private var height_:int;
      
      private var speed_:Number;
      
      private var indicatorRect_:Rectangle;
      
      private var jumpDist_:Number;
      
      private var background_:Sprite;
      
      private var upArrow_:Sprite;
      
      private var downArrow_:Sprite;
      
      private var posIndicator_:Sprite;
      
      private var target_:Sprite;
      
      private var lastUpdateTime_:int;
      
      private var change_:Number;
      
      private var backgroundFill_:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
      
      private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[this.backgroundFill_,this.path_,GraphicsUtil.END_FILL];
      
      public function Scrollbar(param1:int, param2:int, param3:Number = 1, param4:Sprite = null)
      {
         super();
         this.target_ = param4;
         this.background_ = new Sprite();
         this.background_.addEventListener(MouseEvent.MOUSE_DOWN,this.onBackgroundDown);
         addChild(this.background_);
         this.upArrow_ = this.getSprite(this.onUpArrowDown);
         addChild(this.upArrow_);
         this.downArrow_ = this.getSprite(this.onDownArrowDown);
         addChild(this.downArrow_);
         this.posIndicator_ = this.getSprite(this.onStartIndicatorDrag);
         addChild(this.posIndicator_);
         this.resize(param1,param2,param3);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private static function drawArrow(param1:int, param2:int, param3:Graphics) : void
      {
         param3.clear();
         param3.beginFill(3487029,0.01);
         param3.drawRect(-param1 / 2,-param2 / 2,param1,param2);
         param3.endFill();
         param3.beginFill(16777215,1);
         param3.moveTo(-param1 / 2,-param2 / 2);
         param3.lineTo(param1 / 2,0);
         param3.lineTo(-param1 / 2,param2 / 2);
         param3.lineTo(-param1 / 2,-param2 / 2);
         param3.endFill();
      }
      
      public function pos() : Number
      {
         return (this.posIndicator_.y - this.indicatorRect_.y) / (this.indicatorRect_.height - this.posIndicator_.height);
      }
      
      public function setIndicatorSize(param1:Number, param2:Number, param3:Boolean = true) : void
      {
         var _loc4_:int = param2 == 0 ? int(this.indicatorRect_.height) : int(param1 / param2 * this.indicatorRect_.height);
         _loc4_ = Math.min(this.indicatorRect_.height,Math.max(this.width_,_loc4_));
         this.drawIndicator(this.width_,_loc4_,this.posIndicator_.graphics);
         this.jumpDist_ = param1 / (param2 - param1) * 0.33;
         if(param3)
         {
            this.setPos(0);
         }
      }
      
      public function setPos(param1:Number) : void
      {
         param1 = Math.max(0,Math.min(1,param1));
         this.posIndicator_.y = param1 * (this.indicatorRect_.height - this.posIndicator_.height) + this.indicatorRect_.y;
         this.sendPos();
      }
      
      public function jumpUp() : void
      {
         this.setPos(this.pos() - this.jumpDist_);
      }
      
      public function jumpDown() : void
      {
         this.setPos(this.pos() + this.jumpDist_);
      }
      
      private function getSprite(param1:Function) : Sprite
      {
         var _loc2_:Sprite = new Sprite();
         _loc2_.addEventListener(MouseEvent.MOUSE_DOWN,param1);
         _loc2_.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         _loc2_.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         return _loc2_;
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = param1.target as Sprite;
         _loc2_.transform.colorTransform = new ColorTransform(1,0.8627,0.5216);
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = param1.target as Sprite;
         _loc2_.transform.colorTransform = new ColorTransform(1,1,1);
      }
      
      private function onBackgroundDown(param1:MouseEvent) : void
      {
         if(param1.localY < this.posIndicator_.y)
         {
            this.jumpUp();
         }
         else
         {
            this.jumpDown();
         }
      }
      
      protected function onAddedToStage(param1:Event) : void
      {
         if(this.target_ != null)
         {
            this.target_.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         }
         else if(parent)
         {
            parent.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         }
         else
         {
            WebMain.STAGE.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         }
      }
      
      protected function onRemovedFromStage(param1:Event) : void
      {
         if(this.target_ != null)
         {
            this.target_.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         }
         else if(parent)
         {
            parent.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         }
         else
         {
            WebMain.STAGE.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         }
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      protected function onMouseWheel(param1:MouseEvent) : void
      {
         if(param1.delta > 0)
         {
            this.jumpUp();
         }
         else if(param1.delta < 0)
         {
            this.jumpDown();
         }
      }
      
      private function onUpArrowDown(param1:MouseEvent) : void
      {
         addEventListener(Event.ENTER_FRAME,this.onArrowFrame);
         addEventListener(MouseEvent.MOUSE_UP,this.onArrowUp);
         this.lastUpdateTime_ = getTimer();
         this.change_ = -this.speed_;
      }
      
      private function onDownArrowDown(param1:MouseEvent) : void
      {
         addEventListener(Event.ENTER_FRAME,this.onArrowFrame);
         addEventListener(MouseEvent.MOUSE_UP,this.onArrowUp);
         this.lastUpdateTime_ = getTimer();
         this.change_ = this.speed_;
      }
      
      private function onArrowFrame(param1:Event) : void
      {
         var _loc2_:int = getTimer();
         var _loc3_:Number = (_loc2_ - this.lastUpdateTime_) / 1000;
         var _loc4_:Number = (this.height_ - this.width_ * 3) * _loc3_ * this.change_;
         this.setPos((this.posIndicator_.y + _loc4_ - this.indicatorRect_.y) / (this.indicatorRect_.height - this.posIndicator_.height));
         this.lastUpdateTime_ = _loc2_;
      }
      
      private function onArrowUp(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onArrowFrame);
         removeEventListener(MouseEvent.MOUSE_UP,this.onArrowUp);
      }
      
      private function onStartIndicatorDrag(param1:MouseEvent) : void
      {
         this.posIndicator_.startDrag(false,new Rectangle(0,this.indicatorRect_.y,0,this.indicatorRect_.height - this.posIndicator_.height));
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onStopIndicatorDrag);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onDragMove);
         this.sendPos();
      }
      
      private function onStopIndicatorDrag(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStopIndicatorDrag);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDragMove);
         this.posIndicator_.stopDrag();
         this.sendPos();
      }
      
      private function onDragMove(param1:MouseEvent) : void
      {
         this.sendPos();
      }
      
      private function sendPos() : void
      {
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function resize(param1:int, param2:int, param3:Number = 1) : void
      {
         this.width_ = param1;
         this.height_ = param2;
         this.speed_ = param3;
         var _loc4_:int = this.width_ * 0.75;
         this.indicatorRect_ = new Rectangle(0,_loc4_ + 5,this.width_,this.height_ - _loc4_ * 2 - 10);
         var _loc5_:Graphics = this.background_.graphics;
         _loc5_.clear();
         _loc5_.beginFill(5526612,1);
         _loc5_.drawRect(this.indicatorRect_.x,this.indicatorRect_.y,this.indicatorRect_.width,this.indicatorRect_.height);
         _loc5_.endFill();
         drawArrow(_loc4_,this.width_,this.upArrow_.graphics);
         this.upArrow_.rotation = -90;
         this.upArrow_.x = this.width_ / 2;
         this.upArrow_.y = _loc4_ / 2;
         drawArrow(_loc4_,this.width_,this.downArrow_.graphics);
         this.downArrow_.x = this.width_ / 2;
         this.downArrow_.y = this.height_ - _loc4_ / 2;
         this.downArrow_.rotation = 90;
         this.drawIndicator(this.width_,this.height_,this.posIndicator_.graphics);
         this.posIndicator_.x = 0;
         this.posIndicator_.y = this.indicatorRect_.y;
      }
      
      private function drawIndicator(param1:int, param2:int, param3:Graphics) : void
      {
         GraphicsUtil.clearPath(this.path_);
         GraphicsUtil.drawCutEdgeRect(0,0,param1,param2,4,[1,1,1,1],this.path_);
         param3.clear();
         param3.drawGraphicsData(this.graphicsData_);
      }
   }
}

