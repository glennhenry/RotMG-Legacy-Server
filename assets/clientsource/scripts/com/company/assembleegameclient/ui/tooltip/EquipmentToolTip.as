package com.company.assembleegameclient.ui.tooltip
{
   import com.company.assembleegameclient.constants.InventoryOwnerTypes;
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.LineBreakDesign;
   import com.company.util.BitmapUtil;
   import com.company.util.KeyCodes;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.constants.*;
   import kabam.rotmg.messaging.impl.data.StatData;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   import kabam.rotmg.text.view.stringBuilder.StringBuilder;
   
   public class EquipmentToolTip extends ToolTip
   {
      
      private static const MAX_WIDTH:int = 230;
      
      private var icon:Bitmap;
      
      public var titleText:TextFieldDisplayConcrete;
      
      private var tierText:TextFieldDisplayConcrete;
      
      private var descText:TextFieldDisplayConcrete;
      
      private var line1:LineBreakDesign;
      
      private var effectsText:TextFieldDisplayConcrete;
      
      private var line2:LineBreakDesign;
      
      private var restrictionsText:TextFieldDisplayConcrete;
      
      private var player:Player;
      
      private var isEquippable:Boolean = false;
      
      private var objectType:int;
      
      private var curItemXML:XML = null;
      
      private var objectXML:XML = null;
      
      private var slotTypeToTextBuilder:SlotComparisonFactory;
      
      private var restrictions:Vector.<Restriction>;
      
      private var effects:Vector.<Effect>;
      
      private var uniqueEffects:Vector.<Effect> = new Vector.<Effect>();
      
      private var itemSlotTypeId:int;
      
      private var invType:int;
      
      private var inventorySlotID:uint;
      
      private var inventoryOwnerType:String;
      
      private var isInventoryFull:Boolean;
      
      private var playerCanUse:Boolean;
      
      private var comparisonResults:SlotComparisonResult;
      
      private var powerText:TextFieldDisplayConcrete;
      
      public function EquipmentToolTip(param1:int, param2:Player, param3:int, param4:String)
      {
         this.objectType = param1;
         this.player = param2;
         this.invType = param3;
         this.inventoryOwnerType = param4;
         this.isInventoryFull = param2 ? param2.isInventoryFull() : false;
         this.playerCanUse = param2 ? ObjectLibrary.isUsableByPlayer(param1,param2) : false;
         var _loc5_:int = param2 ? ObjectLibrary.getMatchingSlotIndex(param1,param2) : -1;
         var _loc6_:uint = this.playerCanUse || this.player == null ? 3552822 : 6036765;
         var _loc7_:uint = this.playerCanUse || param2 == null ? 10197915 : 10965039;
         super(_loc6_,1,_loc7_,1,true);
         this.slotTypeToTextBuilder = new SlotComparisonFactory();
         this.objectXML = ObjectLibrary.xmlLibrary_[param1];
         this.isEquippable = _loc5_ != -1;
         this.effects = new Vector.<Effect>();
         this.itemSlotTypeId = int(this.objectXML.SlotType);
         if(this.player == null)
         {
            this.curItemXML = this.objectXML;
         }
         else if(this.isEquippable)
         {
            if(this.player.equipment_[_loc5_] != -1)
            {
               this.curItemXML = ObjectLibrary.xmlLibrary_[this.player.equipment_[_loc5_]];
            }
         }
         this.addIcon();
         this.addTitle();
         this.addTierText();
         this.addDescriptionText();
         this.handleWisMod();
         this.buildCategorySpecificText();
         this.addUniqueEffectsToList();
         this.addNumProjectilesTagsToEffectsList();
         this.addProjectileTagsToEffectsList();
         this.addActivateTagsToEffectsList();
         this.addActivateOnEquipTagsToEffectsList();
         this.addDoseTagsToEffectsList();
         this.addMpCostTagToEffectsList();
         this.addFameBonusTagToEffectsList();
         this.makeEffectsList();
         this.makeLineTwo();
         this.makeRestrictionList();
         this.makeRestrictionText();
         this.makeItemPowerText();
      }
      
      private function makeItemPowerText() : void
      {
         var _loc1_:int = 0;
         if(this.objectXML.hasOwnProperty("feedPower"))
         {
            _loc1_ = this.playerCanUse || this.player == null ? 16777215 : 16549442;
            this.powerText = new TextFieldDisplayConcrete().setSize(12).setColor(_loc1_).setBold(true).setTextWidth(MAX_WIDTH - this.icon.width - 4 - 30).setWordWrap(true);
            this.powerText.setStringBuilder(new StaticStringBuilder().setString("Feed Power: " + this.objectXML.feedPower));
            this.powerText.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
            waiter.push(this.powerText.textChanged);
            addChild(this.powerText);
         }
      }
      
      private function addUniqueEffectsToList() : void
      {
         var _loc1_:XMLList = null;
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:AppendingLineBuilder = null;
         if(this.objectXML.hasOwnProperty("ExtraTooltipData"))
         {
            _loc1_ = this.objectXML.ExtraTooltipData.EffectInfo;
            for each(_loc2_ in _loc1_)
            {
               _loc3_ = _loc2_.attribute("name");
               _loc4_ = _loc2_.attribute("description");
               _loc5_ = Boolean(_loc3_) && Boolean(_loc4_) ? ": " : "\n";
               _loc6_ = new AppendingLineBuilder();
               if(_loc3_)
               {
                  _loc6_.pushParams(_loc3_);
               }
               if(_loc4_)
               {
                  _loc6_.pushParams(_loc4_,{},TooltipHelper.getOpenTag(16777103),TooltipHelper.getCloseTag());
               }
               _loc6_.setDelimiter(_loc5_);
               this.uniqueEffects.push(new Effect(TextKey.BLANK,{"data":_loc6_}));
            }
         }
      }
      
      private function isEmptyEquipSlot() : Boolean
      {
         return this.isEquippable && this.curItemXML == null;
      }
      
      private function addIcon() : void
      {
         var _loc1_:XML = ObjectLibrary.xmlLibrary_[this.objectType];
         var _loc2_:int = 5;
         if(this.objectType == 4874 || this.objectType == 4618)
         {
            _loc2_ = 8;
         }
         if(_loc1_.hasOwnProperty("ScaleValue"))
         {
            _loc2_ = int(_loc1_.ScaleValue);
         }
         var _loc3_:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this.objectType,60,true,true,_loc2_);
         _loc3_ = BitmapUtil.cropToBitmapData(_loc3_,4,4,_loc3_.width - 8,_loc3_.height - 8);
         this.icon = new Bitmap(_loc3_);
         addChild(this.icon);
      }
      
      private function addTierText() : void
      {
         var _loc1_:Boolean = this.isPet() == false;
         var _loc2_:Boolean = this.objectXML.hasOwnProperty("Consumable") == false;
         var _loc3_:Boolean = this.objectXML.hasOwnProperty("Treasure") == false;
         var _loc4_:Boolean = this.objectXML.hasOwnProperty("Tier");
         if(_loc1_ && _loc2_ && _loc3_)
         {
            this.tierText = new TextFieldDisplayConcrete().setSize(16).setColor(16777215).setTextWidth(30).setBold(true);
            if(_loc4_)
            {
               this.tierText.setStringBuilder(new LineBuilder().setParams(TextKey.TIER_ABBR,{"tier":this.objectXML.Tier}));
            }
            else if(this.objectXML.hasOwnProperty("@setType"))
            {
               this.tierText.setColor(16750848);
               this.tierText.setStringBuilder(new StaticStringBuilder("ST"));
            }
            else
            {
               this.tierText.setColor(9055202);
               this.tierText.setStringBuilder(new LineBuilder().setParams(TextKey.UNTIERED_ABBR));
            }
            addChild(this.tierText);
         }
      }
      
      private function isPet() : Boolean
      {
         var activateTags:XMLList = null;
         activateTags = this.objectXML.Activate.(text() == "PermaPet");
         return activateTags.length() >= 1;
      }
      
      private function addTitle() : void
      {
         var _loc1_:int = this.playerCanUse || this.player == null ? 16777215 : 16549442;
         this.titleText = new TextFieldDisplayConcrete().setSize(16).setColor(_loc1_).setBold(true).setTextWidth(MAX_WIDTH - this.icon.width - 4 - 30).setWordWrap(true);
         this.titleText.setStringBuilder(new LineBuilder().setParams(ObjectLibrary.typeToDisplayId_[this.objectType]));
         this.titleText.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         waiter.push(this.titleText.textChanged);
         addChild(this.titleText);
      }
      
      private function buildUniqueTooltipData() : String
      {
         var _loc1_:XMLList = null;
         var _loc2_:Vector.<Effect> = null;
         var _loc3_:XML = null;
         if(this.objectXML.hasOwnProperty("ExtraTooltipData"))
         {
            _loc1_ = this.objectXML.ExtraTooltipData.EffectInfo;
            _loc2_ = new Vector.<Effect>();
            for each(_loc3_ in _loc1_)
            {
               _loc2_.push(new Effect(_loc3_.attribute("name"),_loc3_.attribute("description")));
            }
         }
         return "";
      }
      
      private function makeEffectsList() : void
      {
         var _loc1_:AppendingLineBuilder = null;
         if(this.effects.length != 0 || this.comparisonResults.lineBuilder != null || this.objectXML.hasOwnProperty("ExtraTooltipData"))
         {
            this.line1 = new LineBreakDesign(MAX_WIDTH - 12,0);
            this.effectsText = new TextFieldDisplayConcrete().setSize(14).setColor(11776947).setTextWidth(MAX_WIDTH).setWordWrap(true).setHTML(true);
            _loc1_ = this.getEffectsStringBuilder();
            this.effectsText.setStringBuilder(_loc1_);
            this.effectsText.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
            if(_loc1_.hasLines())
            {
               addChild(this.line1);
               addChild(this.effectsText);
            }
         }
      }
      
      private function getEffectsStringBuilder() : AppendingLineBuilder
      {
         var _loc1_:AppendingLineBuilder = new AppendingLineBuilder();
         this.appendEffects(this.uniqueEffects,_loc1_);
         if(this.comparisonResults.lineBuilder.hasLines())
         {
            _loc1_.pushParams(TextKey.BLANK,{"data":this.comparisonResults.lineBuilder});
         }
         this.appendEffects(this.effects,_loc1_);
         return _loc1_;
      }
      
      private function appendEffects(param1:Vector.<Effect>, param2:AppendingLineBuilder) : void
      {
         var _loc3_:Effect = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         for each(_loc3_ in param1)
         {
            _loc4_ = "";
            _loc5_ = "";
            if(_loc3_.color_)
            {
               _loc4_ = "<font color=\"#" + _loc3_.color_.toString(16) + "\">";
               _loc5_ = "</font>";
            }
            param2.pushParams(_loc3_.name_,_loc3_.getValueReplacementsWithColor(),_loc4_,_loc5_);
         }
      }
      
      private function addNumProjectilesTagsToEffectsList() : void
      {
         if(this.objectXML.hasOwnProperty("NumProjectiles") && this.comparisonResults.processedTags.hasOwnProperty(this.objectXML.NumProjectiles.toXMLString()) != true)
         {
            this.effects.push(new Effect(TextKey.SHOTS,{"numShots":this.objectXML.NumProjectiles}));
         }
      }
      
      private function addFameBonusTagToEffectsList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         if(this.objectXML.hasOwnProperty("FameBonus"))
         {
            _loc1_ = int(this.objectXML.FameBonus);
            _loc2_ = this.playerCanUse ? TooltipHelper.BETTER_COLOR : TooltipHelper.NO_DIFF_COLOR;
            if(this.curItemXML != null && this.curItemXML.hasOwnProperty("FameBonus"))
            {
               _loc3_ = int(this.curItemXML.FameBonus.text());
               _loc2_ = TooltipHelper.getTextColor(_loc1_ - _loc3_);
            }
            this.effects.push(new Effect(TextKey.FAME_BONUS,{"percent":this.objectXML.FameBonus + "%"}).setReplacementsColor(_loc2_));
         }
      }
      
      private function addMpCostTagToEffectsList() : void
      {
         if(this.objectXML.hasOwnProperty("MpEndCost"))
         {
            if(!this.comparisonResults.processedTags[this.objectXML.MpEndCost[0].toXMLString()])
            {
               this.effects.push(new Effect(TextKey.MP_COST,{"cost":this.objectXML.MpEndCost}));
            }
         }
         else if(this.objectXML.hasOwnProperty("MpCost") && !this.comparisonResults.processedTags[this.objectXML.MpCost[0].toXMLString()])
         {
            if(!this.comparisonResults.processedTags[this.objectXML.MpCost[0].toXMLString()])
            {
               this.effects.push(new Effect(TextKey.MP_COST,{"cost":this.objectXML.MpCost}));
            }
         }
      }
      
      private function addDoseTagsToEffectsList() : void
      {
         if(this.objectXML.hasOwnProperty("Doses"))
         {
            this.effects.push(new Effect(TextKey.DOSES,{"dose":this.objectXML.Doses}));
         }
      }
      
      private function addProjectileTagsToEffectsList() : void
      {
         var _loc1_:XML = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:XML = null;
         if(this.objectXML.hasOwnProperty("Projectile") && !this.comparisonResults.processedTags.hasOwnProperty(this.objectXML.Projectile.toXMLString()))
         {
            _loc1_ = XML(this.objectXML.Projectile);
            _loc2_ = int(_loc1_.MinDamage);
            _loc3_ = int(_loc1_.MaxDamage);
            this.effects.push(new Effect(TextKey.DAMAGE,{"damage":(_loc2_ == _loc3_ ? _loc2_ : _loc2_ + " - " + _loc3_).toString()}));
            _loc4_ = Number(_loc1_.Speed) * Number(_loc1_.LifetimeMS) / 10000;
            this.effects.push(new Effect(TextKey.RANGE,{"range":TooltipHelper.getFormattedRangeString(_loc4_)}));
            if(this.objectXML.Projectile.hasOwnProperty("MultiHit"))
            {
               this.effects.push(new Effect(TextKey.MULTIHIT,{}).setColor(TooltipHelper.NO_DIFF_COLOR));
            }
            if(this.objectXML.Projectile.hasOwnProperty("PassesCover"))
            {
               this.effects.push(new Effect(TextKey.PASSES_COVER,{}).setColor(TooltipHelper.NO_DIFF_COLOR));
            }
            if(this.objectXML.Projectile.hasOwnProperty("ArmorPiercing"))
            {
               this.effects.push(new Effect(TextKey.ARMOR_PIERCING,{}).setColor(TooltipHelper.NO_DIFF_COLOR));
            }
            for each(_loc5_ in _loc1_.ConditionEffect)
            {
               if(this.comparisonResults.processedTags[_loc5_.toXMLString()] == null)
               {
                  this.effects.push(new Effect(TextKey.SHOT_EFFECT,{"effect":""}));
                  this.effects.push(new Effect(TextKey.EFFECT_FOR_DURATION,{
                     "effect":this.objectXML.Projectile.ConditionEffect,
                     "duration":this.objectXML.Projectile.ConditionEffect.@duration
                  }).setColor(TooltipHelper.NO_DIFF_COLOR));
               }
            }
         }
      }
      
      private function addActivateTagsToEffectsList() : void
      {
         var _loc1_:XML = null;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc8_:String = null;
         var _loc9_:uint = 0;
         var _loc10_:XML = null;
         var _loc11_:Object = null;
         var _loc12_:String = null;
         var _loc13_:uint = 0;
         var _loc14_:XML = null;
         var _loc15_:String = null;
         var _loc16_:Object = null;
         var _loc17_:String = null;
         var _loc18_:Object = null;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:AppendingLineBuilder = null;
         for each(_loc1_ in this.objectXML.Activate)
         {
            _loc5_ = this.comparisonResults.processedTags[_loc1_.toXMLString()];
            if(this.comparisonResults.processedTags[_loc1_.toXMLString()] == true)
            {
               continue;
            }
            _loc6_ = _loc1_.toString();
            switch(_loc6_)
            {
               case ActivationType.COND_EFFECT_AURA:
                  this.effects.push(new Effect(TextKey.PARTY_EFFECT,{"effect":new AppendingLineBuilder().pushParams(TextKey.WITHIN_SQRS,{"range":_loc1_.@range},TooltipHelper.getOpenTag(TooltipHelper.NO_DIFF_COLOR),TooltipHelper.getCloseTag())}));
                  this.effects.push(new Effect(TextKey.EFFECT_FOR_DURATION,{
                     "effect":_loc1_.@effect,
                     "duration":_loc1_.@duration
                  }).setColor(TooltipHelper.NO_DIFF_COLOR));
                  break;
               case ActivationType.COND_EFFECT_SELF:
                  this.effects.push(new Effect(TextKey.EFFECT_ON_SELF,{"effect":""}));
                  this.effects.push(new Effect(TextKey.EFFECT_FOR_DURATION,{
                     "effect":_loc1_.@effect,
                     "duration":_loc1_.@duration
                  }));
                  break;
               case ActivationType.HEAL:
                  this.effects.push(new Effect(TextKey.INCREMENT_STAT,{
                     "statAmount":"+" + _loc1_.@amount + " ",
                     "statName":new LineBuilder().setParams(TextKey.STATUS_BAR_HEALTH_POINTS)
                  }));
                  break;
               case ActivationType.HEAL_NOVA:
                  this.effects.push(new Effect(TextKey.PARTY_HEAL,{"effect":new AppendingLineBuilder().pushParams(TextKey.HP_WITHIN_SQRS,{
                     "amount":_loc1_.@amount,
                     "range":_loc1_.@range
                  },TooltipHelper.getOpenTag(TooltipHelper.NO_DIFF_COLOR),TooltipHelper.getCloseTag())}));
                  break;
               case ActivationType.MAGIC:
                  this.effects.push(new Effect(TextKey.INCREMENT_STAT,{
                     "statAmount":"+" + _loc1_.@amount + " ",
                     "statName":new LineBuilder().setParams(TextKey.STATUS_BAR_MANA_POINTS)
                  }));
                  break;
               case ActivationType.MAGIC_NOVA:
                  this.effects.push(new Effect(TextKey.FILL_PARTY_MAGIC,_loc1_.@amount + " MP at " + _loc1_.@range + " sqrs"));
                  break;
               case ActivationType.TELEPORT:
                  this.effects.push(new Effect(TextKey.BLANK,{"data":new LineBuilder().setParams(TextKey.TELEPORT_TO_TARGET)}));
                  break;
               case ActivationType.VAMPIRE_BLAST:
                  this.effects.push(new Effect(TextKey.STEAL,{"effect":new AppendingLineBuilder().pushParams(TextKey.HP_WITHIN_SQRS,{
                     "amount":_loc1_.@totalDamage,
                     "range":_loc1_.@radius
                  },TooltipHelper.getOpenTag(TooltipHelper.NO_DIFF_COLOR),TooltipHelper.getCloseTag())}));
                  break;
               case ActivationType.TRAP:
                  _loc7_ = _loc1_.hasOwnProperty("@condEffect") ? _loc1_.@condEffect : new LineBuilder().setParams(TextKey.CONDITION_EFFECT_SLOWED);
                  _loc8_ = _loc1_.hasOwnProperty("@condDuration") ? _loc1_.@condDuration : "5";
                  this.effects.push(new Effect(TextKey.TRAP,{"data":new AppendingLineBuilder().pushParams(TextKey.HP_WITHIN_SQRS,{
                     "amount":_loc1_.@totalDamage,
                     "range":_loc1_.@radius
                  },TooltipHelper.getOpenTag(TooltipHelper.NO_DIFF_COLOR),TooltipHelper.getCloseTag()).pushParams(TextKey.EFFECT_FOR_DURATION,{
                     "effect":_loc7_,
                     "duration":_loc8_
                  },TooltipHelper.getOpenTag(TooltipHelper.NO_DIFF_COLOR),TooltipHelper.getCloseTag())}));
                  break;
               case ActivationType.STASIS_BLAST:
                  this.effects.push(new Effect(TextKey.STASIS_GROUP,{"stasis":new AppendingLineBuilder().pushParams(TextKey.SEC_COUNT,{"duration":_loc1_.@duration},TooltipHelper.getOpenTag(TooltipHelper.NO_DIFF_COLOR),TooltipHelper.getCloseTag())}));
                  break;
               case ActivationType.DECOY:
                  this.effects.push(new Effect(TextKey.DECOY,{"data":new AppendingLineBuilder().pushParams(TextKey.SEC_COUNT,{"duration":_loc1_.@duration},TooltipHelper.getOpenTag(TooltipHelper.NO_DIFF_COLOR),TooltipHelper.getCloseTag())}));
                  break;
               case ActivationType.LIGHTNING:
                  this.effects.push(new Effect(TextKey.LIGHTNING,{"data":new AppendingLineBuilder().pushParams(TextKey.DAMAGE_TO_TARGETS,{
                     "damage":_loc1_.@totalDamage,
                     "targets":_loc1_.@maxTargets
                  },TooltipHelper.getOpenTag(TooltipHelper.NO_DIFF_COLOR),TooltipHelper.getCloseTag())}));
                  break;
               case ActivationType.POISON_GRENADE:
                  this.effects.push(new Effect(TextKey.POISON_GRENADE,{"data":""}));
                  this.effects.push(new Effect(TextKey.POISON_GRENADE_DATA,{
                     "damage":_loc1_.@totalDamage,
                     "duration":_loc1_.@duration,
                     "radius":_loc1_.@radius
                  }).setColor(TooltipHelper.NO_DIFF_COLOR));
                  break;
               case ActivationType.REMOVE_NEG_COND:
                  this.effects.push(new Effect(TextKey.REMOVES_NEGATIVE,{}).setColor(TooltipHelper.NO_DIFF_COLOR));
                  break;
               case ActivationType.REMOVE_NEG_COND_SELF:
                  this.effects.push(new Effect(TextKey.REMOVES_NEGATIVE,{}).setColor(TooltipHelper.NO_DIFF_COLOR));
                  break;
               case ActivationType.GENERIC_ACTIVATE:
                  _loc9_ = 16777103;
                  if(this.curItemXML != null)
                  {
                     _loc10_ = this.getEffectTag(this.curItemXML,_loc1_.@effect);
                     if(_loc10_ != null)
                     {
                        _loc19_ = Number(_loc1_.@range);
                        _loc20_ = Number(_loc10_.@range);
                        _loc21_ = Number(_loc1_.@duration);
                        _loc22_ = Number(_loc10_.@duration);
                        _loc23_ = _loc19_ - _loc20_ + (_loc21_ - _loc22_);
                        if(_loc23_ > 0)
                        {
                           _loc9_ = 65280;
                        }
                        else if(_loc23_ < 0)
                        {
                           _loc9_ = 16711680;
                        }
                     }
                  }
                  _loc11_ = {
                     "range":_loc1_.@range,
                     "effect":_loc1_.@effect,
                     "duration":_loc1_.@duration
                  };
                  _loc12_ = "Within {range} sqrs {effect} for {duration} seconds";
                  if(_loc1_.@target != "enemy")
                  {
                     this.effects.push(new Effect(TextKey.PARTY_EFFECT,{"effect":LineBuilder.returnStringReplace(_loc12_,_loc11_)}).setReplacementsColor(_loc9_));
                  }
                  else
                  {
                     this.effects.push(new Effect(TextKey.ENEMY_EFFECT,{"effect":LineBuilder.returnStringReplace(_loc12_,_loc11_)}).setReplacementsColor(_loc9_));
                  }
                  break;
               case ActivationType.STAT_BOOST_AURA:
                  _loc13_ = 16777103;
                  if(this.curItemXML != null)
                  {
                     _loc14_ = this.getStatTag(this.curItemXML,_loc1_.@stat);
                     if(_loc14_ != null)
                     {
                        _loc24_ = Number(_loc1_.@range);
                        _loc25_ = Number(_loc14_.@range);
                        _loc26_ = Number(_loc1_.@duration);
                        _loc27_ = Number(_loc14_.@duration);
                        _loc28_ = Number(_loc1_.@amount);
                        _loc29_ = Number(_loc14_.@amount);
                        _loc30_ = _loc24_ - _loc25_ + (_loc26_ - _loc27_) + (_loc28_ - _loc29_);
                        if(_loc30_ > 0)
                        {
                           _loc13_ = 65280;
                        }
                        else if(_loc30_ < 0)
                        {
                           _loc13_ = 16711680;
                        }
                     }
                  }
                  _loc3_ = int(_loc1_.@stat);
                  _loc15_ = LineBuilder.getLocalizedString2(StatData.statToName(_loc3_));
                  _loc16_ = {
                     "range":_loc1_.@range,
                     "stat":_loc15_,
                     "amount":_loc1_.@amount,
                     "duration":_loc1_.@duration
                  };
                  _loc17_ = "Within {range} sqrs increase {stat} by {amount} for {duration} seconds";
                  this.effects.push(new Effect(TextKey.PARTY_EFFECT,{"effect":LineBuilder.returnStringReplace(_loc17_,_loc16_)}).setReplacementsColor(_loc13_));
                  break;
               case ActivationType.INCREMENT_STAT:
                  _loc3_ = int(_loc1_.@stat);
                  _loc4_ = int(_loc1_.@amount);
                  _loc18_ = {};
                  if(_loc3_ != StatData.HP_STAT && _loc3_ != StatData.MP_STAT)
                  {
                     _loc2_ = TextKey.PERMANENTLY_INCREASES;
                     _loc18_["statName"] = new LineBuilder().setParams(StatData.statToName(_loc3_));
                     this.effects.push(new Effect(_loc2_,_loc18_).setColor(16777103));
                  }
                  else
                  {
                     _loc2_ = TextKey.BLANK;
                     _loc31_ = new AppendingLineBuilder().setDelimiter(" ");
                     _loc31_.pushParams(TextKey.BLANK,{"data":new StaticStringBuilder("+" + _loc4_)});
                     _loc31_.pushParams(StatData.statToName(_loc3_));
                     _loc18_["data"] = _loc31_;
                     this.effects.push(new Effect(_loc2_,_loc18_));
                  }
            }
         }
      }
      
      private function getEffectTag(param1:XML, param2:String) : XML
      {
         var matches:XMLList = null;
         var tag:XML = null;
         var xml:XML = param1;
         var effectValue:String = param2;
         matches = xml.Activate.(text() == ActivationType.GENERIC_ACTIVATE);
         for each(tag in matches)
         {
            if(tag.@effect == effectValue)
            {
               return tag;
            }
         }
         return null;
      }
      
      private function getStatTag(param1:XML, param2:String) : XML
      {
         var matches:XMLList = null;
         var tag:XML = null;
         var xml:XML = param1;
         var statValue:String = param2;
         matches = xml.Activate.(text() == ActivationType.STAT_BOOST_AURA);
         for each(tag in matches)
         {
            if(tag.@stat == statValue)
            {
               return tag;
            }
         }
         return null;
      }
      
      private function addActivateOnEquipTagsToEffectsList() : void
      {
         var _loc1_:XML = null;
         var _loc2_:Boolean = true;
         for each(_loc1_ in this.objectXML.ActivateOnEquip)
         {
            if(_loc2_)
            {
               this.effects.push(new Effect(TextKey.ON_EQUIP,""));
               _loc2_ = false;
            }
            if(_loc1_.toString() == "IncrementStat")
            {
               this.effects.push(new Effect(TextKey.INCREMENT_STAT,this.getComparedStatText(_loc1_)).setReplacementsColor(this.getComparedStatColor(_loc1_)));
            }
         }
      }
      
      private function getComparedStatText(param1:XML) : Object
      {
         var _loc2_:int = int(param1.@stat);
         var _loc3_:int = int(param1.@amount);
         var _loc4_:String = _loc3_ > -1 ? "+" : "";
         return {
            "statAmount":_loc4_ + String(_loc3_) + " ",
            "statName":new LineBuilder().setParams(StatData.statToName(_loc2_))
         };
      }
      
      private function getComparedStatColor(param1:XML) : uint
      {
         var match:XML = null;
         var otherAmount:int = 0;
         var activateXML:XML = param1;
         var stat:int = int(activateXML.@stat);
         var amount:int = int(activateXML.@amount);
         var textColor:uint = this.playerCanUse ? TooltipHelper.BETTER_COLOR : TooltipHelper.NO_DIFF_COLOR;
         var otherMatches:XMLList = null;
         if(this.curItemXML != null)
         {
            otherMatches = this.curItemXML.ActivateOnEquip.(@stat == stat);
         }
         if(otherMatches != null && otherMatches.length() == 1)
         {
            match = XML(otherMatches[0]);
            otherAmount = int(match.@amount);
            textColor = TooltipHelper.getTextColor(amount - otherAmount);
         }
         if(amount < 0)
         {
            textColor = 16711680;
         }
         return textColor;
      }
      
      private function addEquipmentItemRestrictions() : void
      {
         if(this.objectXML.hasOwnProperty("Treasure") == false)
         {
            this.restrictions.push(new Restriction(TextKey.EQUIP_TO_USE,11776947,false));
            if(this.isInventoryFull || this.inventoryOwnerType == InventoryOwnerTypes.CURRENT_PLAYER)
            {
               this.restrictions.push(new Restriction(TextKey.DOUBLE_CLICK_EQUIP,11776947,false));
            }
            else
            {
               this.restrictions.push(new Restriction(TextKey.DOUBLE_CLICK_TAKE,11776947,false));
            }
         }
      }
      
      private function addAbilityItemRestrictions() : void
      {
         this.restrictions.push(new Restriction(TextKey.KEYCODE_TO_USE,16777215,false));
      }
      
      private function addConsumableItemRestrictions() : void
      {
         this.restrictions.push(new Restriction(TextKey.CONSUMED_WITH_USE,11776947,false));
         if(this.isInventoryFull || this.inventoryOwnerType == InventoryOwnerTypes.CURRENT_PLAYER)
         {
            this.restrictions.push(new Restriction(TextKey.DOUBLE_CLICK_OR_SHIFT_CLICK_TO_USE,16777215,false));
         }
         else
         {
            this.restrictions.push(new Restriction(TextKey.DOUBLE_CLICK_TAKE_SHIFT_CLICK_USE,16777215,false));
         }
      }
      
      private function addReusableItemRestrictions() : void
      {
         this.restrictions.push(new Restriction(TextKey.CAN_BE_USED_MULTIPLE_TIMES,11776947,false));
         this.restrictions.push(new Restriction(TextKey.DOUBLE_CLICK_OR_SHIFT_CLICK_TO_USE,16777215,false));
      }
      
      private function makeRestrictionList() : void
      {
         var _loc2_:XML = null;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         this.restrictions = new Vector.<Restriction>();
         if(Boolean(this.objectXML.hasOwnProperty("VaultItem")) && Boolean(this.invType != -1) && this.invType != ObjectLibrary.idToType_["Vault Chest"])
         {
            this.restrictions.push(new Restriction(TextKey.STORE_IN_VAULT,16549442,true));
         }
         if(this.objectXML.hasOwnProperty("Soulbound"))
         {
            this.restrictions.push(new Restriction(TextKey.ITEM_SOULBOUND,11776947,false));
         }
         if(this.objectXML.hasOwnProperty("@setType"))
         {
            this.restrictions.push(new Restriction("This item is a part of " + this.objectXML.attribute("setName"),16750848,false));
         }
         if(this.playerCanUse)
         {
            if(this.objectXML.hasOwnProperty("Usable"))
            {
               this.addAbilityItemRestrictions();
               this.addEquipmentItemRestrictions();
            }
            else if(this.objectXML.hasOwnProperty("Consumable"))
            {
               this.addConsumableItemRestrictions();
            }
            else if(this.objectXML.hasOwnProperty("InvUse"))
            {
               this.addReusableItemRestrictions();
            }
            else
            {
               this.addEquipmentItemRestrictions();
            }
         }
         else if(this.player != null)
         {
            this.restrictions.push(new Restriction(TextKey.NOT_USABLE_BY,16549442,true));
         }
         var _loc1_:Vector.<String> = ObjectLibrary.usableBy(this.objectType);
         if(_loc1_ != null)
         {
            this.restrictions.push(new Restriction(TextKey.USABLE_BY,11776947,false));
         }
         for each(_loc2_ in this.objectXML.EquipRequirement)
         {
            _loc3_ = ObjectLibrary.playerMeetsRequirement(_loc2_,this.player);
            if(_loc2_.toString() == "Stat")
            {
               _loc4_ = int(_loc2_.@stat);
               _loc5_ = int(_loc2_.@value);
               this.restrictions.push(new Restriction("Requires " + StatData.statToName(_loc4_) + " of " + _loc5_,_loc3_ ? 11776947 : 16549442,_loc3_ ? false : true));
            }
         }
      }
      
      private function makeLineTwo() : void
      {
         this.line2 = new LineBreakDesign(MAX_WIDTH - 12,0);
         addChild(this.line2);
      }
      
      private function makeRestrictionText() : void
      {
         if(this.restrictions.length != 0)
         {
            this.restrictionsText = new TextFieldDisplayConcrete().setSize(14).setColor(11776947).setTextWidth(MAX_WIDTH - 4).setIndent(-10).setLeftMargin(10).setWordWrap(true).setHTML(true);
            this.restrictionsText.setStringBuilder(this.buildRestrictionsLineBuilder());
            this.restrictionsText.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
            waiter.push(this.restrictionsText.textChanged);
            addChild(this.restrictionsText);
         }
      }
      
      private function buildRestrictionsLineBuilder() : StringBuilder
      {
         var _loc2_:Restriction = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc1_:AppendingLineBuilder = new AppendingLineBuilder();
         for each(_loc2_ in this.restrictions)
         {
            _loc3_ = _loc2_.bold_ ? "<b>" : "";
            _loc3_ = _loc3_.concat("<font color=\"#" + _loc2_.color_.toString(16) + "\">");
            _loc4_ = "</font>";
            _loc4_ = _loc4_.concat(_loc2_.bold_ ? "</b>" : "");
            _loc5_ = this.player ? ObjectLibrary.typeToDisplayId_[this.player.objectType_] : "";
            _loc1_.pushParams(_loc2_.text_,{
               "unUsableClass":_loc5_,
               "usableClasses":this.getUsableClasses(),
               "keyCode":KeyCodes.CharCodeStrings[Parameters.data_.useSpecial]
            },_loc3_,_loc4_);
         }
         return _loc1_;
      }
      
      private function getUsableClasses() : StringBuilder
      {
         var _loc3_:String = null;
         var _loc1_:Vector.<String> = ObjectLibrary.usableBy(this.objectType);
         var _loc2_:AppendingLineBuilder = new AppendingLineBuilder();
         _loc2_.setDelimiter(", ");
         for each(_loc3_ in _loc1_)
         {
            _loc2_.pushParams(_loc3_);
         }
         return _loc2_;
      }
      
      private function addDescriptionText() : void
      {
         this.descText = new TextFieldDisplayConcrete().setSize(14).setColor(11776947).setTextWidth(MAX_WIDTH).setWordWrap(true);
         this.descText.setStringBuilder(new LineBuilder().setParams(String(this.objectXML.Description)));
         this.descText.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         waiter.push(this.descText.textChanged);
         addChild(this.descText);
      }
      
      override protected function alignUI() : void
      {
         this.titleText.x = this.icon.width + 4;
         this.titleText.y = this.icon.height / 2 - this.titleText.height / 2;
         if(this.tierText)
         {
            this.tierText.y = this.icon.height / 2 - this.tierText.height / 2;
            this.tierText.x = MAX_WIDTH - 30;
         }
         this.descText.x = 4;
         this.descText.y = this.icon.height + 2;
         if(contains(this.line1))
         {
            this.line1.x = 8;
            this.line1.y = this.descText.y + this.descText.height + 8;
            this.effectsText.x = 4;
            this.effectsText.y = this.line1.y + 8;
         }
         else
         {
            this.line1.y = this.descText.y + this.descText.height;
            this.effectsText.y = this.line1.y;
         }
         this.line2.x = 8;
         this.line2.y = this.effectsText.y + this.effectsText.height + 8;
         var _loc1_:uint = this.line2.y + 8;
         if(this.restrictionsText)
         {
            this.restrictionsText.x = 4;
            this.restrictionsText.y = _loc1_;
            _loc1_ += this.restrictionsText.height;
         }
         if(this.powerText)
         {
            if(contains(this.powerText))
            {
               this.powerText.x = 4;
               this.powerText.y = _loc1_;
            }
         }
      }
      
      private function buildCategorySpecificText() : void
      {
         if(this.curItemXML != null)
         {
            this.comparisonResults = this.slotTypeToTextBuilder.getComparisonResults(this.objectXML,this.curItemXML);
         }
         else
         {
            this.comparisonResults = new SlotComparisonResult();
         }
      }
      
      private function handleWisMod() : void
      {
         var _loc3_:XML = null;
         var _loc4_:XML = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         if(this.player == null)
         {
            return;
         }
         var _loc1_:Number = this.player.wisdom_ + this.player.wisdomBoost_;
         if(_loc1_ < 30)
         {
            return;
         }
         var _loc2_:Vector.<XML> = new Vector.<XML>();
         if(this.curItemXML != null)
         {
            this.curItemXML = this.curItemXML.copy();
            _loc2_.push(this.curItemXML);
         }
         if(this.objectXML != null)
         {
            this.objectXML = this.objectXML.copy();
            _loc2_.push(this.objectXML);
         }
         for each(_loc4_ in _loc2_)
         {
            for each(_loc3_ in _loc4_.Activate)
            {
               _loc5_ = _loc3_.toString();
               if(_loc3_.@effect == "Stasis")
               {
                  continue;
               }
               _loc6_ = _loc3_.@useWisMod;
               if(_loc6_ == "" || _loc6_ == "false" || _loc6_ == "0" || _loc3_.@effect == "Stasis")
               {
                  continue;
               }
               switch(_loc5_)
               {
                  case ActivationType.HEAL_NOVA:
                     _loc3_.@amount = this.modifyWisModStat(_loc3_.@amount,0);
                     _loc3_.@range = this.modifyWisModStat(_loc3_.@range);
                     break;
                  case ActivationType.COND_EFFECT_AURA:
                     _loc3_.@duration = this.modifyWisModStat(_loc3_.@duration);
                     _loc3_.@range = this.modifyWisModStat(_loc3_.@range);
                     break;
                  case ActivationType.COND_EFFECT_SELF:
                     _loc3_.@duration = this.modifyWisModStat(_loc3_.@duration);
                     break;
                  case ActivationType.STAT_BOOST_AURA:
                     _loc3_.@amount = this.modifyWisModStat(_loc3_.@amount,0);
                     _loc3_.@duration = this.modifyWisModStat(_loc3_.@duration);
                     _loc3_.@range = this.modifyWisModStat(_loc3_.@range);
                     break;
                  case ActivationType.GENERIC_ACTIVATE:
                     _loc3_.@duration = this.modifyWisModStat(_loc3_.@duration);
                     _loc3_.@range = this.modifyWisModStat(_loc3_.@range);
               }
            }
         }
      }
      
      private function modifyWisModStat(param1:String, param2:Number = 1) : String
      {
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc3_:String = "-1";
         var _loc4_:Number = this.player.wisdom_ + this.player.wisdomBoost_;
         if(_loc4_ < 30)
         {
            _loc3_ = param1;
         }
         else
         {
            _loc5_ = Number(param1);
            _loc6_ = _loc5_ < 0 ? -1 : 1;
            _loc7_ = _loc5_ * _loc4_ / 150 + _loc5_ * _loc6_;
            _loc7_ = Math.floor(_loc7_ * Math.pow(10,param2)) / Math.pow(10,param2);
            if(_loc7_ - int(_loc7_) * _loc6_ >= 1 / Math.pow(10,param2) * _loc6_)
            {
               _loc3_ = _loc7_.toFixed(1);
            }
            else
            {
               _loc3_ = _loc7_.toFixed(0);
            }
         }
         return _loc3_;
      }
   }
}

import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

class Effect
{
   
   public var name_:String;
   
   public var valueReplacements_:Object;
   
   public var replacementColor_:uint = 16777103;
   
   public var color_:uint = 11776947;
   
   public function Effect(param1:String, param2:Object)
   {
      super();
      this.name_ = param1;
      this.valueReplacements_ = param2;
   }
   
   public function setColor(param1:uint) : Effect
   {
      this.color_ = param1;
      return this;
   }
   
   public function setReplacementsColor(param1:uint) : Effect
   {
      this.replacementColor_ = param1;
      return this;
   }
   
   public function getValueReplacementsWithColor() : Object
   {
      var _loc4_:String = null;
      var _loc5_:LineBuilder = null;
      var _loc1_:Object = {};
      var _loc2_:String = "";
      var _loc3_:String = "";
      if(this.replacementColor_)
      {
         _loc2_ = "</font><font color=\"#" + this.replacementColor_.toString(16) + "\">";
         _loc3_ = "</font><font color=\"#" + this.color_.toString(16) + "\">";
      }
      for(_loc4_ in this.valueReplacements_)
      {
         if(this.valueReplacements_[_loc4_] is AppendingLineBuilder)
         {
            _loc1_[_loc4_] = this.valueReplacements_[_loc4_];
         }
         else if(this.valueReplacements_[_loc4_] is LineBuilder)
         {
            _loc5_ = this.valueReplacements_[_loc4_] as LineBuilder;
            _loc5_.setPrefix(_loc2_).setPostfix(_loc3_);
            _loc1_[_loc4_] = _loc5_;
         }
         else
         {
            _loc1_[_loc4_] = _loc2_ + this.valueReplacements_[_loc4_] + _loc3_;
         }
      }
      return _loc1_;
   }
}

class Restriction
{
   
   public var text_:String;
   
   public var color_:uint;
   
   public var bold_:Boolean;
   
   public function Restriction(param1:String, param2:uint, param3:Boolean)
   {
      super();
      this.text_ = param1;
      this.color_ = param2;
      this.bold_ = param3;
   }
}
