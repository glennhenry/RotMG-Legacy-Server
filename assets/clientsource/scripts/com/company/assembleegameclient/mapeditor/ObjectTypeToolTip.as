package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import com.company.ui.BaseSimpleText;
   import flash.filters.DropShadowFilter;
   
   public class ObjectTypeToolTip extends ToolTip
   {
      
      private static const MAX_WIDTH:int = 180;
      
      private var titleText_:BaseSimpleText;
      
      private var descText_:BaseSimpleText;
      
      public function ObjectTypeToolTip(param1:XML)
      {
         var _loc3_:XML = null;
         super(3552822,1,10197915,1,true);
         this.titleText_ = new BaseSimpleText(16,16777215,false,MAX_WIDTH - 4,0);
         this.titleText_.setBold(true);
         this.titleText_.wordWrap = true;
         this.titleText_.text = String(param1.@id);
         this.titleText_.useTextDimensions();
         this.titleText_.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         this.titleText_.x = 0;
         this.titleText_.y = 0;
         addChild(this.titleText_);
         var _loc2_:String = "";
         if(param1.hasOwnProperty("Group"))
         {
            _loc2_ += "Group: " + param1.Group + "\n";
         }
         if(param1.hasOwnProperty("Static"))
         {
            _loc2_ += "Static\n";
         }
         if(param1.hasOwnProperty("Enemy"))
         {
            _loc2_ += "Enemy\n";
            if(param1.hasOwnProperty("MaxHitPoints"))
            {
               _loc2_ += "MaxHitPoints: " + param1.MaxHitPoints + "\n";
            }
            if(param1.hasOwnProperty("Defense"))
            {
               _loc2_ += "Defense: " + param1.Defense + "\n";
            }
         }
         if(param1.hasOwnProperty("God"))
         {
            _loc2_ += "God\n";
         }
         if(param1.hasOwnProperty("Quest"))
         {
            _loc2_ += "Quest\n";
         }
         if(param1.hasOwnProperty("Hero"))
         {
            _loc2_ += "Hero\n";
         }
         if(param1.hasOwnProperty("Encounter"))
         {
            _loc2_ += "Encounter\n";
         }
         if(param1.hasOwnProperty("Level"))
         {
            _loc2_ += "Level: " + param1.Level + "\n";
         }
         if(param1.hasOwnProperty("Terrain"))
         {
            _loc2_ += "Terrain: " + param1.Terrain + "\n";
         }
         for each(_loc3_ in param1.Projectile)
         {
            _loc2_ += "Projectile " + _loc3_.@id + ": " + _loc3_.ObjectId + "\n" + "\tDamage: " + _loc3_.Damage + "\n" + "\tSpeed: " + _loc3_.Speed + "\n";
            if(_loc3_.hasOwnProperty("PassesCover"))
            {
               _loc2_ += "\tPassesCover\n";
            }
            if(_loc3_.hasOwnProperty("MultiHit"))
            {
               _loc2_ += "\tMultiHit\n";
            }
            if(_loc3_.hasOwnProperty("ConditionEffect"))
            {
               _loc2_ += "\t" + _loc3_.ConditionEffect + " for " + _loc3_.ConditionEffect.@duration + " secs\n";
            }
            if(_loc3_.hasOwnProperty("Parametric"))
            {
               _loc2_ += "\tParametric\n";
            }
         }
         this.descText_ = new BaseSimpleText(14,11776947,false,MAX_WIDTH,0);
         this.descText_.wordWrap = true;
         this.descText_.text = String(_loc2_);
         this.descText_.useTextDimensions();
         this.descText_.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         this.descText_.x = 0;
         this.descText_.y = this.titleText_.height + 2;
         addChild(this.descText_);
      }
   }
}

