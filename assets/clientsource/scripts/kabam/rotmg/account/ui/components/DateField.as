package kabam.rotmg.account.ui.components
{
   import com.company.ui.BaseSimpleText;
   import flash.display.CapsStyle;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.TextEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import kabam.lib.util.DateValidator;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import org.osflash.signals.Signal;
   
   public class DateField extends Sprite
   {
      
      private static const BACKGROUND_COLOR:uint = 3355443;
      
      private static const ERROR_BORDER_COLOR:uint = 16549442;
      
      private static const NORMAL_BORDER_COLOR:uint = 4539717;
      
      private static const TEXT_COLOR:uint = 11776947;
      
      private static const INPUT_RESTRICTION:String = "1234567890";
      
      private static const FORMAT_HINT_COLOR:uint = 5592405;
      
      public var label:TextFieldDisplayConcrete;
      
      public var days:BaseSimpleText;
      
      public var months:BaseSimpleText;
      
      public var years:BaseSimpleText;
      
      private var dayFormatText:TextFieldDisplayConcrete;
      
      private var monthFormatText:TextFieldDisplayConcrete;
      
      private var yearFormatText:TextFieldDisplayConcrete;
      
      private var thisYear:int;
      
      private var validator:DateValidator;
      
      public function DateField()
      {
         super();
         this.validator = new DateValidator();
         this.thisYear = new Date().getFullYear();
         this.label = new TextFieldDisplayConcrete().setSize(18).setColor(11776947);
         this.label.setBold(true);
         this.label.setStringBuilder(new LineBuilder().setParams(name));
         this.label.filters = [new DropShadowFilter(0,0,0)];
         addChild(this.label);
         this.months = new BaseSimpleText(20,TEXT_COLOR,true,35,30);
         this.months.restrict = INPUT_RESTRICTION;
         this.months.maxChars = 2;
         this.months.y = 30;
         this.months.x = 6;
         this.months.border = false;
         this.months.updateMetrics();
         this.months.addEventListener(TextEvent.TEXT_INPUT,this.onMonthInput);
         this.months.addEventListener(FocusEvent.FOCUS_OUT,this.onMonthFocusOut);
         this.months.addEventListener(Event.CHANGE,this.onEditMonth);
         this.monthFormatText = this.createFormatHint(this.months,TextKey.DATE_FIELD_MONTHS);
         addChild(this.monthFormatText);
         addChild(this.months);
         this.days = new BaseSimpleText(20,TEXT_COLOR,true,35,30);
         this.days.restrict = INPUT_RESTRICTION;
         this.days.maxChars = 2;
         this.days.y = 30;
         this.days.x = 63;
         this.days.border = false;
         this.days.updateMetrics();
         this.days.addEventListener(TextEvent.TEXT_INPUT,this.onDayInput);
         this.days.addEventListener(FocusEvent.FOCUS_OUT,this.onDayFocusOut);
         this.days.addEventListener(Event.CHANGE,this.onEditDay);
         this.dayFormatText = this.createFormatHint(this.days,TextKey.DATE_FIELD_DAYS);
         addChild(this.dayFormatText);
         addChild(this.days);
         this.years = new BaseSimpleText(20,TEXT_COLOR,true,55,30);
         this.years.restrict = INPUT_RESTRICTION;
         this.years.maxChars = 4;
         this.years.y = 30;
         this.years.x = 118;
         this.years.border = false;
         this.years.updateMetrics();
         this.years.restrict = INPUT_RESTRICTION;
         this.years.addEventListener(TextEvent.TEXT_INPUT,this.onYearInput);
         this.years.addEventListener(Event.CHANGE,this.onEditYear);
         this.yearFormatText = this.createFormatHint(this.years,TextKey.DATE_FIELD_YEARS);
         addChild(this.yearFormatText);
         addChild(this.years);
         this.setErrorHighlight(false);
      }
      
      public function setTitle(param1:String) : void
      {
         this.label.setStringBuilder(new LineBuilder().setParams(param1));
      }
      
      public function setErrorHighlight(param1:Boolean) : void
      {
         this.drawSimpleTextBackground(this.months,0,0,param1);
         this.drawSimpleTextBackground(this.days,0,0,param1);
         this.drawSimpleTextBackground(this.years,0,0,param1);
      }
      
      private function drawSimpleTextBackground(param1:BaseSimpleText, param2:int, param3:int, param4:Boolean) : void
      {
         var _loc5_:uint = param4 ? ERROR_BORDER_COLOR : NORMAL_BORDER_COLOR;
         graphics.lineStyle(2,_loc5_,1,false,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND);
         graphics.beginFill(BACKGROUND_COLOR,1);
         graphics.drawRect(param1.x - param2 - 5,param1.y - param3,param1.width + param2 * 2,param1.height + param3 * 2);
         graphics.endFill();
         graphics.lineStyle();
      }
      
      private function createFormatHint(param1:BaseSimpleText, param2:String) : TextFieldDisplayConcrete
      {
         var _loc3_:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setColor(FORMAT_HINT_COLOR);
         _loc3_.setTextWidth(param1.width + 4).setTextHeight(param1.height);
         _loc3_.x = param1.x - 6;
         _loc3_.y = param1.y + 3;
         _loc3_.setStringBuilder(new LineBuilder().setParams(param2));
         _loc3_.setAutoSize(TextFieldAutoSize.CENTER);
         return _loc3_;
      }
      
      private function onMonthInput(param1:TextEvent) : void
      {
         var _loc2_:String = this.months.text + param1.text;
         var _loc3_:int = int(_loc2_);
         if(_loc2_ != "0" && !this.validator.isValidMonth(_loc3_))
         {
            param1.preventDefault();
         }
      }
      
      private function onMonthFocusOut(param1:FocusEvent) : void
      {
         var _loc2_:int = int(this.months.text);
         if(_loc2_ < 10 && this.days.text != "")
         {
            this.months.text = "0" + _loc2_.toString();
         }
      }
      
      private function onEditMonth(param1:Event) : void
      {
         this.monthFormatText.visible = !this.months.text;
      }
      
      private function onDayInput(param1:TextEvent) : void
      {
         var _loc2_:String = this.days.text + param1.text;
         var _loc3_:int = int(_loc2_);
         if(_loc2_ != "0" && !this.validator.isValidDay(_loc3_))
         {
            param1.preventDefault();
         }
      }
      
      private function onDayFocusOut(param1:FocusEvent) : void
      {
         var _loc2_:int = int(this.days.text);
         if(_loc2_ < 10 && this.days.text != "")
         {
            this.days.text = "0" + _loc2_.toString();
         }
      }
      
      private function onEditDay(param1:Event) : void
      {
         this.dayFormatText.visible = !this.days.text;
      }
      
      private function onYearInput(param1:TextEvent) : void
      {
         var _loc2_:String = this.years.text + param1.text;
         var _loc3_:int = this.getEarliestYear(_loc2_);
         if(_loc3_ > this.thisYear)
         {
            param1.preventDefault();
         }
      }
      
      private function getEarliestYear(param1:String) : int
      {
         while(param1.length < 4)
         {
            param1 += "0";
         }
         return int(param1);
      }
      
      private function onEditYear(param1:Event) : void
      {
         this.yearFormatText.visible = !this.years.text;
      }
      
      public function isValidDate() : Boolean
      {
         var _loc1_:int = int(this.months.text);
         var _loc2_:int = int(this.days.text);
         var _loc3_:int = int(this.years.text);
         return this.validator.isValidDate(_loc1_,_loc2_,_loc3_,100);
      }
      
      public function getDate() : String
      {
         var _loc1_:String = this.getFixedLengthString(this.months.text,2);
         var _loc2_:String = this.getFixedLengthString(this.days.text,2);
         var _loc3_:String = this.getFixedLengthString(this.years.text,4);
         return _loc1_ + "/" + _loc2_ + "/" + _loc3_;
      }
      
      private function getFixedLengthString(param1:String, param2:int) : String
      {
         while(param1.length < param2)
         {
            param1 = "0" + param1;
         }
         return param1;
      }
      
      public function getTextChanged() : Signal
      {
         return this.label.textChanged;
      }
   }
}

