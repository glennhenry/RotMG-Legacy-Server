package kabam.rotmg.game.model
{
   import flash.utils.Dictionary;
   import kabam.rotmg.ui.model.PotionModel;
   import org.osflash.signals.Signal;
   
   public class PotionInventoryModel
   {
      
      public static const HEALTH_POTION_ID:int = 2594;
      
      public static const HEALTH_POTION_SLOT:int = 254;
      
      public static const MAGIC_POTION_ID:int = 2595;
      
      public static const MAGIC_POTION_SLOT:int = 255;
      
      public var potionModels:Dictionary;
      
      public var updatePosition:Signal;
      
      public function PotionInventoryModel()
      {
         super();
         this.potionModels = new Dictionary();
         this.updatePosition = new Signal(int);
      }
      
      public static function getPotionSlot(param1:int) : int
      {
         switch(param1)
         {
            case HEALTH_POTION_ID:
               return HEALTH_POTION_SLOT;
            case MAGIC_POTION_ID:
               return MAGIC_POTION_SLOT;
            default:
               return -1;
         }
      }
      
      public function initializePotionModels(param1:XML) : void
      {
         var _loc6_:int = 0;
         var _loc7_:PotionModel = null;
         var _loc2_:int = int(param1.PotionPurchaseCooldown);
         var _loc3_:int = int(param1.PotionPurchaseCostCooldown);
         var _loc4_:int = int(param1.MaxStackablePotions);
         var _loc5_:Array = new Array();
         for each(_loc6_ in param1.PotionPurchaseCosts.cost)
         {
            _loc5_.push(_loc6_);
         }
         _loc7_ = new PotionModel();
         _loc7_.purchaseCooldownMillis = _loc2_;
         _loc7_.priceCooldownMillis = _loc3_;
         _loc7_.maxPotionCount = _loc4_;
         _loc7_.objectId = HEALTH_POTION_ID;
         _loc7_.position = 0;
         _loc7_.costs = _loc5_;
         this.potionModels[_loc7_.position] = _loc7_;
         _loc7_.update.add(this.update);
         _loc7_ = new PotionModel();
         _loc7_.purchaseCooldownMillis = _loc2_;
         _loc7_.priceCooldownMillis = _loc3_;
         _loc7_.maxPotionCount = _loc4_;
         _loc7_.objectId = MAGIC_POTION_ID;
         _loc7_.position = 1;
         _loc7_.costs = _loc5_;
         this.potionModels[_loc7_.position] = _loc7_;
         _loc7_.update.add(this.update);
      }
      
      public function getPotionModel(param1:uint) : PotionModel
      {
         var _loc2_:String = null;
         for(_loc2_ in this.potionModels)
         {
            if(this.potionModels[_loc2_].objectId == param1)
            {
               return this.potionModels[_loc2_];
            }
         }
         return null;
      }
      
      private function update(param1:int) : void
      {
         this.updatePosition.dispatch(param1);
      }
   }
}

