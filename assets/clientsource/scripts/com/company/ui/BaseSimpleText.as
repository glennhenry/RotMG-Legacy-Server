package com.company.ui
{
   import flash.events.Event;
   import flash.text.Font;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextLineMetrics;
   
   public class BaseSimpleText extends TextField
   {
      
      public static const MyriadPro:Class = BaseSimpleText_MyriadPro;
      
      public var inputWidth_:int;
      
      public var inputHeight_:int;
      
      public var actualWidth_:int;
      
      public var actualHeight_:int;
      
      public function BaseSimpleText(param1:int, param2:uint, param3:Boolean = false, param4:int = 0, param5:int = 0)
      {
         super();
         this.inputWidth_ = param4;
         if(this.inputWidth_ != 0)
         {
            width = param4;
         }
         this.inputHeight_ = param5;
         if(this.inputHeight_ != 0)
         {
            height = param5;
         }
         Font.registerFont(MyriadPro);
         var _loc6_:Font = new MyriadPro();
         var _loc7_:TextFormat = this.defaultTextFormat;
         _loc7_.font = _loc6_.fontName;
         _loc7_.bold = false;
         _loc7_.size = param1;
         _loc7_.color = param2;
         defaultTextFormat = _loc7_;
         if(param3)
         {
            selectable = true;
            mouseEnabled = true;
            type = TextFieldType.INPUT;
            border = true;
            borderColor = param2;
            addEventListener(Event.CHANGE,this.onChange);
         }
         else
         {
            selectable = false;
            mouseEnabled = false;
         }
      }
      
      public function setFont(param1:String) : void
      {
         var _loc2_:TextFormat = defaultTextFormat;
         _loc2_.font = param1;
         defaultTextFormat = _loc2_;
      }
      
      public function setSize(param1:int) : void
      {
         var _loc2_:TextFormat = defaultTextFormat;
         _loc2_.size = param1;
         this.applyFormat(_loc2_);
      }
      
      public function setColor(param1:uint) : void
      {
         var _loc2_:TextFormat = defaultTextFormat;
         _loc2_.color = param1;
         this.applyFormat(_loc2_);
      }
      
      public function setBold(param1:Boolean) : void
      {
         var _loc2_:TextFormat = defaultTextFormat;
         _loc2_.bold = param1;
         this.applyFormat(_loc2_);
      }
      
      public function setAlignment(param1:String) : void
      {
         var _loc2_:TextFormat = defaultTextFormat;
         _loc2_.align = param1;
         this.applyFormat(_loc2_);
      }
      
      public function setText(param1:String) : void
      {
         this.text = param1;
      }
      
      private function applyFormat(param1:TextFormat) : void
      {
         setTextFormat(param1);
         defaultTextFormat = param1;
      }
      
      private function onChange(param1:Event) : void
      {
         this.updateMetrics();
      }
      
      public function updateMetrics() : void
      {
         var _loc2_:TextLineMetrics = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this.actualWidth_ = 0;
         this.actualHeight_ = 0;
         var _loc1_:int = 0;
         while(_loc1_ < numLines)
         {
            _loc2_ = getLineMetrics(_loc1_);
            _loc3_ = _loc2_.width + 4;
            _loc4_ = _loc2_.height + 4;
            if(_loc3_ > this.actualWidth_)
            {
               this.actualWidth_ = _loc3_;
            }
            this.actualHeight_ += _loc4_;
            _loc1_++;
         }
         width = this.inputWidth_ == 0 ? this.actualWidth_ : this.inputWidth_;
         height = this.inputHeight_ == 0 ? this.actualHeight_ : this.inputHeight_;
      }
      
      public function useTextDimensions() : void
      {
         width = this.inputWidth_ == 0 ? textWidth + 4 : this.inputWidth_;
         height = this.inputHeight_ == 0 ? textHeight + 4 : this.inputHeight_;
      }
   }
}

