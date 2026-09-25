package kabam.rotmg.account.web.view
{
   import com.company.assembleegameclient.account.ui.CheckBoxField;
   import com.company.assembleegameclient.account.ui.Frame;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.util.EmailValidator;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.account.ui.components.DateField;
   import kabam.rotmg.account.web.model.AccountData;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class WebRegisterDialog extends Frame
   {
      
      public var register:Signal;
      
      public var signIn:Signal;
      
      public var cancel:Signal;
      
      private const errors:Array = [];
      
      private var emailInput:LabeledField;
      
      private var passwordInput:LabeledField;
      
      private var retypePasswordInput:LabeledField;
      
      private var checkbox:CheckBoxField;
      
      private var ageVerificationInput:DateField;
      
      private var signInText:TextFieldDisplayConcrete;
      
      private var tosText:TextFieldDisplayConcrete;
      
      private var endLink:String = "</a></font>";
      
      public function WebRegisterDialog()
      {
         super(TextKey.REGISTER_IMPERATIVE,"RegisterWebAccountDialog.leftButton","RegisterWebAccountDialog.rightButton","/registerAccount",326);
         this.makeUIElements();
         this.makeSignals();
      }
      
      private function makeUIElements() : void
      {
         this.emailInput = new LabeledField(TextKey.REGISTER_WEB_ACCOUNT_EMAIL,false,275);
         this.passwordInput = new LabeledField(TextKey.REGISTER_WEB_ACCOUNT_PASSWORD,true,275);
         this.retypePasswordInput = new LabeledField(TextKey.RETYPE_PASSWORD,true,275);
         this.ageVerificationInput = new DateField();
         this.ageVerificationInput.setTitle(TextKey.BIRTHDAY);
         addLabeledField(this.emailInput);
         addLabeledField(this.passwordInput);
         addLabeledField(this.retypePasswordInput);
         addComponent(this.ageVerificationInput,17);
         addSpace(35);
         this.checkbox = new CheckBoxField(TextKey.CHECK_BOX_TEXT,false,12);
         addCheckBox(this.checkbox);
         addSpace(17);
         this.makeTosText();
         addSpace(17 * 2);
         this.makeSignInText();
      }
      
      public function makeSignInText() : void
      {
         this.signInText = new TextFieldDisplayConcrete();
         this.signInText.setStringBuilder(new LineBuilder().setParams(TextKey.SIGN_IN_TEXT,{
            "signIn":"<font color=\"#7777EE\"><a href=\"event:flash.events.TextEvent\">",
            "_signIn":this.endLink
         }));
         this.signInText.addEventListener(TextEvent.LINK,this.linkEvent);
         this.configureTextAndAdd(this.signInText);
      }
      
      public function makeTosText() : void
      {
         this.tosText = new TextFieldDisplayConcrete();
         var _loc1_:String = "<font color=\"#7777EE\"><a href=\"" + Parameters.TERMS_OF_USE_URL + "\" target=\"_blank\">";
         var _loc2_:String = "<font color=\"#7777EE\"><a href=\"" + Parameters.PRIVACY_POLICY_URL + "\" target=\"_blank\">";
         this.tosText.setStringBuilder(new LineBuilder().setParams(TextKey.TOS_TEXT,{
            "tou":_loc1_,
            "_tou":this.endLink,
            "policy":_loc2_,
            "_policy":this.endLink
         }));
         this.configureTextAndAdd(this.tosText);
      }
      
      public function configureTextAndAdd(param1:TextFieldDisplayConcrete) : void
      {
         param1.setSize(12).setColor(11776947).setBold(true);
         param1.setTextWidth(275);
         param1.setMultiLine(true).setWordWrap(true).setHTML(true);
         param1.filters = [new DropShadowFilter(0,0,0)];
         addChild(param1);
         positionText(param1);
      }
      
      private function linkEvent(param1:TextEvent) : void
      {
         this.signIn.dispatch();
      }
      
      private function makeSignals() : void
      {
         this.cancel = new NativeMappedSignal(leftButton_,MouseEvent.CLICK);
         rightButton_.addEventListener(MouseEvent.CLICK,this.onRegister);
         this.register = new Signal(AccountData);
         this.signIn = new Signal();
      }
      
      private function onRegister(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = this.areInputsValid();
         this.displayErrors();
         if(_loc2_)
         {
            this.sendData();
         }
      }
      
      private function areInputsValid() : Boolean
      {
         this.errors.length = 0;
         var _loc1_:Boolean = true;
         _loc1_ = this.isEmailValid() && _loc1_;
         _loc1_ = this.isPasswordValid() && _loc1_;
         _loc1_ = this.isPasswordVerified() && _loc1_;
         _loc1_ = this.isAgeVerified() && _loc1_;
         return this.isAgeValid() && _loc1_;
      }
      
      private function isAgeVerified() : Boolean
      {
         var _loc1_:uint = DateFieldValidator.getPlayerAge(this.ageVerificationInput);
         var _loc2_:Boolean = _loc1_ >= 13;
         this.ageVerificationInput.setErrorHighlight(!_loc2_);
         if(!_loc2_)
         {
            this.errors.push(TextKey.INELIGIBLE_AGE);
         }
         return _loc2_;
      }
      
      private function isAgeValid() : Boolean
      {
         var _loc1_:Boolean = this.ageVerificationInput.isValidDate();
         this.ageVerificationInput.setErrorHighlight(!_loc1_);
         if(!_loc1_)
         {
            this.errors.push(TextKey.INVALID_BIRTHDATE);
         }
         return _loc1_;
      }
      
      private function isEmailValid() : Boolean
      {
         var _loc1_:Boolean = EmailValidator.isValidEmail(this.emailInput.text());
         this.emailInput.setErrorHighlight(!_loc1_);
         if(!_loc1_)
         {
            this.errors.push(TextKey.INVALID_EMAIL_ADDRESS);
         }
         return _loc1_;
      }
      
      private function isPasswordValid() : Boolean
      {
         var _loc1_:Boolean = this.passwordInput.text().length >= 5;
         this.passwordInput.setErrorHighlight(!_loc1_);
         if(!_loc1_)
         {
            this.errors.push(TextKey.PASSWORD_TOO_SHORT);
         }
         return _loc1_;
      }
      
      private function isPasswordVerified() : Boolean
      {
         var _loc1_:Boolean = this.passwordInput.text() == this.retypePasswordInput.text();
         this.retypePasswordInput.setErrorHighlight(!_loc1_);
         if(!_loc1_)
         {
            this.errors.push(TextKey.PASSWORDS_DONT_MATCH);
         }
         return _loc1_;
      }
      
      public function displayErrors() : void
      {
         if(this.errors.length == 0)
         {
            this.clearErrors();
         }
         else
         {
            this.displayErrorText(this.errors.length == 1 ? this.errors[0] : TextKey.MULTIPLE_ERRORS_MESSAGE);
         }
      }
      
      public function displayServerError(param1:String) : void
      {
         this.displayErrorText(param1);
      }
      
      private function clearErrors() : void
      {
         titleText_.setStringBuilder(new LineBuilder().setParams(TextKey.REGISTER_IMPERATIVE));
         titleText_.setColor(11776947);
      }
      
      private function displayErrorText(param1:String) : void
      {
         titleText_.setStringBuilder(new LineBuilder().setParams(param1));
         titleText_.setColor(16549442);
      }
      
      private function sendData() : void
      {
         var _loc1_:AccountData = new AccountData();
         _loc1_.username = this.emailInput.text();
         _loc1_.password = this.passwordInput.text();
         _loc1_.signedUpKabamEmail = this.checkbox.isChecked() ? 1 : 0;
         this.register.dispatch(_loc1_);
      }
   }
}

