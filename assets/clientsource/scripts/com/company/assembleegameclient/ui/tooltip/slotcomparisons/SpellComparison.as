package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StringBuilder;
   
   public class SpellComparison extends SlotComparison
   {
      
      private var itemXML:XML;
      
      private var curItemXML:XML;
      
      private var projXML:XML;
      
      private var otherProjXML:XML;
      
      public function SpellComparison()
      {
         super();
         comparisonStringBuilder = new AppendingLineBuilder();
      }
      
      override protected function compareSlots(param1:XML, param2:XML) : void
      {
         this.itemXML = param1;
         this.curItemXML = param2;
         this.projXML = param1.Projectile[0];
         this.otherProjXML = param2.Projectile[0];
         this.getDamageText();
         this.getRangeText();
         processedTags[this.projXML.toXMLString()] = true;
      }
      
      private function getDamageText() : StringBuilder
      {
         var _loc1_:int = int(this.projXML.MinDamage);
         var _loc2_:int = int(this.projXML.MaxDamage);
         var _loc3_:int = int(this.otherProjXML.MinDamage);
         var _loc4_:int = int(this.otherProjXML.MaxDamage);
         var _loc5_:Number = (_loc1_ + _loc2_) / 2;
         var _loc6_:Number = (_loc3_ + _loc4_) / 2;
         var _loc7_:uint = getTextColor(_loc5_ - _loc6_);
         var _loc8_:String = _loc1_ == _loc2_ ? _loc2_.toString() : _loc1_ + " - " + _loc2_;
         return comparisonStringBuilder.pushParams(TextKey.DAMAGE,{"damage":"<font color=\"#" + _loc7_.toString(16) + "\">" + _loc8_ + "</font>"});
      }
      
      private function getRangeText() : StringBuilder
      {
         var _loc1_:Number = Number(this.projXML.Speed) * Number(this.projXML.LifetimeMS) / 10000;
         var _loc2_:Number = Number(this.otherProjXML.Speed) * Number(this.otherProjXML.LifetimeMS) / 10000;
         var _loc3_:uint = getTextColor(_loc1_ - _loc2_);
         return comparisonStringBuilder.pushParams(TextKey.RANGE,{"range":"<font color=\"#" + _loc3_.toString(16) + "\">" + _loc1_ + "</font>"});
      }
   }
}

