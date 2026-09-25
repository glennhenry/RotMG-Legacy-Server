package com.company.assembleegameclient.ui
{
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   
   public class DeprecatedClickableText extends ClickableTextBase
   {
      
      public function DeprecatedClickableText(param1:int, param2:Boolean, param3:String)
      {
         super(param1,param2,param3);
      }
      
      override protected function makeText() : TextFieldDisplayConcrete
      {
         return new TextFieldDisplayConcrete();
      }
   }
}

