package com.company.assembleegameclient.ui
{
   import flash.display.IGraphicsData;
   import flash.events.MouseEvent;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class TextButtonBase extends BackgroundFilledText
   {
      
      public function TextButtonBase(param1:int)
      {
         super(param1);
      }
      
      protected function initText() : void
      {
         centerTextAndDrawButton();
         this.draw();
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
      }
      
      public function setText(param1:String) : void
      {
         text_.setStringBuilder(new LineBuilder().setParams(param1));
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         if(param1 == mouseEnabled)
         {
            return;
         }
         mouseEnabled = param1;
         graphicsData_[0] = param1 ? enabledFill_ : disabledFill_;
         this.draw();
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         enabledFill_.color = 16768133;
         this.draw();
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         enabledFill_.color = 16777215;
         this.draw();
      }
      
      private function draw() : void
      {
         graphics.clear();
         graphics.drawGraphicsData(graphicsData_);
      }
   }
}

