package kabam.rotmg.account.web.view
{
   import com.company.assembleegameclient.account.ui.Frame;
   import com.company.assembleegameclient.account.ui.TextInputField;
   import com.company.assembleegameclient.ui.DeprecatedClickableText;
   import com.company.util.KeyCodes;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import kabam.rotmg.account.web.model.AccountData;
   import kabam.rotmg.text.model.TextKey;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class WebLoginDialog extends Frame
   {
      
      public var cancel:Signal;
      
      public var signIn:Signal;
      
      public var forgot:Signal;
      
      public var register:Signal;
      
      private var email:TextInputField;
      
      private var password:TextInputField;
      
      private var forgotText:DeprecatedClickableText;
      
      private var registerText:DeprecatedClickableText;
      
      public function WebLoginDialog()
      {
         super(TextKey.WEB_LOGIN_DIALOG_TITLE,TextKey.WEB_LOGIN_DIALOG_LEFT,TextKey.WEB_LOGIN_DIALOG_RIGHT,"/signIn");
         this.makeUI();
         this.forgot = new NativeMappedSignal(this.forgotText,MouseEvent.CLICK);
         this.register = new NativeMappedSignal(this.registerText,MouseEvent.CLICK);
         this.cancel = new NativeMappedSignal(leftButton_,MouseEvent.CLICK);
         this.signIn = new Signal(AccountData);
      }
      
      private function makeUI() : void
      {
         this.email = new TextInputField(TextKey.WEB_LOGIN_DIALOG_EMAIL,false);
         addTextInputField(this.email);
         this.password = new TextInputField(TextKey.WEB_LOGIN_DIALOG_PASSWORD,true);
         addTextInputField(this.password);
         this.forgotText = new DeprecatedClickableText(12,false,TextKey.WEB_LOGIN_DIALOG_FORGOT);
         addNavigationText(this.forgotText);
         this.registerText = new DeprecatedClickableText(12,false,TextKey.WEB_LOGIN_DIALOG_REGISTER);
         addNavigationText(this.registerText);
         rightButton_.addEventListener(MouseEvent.CLICK,this.onSignIn);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == KeyCodes.ENTER)
         {
            this.onSignInSub();
         }
      }
      
      private function onCancel(param1:MouseEvent) : void
      {
         this.cancel.dispatch();
      }
      
      private function onSignIn(param1:MouseEvent) : void
      {
         this.onSignInSub();
      }
      
      private function onSignInSub() : void
      {
         var _loc1_:AccountData = null;
         if(this.isEmailValid() && this.isPasswordValid())
         {
            _loc1_ = new AccountData();
            _loc1_.username = this.email.text();
            _loc1_.password = this.password.text();
            this.signIn.dispatch(_loc1_);
         }
      }
      
      private function isPasswordValid() : Boolean
      {
         var _loc1_:Boolean = this.password.text() != "";
         if(!_loc1_)
         {
            this.password.setError(TextKey.WEB_LOGIN_DIALOG_PASSWORD_ERROR);
         }
         return _loc1_;
      }
      
      private function isEmailValid() : Boolean
      {
         var _loc1_:Boolean = this.email.text() != "";
         if(!_loc1_)
         {
            this.email.setError(TextKey.WEBLOGINDIALOG_EMAIL_ERROR);
         }
         return _loc1_;
      }
      
      public function setError(param1:String) : void
      {
         this.password.setError(param1);
      }
      
      public function setEmail(param1:String) : void
      {
         this.email.inputText_.text = param1;
      }
   }
}

