package kabam.rotmg.pets.data
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.util.AnimatedChar;
   import com.company.assembleegameclient.util.AnimatedChars;
   import com.company.assembleegameclient.util.MaskedImage;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import org.osflash.signals.Signal;
   
   public class PetVO
   {
      
      private var staticData:XML;
      
      private var id:int;
      
      private var type:int;
      
      private var rarity:String;
      
      private var name:String;
      
      private var maxAbilityPower:int;
      
      public var abilityList:Array = [new AbilityVO(),new AbilityVO(),new AbilityVO()];
      
      private var skinID:int;
      
      private var skin:AnimatedChar;
      
      public const updated:Signal = new Signal();
      
      public function PetVO(param1:int = undefined)
      {
         super();
         this.id = param1;
         this.staticData = <data/>;
         this.listenToAbilities();
      }
      
      private static function getPetDataDescription(param1:int) : String
      {
         return ObjectLibrary.getPetDataXMLByType(param1).Description;
      }
      
      private static function getPetDataDisplayId(param1:int) : String
      {
         return ObjectLibrary.getPetDataXMLByType(param1).DisplayId;
      }
      
      public static function clone(param1:PetVO) : PetVO
      {
         return new PetVO(param1.id);
      }
      
      private function listenToAbilities() : void
      {
         var _loc1_:AbilityVO = null;
         for each(_loc1_ in this.abilityList)
         {
            _loc1_.updated.add(this.onAbilityUpdate);
         }
      }
      
      public function maxedAllAbilities() : Boolean
      {
         var _loc2_:AbilityVO = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.abilityList)
         {
            if(_loc2_.level == 100)
            {
               _loc1_++;
            }
         }
         return _loc1_ == this.abilityList.length;
      }
      
      private function onAbilityUpdate(param1:AbilityVO) : void
      {
         this.updated.dispatch();
      }
      
      public function apply(param1:XML) : void
      {
         this.extractBasicData(param1);
         this.extractAbilityData(param1);
      }
      
      private function extractBasicData(param1:XML) : void
      {
         param1.@instanceId && this.setID(param1.@instanceId);
         param1.@type && this.setType(param1.@type);
         param1.@name && this.setName(param1.@name);
         param1.@skin && this.setSkin(param1.@skin);
         param1.@rarity && this.setRarity(param1.@rarity);
      }
      
      public function extractAbilityData(param1:XML) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:AbilityVO = null;
         var _loc5_:int = 0;
         var _loc3_:uint = this.abilityList.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.abilityList[_loc2_];
            _loc5_ = int(param1.Abilities.Ability[_loc2_].@type);
            _loc4_.name = getPetDataDisplayId(_loc5_);
            _loc4_.description = getPetDataDescription(_loc5_);
            _loc4_.level = param1.Abilities.Ability[_loc2_].@power;
            _loc4_.points = param1.Abilities.Ability[_loc2_].@points;
            _loc2_++;
         }
      }
      
      public function getFamily() : String
      {
         return this.staticData.Family;
      }
      
      public function setID(param1:int) : void
      {
         this.id = param1;
      }
      
      public function getID() : int
      {
         return this.id;
      }
      
      public function setType(param1:int) : void
      {
         this.type = param1;
         this.staticData = ObjectLibrary.xmlLibrary_[this.type];
      }
      
      public function getType() : int
      {
         return this.type;
      }
      
      public function setRarity(param1:uint) : void
      {
         this.rarity = PetRarityEnum.selectByOrdinal(param1).value;
         this.unlockAbilitiesBasedOnPetRarity(param1);
         this.updated.dispatch();
      }
      
      private function unlockAbilitiesBasedOnPetRarity(param1:uint) : void
      {
         this.abilityList[0].setUnlocked(true);
         this.abilityList[1].setUnlocked(param1 >= PetRarityEnum.UNCOMMON.ordinal);
         this.abilityList[2].setUnlocked(param1 >= PetRarityEnum.LEGENDARY.ordinal);
      }
      
      public function getRarity() : String
      {
         return this.rarity;
      }
      
      public function setName(param1:String) : void
      {
         this.name = param1;
         this.updated.dispatch();
      }
      
      public function getName() : String
      {
         return this.name;
      }
      
      public function setMaxAbilityPower(param1:int) : void
      {
         this.maxAbilityPower = param1;
         this.updated.dispatch();
      }
      
      public function getMaxAbilityPower() : int
      {
         return this.maxAbilityPower;
      }
      
      public function setSkin(param1:int) : void
      {
         this.skinID = param1;
         this.updated.dispatch();
      }
      
      public function getSkinID() : int
      {
         return this.skinID;
      }
      
      public function getSkin() : Bitmap
      {
         this.makeSkin();
         var _loc1_:MaskedImage = this.skin.imageFromAngle(0,AnimatedChar.STAND,0);
         var _loc2_:int = this.rarity == PetRarityEnum.DIVINE.value ? 40 : 80;
         var _loc3_:BitmapData = TextureRedrawer.resize(_loc1_.image_,_loc1_.mask_,_loc2_,true,0,0);
         _loc3_ = GlowRedrawer.outlineGlow(_loc3_,0);
         return new Bitmap(_loc3_);
      }
      
      public function getSkinMaskedImage() : MaskedImage
      {
         this.makeSkin();
         return this.skin ? this.skin.imageFromAngle(0,AnimatedChar.STAND,0) : null;
      }
      
      private function makeSkin() : void
      {
         var _loc1_:XML = ObjectLibrary.getXMLfromId(ObjectLibrary.getIdFromType(this.skinID));
         var _loc2_:String = _loc1_.AnimatedTexture.File;
         var _loc3_:int = int(_loc1_.AnimatedTexture.Index);
         this.skin = AnimatedChars.getAnimatedChar(_loc2_,_loc3_);
      }
   }
}

