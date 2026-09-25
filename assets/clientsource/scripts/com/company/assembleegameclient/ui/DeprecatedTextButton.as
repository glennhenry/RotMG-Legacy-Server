package com.company.assembleegameclient.ui
{
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   import org.osflash.signals.Signal;
   
   public class DeprecatedTextButton extends TextButtonBase
   {
      
      public const textChanged:Signal = new Signal();
      
      public function DeprecatedTextButton(param1:int, param2:String, param3:int = 0, param4:Boolean = false)
      {
         super(param3);
         addText(param1);
         if(param4)
         {
            text_.setStringBuilder(new StaticStringBuilder(param2));
         }
         else
         {
            text_.setStringBuilder(new LineBuilder().setParams(param2));
         }
         text_.textChanged.addOnce(this.onTextChanged);
      }
      
      protected function onTextChanged() : void
      {
         initText();
         this.textChanged.dispatch();
      }
   }
}

