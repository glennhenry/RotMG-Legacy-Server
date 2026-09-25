package com.company.assembleegameclient.ui.panels.itemgrids.itemtiles
{
   import com.company.assembleegameclient.ui.panels.itemgrids.ItemGrid;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class InteractiveItemTile extends ItemTile
   {
      
      private static const DOUBLE_CLICK_PAUSE:uint = 250;
      
      private static const DRAG_DIST:int = 3;
      
      private var doubleClickTimer:Timer;
      
      private var dragStart:Point;
      
      private var pendingSecondClick:Boolean;
      
      private var isDragging:Boolean;
      
      public function InteractiveItemTile(param1:int, param2:ItemGrid, param3:Boolean)
      {
         super(param1,param2);
         mouseChildren = false;
         this.doubleClickTimer = new Timer(DOUBLE_CLICK_PAUSE,1);
         this.doubleClickTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onDoubleClickTimerComplete);
         this.setInteractive(param3);
      }
      
      public function setInteractive(param1:Boolean) : void
      {
         if(param1)
         {
            addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
            addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         }
         else
         {
            removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         }
      }
      
      public function getDropTarget() : DisplayObject
      {
         return itemSprite.dropTarget;
      }
      
      protected function beginDragCallback() : void
      {
      }
      
      protected function endDragCallback() : void
      {
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         this.setPendingDoubleClick(false);
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         if(this.isDragging)
         {
            return;
         }
         if(param1.shiftKey)
         {
            this.setPendingDoubleClick(false);
            dispatchEvent(new ItemTileEvent(ItemTileEvent.ITEM_SHIFT_CLICK,this));
         }
         else if(param1.ctrlKey)
         {
            this.setPendingDoubleClick(false);
            dispatchEvent(new ItemTileEvent(ItemTileEvent.ITEM_CTRL_CLICK,this));
         }
         else if(!this.pendingSecondClick)
         {
            this.setPendingDoubleClick(true);
         }
         else
         {
            this.setPendingDoubleClick(false);
            dispatchEvent(new ItemTileEvent(ItemTileEvent.ITEM_DOUBLE_CLICK,this));
         }
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         this.beginDragCheck(param1);
      }
      
      private function setPendingDoubleClick(param1:Boolean) : void
      {
         this.pendingSecondClick = param1;
         if(this.pendingSecondClick)
         {
            this.doubleClickTimer.reset();
            this.doubleClickTimer.start();
         }
         else
         {
            this.doubleClickTimer.stop();
         }
      }
      
      private function beginDragCheck(param1:MouseEvent) : void
      {
         this.dragStart = new Point(param1.stageX,param1.stageY);
         addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveCheckDrag);
         addEventListener(MouseEvent.MOUSE_OUT,this.cancelDragCheck);
         addEventListener(MouseEvent.MOUSE_UP,this.cancelDragCheck);
      }
      
      private function cancelDragCheck(param1:MouseEvent) : void
      {
         removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveCheckDrag);
         removeEventListener(MouseEvent.MOUSE_OUT,this.cancelDragCheck);
         removeEventListener(MouseEvent.MOUSE_UP,this.cancelDragCheck);
      }
      
      private function onMouseMoveCheckDrag(param1:MouseEvent) : void
      {
         var _loc2_:Number = param1.stageX - this.dragStart.x;
         var _loc3_:Number = param1.stageY - this.dragStart.y;
         var _loc4_:Number = Math.sqrt(_loc2_ * _loc2_ + _loc3_ * _loc3_);
         if(_loc4_ > DRAG_DIST)
         {
            this.cancelDragCheck(null);
            this.setPendingDoubleClick(false);
            this.beginDrag(param1);
         }
      }
      
      private function onDoubleClickTimerComplete(param1:TimerEvent) : void
      {
         this.setPendingDoubleClick(false);
         dispatchEvent(new ItemTileEvent(ItemTileEvent.ITEM_CLICK,this));
      }
      
      private function beginDrag(param1:MouseEvent) : void
      {
         this.isDragging = true;
         stage.addChild(itemSprite);
         itemSprite.startDrag(true);
         itemSprite.x = param1.stageX;
         itemSprite.y = param1.stageY;
         itemSprite.addEventListener(MouseEvent.MOUSE_UP,this.endDrag);
         this.beginDragCallback();
      }
      
      private function endDrag(param1:MouseEvent) : void
      {
         this.isDragging = false;
         itemSprite.stopDrag();
         itemSprite.removeEventListener(MouseEvent.MOUSE_UP,this.endDrag);
         dispatchEvent(new ItemTileEvent(ItemTileEvent.ITEM_MOVE,this));
         this.endDragCallback();
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         this.setPendingDoubleClick(false);
         this.cancelDragCheck(null);
         if(this.isDragging)
         {
            itemSprite.stopDrag();
         }
      }
   }
}

