package kabam.rotmg.classes.model
{
   import org.osflash.signals.Signal;
   
   public class ClassesModel
   {
      
      public static const WIZARD_ID:int = 782;
      
      public const selected:Signal = new Signal(CharacterClass);
      
      private const map:Object = {};
      
      private const classes:Vector.<CharacterClass> = new Vector.<CharacterClass>(0);
      
      private var count:uint = 0;
      
      private var selectedChar:CharacterClass;
      
      public function ClassesModel()
      {
         super();
      }
      
      public function getCount() : uint
      {
         return this.count;
      }
      
      public function getClassAtIndex(param1:int) : CharacterClass
      {
         return this.classes[param1];
      }
      
      public function getCharacterClass(param1:int) : CharacterClass
      {
         return this.map[param1] = this.map[param1] || this.makeCharacterClass();
      }
      
      private function makeCharacterClass() : CharacterClass
      {
         var _loc1_:CharacterClass = new CharacterClass();
         _loc1_.selected.add(this.onClassSelected);
         this.count = this.classes.push(_loc1_);
         return _loc1_;
      }
      
      private function onClassSelected(param1:CharacterClass) : void
      {
         if(this.selectedChar != param1)
         {
            this.selectedChar && this.selectedChar.setIsSelected(false);
            this.selectedChar = param1;
            this.selected.dispatch(param1);
         }
      }
      
      public function getSelected() : CharacterClass
      {
         return this.selectedChar || this.getCharacterClass(WIZARD_ID);
      }
      
      public function getCharacterSkin(param1:int) : CharacterSkin
      {
         var _loc2_:CharacterSkin = null;
         var _loc3_:CharacterClass = null;
         for each(_loc3_ in this.classes)
         {
            _loc2_ = _loc3_.skins.getSkin(param1);
            if(_loc2_ != _loc3_.skins.getDefaultSkin())
            {
               break;
            }
         }
         return _loc2_;
      }
   }
}

