package kabam.rotmg.account.core.view
{
   import com.company.assembleegameclient.account.ui.Frame;
   import com.company.assembleegameclient.account.ui.TextInputField;
   import com.company.util.EmailValidator;
   import com.company.util.MoreObjectUtil;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.web.model.AccountData;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.pets.view.components.DialogCloseButton;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import org.osflash.signals.Signal;
   
   public class ConfirmEmailModal extends Frame
   {
      
      public var register:Signal = new Signal(AccountData);
      
      public var cancel:Signal;
      
      private var emailInput:TextInputField;
      
      private var account:Account;
      
      private var closeButton:DialogCloseButton;
      
      private var isKabam:Boolean = false;
      
      public function ConfirmEmailModal()
      {
         super(TextKey.VERIFY_WEB_ACCOUNT_DIALOG_TITLE,TextKey.REGISTER_WEB_ACCOUNT_DIALOG_LEFTBUTTON,TextKey.VERIFY_WEB_ACCOUNT_DIALOG_BUTTON);
         this.positionAndStuff();
         removeChild(leftButton_);
         this.account = StaticInjectorContext.getInjector().getInstance(Account);
         this.createAssets();
         this.enableForTabBehavior();
         this.addEventListeners();
      }
      
      private function addEventListeners() : void
      {
         rightButton_.addEventListener(MouseEvent.CLICK,this.onVerify);
         this.closeButton.addEventListener(MouseEvent.CLICK,this.onCancel);
      }
      
      private function createAssets() : void
      {
         this.emailInput = new TextInputField(TextKey.REGISTER_WEB_ACCOUNT_EMAIL,false);
         if(EmailValidator.isValidEmail(this.account.getUserId()))
         {
            this.emailInput.inputText_.setText(this.account.getUserId());
         }
         else
         {
            this.emailInput.inputText_.setText("");
            this.isKabam = true;
         }
         addTextInputField(this.emailInput);
         this.closeButton = new DialogCloseButton();
         this.closeButton.y = -2;
         this.closeButton.x = w_ - this.closeButton.width - 8;
         addChild(this.closeButton);
      }
      
      private function enableForTabBehavior() : void
      {
         this.emailInput.tabIndex = 1;
         rightButton_.tabIndex = 2;
         this.emailInput.tabEnabled = true;
         rightButton_.tabEnabled = true;
      }
      
      private function onCancel(param1:MouseEvent) : void
      {
         this.close();
      }
      
      private function close() : void
      {
         if(Boolean(parent) && parent.contains(this))
         {
            parent.removeChild(this);
         }
      }
      
      private function onVerify(param1:MouseEvent) : void
      {
         var _loc2_:AppEngineClient = null;
         var _loc3_:Object = null;
         if(this.isEmailValid())
         {
            _loc2_ = StaticInjectorContext.getInjector().getInstance(AppEngineClient);
            _loc2_.complete.addOnce(this.onComplete);
            _loc3_ = {"newGuid":this.emailInput.text()};
            MoreObjectUtil.addToObject(_loc3_,this.account.getCredentials());
            _loc2_.sendRequest("account/changeEmail",_loc3_);
            rightButton_.removeEventListener(MouseEvent.CLICK,this.onVerify);
         }
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         if(param1)
         {
            this.onSent();
         }
         else
         {
            this.onError(param2);
         }
         rightButton_.addEventListener(MouseEvent.CLICK,this.onVerify);
      }
      
      private function onSent() : void
      {
         var _loc1_:Account = StaticInjectorContext.getInjector().getInstance(Account);
         if(!this.isKabam)
         {
            _loc1_.updateUser(this.emailInput.text(),_loc1_.getPassword());
         }
         removeChild(titleText_);
         titleText_ = new TextFieldDisplayConcrete().setSize(12).setColor(11776947);
         titleText_.setStringBuilder(new LineBuilder().setParams("WebAccountDetailDialog.sent"));
         titleText_.filters = [new DropShadowFilter(0,0,0)];
         titleText_.x = 5;
         titleText_.y = 3;
         titleText_.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         addChild(titleText_);
      }
      
      private function onError(param1:String) : void
      {
         removeChild(titleText_);
         titleText_ = new TextFieldDisplayConcrete().setSize(12).setColor(16549442);
         titleText_.setStringBuilder(new LineBuilder().setParams(param1));
         titleText_.filters = [new DropShadowFilter(0,0,0)];
         titleText_.x = 5;
         titleText_.y = 3;
         titleText_.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         addChild(titleText_);
      }
      
      private function isEmailValid() : Boolean
      {
         var _loc1_:Boolean = EmailValidator.isValidEmail(this.emailInput.text());
         if(!_loc1_)
         {
            this.emailInput.setError(TextKey.INVALID_EMAIL_ADDRESS);
         }
         return _loc1_;
      }
      
      private function positionAndStuff() : void
      {
         this.x = WebMain.STAGE.stageWidth / 2 - this.w_ / 2;
         this.y = WebMain.STAGE.stageHeight / 2 - this.h_ / 2;
      }
   }
}

