package com.company.assembleegameclient.editor
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.utils.Dictionary;
   
   public class CommandMenu extends Sprite
   {
      
      private var keyCodeDict_:Dictionary = new Dictionary();
      
      private var yOffset_:int = 0;
      
      private var selected_:CommandMenuItem = null;
      
      public function CommandMenu()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function getCommand() : int
      {
         return this.selected_.command_;
      }
      
      public function setCommand(param1:int) : void
      {
         var _loc3_:CommandMenuItem = null;
         var _loc2_:int = 0;
         while(_loc2_ < numChildren)
         {
            _loc3_ = getChildAt(_loc2_) as CommandMenuItem;
            if(_loc3_ != null)
            {
               if(_loc3_.command_ == param1)
               {
                  this.setSelected(_loc3_);
                  break;
               }
            }
            _loc2_++;
         }
      }
      
      protected function setSelected(param1:CommandMenuItem) : void
      {
         if(this.selected_ != null)
         {
            this.selected_.setSelected(false);
         }
         this.selected_ = param1;
         this.selected_.setSelected(true);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(stage.focus != null)
         {
            return;
         }
         var _loc2_:CommandMenuItem = this.keyCodeDict_[param1.keyCode];
         if(_loc2_ == null)
         {
            return;
         }
         _loc2_.callback_(_loc2_);
      }
      
      protected function addCommandMenuItem(param1:String, param2:int, param3:Function, param4:int) : void
      {
         var _loc5_:CommandMenuItem = new CommandMenuItem(param1,param3,param4);
         _loc5_.y = this.yOffset_;
         addChild(_loc5_);
         this.keyCodeDict_[param2] = _loc5_;
         if(this.selected_ == null)
         {
            this.setSelected(_loc5_);
         }
         this.yOffset_ += 30;
      }
      
      protected function addBreak() : void
      {
         this.yOffset_ += 30;
      }
   }
}

