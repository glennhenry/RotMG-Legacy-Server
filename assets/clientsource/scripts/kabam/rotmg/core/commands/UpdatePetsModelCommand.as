package kabam.rotmg.core.commands
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import kabam.rotmg.pets.data.PetVO;
   import kabam.rotmg.pets.data.PetYardEnum;
   import kabam.rotmg.pets.data.PetsModel;
   import robotlegs.bender.bundles.mvcs.Command;
   
   public class UpdatePetsModelCommand extends Command
   {
      
      [Inject]
      public var model:PetsModel;
      
      [Inject]
      public var data:XML;
      
      public function UpdatePetsModelCommand()
      {
         super();
      }
      
      override public function execute() : void
      {
         if(this.data.Account.hasOwnProperty("PetYardType"))
         {
            this.model.setPetYardType(this.parseYardFromXML());
         }
         if(this.data.hasOwnProperty("Pet"))
         {
            this.model.setActivePet(this.parsePetFromXML());
         }
      }
      
      private function parseYardFromXML() : int
      {
         var _loc1_:String = PetYardEnum.selectByOrdinal(this.data.Account.PetYardType).value;
         var _loc2_:XML = ObjectLibrary.getXMLfromId(_loc1_);
         return _loc2_.@type;
      }
      
      private function parsePetFromXML() : PetVO
      {
         var _loc1_:XMLList = this.data.Pet;
         var _loc2_:PetVO = this.model.getPetVO(_loc1_.@instanceId);
         _loc2_.apply(_loc1_[0]);
         return _loc2_;
      }
   }
}

