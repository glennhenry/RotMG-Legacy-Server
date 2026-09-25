package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.objects.animation.AnimationsData;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.AssetLibrary;
   import com.company.util.ConversionUtil;
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import kabam.rotmg.constants.GeneralConstants;
   import kabam.rotmg.constants.ItemConstants;
   import kabam.rotmg.messaging.impl.data.StatData;
   
   public class ObjectLibrary
   {
      
      public static var textureDataFactory:TextureDataFactory = new TextureDataFactory();
      
      public static const IMAGE_SET_NAME:String = "lofiObj3";
      
      public static const IMAGE_ID:int = 255;
      
      public static var playerChars_:Vector.<XML> = new Vector.<XML>();
      
      public static var hexTransforms_:Vector.<XML> = new Vector.<XML>();
      
      public static var playerClassAbbr_:Dictionary = new Dictionary();
      
      public static const propsLibrary_:Dictionary = new Dictionary();
      
      public static const xmlLibrary_:Dictionary = new Dictionary();
      
      public static const idToType_:Dictionary = new Dictionary();
      
      public static const typeToDisplayId_:Dictionary = new Dictionary();
      
      public static const typeToTextureData_:Dictionary = new Dictionary();
      
      public static const typeToTopTextureData_:Dictionary = new Dictionary();
      
      public static const typeToAnimationsData_:Dictionary = new Dictionary();
      
      public static const petXMLDataLibrary_:Dictionary = new Dictionary();
      
      public static const skinSetXMLDataLibrary_:Dictionary = new Dictionary();
      
      public static const defaultProps_:ObjectProperties = new ObjectProperties(null);
      
      public static const TYPE_MAP:Object = {
         "ArenaGuard":ArenaGuard,
         "ArenaPortal":ArenaPortal,
         "CaveWall":CaveWall,
         "Character":Character,
         "CharacterChanger":CharacterChanger,
         "ClosedGiftChest":ClosedGiftChest,
         "ClosedVaultChest":ClosedVaultChest,
         "ConnectedWall":ConnectedWall,
         "Container":Container,
         "DoubleWall":DoubleWall,
         "FortuneGround":FortuneGround,
         "FortuneTeller":FortuneTeller,
         "GameObject":GameObject,
         "GuildBoard":GuildBoard,
         "GuildChronicle":GuildChronicle,
         "GuildHallPortal":GuildHallPortal,
         "GuildMerchant":GuildMerchant,
         "GuildRegister":GuildRegister,
         "Merchant":Merchant,
         "MoneyChanger":MoneyChanger,
         "MysteryBoxGround":MysteryBoxGround,
         "NameChanger":NameChanger,
         "ReskinVendor":ReskinVendor,
         "OneWayContainer":OneWayContainer,
         "Player":Player,
         "Portal":Portal,
         "Projectile":Projectile,
         "QuestRewards":QuestRewards,
         "Sign":Sign,
         "SpiderWeb":SpiderWeb,
         "Stalagmite":Stalagmite,
         "Wall":Wall,
         "Pet":Pet,
         "PetUpgrader":PetUpgrader,
         "YardUpgrader":YardUpgrader
      };
      
      public function ObjectLibrary()
      {
         super();
      }
      
      public static function parseFromXML(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         for each(_loc2_ in param1.Object)
         {
            _loc3_ = String(_loc2_.@id);
            _loc4_ = _loc3_;
            if(_loc2_.hasOwnProperty("DisplayId"))
            {
               _loc4_ = _loc2_.DisplayId;
            }
            if(_loc2_.hasOwnProperty("Group"))
            {
               if(_loc2_.Group == "Hexable")
               {
                  hexTransforms_.push(_loc2_);
               }
            }
            _loc5_ = int(_loc2_.@type);
            if(_loc2_.hasOwnProperty("PetBehavior") || _loc2_.hasOwnProperty("PetAbility"))
            {
               petXMLDataLibrary_[_loc5_] = _loc2_;
            }
            else
            {
               propsLibrary_[_loc5_] = new ObjectProperties(_loc2_);
               xmlLibrary_[_loc5_] = _loc2_;
               idToType_[_loc3_] = _loc5_;
               typeToDisplayId_[_loc5_] = _loc4_;
               if(String(_loc2_.Class) == "Player")
               {
                  playerClassAbbr_[_loc5_] = String(_loc2_.@id).substr(0,2);
                  _loc6_ = false;
                  _loc7_ = 0;
                  while(_loc7_ < playerChars_.length)
                  {
                     if(int(playerChars_[_loc7_].@type) == _loc5_)
                     {
                        playerChars_[_loc7_] = _loc2_;
                        _loc6_ = true;
                     }
                     _loc7_++;
                  }
                  if(!_loc6_)
                  {
                     playerChars_.push(_loc2_);
                  }
               }
               typeToTextureData_[_loc5_] = textureDataFactory.create(_loc2_);
               if(_loc2_.hasOwnProperty("Top"))
               {
                  typeToTopTextureData_[_loc5_] = textureDataFactory.create(XML(_loc2_.Top));
               }
               if(_loc2_.hasOwnProperty("Animation"))
               {
                  typeToAnimationsData_[_loc5_] = new AnimationsData(_loc2_);
               }
            }
         }
      }
      
      public static function getIdFromType(param1:int) : String
      {
         var _loc2_:XML = xmlLibrary_[param1];
         if(_loc2_ == null)
         {
            return null;
         }
         return String(_loc2_.@id);
      }
      
      public static function getPropsFromId(param1:String) : ObjectProperties
      {
         var _loc2_:int = int(idToType_[param1]);
         return propsLibrary_[_loc2_];
      }
      
      public static function getXMLfromId(param1:String) : XML
      {
         var _loc2_:int = int(idToType_[param1]);
         return xmlLibrary_[_loc2_];
      }
      
      public static function getObjectFromType(param1:int) : GameObject
      {
         var _loc2_:XML = xmlLibrary_[param1];
         var _loc3_:String = _loc2_.Class;
         var _loc4_:Class = TYPE_MAP[_loc3_] || makeClass(_loc3_);
         return new _loc4_(_loc2_);
      }
      
      private static function makeClass(param1:String) : Class
      {
         var _loc2_:String = "com.company.assembleegameclient.objects." + param1;
         return getDefinitionByName(_loc2_) as Class;
      }
      
      public static function getTextureFromType(param1:int) : BitmapData
      {
         var _loc2_:TextureData = typeToTextureData_[param1];
         if(_loc2_ == null)
         {
            return null;
         }
         return _loc2_.getTexture();
      }
      
      public static function getBitmapData(param1:int) : BitmapData
      {
         var _loc2_:TextureData = typeToTextureData_[param1];
         var _loc3_:BitmapData = _loc2_ ? _loc2_.getTexture() : null;
         if(_loc3_)
         {
            return _loc3_;
         }
         return AssetLibrary.getImageFromSet(IMAGE_SET_NAME,IMAGE_ID);
      }
      
      public static function getRedrawnTextureFromType(param1:int, param2:int, param3:Boolean, param4:Boolean = true, param5:Number = 5) : BitmapData
      {
         var _loc6_:BitmapData = getBitmapData(param1);
         return TextureRedrawer.redraw(_loc6_,param2,param3,0,param4,param5);
      }
      
      public static function getSizeFromType(param1:int) : int
      {
         var _loc2_:XML = xmlLibrary_[param1];
         if(!_loc2_.hasOwnProperty("Size"))
         {
            return 100;
         }
         return int(_loc2_.Size);
      }
      
      public static function getSlotTypeFromType(param1:int) : int
      {
         var _loc2_:XML = xmlLibrary_[param1];
         if(!_loc2_.hasOwnProperty("SlotType"))
         {
            return -1;
         }
         return int(_loc2_.SlotType);
      }
      
      public static function isEquippableByPlayer(param1:int, param2:Player) : Boolean
      {
         if(param1 == ItemConstants.NO_ITEM)
         {
            return false;
         }
         var _loc3_:XML = xmlLibrary_[param1];
         var _loc4_:int = int(_loc3_.SlotType.toString());
         var _loc5_:uint = 0;
         while(_loc5_ < GeneralConstants.NUM_EQUIPMENT_SLOTS)
         {
            if(param2.slotTypes_[_loc5_] == _loc4_)
            {
               return true;
            }
            _loc5_++;
         }
         return false;
      }
      
      public static function getMatchingSlotIndex(param1:int, param2:Player) : int
      {
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         if(param1 != ItemConstants.NO_ITEM)
         {
            _loc3_ = xmlLibrary_[param1];
            _loc4_ = int(_loc3_.SlotType);
            _loc5_ = 0;
            while(_loc5_ < GeneralConstants.NUM_EQUIPMENT_SLOTS)
            {
               if(param2.slotTypes_[_loc5_] == _loc4_)
               {
                  return _loc5_;
               }
               _loc5_++;
            }
         }
         return -1;
      }
      
      public static function isUsableByPlayer(param1:int, param2:Player) : Boolean
      {
         if(param2 == null)
         {
            return true;
         }
         var _loc3_:XML = xmlLibrary_[param1];
         if(_loc3_ == null || !_loc3_.hasOwnProperty("SlotType"))
         {
            return false;
         }
         var _loc4_:int = int(_loc3_.SlotType);
         if(_loc4_ == ItemConstants.POTION_TYPE || _loc4_ == ItemConstants.EGG_TYPE)
         {
            return true;
         }
         var _loc5_:int = 0;
         while(_loc5_ < param2.slotTypes_.length)
         {
            if(param2.slotTypes_[_loc5_] == _loc4_)
            {
               return true;
            }
            _loc5_++;
         }
         return false;
      }
      
      public static function isSoulbound(param1:int) : Boolean
      {
         var _loc2_:XML = xmlLibrary_[param1];
         return _loc2_ != null && _loc2_.hasOwnProperty("Soulbound");
      }
      
      public static function usableBy(param1:int) : Vector.<String>
      {
         var _loc5_:XML = null;
         var _loc6_:Vector.<int> = null;
         var _loc7_:int = 0;
         var _loc2_:XML = xmlLibrary_[param1];
         if(_loc2_ == null || !_loc2_.hasOwnProperty("SlotType"))
         {
            return null;
         }
         var _loc3_:int = int(_loc2_.SlotType);
         if(_loc3_ == ItemConstants.POTION_TYPE || _loc3_ == ItemConstants.RING_TYPE || _loc3_ == ItemConstants.EGG_TYPE)
         {
            return null;
         }
         var _loc4_:Vector.<String> = new Vector.<String>();
         for each(_loc5_ in playerChars_)
         {
            _loc6_ = ConversionUtil.toIntVector(_loc5_.SlotTypes);
            _loc7_ = 0;
            while(_loc7_ < _loc6_.length)
            {
               if(_loc6_[_loc7_] == _loc3_)
               {
                  _loc4_.push(typeToDisplayId_[int(_loc5_.@type)]);
                  break;
               }
               _loc7_++;
            }
         }
         return _loc4_;
      }
      
      public static function playerMeetsRequirements(param1:int, param2:Player) : Boolean
      {
         var _loc4_:XML = null;
         if(param2 == null)
         {
            return true;
         }
         var _loc3_:XML = xmlLibrary_[param1];
         for each(_loc4_ in _loc3_.EquipRequirement)
         {
            if(!playerMeetsRequirement(_loc4_,param2))
            {
               return false;
            }
         }
         return true;
      }
      
      public static function playerMeetsRequirement(param1:XML, param2:Player) : Boolean
      {
         var _loc3_:int = 0;
         if(param1.toString() == "Stat")
         {
            _loc3_ = int(param1.@value);
            switch(int(param1.@stat))
            {
               case StatData.MAX_HP_STAT:
                  return param2.maxHP_ >= _loc3_;
               case StatData.MAX_MP_STAT:
                  return param2.maxMP_ >= _loc3_;
               case StatData.LEVEL_STAT:
                  return param2.level_ >= _loc3_;
               case StatData.ATTACK_STAT:
                  return param2.attack_ >= _loc3_;
               case StatData.DEFENSE_STAT:
                  return param2.defense_ >= _loc3_;
               case StatData.SPEED_STAT:
                  return param2.speed_ >= _loc3_;
               case StatData.VITALITY_STAT:
                  return param2.vitality_ >= _loc3_;
               case StatData.WISDOM_STAT:
                  return param2.wisdom_ >= _loc3_;
               case StatData.DEXTERITY_STAT:
                  return param2.dexterity_ >= _loc3_;
            }
         }
         return false;
      }
      
      public static function getPetDataXMLByType(param1:int) : XML
      {
         return petXMLDataLibrary_[param1];
      }
   }
}

