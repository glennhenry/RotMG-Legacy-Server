package kabam.rotmg.classes.control
{
   import kabam.rotmg.classes.model.CharacterClass;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.classes.model.CharacterSkinState;
   import kabam.rotmg.classes.model.ClassesModel;
   
   public class ResetClassDataCommand
   {
      
      [Inject]
      public var classes:ClassesModel;
      
      public function ResetClassDataCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var _loc1_:int = int(this.classes.getCount());
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this.resetClass(this.classes.getClassAtIndex(_loc2_));
            _loc2_++;
         }
      }
      
      private function resetClass(param1:CharacterClass) : void
      {
         param1.setIsSelected(param1.id == ClassesModel.WIZARD_ID);
         this.resetClassSkins(param1);
      }
      
      private function resetClassSkins(param1:CharacterClass) : void
      {
         var _loc5_:CharacterSkin = null;
         var _loc2_:CharacterSkin = param1.skins.getDefaultSkin();
         var _loc3_:int = param1.skins.getCount();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1.skins.getSkinAt(_loc4_);
            if(_loc5_ != _loc2_)
            {
               this.resetSkin(param1.skins.getSkinAt(_loc4_));
            }
            _loc4_++;
         }
      }
      
      private function resetSkin(param1:CharacterSkin) : void
      {
         param1.setState(CharacterSkinState.LOCKED);
      }
   }
}

