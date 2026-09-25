package kabam.rotmg.classes.control
{
   import kabam.rotmg.classes.model.CharacterClass;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.classes.model.CharacterSkinState;
   import kabam.rotmg.classes.model.ClassesModel;
   import robotlegs.bender.framework.api.ILogger;
   
   public class ParseCharListXmlCommand
   {
      
      [Inject]
      public var data:XML;
      
      [Inject]
      public var model:ClassesModel;
      
      [Inject]
      public var logger:ILogger;
      
      public function ParseCharListXmlCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         this.parseMaxLevelsAchieved();
         this.parseItemCosts();
         this.parseOwnership();
      }
      
      private function parseMaxLevelsAchieved() : void
      {
         var _loc2_:XML = null;
         var _loc3_:CharacterClass = null;
         var _loc1_:XMLList = this.data.MaxClassLevelList.MaxClassLevel;
         for each(_loc2_ in _loc1_)
         {
            _loc3_ = this.model.getCharacterClass(_loc2_.@classType);
            _loc3_.setMaxLevelAchieved(_loc2_.@maxLevel);
         }
      }
      
      private function parseItemCosts() : void
      {
         var _loc2_:XML = null;
         var _loc3_:CharacterSkin = null;
         var _loc1_:XMLList = this.data.ItemCosts.ItemCost;
         for each(_loc2_ in _loc1_)
         {
            _loc3_ = this.model.getCharacterSkin(_loc2_.@type);
            if(_loc3_)
            {
               _loc3_.cost = int(_loc2_);
               _loc3_.limited = Boolean(int(_loc2_.@expires));
               if(!Boolean(int(_loc2_.@purchasable)))
               {
                  _loc3_.setState(CharacterSkinState.UNLISTED);
               }
            }
            else
            {
               this.logger.warn("Cannot set Character Skin cost: type {0} not found",[_loc2_.@type]);
            }
         }
      }
      
      private function parseOwnership() : void
      {
         var _loc2_:int = 0;
         var _loc3_:CharacterSkin = null;
         var _loc1_:Array = this.data.OwnedSkins.length() ? this.data.OwnedSkins.split(",") : [];
         for each(_loc2_ in _loc1_)
         {
            _loc3_ = this.model.getCharacterSkin(_loc2_);
            if(_loc3_)
            {
               _loc3_.setState(CharacterSkinState.OWNED);
            }
            else
            {
               this.logger.warn("Cannot set Character Skin ownership: type {0} not found",[_loc2_]);
            }
         }
      }
   }
}

