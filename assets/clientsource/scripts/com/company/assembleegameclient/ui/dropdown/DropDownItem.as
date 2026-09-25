package com.company.assembleegameclient.ui.dropdown
{
   import com.company.ui.BaseSimpleText;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   
   public class DropDownItem extends Sprite
   {
      
      public var w_:int;
      
      public var h_:int;
      
      private var nameText_:BaseSimpleText;
      
      public function DropDownItem(param1:String, param2:int, param3:int)
      {
         super();
         this.w_ = param2;
         this.h_ = param3;
         this.nameText_ = new BaseSimpleText(16,11776947,false,0,0);
         this.nameText_.setBold(true);
         this.nameText_.text = param1;
         this.nameText_.updateMetrics();
         this.nameText_.filters = [new DropShadowFilter(0,0,0)];
         this.nameText_.x = this.w_ / 2 - this.nameText_.width / 2;
         this.nameText_.y = this.h_ / 2 - this.nameText_.height / 2;
         addChild(this.nameText_);
         this.drawBackground(3552822);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      public function getValue() : String
      {
         return this.nameText_.text;
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         this.drawBackground(5658198);
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         this.drawBackground(3552822);
      }
      
      private function drawBackground(param1:uint) : void
      {
         graphics.clear();
         graphics.lineStyle(1,11776947);
         graphics.beginFill(param1,1);
         graphics.drawRect(0,0,this.w_,this.h_);
         graphics.endFill();
         graphics.lineStyle();
      }
   }
}

