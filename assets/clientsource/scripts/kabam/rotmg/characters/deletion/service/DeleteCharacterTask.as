package kabam.rotmg.characters.deletion.service
{
   import com.company.assembleegameclient.appengine.SavedCharacter;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.characters.model.CharacterModel;
   
   public class DeleteCharacterTask extends BaseTask
   {
      
      [Inject]
      public var character:SavedCharacter;
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var model:CharacterModel;
      
      public function DeleteCharacterTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.setMaxRetries(2);
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/char/delete",this.getRequestPacket());
      }
      
      private function getRequestPacket() : Object
      {
         var _loc1_:Object = this.account.getCredentials();
         _loc1_.charId = this.character.charId();
         _loc1_.reason = 1;
         return _loc1_;
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         param1 && this.updateUserData();
         completeTask(param1,param2);
      }
      
      private function updateUserData() : void
      {
         this.model.deleteCharacter(this.character.charId());
      }
   }
}

