package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Element extends Sprite
   {
      
      public static const WIDTH:int = 50;
      
      public static const HEIGHT:int = 50;
      
      protected static var toolTip_:ToolTip = null;
      
      public var type_:int;
      
      protected var selected_:Boolean = false;
      
      protected var mouseOver_:Boolean = false;
      
      public function Element(param1:int)
      {
         super();
         this.type_ = param1;
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function setSelected(param1:Boolean) : void
      {
         this.selected_ = param1;
         this.draw();
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
      }
      
      private function onMouseOver(param1:Event) : void
      {
         this.mouseOver_ = true;
         this.draw();
         this.setToolTip(this.getToolTip());
      }
      
      private function onRollOut(param1:Event) : void
      {
         this.mouseOver_ = false;
         this.draw();
         this.removeTooltip();
      }
      
      protected function setToolTip(param1:ToolTip) : void
      {
         this.removeTooltip();
         toolTip_ = param1;
         if(toolTip_ != null)
         {
            stage.addChild(toolTip_);
         }
      }
      
      protected function removeTooltip() : void
      {
         if(toolTip_ != null)
         {
            if(toolTip_.parent != null)
            {
               toolTip_.parent.removeChild(toolTip_);
            }
            toolTip_ = null;
         }
      }
      
      protected function getToolTip() : ToolTip
      {
         return null;
      }
      
      private function draw() : void
      {
         graphics.clear();
         var _loc1_:uint = 3552822;
         if(this.selected_)
         {
            graphics.lineStyle(1,16777215);
            _loc1_ = 8355711;
         }
         graphics.beginFill(this.mouseOver_ ? 5658198 : 3552822,1);
         graphics.drawRect(2,2,WIDTH - 4,HEIGHT - 4);
         if(this.selected_)
         {
            graphics.lineStyle();
         }
         graphics.endFill();
      }
   }
}

