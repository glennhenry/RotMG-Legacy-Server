package kabam.rotmg.account.core.view
{
   import com.company.assembleegameclient.ui.dialogs.Dialog;
   import kabam.rotmg.text.model.TextKey;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class RegisterPromptDialog extends Dialog
   {
      
      public var cancel:Signal;
      
      public var register:Signal;
      
      public function RegisterPromptDialog(param1:String, param2:Object = null)
      {
         super(TextKey.REGISTER_PROMPT_NOT_REGISTERED,param1,TextKey.REGISTER_PROMPT_CANCEL,TextKey.REGISTER_PROMPT_REGISTER,"/needRegister",param2);
         this.cancel = new NativeMappedSignal(this,LEFT_BUTTON);
         this.register = new NativeMappedSignal(this,RIGHT_BUTTON);
      }
   }
}

