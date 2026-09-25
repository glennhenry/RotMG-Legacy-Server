package kabam.rotmg.editor.view
{
   import com.company.assembleegameclient.ui.TextButtonBase;
   import kabam.rotmg.text.view.StaticTextDisplay;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class StaticTextButton extends TextButtonBase
   {
      
      public function StaticTextButton(param1:int, param2:String, param3:int = 0)
      {
         super(param3);
         addText(param1);
         text_.setStringBuilder(new LineBuilder().setParams(param2));
         initText();
      }
      
      override protected function makeText() : TextFieldDisplayConcrete
      {
         return new StaticTextDisplay();
      }
   }
}

