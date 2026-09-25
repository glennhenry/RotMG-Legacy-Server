package com.company.assembleegameclient.ui
{
   import com.company.assembleegameclient.ui.components.TimerDisplay;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   
   public class ExperienceBoostTimerPopup extends Sprite
   {
      
      private var timerDisplay:TimerDisplay;
      
      private var textField:TextFieldDisplayConcrete;
      
      public function ExperienceBoostTimerPopup()
      {
         super();
         this.textField = this.returnTimerTextField();
         this.textField.x = 5;
         this.timerDisplay = new TimerDisplay(this.textField);
         addChild(this.timerDisplay);
         this.timerDisplay.update(100000);
         graphics.lineStyle(2,16777215);
         graphics.beginFill(3552822);
         graphics.drawRoundRect(0,0,150,25,10);
         filters = [new DropShadowFilter(0,0,0,1,16,16,1)];
      }
      
      public function update(param1:Number) : void
      {
         this.timerDisplay.update(param1);
      }
      
      private function returnTimerTextField() : TextFieldDisplayConcrete
      {
         var _loc1_:TextFieldDisplayConcrete = null;
         _loc1_ = new TextFieldDisplayConcrete().setSize(16).setColor(16777103);
         _loc1_.setBold(true);
         _loc1_.setMultiLine(true);
         _loc1_.mouseEnabled = true;
         _loc1_.filters = [new DropShadowFilter(0,0,0)];
         return _loc1_;
      }
   }
}

