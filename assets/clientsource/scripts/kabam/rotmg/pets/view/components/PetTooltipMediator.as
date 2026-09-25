package kabam.rotmg.pets.view.components
{
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class PetTooltipMediator extends Mediator
   {
      
      [Inject]
      public var view:PetTooltip;
      
      public function PetTooltipMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.init();
      }
   }
}

