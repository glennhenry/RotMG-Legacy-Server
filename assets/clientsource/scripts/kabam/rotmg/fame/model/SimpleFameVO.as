package kabam.rotmg.fame.model
{
   public class SimpleFameVO implements FameVO
   {
      
      private var accountId:String;
      
      private var characterId:int;
      
      public function SimpleFameVO(param1:String, param2:int)
      {
         super();
         this.accountId = param1;
         this.characterId = param2;
      }
      
      public function getAccountId() : String
      {
         return this.accountId;
      }
      
      public function getCharacterId() : int
      {
         return this.characterId;
      }
   }
}

