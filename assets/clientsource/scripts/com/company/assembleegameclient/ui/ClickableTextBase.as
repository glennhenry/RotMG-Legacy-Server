package com.company.assembleegameclient.ui
{
   import com.company.assembleegameclient.sound.SoundEffectLibrary;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class ClickableTextBase extends Sprite
   {
      
      public var text_:TextFieldDisplayConcrete;
      
      public var defaultColor_:uint = 16777215;
      
      public function ClickableTextBase(param1:int, param2:Boolean, param3:String)
      {
         super();
         this.text_ = this.makeText().setSize(param1).setColor(16777215);
         this.text_.setBold(param2);
         this.text_.setStringBuilder(new LineBuilder().setParams(param3));
         addChild(this.text_);
         this.text_.filters = [new DropShadowFilter(0,0,0)];
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         addEventListener(MouseEvent.CLICK,this.onMouseClick);
      }
      
      public function removeOnHoverEvents() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      protected function makeText() : TextFieldDisplayConcrete
      {
         return new TextFieldDisplayConcrete();
      }
      
      public function setAutoSize(param1:String) : void
      {
         this.text_.setAutoSize(param1);
      }
      
      public function makeStatic(param1:String) : void
      {
         this.text_.setStringBuilder(new LineBuilder().setParams(param1));
         this.setDefaultColor(11776947);
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function setColor(param1:uint) : void
      {
         this.text_.setColor(param1);
      }
      
      public function setDefaultColor(param1:uint) : void
      {
         this.defaultColor_ = param1;
         this.setColor(this.defaultColor_);
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         this.setColor(16768133);
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         this.setColor(this.defaultColor_);
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         SoundEffectLibrary.play("button_click");
      }
   }
}

