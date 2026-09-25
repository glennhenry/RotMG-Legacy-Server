package kabam.rotmg.text.view
{
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   
   public class TextFieldConcreteBuilder
   {
      
      private var _containerWidth:int = -1;
      
      private var _containerMargin:int = -1;
      
      public function TextFieldConcreteBuilder()
      {
         super();
      }
      
      public function getLocalizedTextObject(param1:String, param2:int = -1, param3:int = -1, param4:int = 16, param5:int = 16777215, param6:int = -1, param7:int = -1) : TextFieldDisplayConcrete
      {
         var _loc8_:TextFieldDisplayConcrete = new TextFieldDisplayConcrete();
         _loc8_.setStringBuilder(new LineBuilder().setParams(param1));
         return this.defaultFormatTFDC(_loc8_,param2,param3,param4,param5,param6,param7);
      }
      
      public function getLiteralTextObject(param1:String, param2:int = -1, param3:int = -1, param4:int = 16, param5:int = 16777215, param6:int = -1, param7:int = -1) : TextFieldDisplayConcrete
      {
         var _loc8_:TextFieldDisplayConcrete = new TextFieldDisplayConcrete();
         _loc8_.setStringBuilder(new StaticStringBuilder(param1));
         return this.defaultFormatTFDC(_loc8_,param2,param3,param4,param5,param6,param7);
      }
      
      public function getBlankFormattedTextObject(param1:String, param2:int = -1, param3:int = -1, param4:int = 16, param5:int = 16777215, param6:int = -1, param7:int = -1) : TextFieldDisplayConcrete
      {
         var _loc8_:TextFieldDisplayConcrete = new TextFieldDisplayConcrete();
         return this.defaultFormatTFDC(_loc8_,param2,param3,param4,param5,param6,param7);
      }
      
      public function formatExistingTextObject(param1:TextFieldDisplayConcrete, param2:int = -1, param3:int = -1, param4:int = 16, param5:int = 16777215, param6:int = -1, param7:int = -1) : TextFieldDisplayConcrete
      {
         return this.defaultFormatTFDC(param1,param2,param3,param4,param5,param6,param7);
      }
      
      private function defaultFormatTFDC(param1:TextFieldDisplayConcrete, param2:int = -1, param3:int = -1, param4:int = 16, param5:int = 16777215, param6:int = -1, param7:int = -1) : TextFieldDisplayConcrete
      {
         param1.setSize(param4).setColor(param5);
         if(param6 != -1 && param7 != -1)
         {
            param1.setTextWidth(param6 - param7 * 2);
         }
         else if(this.containerWidth != -1 && this.containerMargin != -1)
         {
            param1.setTextWidth(this.containerWidth - this.containerMargin * 2);
         }
         param1.setBold(true);
         param1.setWordWrap(true);
         param1.setMultiLine(true);
         param1.setAutoSize(TextFieldAutoSize.CENTER);
         param1.setHorizontalAlign(TextFormatAlign.CENTER);
         param1.filters = [new DropShadowFilter(0,0,0)];
         if(param2 != -1)
         {
            param1.x = param2;
         }
         if(param3 != -1)
         {
            param1.y = param3;
         }
         return param1;
      }
      
      public function get containerWidth() : int
      {
         return this._containerWidth;
      }
      
      public function set containerWidth(param1:int) : void
      {
         this._containerWidth = param1;
      }
      
      public function get containerMargin() : int
      {
         return this._containerMargin;
      }
      
      public function set containerMargin(param1:int) : void
      {
         this._containerMargin = param1;
      }
   }
}

