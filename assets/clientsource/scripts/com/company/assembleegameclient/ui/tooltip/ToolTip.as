package com.company.assembleegameclient.ui.tooltip
{
   import com.company.util.GraphicsUtil;
   import flash.display.CapsStyle;
   import flash.display.DisplayObject;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.GraphicsStroke;
   import flash.display.IGraphicsData;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.ui.view.SignalWaiter;
   
   public class ToolTip extends Sprite
   {
      
      private var background_:uint;
      
      private var backgroundAlpha_:Number;
      
      private var outline_:uint;
      
      private var outlineAlpha_:Number;
      
      private var followMouse_:Boolean;
      
      private var forcePositionLeft_:Boolean = false;
      
      private var forcePositionRight_:Boolean = false;
      
      public var contentWidth_:int;
      
      public var contentHeight_:int;
      
      private var targetObj:DisplayObject;
      
      private var backgroundFill_:GraphicsSolidFill = new GraphicsSolidFill(0,1);
      
      private var outlineFill_:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
      
      private var lineStyle_:GraphicsStroke = new GraphicsStroke(1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,this.outlineFill_);
      
      private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[this.lineStyle_,this.backgroundFill_,this.path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
      
      protected const waiter:SignalWaiter = new SignalWaiter();
      
      public function ToolTip(param1:uint, param2:Number, param3:uint, param4:Number, param5:Boolean = true)
      {
         super();
         this.background_ = param1;
         this.backgroundAlpha_ = param2;
         this.outline_ = param3;
         this.outlineAlpha_ = param4;
         this.followMouse_ = param5;
         mouseEnabled = false;
         mouseChildren = false;
         filters = [new DropShadowFilter(0,0,0,1,16,16)];
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.waiter.complete.add(this.alignUIAndDraw);
      }
      
      private function alignUIAndDraw() : void
      {
         this.alignUI();
         this.draw();
         this.position();
      }
      
      protected function alignUI() : void
      {
      }
      
      public function attachToTarget(param1:DisplayObject) : void
      {
         if(param1)
         {
            this.targetObj = param1;
            this.targetObj.addEventListener(MouseEvent.ROLL_OUT,this.onLeaveTarget);
         }
      }
      
      public function detachFromTarget() : void
      {
         if(this.targetObj)
         {
            this.targetObj.removeEventListener(MouseEvent.ROLL_OUT,this.onLeaveTarget);
            if(parent)
            {
               parent.removeChild(this);
            }
            this.targetObj = null;
         }
      }
      
      public function forcePostionLeft() : void
      {
         this.forcePositionLeft_ = true;
         this.forcePositionRight_ = false;
      }
      
      public function forcePostionRight() : void
      {
         this.forcePositionRight_ = true;
         this.forcePositionLeft_ = false;
      }
      
      private function onLeaveTarget(param1:MouseEvent) : void
      {
         this.detachFromTarget();
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         if(this.waiter.isEmpty())
         {
            this.draw();
         }
         if(this.followMouse_)
         {
            this.position();
            addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         if(this.followMouse_)
         {
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         this.position();
      }
      
      protected function position() : void
      {
         if(stage == null)
         {
            return;
         }
         if(!this.forcePositionLeft_ && stage.mouseX < stage.stageWidth / 2 || this.forcePositionRight_)
         {
            x = stage.mouseX + 12;
         }
         else
         {
            x = stage.mouseX - width - 1;
         }
         if(x < 12)
         {
            x = 12;
         }
         if(!this.forcePositionLeft_ && stage.mouseY < stage.stageHeight / 3 || this.forcePositionRight_)
         {
            y = stage.mouseY + 12;
         }
         else
         {
            y = stage.mouseY - height - 1;
         }
         if(y < 12)
         {
            y = 12;
         }
      }
      
      public function draw() : void
      {
         this.backgroundFill_.color = this.background_;
         this.backgroundFill_.alpha = this.backgroundAlpha_;
         this.outlineFill_.color = this.outline_;
         this.outlineFill_.alpha = this.outlineAlpha_;
         graphics.clear();
         this.contentWidth_ = width;
         this.contentHeight_ = height;
         GraphicsUtil.clearPath(this.path_);
         GraphicsUtil.drawCutEdgeRect(-6,-6,this.contentWidth_ + 12,this.contentHeight_ + 12,4,[1,1,1,1],this.path_);
         graphics.drawGraphicsData(this.graphicsData_);
      }
   }
}

