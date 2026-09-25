package com.company.assembleegameclient.ui.dropdown
{
   import com.company.ui.BaseSimpleText;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class DropDown extends Sprite
   {
      
      protected var strings_:Vector.<String>;
      
      protected var w_:int;
      
      protected var h_:int;
      
      protected var labelText_:BaseSimpleText;
      
      protected var xOffset_:int = 0;
      
      protected var selected_:DropDownItem;
      
      protected var all_:Sprite = new Sprite();
      
      public function DropDown(param1:Vector.<String>, param2:int, param3:int, param4:String = null)
      {
         super();
         this.strings_ = param1;
         this.w_ = param2;
         this.h_ = param3;
         if(param4 != null)
         {
            this.labelText_ = new BaseSimpleText(16,16777215,false,0,0);
            this.labelText_.setBold(true);
            this.labelText_.text = param4 + ":";
            this.labelText_.updateMetrics();
            addChild(this.labelText_);
            this.xOffset_ = this.labelText_.width + 5;
         }
         this.setIndex(0);
      }
      
      public function getValue() : String
      {
         return this.selected_.getValue();
      }
      
      public function setValue(param1:String) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.strings_.length)
         {
            if(param1 == this.strings_[_loc2_])
            {
               this.setIndex(_loc2_);
               return;
            }
            _loc2_++;
         }
      }
      
      public function setIndex(param1:int) : void
      {
         this.setSelected(this.strings_[param1]);
      }
      
      public function getIndex() : int
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.strings_.length)
         {
            if(this.selected_.getValue() == this.strings_[_loc1_])
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return -1;
      }
      
      private function setSelected(param1:String) : void
      {
         var _loc2_:String = null;
         _loc2_ = this.selected_ != null ? this.selected_.getValue() : null;
         this.selected_ = new DropDownItem(param1,this.w_,this.h_);
         this.selected_.x = this.xOffset_;
         this.selected_.y = 0;
         addChild(this.selected_);
         this.selected_.addEventListener(MouseEvent.CLICK,this.onClick);
         if(param1 != _loc2_)
         {
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         this.selected_.removeEventListener(MouseEvent.CLICK,this.onClick);
         if(contains(this.selected_))
         {
            removeChild(this.selected_);
         }
         this.showAll();
      }
      
      private function showAll() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Point = null;
         var _loc4_:DropDownItem = null;
         _loc1_ = 0;
         _loc2_ = parent.localToGlobal(new Point(x,y));
         this.all_.x = _loc2_.x;
         this.all_.y = _loc2_.y;
         var _loc3_:int = 0;
         while(_loc3_ < this.strings_.length)
         {
            _loc4_ = new DropDownItem(this.strings_[_loc3_],this.w_,this.h_);
            _loc4_.addEventListener(MouseEvent.CLICK,this.onSelect);
            _loc4_.x = this.xOffset_;
            _loc4_.y = _loc1_;
            this.all_.addChild(_loc4_);
            _loc1_ += _loc4_.h_;
            _loc3_++;
         }
         this.all_.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         stage.addChild(this.all_);
      }
      
      private function hideAll() : void
      {
         this.all_.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
         stage.removeChild(this.all_);
      }
      
      private function onSelect(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         this.hideAll();
         var _loc2_:DropDownItem = param1.target as DropDownItem;
         this.setSelected(_loc2_.getValue());
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this.hideAll();
         this.setSelected(this.selected_.getValue());
      }
   }
}

