package kabam.rotmg.pets.view.dialogs
{
   import kabam.rotmg.pets.data.PetVO;
   import kabam.rotmg.pets.view.components.PetIcon;
   import kabam.rotmg.pets.view.components.PetIconFactory;
   
   public class PetItemFactory
   {
      
      [Inject]
      public var petIconFactory:PetIconFactory;
      
      public function PetItemFactory()
      {
         super();
      }
      
      public function create(param1:PetVO, param2:int) : PetItem
      {
         var _loc3_:PetItem = new PetItem();
         var _loc4_:PetIcon = this.petIconFactory.create(param1,param2);
         _loc3_.setPetIcon(_loc4_);
         _loc3_.setSize(param2);
         _loc3_.setBackground(PetItem.REGULAR);
         return _loc3_;
      }
   }
}

