package kabam.rotmg.classes.control
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import kabam.rotmg.assets.EmbeddedData;
   import kabam.rotmg.assets.model.CharacterTemplate;
   import kabam.rotmg.classes.model.CharacterClass;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.classes.model.ClassesModel;
   
   public class ParseSkinsXmlCommand
   {
      
      [Inject]
      public var model:ClassesModel;
      
      public function ParseSkinsXmlCommand()
      {
         super();
      }
      
      private static function parseNodeEquipment(param1:XML) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc2_ = param1.children();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.attribute("skinType").length() != 0)
            {
               _loc4_ = int(_loc3_.@skinType);
               _loc5_ = 16766720;
               if(_loc3_.attribute("color").length() != 0)
               {
                  _loc5_ = int(_loc3_.@color);
               }
               ObjectLibrary.skinSetXMLDataLibrary_[_loc4_] = _loc3_;
            }
         }
      }
      
      public function execute() : void
      {
         var _loc1_:XML = null;
         var _loc2_:XMLList = null;
         var _loc3_:XML = null;
         _loc1_ = EmbeddedData.skinsXML;
         _loc2_ = _loc1_.children();
         for each(_loc3_ in _loc2_)
         {
            this.parseNode(_loc3_);
         }
         _loc1_ = EmbeddedData.skinsEquipmentSetsXML;
         _loc2_ = _loc1_.children();
         for each(_loc3_ in _loc2_)
         {
            parseNodeEquipment(_loc3_);
         }
      }
      
      private function parseNode(param1:XML) : void
      {
         var _loc2_:String = param1.AnimatedTexture.File;
         var _loc3_:int = int(param1.AnimatedTexture.Index);
         var _loc4_:CharacterSkin = new CharacterSkin();
         _loc4_.id = param1.@type;
         _loc4_.name = param1.DisplayId;
         _loc4_.unlockLevel = param1.UnlockLevel;
         if(param1.hasOwnProperty("NoSkinSelect"))
         {
            _loc4_.skinSelectEnabled = false;
         }
         if(param1.hasOwnProperty("UnlockSpecial"))
         {
            _loc4_.unlockSpecial = param1.UnlockSpecial;
         }
         _loc4_.template = new CharacterTemplate(_loc2_,_loc3_);
         var _loc5_:CharacterClass = this.model.getCharacterClass(param1.PlayerClassType);
         _loc5_.skins.addSkin(_loc4_);
      }
   }
}

