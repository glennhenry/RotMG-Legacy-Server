package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   import com.company.assembleegameclient.ui.tooltip.TooltipHelper;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
   
   public class GeneralProjectileComparison extends SlotComparison
   {
      
      private var itemXML:XML;
      
      private var curItemXML:XML;
      
      private var projXML:XML;
      
      private var otherProjXML:XML;
      
      public function GeneralProjectileComparison()
      {
         super();
      }
      
      override protected function compareSlots(param1:XML, param2:XML) : void
      {
         this.itemXML = param1;
         this.curItemXML = param2;
         comparisonStringBuilder = new AppendingLineBuilder();
         if(param1.hasOwnProperty("NumProjectiles"))
         {
            this.addNumProjectileText();
            processedTags[param1.NumProjectiles.toXMLString()] = true;
         }
         if(param1.hasOwnProperty("Projectile"))
         {
            this.addProjectileText();
            processedTags[param1.Projectile.toXMLString()] = true;
         }
         this.buildRateOfFireText();
      }
      
      private function addProjectileText() : void
      {
         this.addDamageText();
         var _loc1_:Number = Number(this.projXML.Speed) * Number(this.projXML.LifetimeMS) / 10000;
         var _loc2_:Number = Number(this.otherProjXML.Speed) * Number(this.otherProjXML.LifetimeMS) / 10000;
         var _loc3_:String = TooltipHelper.getFormattedRangeString(_loc1_);
         comparisonStringBuilder.pushParams(TextKey.RANGE,{"range":wrapInColoredFont(_loc3_,getTextColor(_loc1_ - _loc2_))});
         if(this.projXML.hasOwnProperty("MultiHit"))
         {
            comparisonStringBuilder.pushParams(TextKey.MULTIHIT,{},TooltipHelper.getOpenTag(NO_DIFF_COLOR),TooltipHelper.getCloseTag());
         }
         if(this.projXML.hasOwnProperty("PassesCover"))
         {
            comparisonStringBuilder.pushParams(TextKey.PASSES_COVER,{},TooltipHelper.getOpenTag(NO_DIFF_COLOR),TooltipHelper.getCloseTag());
         }
         if(this.projXML.hasOwnProperty("ArmorPiercing"))
         {
            comparisonStringBuilder.pushParams(TextKey.ARMOR_PIERCING,{},TooltipHelper.getOpenTag(NO_DIFF_COLOR),TooltipHelper.getCloseTag());
         }
      }
      
      private function addNumProjectileText() : void
      {
         var _loc1_:int = int(this.itemXML.NumProjectiles);
         var _loc2_:int = int(this.curItemXML.NumProjectiles);
         var _loc3_:uint = getTextColor(_loc1_ - _loc2_);
         comparisonStringBuilder.pushParams(TextKey.SHOTS,{"numShots":wrapInColoredFont(_loc1_.toString(),_loc3_)});
      }
      
      private function addDamageText() : void
      {
         this.projXML = XML(this.itemXML.Projectile);
         var _loc1_:int = int(this.projXML.MinDamage);
         var _loc2_:int = int(this.projXML.MaxDamage);
         var _loc3_:Number = (_loc2_ + _loc1_) / 2;
         this.otherProjXML = XML(this.curItemXML.Projectile);
         var _loc4_:int = int(this.otherProjXML.MinDamage);
         var _loc5_:int = int(this.otherProjXML.MaxDamage);
         var _loc6_:Number = (_loc5_ + _loc4_) / 2;
         var _loc7_:String = (_loc1_ == _loc2_ ? _loc1_ : _loc1_ + " - " + _loc2_).toString();
         comparisonStringBuilder.pushParams(TextKey.DAMAGE,{"damage":wrapInColoredFont(_loc7_,getTextColor(_loc3_ - _loc6_))});
      }
      
      private function buildRateOfFireText() : void
      {
         if(this.itemXML.RateOfFire.length() == 0 || this.curItemXML.RateOfFire.length() == 0)
         {
            return;
         }
         var _loc1_:Number = Number(this.curItemXML.RateOfFire[0]);
         var _loc2_:Number = Number(this.itemXML.RateOfFire[0]);
         var _loc3_:int = int(_loc2_ / _loc1_ * 100);
         var _loc4_:int = _loc3_ - 100;
         if(_loc4_ == 0)
         {
            return;
         }
         var _loc5_:uint = getTextColor(_loc4_);
         var _loc6_:String = _loc4_.toString();
         if(_loc4_ > 0)
         {
            _loc6_ = "+" + _loc6_;
         }
         _loc6_ = wrapInColoredFont(_loc6_ + "%",_loc5_);
         comparisonStringBuilder.pushParams(TextKey.RATE_OF_FIRE,{"data":_loc6_});
         processedTags[this.itemXML.RateOfFire[0].toXMLString()];
      }
   }
}

