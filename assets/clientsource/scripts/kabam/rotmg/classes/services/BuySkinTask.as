package kabam.rotmg.classes.services
{
   import com.company.assembleegameclient.ui.dialogs.ErrorDialog;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.classes.model.CharacterSkinState;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   
   public class BuySkinTask extends BaseTask
   {
      
      [Inject]
      public var skin:CharacterSkin;
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var player:PlayerModel;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      public function BuySkinTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.skin.setState(CharacterSkinState.PURCHASING);
         this.player.changeCredits(-this.skin.cost);
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("account/purchaseSkin",this.makeCredentials());
      }
      
      private function makeCredentials() : Object
      {
         var _loc1_:Object = this.account.getCredentials();
         _loc1_.skinType = this.skin.id;
         return _loc1_;
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         if(param1)
         {
            this.completePurchase();
         }
         else
         {
            this.abandonPurchase(param2);
         }
         completeTask(param1,param2);
      }
      
      private function completePurchase() : void
      {
         this.skin.setState(CharacterSkinState.OWNED);
         this.skin.setIsSelected(true);
      }
      
      private function abandonPurchase(param1:String) : void
      {
         var _loc2_:ErrorDialog = new ErrorDialog(param1);
         this.openDialog.dispatch(_loc2_);
         this.skin.setState(CharacterSkinState.PURCHASABLE);
         this.player.changeCredits(this.skin.cost);
      }
   }
}

