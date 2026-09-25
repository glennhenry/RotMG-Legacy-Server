package kabam.rotmg.account.transfer.view
{
   import com.company.assembleegameclient.account.ui.Frame;
   import com.company.assembleegameclient.account.ui.TextInputField;
   import com.company.assembleegameclient.ui.DeprecatedClickableText;
   import com.company.util.KeyCodes;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.account.transfer.model.TransferAccountData;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class KabamLoginView extends Frame
   {
      
      public var cancel:Signal;
      
      public var signIn:Signal;
      
      public var forgot:Signal;
      
      private var email:TextInputField;
      
      private var password:TextInputField;
      
      private var headerText:TextFieldDisplayConcrete;
      
      private var forgotText:DeprecatedClickableText;
      
      public function KabamLoginView()
      {
         super("Kabam.com account transfer",TextKey.WEB_LOGIN_DIALOG_LEFT,TextKey.WEB_LOGIN_DIALOG_RIGHT,"/signIn");
         this.makeUI();
         this.forgot = new NativeMappedSignal(this.forgotText,MouseEvent.CLICK);
         this.cancel = new NativeMappedSignal(leftButton_,MouseEvent.CLICK);
         this.signIn = new Signal(TransferAccountData);
      }
      
      private function makeUI() : void
      {
         this.headerText = new TextFieldDisplayConcrete().setSize(13).setColor(11776947);
         this.headerText.setStringBuilder(new StaticStringBuilder("Please login to Kabam.com"));
         this.headerText.filters = [new DropShadowFilter(0,0,0)];
         this.headerText.x = 5;
         this.headerText.y = 3;
         this.headerText.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         addChild(this.headerText);
         positionText(this.headerText);
         this.email = new TextInputField(TextKey.WEB_LOGIN_DIALOG_EMAIL,false);
         addTextInputField(this.email);
         this.password = new TextInputField(TextKey.WEB_LOGIN_DIALOG_PASSWORD,true);
         addTextInputField(this.password);
         this.forgotText = new DeprecatedClickableText(12,false,TextKey.WEB_LOGIN_DIALOG_FORGOT);
         addNavigationText(this.forgotText);
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
         var _loc1_:TransferAccountData = null;
         if(this.isEmailValid() && this.isPasswordValid())
         {
            _loc1_ = new TransferAccountData();
            _loc1_.currentEmail = this.email.text();
            _loc1_.currentPassword = this.password.text();
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

