package kabam.rotmg.account.web.view
{
   import com.company.assembleegameclient.account.ui.Frame;
   import com.company.assembleegameclient.account.ui.TextInputField;
   import flash.events.MouseEvent;
   import kabam.rotmg.account.web.model.ChangePasswordData;
   import kabam.rotmg.text.model.TextKey;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class WebChangePasswordDialog extends Frame
   {
      
      public var cancel:Signal;
      
      public var change:Signal;
      
      public var password_:TextInputField;
      
      public var newPassword_:TextInputField;
      
      public var retypeNewPassword_:TextInputField;
      
      public function WebChangePasswordDialog()
      {
         super(TextKey.WEB_CHANGE_PASSWORD_TITLE,TextKey.WEB_CHANGE_PASSWORD_LEFT,TextKey.WEB_CHANGE_PASSWORD_RIGHT,"/changePassword");
         this.password_ = new TextInputField(TextKey.WEB_CHANGE_PASSWORD_PASSWORD,true);
         addTextInputField(this.password_);
         this.newPassword_ = new TextInputField(TextKey.WEB_CHANGE_PASSWORD_NEW_PASSWORD,true);
         addTextInputField(this.newPassword_);
         this.retypeNewPassword_ = new TextInputField(TextKey.WEB_CHANGE_PASSWORD_RETYPE_PASSWORD,true);
         addTextInputField(this.retypeNewPassword_);
         this.cancel = new NativeMappedSignal(leftButton_,MouseEvent.CLICK);
         this.change = new NativeMappedSignal(rightButton_,MouseEvent.CLICK);
      }
      
      private function onChange(param1:MouseEvent) : void
      {
         var _loc2_:ChangePasswordData = null;
         if(this.isCurrentPasswordValid() && this.isNewPasswordValid() && this.isNewPasswordVerified())
         {
            disable();
            _loc2_ = new ChangePasswordData();
            _loc2_.currentPassword = this.password_.text();
            _loc2_.newPassword = this.newPassword_.text();
            this.change.dispatch(_loc2_);
         }
      }
      
      private function isCurrentPasswordValid() : Boolean
      {
         var _loc1_:Boolean = this.password_.text().length >= 5;
         if(!_loc1_)
         {
            this.password_.setError(TextKey.WEB_CHANGE_PASSWORD_INCORRECT);
         }
         return _loc1_;
      }
      
      private function isNewPasswordValid() : Boolean
      {
         var _loc1_:Boolean = this.newPassword_.text().length >= 5;
         if(!_loc1_)
         {
            this.newPassword_.setError(TextKey.LINK_WEB_ACCOUNT_SHORT);
         }
         return _loc1_;
      }
      
      private function isNewPasswordVerified() : Boolean
      {
         var _loc1_:Boolean = this.newPassword_.text() == this.retypeNewPassword_.text();
         if(!_loc1_)
         {
            this.retypeNewPassword_.setError(TextKey.PASSWORD_DOES_NOT_MATCH);
         }
         return _loc1_;
      }
      
      public function setError(param1:String) : void
      {
         this.password_.setError(param1);
      }
      
      public function clearError() : void
      {
         this.password_.clearError();
         this.retypeNewPassword_.clearError();
         this.newPassword_.clearError();
      }
   }
}

