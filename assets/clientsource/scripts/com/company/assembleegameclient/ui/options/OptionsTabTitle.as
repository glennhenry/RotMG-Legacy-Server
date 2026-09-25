package com.company.assembleegameclient.ui.options
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class OptionsTabTitle extends Sprite
   {
      
      private static const TEXT_SIZE:int = 16;
      
      public var text_:String;
      
      protected var textText_:TextFieldDisplayConcrete;
      
      protected var selected_:Boolean;
      
      public function OptionsTabTitle(param1:String)
      {
         super();
         this.text_ = param1;
         this.textText_ = new TextFieldDisplayConcrete().setSize(TEXT_SIZE).setColor(11776947);
         this.textText_.setBold(true);
         this.textText_.setStringBuilder(new LineBuilder().setParams(param1));
         this.textText_.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         addChild(this.textText_);
         this.selected_ = false;
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
      }
      
      public function setSelected(param1:Boolean) : void
      {
         this.selected_ = param1;
         this.redraw(false);
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         this.redraw(true);
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         this.redraw(false);
      }
      
      private function redraw(param1:Boolean) : void
      {
         this.textText_.setSize(TEXT_SIZE);
         this.textText_.setColor(this.getColor(param1));
      }
      
      private function getColor(param1:Boolean) : uint
      {
         if(this.selected_)
         {
            return 16762880;
         }
         return param1 ? 16777215 : 11776947;
      }
   }
}

