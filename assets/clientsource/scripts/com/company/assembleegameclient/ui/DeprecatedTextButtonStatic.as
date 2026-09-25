package com.company.assembleegameclient.ui
{
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   import org.osflash.signals.Signal;
   
   public class DeprecatedTextButtonStatic extends TextButtonBase
   {
      
      public const textChanged:Signal = new Signal();
      
      public function DeprecatedTextButtonStatic(param1:int, param2:String, param3:int = 0)
      {
         super(param3);
         addText(param1);
         text_.setStringBuilder(new StaticStringBuilder(param2));
         text_.textChanged.addOnce(this.onTextChanged);
      }
      
      protected function onTextChanged() : void
      {
         initText();
         this.textChanged.dispatch();
      }
   }
}

