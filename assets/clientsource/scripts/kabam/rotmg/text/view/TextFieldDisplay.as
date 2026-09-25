package kabam.rotmg.text.view
{
   import flash.text.TextField;
   import kabam.rotmg.language.model.StringMap;
   import kabam.rotmg.text.model.FontInfo;
   
   public interface TextFieldDisplay
   {
      
      function setTextField(param1:TextField) : void;
      
      function setStringMap(param1:StringMap) : void;
      
      function setFont(param1:FontInfo) : void;
   }
}

