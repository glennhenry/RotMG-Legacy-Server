package kabam.rotmg.friends.controller
{
   import com.company.assembleegameclient.ui.dialogs.ErrorDialog;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.friends.model.FriendConstant;
   import kabam.rotmg.friends.model.FriendRequestVO;
   
   public class FriendActionCommand
   {
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var vo:FriendRequestVO;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      public function FriendActionCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var _loc1_:String = FriendConstant.getURL(this.vo.request);
         var _loc2_:Object = this.account.getCredentials();
         _loc2_["targetName"] = this.vo.target;
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest(_loc1_,_loc2_);
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         if(Boolean(this.vo.callback))
         {
            this.vo.callback(param1,param2,this.vo.target);
         }
         else if(!param1)
         {
            this.openDialog.dispatch(new ErrorDialog(param2));
         }
      }
   }
}

