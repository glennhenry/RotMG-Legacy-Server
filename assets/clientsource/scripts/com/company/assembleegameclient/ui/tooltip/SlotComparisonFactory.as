package com.company.assembleegameclient.ui.tooltip
{
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.CloakComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.GeneralProjectileComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.GenericArmorComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.HelmetComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.OrbComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.PoisonComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.PrismComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.QuiverComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.ScepterComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.SealComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.ShieldComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.SkullComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.SlotComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.SpellComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.TomeComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.TrapComparison;
   import kabam.rotmg.constants.ItemConstants;
   
   public class SlotComparisonFactory
   {
      
      private var hash:Object;
      
      public function SlotComparisonFactory()
      {
         super();
         var _loc1_:GeneralProjectileComparison = new GeneralProjectileComparison();
         var _loc2_:GenericArmorComparison = new GenericArmorComparison();
         this.hash = {};
         this.hash[ItemConstants.SWORD_TYPE] = _loc1_;
         this.hash[ItemConstants.DAGGER_TYPE] = _loc1_;
         this.hash[ItemConstants.BOW_TYPE] = _loc1_;
         this.hash[ItemConstants.TOME_TYPE] = new TomeComparison();
         this.hash[ItemConstants.SHIELD_TYPE] = new ShieldComparison();
         this.hash[ItemConstants.LEATHER_TYPE] = _loc2_;
         this.hash[ItemConstants.PLATE_TYPE] = _loc2_;
         this.hash[ItemConstants.WAND_TYPE] = _loc1_;
         this.hash[ItemConstants.SPELL_TYPE] = new SpellComparison();
         this.hash[ItemConstants.SEAL_TYPE] = new SealComparison();
         this.hash[ItemConstants.CLOAK_TYPE] = new CloakComparison();
         this.hash[ItemConstants.ROBE_TYPE] = _loc2_;
         this.hash[ItemConstants.QUIVER_TYPE] = new QuiverComparison();
         this.hash[ItemConstants.HELM_TYPE] = new HelmetComparison();
         this.hash[ItemConstants.STAFF_TYPE] = _loc1_;
         this.hash[ItemConstants.POISON_TYPE] = new PoisonComparison();
         this.hash[ItemConstants.SKULL_TYPE] = new SkullComparison();
         this.hash[ItemConstants.TRAP_TYPE] = new TrapComparison();
         this.hash[ItemConstants.ORB_TYPE] = new OrbComparison();
         this.hash[ItemConstants.PRISM_TYPE] = new PrismComparison();
         this.hash[ItemConstants.SCEPTER_TYPE] = new ScepterComparison();
         this.hash[ItemConstants.KATANA_TYPE] = _loc1_;
         this.hash[ItemConstants.SHURIKEN_TYPE] = _loc1_;
      }
      
      public function getComparisonResults(param1:XML, param2:XML) : SlotComparisonResult
      {
         var _loc3_:int = int(param1.SlotType);
         var _loc4_:SlotComparison = this.hash[_loc3_];
         var _loc5_:SlotComparisonResult = new SlotComparisonResult();
         if(_loc4_ != null)
         {
            _loc4_.compare(param1,param2);
            _loc5_.lineBuilder = _loc4_.comparisonStringBuilder;
            _loc5_.processedTags = _loc4_.processedTags;
         }
         return _loc5_;
      }
   }
}

