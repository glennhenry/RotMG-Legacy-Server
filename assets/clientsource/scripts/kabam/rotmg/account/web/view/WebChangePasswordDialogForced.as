package kabam.rotmg.account.web.view
{
   import com.company.assembleegameclient.account.ui.Frame;
   import com.company.assembleegameclient.account.ui.TextInputField;
   import flash.events.MouseEvent;
   import kabam.rotmg.text.model.TextKey;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class WebChangePasswordDialogForced extends Frame
   {
      
      public var cancel:Signal;
      
      public var change:Signal;
      
      public var password_:TextInputField;
      
      public var newPassword_:TextInputField;
      
      public var retypeNewPassword_:TextInputField;
      
      public function WebChangePasswordDialogForced()
      {
         super(TextKey.WEB_CHANGE_PASSWORD_TITLE,"",TextKey.WEB_CHANGE_PASSWORD_RIGHT,"/changePassword");
         this.password_ = new TextInputField(TextKey.WEB_CHANGE_PASSWORD_PASSWORD,true);
         addTextInputField(this.password_);
         this.newPassword_ = new TextInputField(TextKey.WEB_CHANGE_PASSWORD_NEW_PASSWORD,true);
         addTextInputField(this.newPassword_);
         this.retypeNewPassword_ = new TextInputField(TextKey.WEB_CHANGE_PASSWORD_RETYPE_PASSWORD,true);
         addTextInputField(this.retypeNewPassword_);
         this.change = new NativeMappedSignal(rightButton_,MouseEvent.CLICK);
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
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc1_:Boolean = this.newPassword_.text().length >= 10;
         if(!_loc1_)
         {
            this.newPassword_.setError(TextKey.LINK_WEB_ACCOUNT_SHORT);
         }
         else
         {
            _loc2_ = this.newPassword_.text();
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length - 2)
            {
               if(_loc2_.charAt(_loc3_) == _loc2_.charAt(_loc3_ + 1) && _loc2_.charAt(_loc3_ + 1) == _loc2_.charAt(_loc3_ + 2))
               {
                  this.newPassword_.setError(TextKey.LINK_WEB_ACCOUNT_SHORT);
                  _loc1_ = false;
               }
               _loc3_++;
            }
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

