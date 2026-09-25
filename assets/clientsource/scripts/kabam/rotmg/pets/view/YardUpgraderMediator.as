package kabam.rotmg.pets.view
{
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.pets.controller.UpgradePetSignal;
   import kabam.rotmg.pets.data.PetRarityEnum;
   import kabam.rotmg.pets.data.PetsModel;
   import kabam.rotmg.pets.data.UpgradePetYardRequestVO;
   import kabam.rotmg.pets.data.YardUpgraderVO;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class YardUpgraderMediator extends Mediator
   {
      
      [Inject]
      public var view:YardUpgraderView;
      
      [Inject]
      public var petModel:PetsModel;
      
      [Inject]
      public var upgradePet:UpgradePetSignal;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var closeDialog:CloseDialogsSignal;
      
      public function YardUpgraderMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         var _loc1_:YardUpgraderVO = new YardUpgraderVO();
         var _loc2_:int = int(this.petModel.getPetYardRarity());
         var _loc3_:int = _loc2_ < PetRarityEnum.DIVINE.ordinal ? PetRarityEnum.selectByOrdinal(_loc2_ + 1).ordinal : PetRarityEnum.DIVINE.ordinal;
         _loc1_.currentRarityLevel = PetRarityEnum.selectByOrdinal(_loc2_).value;
         _loc1_.nextRarityLevel = PetRarityEnum.selectByOrdinal(_loc3_).value;
         _loc1_.famePrice = this.petModel.getPetYardUpgradeFamePrice();
         _loc1_.goldPrice = this.petModel.getPetYardUpgradeGoldPrice();
         this.view.init(_loc1_);
         this.view.famePurchase.add(this.onFamePurchase);
         this.view.goldPurchase.add(this.onGoldPurchase);
      }
      
      private function onGoldPurchase(param1:int) : void
      {
         this.purchaseUpgrade(0);
      }
      
      private function onFamePurchase(param1:int) : void
      {
         this.purchaseUpgrade(1);
      }
      
      private function purchaseUpgrade(param1:uint) : void
      {
         var _loc2_:int = this.petModel.getPetYardObjectID();
         var _loc3_:UpgradePetYardRequestVO = new UpgradePetYardRequestVO(_loc2_,param1);
         this.closeDialog.dispatch();
         this.upgradePet.dispatch(_loc3_);
      }
   }
}

