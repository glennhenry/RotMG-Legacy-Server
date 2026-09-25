package com.company.assembleegameclient.ui.components
{
   import flash.display.Sprite;
   import kabam.lib.util.TimeWriter;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   
   public class TimerDisplay extends Sprite
   {
      
      private var _textField:TextFieldDisplayConcrete;
      
      private var stringifier:TimeWriter = new TimeWriter();
      
      public function TimerDisplay(param1:TextFieldDisplayConcrete)
      {
         super();
         this.initTextField(param1);
      }
      
      private function initTextField(param1:TextFieldDisplayConcrete) : void
      {
         addChild(this._textField = param1);
      }
      
      public function update(param1:Number) : void
      {
         this._textField.setStringBuilder(new StaticStringBuilder(this.stringifier.parseTime(param1)));
      }
   }
}

