package kabam.rotmg.characters.model
{
   import com.company.assembleegameclient.appengine.SavedCharacter;
   import kabam.rotmg.core.model.PlayerModel;
   
   public class LegacyCharacterModel implements CharacterModel
   {
      
      [Inject]
      public var wrapped:PlayerModel;
      
      private var selected:SavedCharacter;
      
      public function LegacyCharacterModel()
      {
         super();
      }
      
      public function getCharacterCount() : int
      {
         return this.wrapped.getCharacterCount();
      }
      
      public function getCharacter(param1:int) : SavedCharacter
      {
         return this.wrapped.getCharById(param1);
      }
      
      public function deleteCharacter(param1:int) : void
      {
         this.wrapped.deleteCharacter(param1);
         if(this.selected.charId() == param1)
         {
            this.selected = null;
         }
      }
      
      public function select(param1:SavedCharacter) : void
      {
         this.selected = param1;
      }
      
      public function getSelected() : SavedCharacter
      {
         return this.selected;
      }
   }
}

