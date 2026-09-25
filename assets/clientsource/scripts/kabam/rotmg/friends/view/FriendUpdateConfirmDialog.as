package kabam.rotmg.friends.view
{
   import com.company.assembleegameclient.ui.dialogs.CloseDialogComponent;
   import com.company.assembleegameclient.ui.dialogs.Dialog;
   import com.company.assembleegameclient.ui.dialogs.DialogCloser;
   import flash.events.Event;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.friends.controller.FriendActionSignal;
   import kabam.rotmg.friends.model.FriendRequestVO;
   import org.osflash.signals.Signal;
   import org.swiftsuspenders.Injector;
   
   public class FriendUpdateConfirmDialog extends Dialog implements DialogCloser
   {
      
      private const closeDialogComponent:CloseDialogComponent = new CloseDialogComponent();
      
      private var _friendRequestVO:FriendRequestVO;
      
      public function FriendUpdateConfirmDialog(param1:String, param2:String, param3:String, param4:String, param5:FriendRequestVO, param6:Object = null)
      {
         super(param1,param2,param3,param4,null,param6);
         this._friendRequestVO = param5;
         this.closeDialogComponent.add(this,Dialog.RIGHT_BUTTON);
         this.closeDialogComponent.add(this,Dialog.LEFT_BUTTON);
         addEventListener(Dialog.RIGHT_BUTTON,this.onRightButton);
      }
      
      private function onRightButton(param1:Event) : void
      {
         removeEventListener(Dialog.RIGHT_BUTTON,this.onRightButton);
         var _loc2_:Injector = StaticInjectorContext.getInjector();
         var _loc3_:FriendActionSignal = _loc2_.getInstance(FriendActionSignal);
         _loc3_.dispatch(this._friendRequestVO);
      }
      
      public function getCloseSignal() : Signal
      {
         return this.closeDialogComponent.getCloseSignal();
      }
   }
}

