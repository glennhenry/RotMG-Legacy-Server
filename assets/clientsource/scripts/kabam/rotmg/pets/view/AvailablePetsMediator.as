package kabam.rotmg.pets.view
{
   import kabam.rotmg.pets.controller.NotifyActivePetUpdated;
   import kabam.rotmg.pets.data.PetVO;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class AvailablePetsMediator extends Mediator
   {
      
      [Inject]
      public var view:AvailablePetsView;
      
      [Inject]
      public var notifyActivePetUpdated:NotifyActivePetUpdated;
      
      public function AvailablePetsMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.petSelected.add(this.onPetUpdated);
         this.view.init();
      }
      
      private function onPetUpdated(param1:PetVO) : void
      {
         this.notifyActivePetUpdated.dispatch(param1);
      }
      
      override public function destroy() : void
      {
      }
   }
}

