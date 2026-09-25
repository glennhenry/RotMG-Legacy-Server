package kabam.rotmg.ui.view
{
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.dialogs.Dialog;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.account.ui.components.DateField;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import org.osflash.signals.Signal;
   
   public class AgeVerificationDialog extends Dialog
   {
      
      private static const WIDTH:int = 300;
      
      private const BIRTH_DATE_BELOW_MINIMUM_ERROR:String = "AgeVerificationDialog.tooYoung";
      
      private const BIRTH_DATE_INVALID_ERROR:String = "AgeVerificationDialog.invalidBirthDate";
      
      private var ageVerificationField:DateField;
      
      private var errorLabel:TextFieldDisplayConcrete;
      
      private const MINIMUM_AGE:uint = 13;
      
      public const response:Signal = new Signal(Boolean);
      
      public function AgeVerificationDialog()
      {
         super(TextKey.AGE_VERIFICATION_DIALOG_TITLE,"",TextKey.AGE_VERIFICATION_DIALOG_LEFT,TextKey.AGE_VERIFICATION_DIALOG_RIGHT,"/ageVerificationDialog");
         addEventListener(Dialog.LEFT_BUTTON,this.onCancel);
         addEventListener(Dialog.RIGHT_BUTTON,this.onVerify);
      }
      
      override protected function makeUIAndAdd() : void
      {
         this.makeAgeVerificationAndErrorLabel();
         this.addChildren();
      }
      
      private function makeAgeVerificationAndErrorLabel() : void
      {
         this.makeAgeVerificationField();
         this.makeErrorLabel();
      }
      
      private function addChildren() : void
      {
         uiWaiter.pushArgs(this.ageVerificationField.getTextChanged());
         box_.addChild(this.ageVerificationField);
         box_.addChild(this.errorLabel);
      }
      
      override protected function initText(param1:String) : void
      {
         textText_ = new TextFieldDisplayConcrete().setSize(14).setColor(11776947);
         textText_.setTextWidth(WIDTH - 40);
         textText_.x = 20;
         textText_.setMultiLine(true).setWordWrap(true).setHTML(true);
         textText_.setAutoSize(TextFieldAutoSize.LEFT);
         textText_.mouseEnabled = true;
         textText_.filters = [new DropShadowFilter(0,0,0,1,6,6,1)];
         this.setText();
      }
      
      private function setText() : void
      {
         var _loc1_:String = "<font color=\"#7777EE\"><a href=\"" + Parameters.TERMS_OF_USE_URL + "\" target=\"_blank\">";
         var _loc2_:String = "<font color=\"#7777EE\"><a href=\"" + Parameters.PRIVACY_POLICY_URL + "\" target=\"_blank\">";
         textText_.setStringBuilder(new LineBuilder().setParams("AgeVerificationDialog.text",{
            "tou":_loc1_,
            "_tou":"</a></font>",
            "policy":_loc2_,
            "_policy":"</a></font>"
         }));
      }
      
      override protected function drawAdditionalUI() : void
      {
         this.ageVerificationField.y = textText_.getBounds(box_).bottom + 8;
         this.ageVerificationField.x = 20;
         this.errorLabel.y = this.ageVerificationField.y + this.ageVerificationField.height + 8;
         this.errorLabel.x = 20;
      }
      
      private function makeAgeVerificationField() : void
      {
         this.ageVerificationField = new DateField();
         this.ageVerificationField.setTitle(TextKey.BIRTHDAY);
      }
      
      private function makeErrorLabel() : void
      {
         this.errorLabel = new TextFieldDisplayConcrete().setSize(12).setColor(16549442);
         this.errorLabel.setMultiLine(true);
         this.errorLabel.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
      }
      
      private function onCancel(param1:Event) : void
      {
         this.response.dispatch(false);
      }
      
      private function onVerify(param1:Event) : void
      {
         var _loc3_:Boolean = false;
         var _loc2_:uint = this.getPlayerAge();
         var _loc4_:String = "";
         if(!this.ageVerificationField.isValidDate())
         {
            _loc4_ = this.BIRTH_DATE_INVALID_ERROR;
            _loc3_ = true;
         }
         else if(_loc2_ < this.MINIMUM_AGE && !_loc3_)
         {
            _loc4_ = this.BIRTH_DATE_BELOW_MINIMUM_ERROR;
            _loc3_ = true;
         }
         else
         {
            _loc4_ = "";
            _loc3_ = false;
            this.response.dispatch(true);
         }
         this.errorLabel.setStringBuilder(new LineBuilder().setParams(_loc4_));
         this.ageVerificationField.setErrorHighlight(_loc3_);
         drawButtonsAndBackground();
      }
      
      private function getPlayerAge() : uint
      {
         var _loc1_:Date = new Date(this.getBirthDate());
         var _loc2_:Date = new Date();
         var _loc3_:uint = Number(_loc2_.fullYear) - Number(_loc1_.fullYear);
         if(_loc1_.month > _loc2_.month || _loc1_.month == _loc2_.month && _loc1_.date > _loc2_.date)
         {
            _loc3_--;
         }
         return _loc3_;
      }
      
      private function getBirthDate() : Number
      {
         return Date.parse(this.ageVerificationField.getDate());
      }
   }
}

