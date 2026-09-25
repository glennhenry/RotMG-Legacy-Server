package kabam.rotmg.text.view
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextLineMetrics;
   import kabam.rotmg.language.model.StringMap;
   import kabam.rotmg.text.model.FontInfo;
   import kabam.rotmg.text.view.stringBuilder.StringBuilder;
   import org.osflash.signals.Signal;
   
   public class TextFieldDisplayConcrete extends Sprite implements TextFieldDisplay
   {
      
      public static const MIDDLE:String = "middle";
      
      public static const BOTTOM:String = "bottom";
      
      private static const GUTTER:int = 2;
      
      public const textChanged:Signal = new Signal();
      
      public var textField:TextField;
      
      private var stringMap:StringMap;
      
      private var stringBuilder:StringBuilder;
      
      private var size:int = 12;
      
      private var color:uint;
      
      private var font:FontInfo;
      
      private var bold:Boolean;
      
      private var autoSize:String = "left";
      
      private var horizontalAlign:String = "left";
      
      private var verticalAlign:String;
      
      private var multiline:Boolean;
      
      private var wordWrap:Boolean;
      
      private var textWidth:Number = 0;
      
      private var textHeight:Number = 0;
      
      private var html:Boolean;
      
      private var displayAsPassword:Boolean;
      
      private var debugName:String;
      
      private var leftMargin:int = 0;
      
      private var indent:int = 0;
      
      private var leading:int = 0;
      
      public function TextFieldDisplayConcrete()
      {
         super();
      }
      
      private static function getOnlyTextHeight(param1:TextLineMetrics) : Number
      {
         return param1.height - param1.leading;
      }
      
      public function setIndent(param1:int) : TextFieldDisplayConcrete
      {
         this.indent = param1;
         this.setPropertiesIfHasTextField();
         return this;
      }
      
      public function setLeading(param1:int) : TextFieldDisplayConcrete
      {
         this.leading = param1;
         this.setPropertiesIfHasTextField();
         return this;
      }
      
      public function setLeftMargin(param1:int) : TextFieldDisplayConcrete
      {
         this.leftMargin = param1;
         this.setPropertiesIfHasTextField();
         return this;
      }
      
      public function setDisplayAsPassword(param1:Boolean) : TextFieldDisplayConcrete
      {
         this.displayAsPassword = param1;
         this.setPropertiesIfHasTextField();
         return this;
      }
      
      public function setDebugName(param1:String) : TextFieldDisplayConcrete
      {
         this.debugName = param1;
         this.textField && (this.textField.name = this.debugName);
         return this;
      }
      
      public function setSize(param1:int) : TextFieldDisplayConcrete
      {
         this.size = param1;
         this.setPropertiesIfHasTextField();
         return this;
      }
      
      public function setColor(param1:uint) : TextFieldDisplayConcrete
      {
         this.color = param1;
         this.setPropertiesIfHasTextField();
         return this;
      }
      
      public function setBold(param1:Boolean) : TextFieldDisplayConcrete
      {
         this.bold = param1;
         this.setPropertiesIfHasTextField();
         return this;
      }
      
      public function setHorizontalAlign(param1:String) : TextFieldDisplayConcrete
      {
         this.horizontalAlign = param1;
         this.setPropertiesIfHasTextField();
         return this;
      }
      
      public function setAutoSize(param1:String) : TextFieldDisplayConcrete
      {
         this.autoSize = param1;
         this.setPropertiesIfHasTextField();
         return this;
      }
      
      public function setMultiLine(param1:Boolean) : TextFieldDisplayConcrete
      {
         this.multiline = param1;
         this.setPropertiesIfHasTextField();
         return this;
      }
      
      public function setWordWrap(param1:Boolean) : TextFieldDisplayConcrete
      {
         this.wordWrap = param1;
         this.setPropertiesIfHasTextField();
         return this;
      }
      
      public function setTextWidth(param1:Number) : TextFieldDisplayConcrete
      {
         this.textWidth = param1;
         this.setPropertiesIfHasTextField();
         return this;
      }
      
      public function setTextHeight(param1:Number) : TextFieldDisplayConcrete
      {
         this.textHeight = param1;
         this.setPropertiesIfHasTextField();
         return this;
      }
      
      public function setHTML(param1:Boolean) : TextFieldDisplayConcrete
      {
         this.html = param1;
         return this;
      }
      
      public function setStringBuilder(param1:StringBuilder) : TextFieldDisplayConcrete
      {
         this.stringBuilder = param1;
         this.setTextIfAble();
         return this;
      }
      
      public function getStringBuilder() : StringBuilder
      {
         return this.stringBuilder;
      }
      
      public function setPosition(param1:Number, param2:Number) : TextFieldDisplayConcrete
      {
         this.x = param1;
         this.y = param2;
         return this;
      }
      
      public function setVerticalAlign(param1:String) : TextFieldDisplayConcrete
      {
         this.verticalAlign = param1;
         return this;
      }
      
      public function update() : void
      {
         this.setTextIfAble();
      }
      
      public function setFont(param1:FontInfo) : void
      {
         this.font = param1;
      }
      
      public function setStringMap(param1:StringMap) : void
      {
         this.stringMap = param1;
         this.setTextIfAble();
      }
      
      public function setTextField(param1:TextField) : void
      {
         param1.width = this.textWidth;
         param1.height = this.textHeight;
         this.debugName && (param1.name = this.debugName);
         this.updateTextOfInjectedTextField(param1);
         this.textField = param1;
         this.setProperties();
         addChild(this.textField);
      }
      
      private function setPropertiesIfHasTextField() : void
      {
         if(this.textField)
         {
            this.setProperties();
         }
      }
      
      private function setProperties() : void
      {
         this.setFormatProperties();
         this.setTextFieldProperties();
      }
      
      private function setTextFieldProperties() : void
      {
         if(this.textWidth != 0)
         {
            this.textField.width = this.textWidth;
         }
         if(this.textHeight != 0)
         {
            this.textField.height = this.textHeight;
         }
         this.textField.selectable = false;
         this.textField.textColor = this.color;
         this.textField.autoSize = this.autoSize;
         this.textField.multiline = this.multiline;
         this.textField.wordWrap = this.wordWrap;
         this.textField.displayAsPassword = this.displayAsPassword;
         this.textField.embedFonts = true;
      }
      
      private function setFormatProperties() : void
      {
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.size = this.size;
         _loc1_.font = this.font.getName();
         _loc1_.bold = this.bold;
         _loc1_.align = this.horizontalAlign;
         _loc1_.leftMargin = this.leftMargin;
         _loc1_.indent = this.indent;
         _loc1_.leading = this.leading;
         this.setTextFormat(_loc1_);
      }
      
      private function updateTextOfInjectedTextField(param1:TextField) : void
      {
         if(this.textField)
         {
            param1.text = this.textField.text;
            removeChild(this.textField);
         }
      }
      
      private function setTextIfAble() : void
      {
         var _loc1_:String = null;
         if(this.isAble())
         {
            this.stringBuilder.setStringMap(this.stringMap);
            _loc1_ = this.stringBuilder.getString();
            this.setText(_loc1_);
            this.alignVertically();
            this.invalidateTextField();
            this.textChanged.dispatch();
         }
      }
      
      private function invalidateTextField() : void
      {
         this.textField.height;
      }
      
      public function setText(param1:String) : void
      {
         if(this.html)
         {
            this.textField.htmlText = param1;
         }
         else
         {
            this.textField.text = param1;
         }
      }
      
      private function alignVertically() : void
      {
         var _loc1_:TextLineMetrics = null;
         if(this.verticalAlign == MIDDLE)
         {
            this.setYToMiddle();
         }
         else if(this.verticalAlign == BOTTOM)
         {
            _loc1_ = this.textField.getLineMetrics(0);
            this.textField.y = -getOnlyTextHeight(_loc1_);
         }
      }
      
      private function setYToMiddle() : void
      {
         this.textField.height;
         var _loc1_:TextFormat = this.textField.getTextFormat();
         var _loc2_:Number = this.getSpecificXHeight(_loc1_);
         var _loc3_:Number = this.getSpecificVerticalSpace(_loc1_);
         this.textField.y = -(this.textField.height - (_loc2_ / 2 + _loc3_ + GUTTER));
      }
      
      private function getSpecificXHeight(param1:TextFormat) : Number
      {
         return this.font.getXHeight(Number(param1.size));
      }
      
      private function getSpecificVerticalSpace(param1:TextFormat) : Number
      {
         return this.font.getVerticalSpace(Number(param1.size));
      }
      
      public function setTextFormat(param1:TextFormat, param2:int = -1, param3:int = -1) : void
      {
         this.textField.defaultTextFormat = param1;
         this.textField.setTextFormat(param1,param2,param3);
      }
      
      private function isAble() : Boolean
      {
         return Boolean(this.stringMap) && Boolean(this.stringBuilder) && Boolean(this.textField);
      }
      
      public function getVerticalSpace() : Number
      {
         return this.font.getVerticalSpace(Number(this.textField.getTextFormat().size));
      }
      
      public function getText() : String
      {
         return this.textField ? this.textField.text : "null";
      }
      
      public function getColor() : uint
      {
         return this.color;
      }
      
      public function getSize() : int
      {
         return this.size;
      }
      
      public function hasTextField() : Boolean
      {
         return this.textField != null;
      }
      
      public function hasStringMap() : Boolean
      {
         return this.stringMap != null;
      }
      
      public function hasFont() : Boolean
      {
         return this.font != null;
      }
      
      public function getTextFormat(param1:int = -1, param2:int = -1) : TextFormat
      {
         return this.textField.getTextFormat(param1,param2);
      }
   }
}

