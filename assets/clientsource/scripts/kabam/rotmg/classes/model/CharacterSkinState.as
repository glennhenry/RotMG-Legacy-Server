package kabam.rotmg.classes.model
{
   public class CharacterSkinState
   {
      
      public static const OWNED:CharacterSkinState = new CharacterSkinState(false,"OWNED",false);
      
      public static const UNLISTED:CharacterSkinState = new CharacterSkinState(true,"UNLISTED",false);
      
      public static const PURCHASABLE:CharacterSkinState = new CharacterSkinState(false,"PURCHASABLE",true);
      
      public static const PURCHASING:CharacterSkinState = new CharacterSkinState(true,"PURCHASING",true);
      
      public static const LOCKED:CharacterSkinState = new CharacterSkinState(true,"LOCKED",true);
      
      public static const NULL:CharacterSkinState = new CharacterSkinState(true,"NULL",true);
      
      private var _isDisabled:Boolean;
      
      private var _skinStateDeterminedByLevel:Boolean;
      
      private var name:String;
      
      public function CharacterSkinState(param1:Boolean, param2:String, param3:Boolean)
      {
         super();
         this._isDisabled = param1;
         this._skinStateDeterminedByLevel = param3;
         this.name = param2;
      }
      
      public function isDisabled() : Boolean
      {
         return this._isDisabled;
      }
      
      public function isSkinStateDeterminedByLevel() : Boolean
      {
         return this._skinStateDeterminedByLevel;
      }
      
      public function toString() : String
      {
         return "[CharacterSkinState {NAME}]".replace("{NAME}",this.name);
      }
   }
}

