package kabam.rotmg.characters.reskin.control
{
   import com.company.assembleegameclient.objects.Player;
   import kabam.rotmg.assets.services.CharacterFactory;
   import kabam.rotmg.classes.model.CharacterClass;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.classes.model.ClassesModel;
   import kabam.rotmg.game.model.GameModel;
   import kabam.rotmg.messaging.impl.outgoing.Reskin;
   
   public class ReskinHandler
   {
      
      [Inject]
      public var model:GameModel;
      
      [Inject]
      public var classes:ClassesModel;
      
      [Inject]
      public var factory:CharacterFactory;
      
      public function ReskinHandler()
      {
         super();
      }
      
      public function execute(param1:Reskin) : void
      {
         var _loc2_:Player = null;
         var _loc3_:int = 0;
         var _loc4_:CharacterClass = null;
         _loc2_ = param1.player || this.model.player;
         _loc3_ = param1.skinID;
         _loc4_ = this.classes.getCharacterClass(_loc2_.objectType_);
         var _loc5_:CharacterSkin = _loc4_.skins.getSkin(_loc3_);
         _loc2_.skinId = _loc3_;
         _loc2_.skin = this.factory.makeCharacter(_loc5_.template);
         _loc2_.isDefaultAnimatedChar = false;
      }
   }
}

