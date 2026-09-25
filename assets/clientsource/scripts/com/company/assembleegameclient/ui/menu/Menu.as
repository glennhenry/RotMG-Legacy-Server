package com.company.assembleegameclient.ui.menu
{
   import com.company.util.GraphicsUtil;
   import com.company.util.RectangleUtil;
   import flash.display.CapsStyle;
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
   import flash.geom.Rectangle;
   import kabam.rotmg.ui.view.UnFocusAble;
   
   public class Menu extends Sprite implements UnFocusAble
   {
      
      private var backgroundFill_:GraphicsSolidFill = new GraphicsSolidFill(0,1);
      
      private var outlineFill_:GraphicsSolidFill = new GraphicsSolidFill(0,1);
      
      private var lineStyle_:GraphicsStroke = new GraphicsStroke(1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,this.outlineFill_);
      
      private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[this.lineStyle_,this.backgroundFill_,this.path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
      
      private var background_:uint;
      
      private var outline_:uint;
      
      protected var yOffset:int;
      
      public function Menu(param1:uint, param2:uint)
      {
         super();
         this.background_ = param1;
         this.outline_ = param2;
         this.yOffset = 40;
         filters = [new DropShadowFilter(0,0,0,1,16,16)];
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      protected function addOption(param1:MenuOption) : void
      {
         param1.x = 8;
         param1.y = this.yOffset;
         addChild(param1);
         this.yOffset += 28;
      }
      
      protected function onAddedToStage(param1:Event) : void
      {
         this.draw();
         this.position();
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
      }
      
      protected function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
      }
      
      protected function onEnterFrame(param1:Event) : void
      {
         if(stage == null)
         {
            return;
         }
         var _loc2_:Rectangle = getRect(stage);
         var _loc3_:Number = RectangleUtil.pointDist(_loc2_,stage.mouseX,stage.mouseY);
         if(_loc3_ > 40)
         {
            this.remove();
         }
      }
      
      private function position() : void
      {
         if(stage == null)
         {
            return;
         }
         if(stage.mouseX < stage.stageWidth / 2)
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
         if(stage.mouseY < stage.stageHeight / 3)
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
      
      protected function onRollOut(param1:Event) : void
      {
         this.remove();
      }
      
      public function remove() : void
      {
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      protected function draw() : void
      {
         this.backgroundFill_.color = this.background_;
         this.outlineFill_.color = this.outline_;
         graphics.clear();
         GraphicsUtil.clearPath(this.path_);
         GraphicsUtil.drawCutEdgeRect(-6,-6,Math.max(154,width + 12),height + 12,4,[1,1,1,1],this.path_);
         graphics.drawGraphicsData(this.graphicsData_);
      }
   }
}

