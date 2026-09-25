package kabam.rotmg.pets.view.dialogs
{
   public class ItemBackgroundFactory
   {
      
      public function ItemBackgroundFactory()
      {
         super();
      }
      
      public function create(param1:int, param2:Array) : PetItemBackground
      {
         return new PetItemBackground(param1,param2);
      }
   }
}

