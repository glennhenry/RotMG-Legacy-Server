package kabam.rotmg.pets.view.components
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.core.signals.HideTooltipsSignal;
   import kabam.rotmg.core.signals.ShowTooltipSignal;
   import kabam.rotmg.pets.data.AbilityVO;
   import kabam.rotmg.pets.util.PetsAbilityLevelHelper;
   import kabam.rotmg.pets.util.PetsConstants;
   import kabam.rotmg.pets.util.PetsViewAssetFactory;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.tooltips.HoverTooltipDelegate;
   import kabam.rotmg.tooltips.TooltipAble;
   import kabam.rotmg.ui.view.SignalWaiter;
   import org.osflash.signals.Signal;
   
   public class PetAbilityMeter extends Sprite implements TooltipAble
   {
      
      public const animating:Signal = new Signal(PetAbilityMeter,Boolean);
      
      private const labelTextfield:TextFieldDisplayConcrete = PetsViewAssetFactory.returnTopAlignedTextfield(11776947,14,true,true);
      
      private const levelTextfield:TextFieldDisplayConcrete = PetsViewAssetFactory.returnTopAlignedTextfield(11776947,14,true,true);
      
      private const abilityBar:AnimatedAbilityBar = new AnimatedAbilityBar(PetsConstants.PET_ABILITY_BAR_WIDTH,PetsConstants.PET_ABILITY_BAR_HEIGHT);
      
      private var unlocked:Boolean = true;
      
      private var pointsShown:int = 0;
      
      private var levelShown:int = 0;
      
      private var pointsLeftToAdd:Number = 0;
      
      public var positioned:Signal = new Signal();
      
      public var max:int;
      
      public var index:int;
      
      private var tooltipDelegate:HoverTooltipDelegate = new HoverTooltipDelegate();
      
      public function PetAbilityMeter()
      {
         super();
         this.abilityBar.animating.add(this.onAnimatingBar);
         this.waitForTextChanged();
         this.addChildren();
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.tooltipDelegate.setDisplayObject(this);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         this.abilityBar.animating.remove(this.onAnimatingBar);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function initializeData(param1:AbilityVO) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.pointsShown = param1.points;
         this.levelShown = param1.level;
         this.setAbilityLabel(param1.name);
         this.setUnlocked(param1.getUnlocked());
         this.setLevelLabel(this.unlocked ? param1.level : 0);
         this.onAnimatingBar(false);
         this.tooltipDelegate.tooltip = new PetAbilityTooltip(param1);
         if(this.unlocked)
         {
            _loc2_ = Math.max(0,PetsAbilityLevelHelper.getCurrentPointsForLevel(param1.points,param1.level));
            _loc3_ = PetsAbilityLevelHelper.getAbilityPointsforLevel(param1.level);
            _loc2_ = param1.level >= this.max ? _loc3_ : _loc2_;
            this.setAbilityBar(_loc2_,_loc3_);
         }
         param1.updated.add(this.updateData);
      }
      
      private function updateData(param1:AbilityVO) : void
      {
         var _loc2_:Number = NaN;
         this.setUnlocked(param1.getUnlocked());
         if(param1.points > this.pointsShown && this.unlocked)
         {
            this.pointsShown = param1.points;
            this.pointsLeftToAdd = PetsAbilityLevelHelper.getCurrentPointsForLevel(param1.points,this.levelShown);
            _loc2_ = PetsAbilityLevelHelper.getAbilityPointsforLevel(this.levelShown);
            if(_loc2_ != 0 && this.pointsLeftToAdd > _loc2_)
            {
               this.pointsLeftToAdd -= _loc2_;
               this.abilityBar.filledUp.add(this.onChainedFill);
               this.abilityBar.fill();
               this.onAnimatingBar(true);
            }
            else
            {
               this.setAbilityBar(this.pointsLeftToAdd,_loc2_);
            }
         }
      }
      
      private function onChainedFill() : void
      {
         var _loc2_:Number = NaN;
         ++this.levelShown;
         this.setLevelLabel(this.levelShown,true);
         _loc2_ = PetsAbilityLevelHelper.getAbilityPointsforLevel(this.levelShown);
         if(this.pointsLeftToAdd > _loc2_)
         {
            this.abilityBar.reset();
            this.pointsLeftToAdd -= _loc2_;
            this.abilityBar.fill();
         }
         else
         {
            this.abilityBar.filledUp.remove(this.onChainedFill);
            if(this.levelShown >= this.max)
            {
               this.abilityBar.handleTweenComplete(null);
               this.pointsLeftToAdd = 0;
            }
            else
            {
               this.abilityBar.reset();
               this.setAbilityBar(this.pointsLeftToAdd,_loc2_);
            }
         }
      }
      
      public function setAbilityLabel(param1:String) : void
      {
         this.levelTextfield.setStringBuilder(new LineBuilder().setParams(param1));
      }
      
      public function setLevelLabel(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:String = param1 >= this.max ? TextKey.PET_ABILITY_LEVEL_MAX : TextKey.ABILITY_BAR_LEVEL_LABEL;
         this.labelTextfield.setColor(param2 ? 1572859 : (param1 >= this.max ? PetsConstants.COLOR_GREEN_TEXT_HIGHLIGHT : 11776947));
         this.labelTextfield.setStringBuilder(new LineBuilder().setParams(_loc3_,{"level":param1.toString()}));
         this.labelTextfield.textChanged.addOnce(this.positionLabelText);
      }
      
      public function setAbilityBar(param1:int, param2:int) : void
      {
         this.abilityBar.setMaxPointValue(param2);
         this.abilityBar.setCurrentPointValue(param1);
      }
      
      public function setUnlocked(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         if(this.unlocked != param1)
         {
            this.unlocked = param1;
            _loc2_ = param1 ? 11776947 : 5658198;
            _loc3_ = param1 ? [new DropShadowFilter(0,0,0)] : [];
            this.levelTextfield.setColor(_loc2_);
            this.levelTextfield.filters = _loc3_;
            this.labelTextfield.visible = param1;
         }
      }
      
      private function addChildren() : void
      {
         addChild(this.levelTextfield);
         addChild(this.labelTextfield);
         addChild(this.abilityBar);
      }
      
      private function waitForTextChanged() : void
      {
         var _loc1_:SignalWaiter = new SignalWaiter();
         _loc1_.push(this.labelTextfield.textChanged);
         _loc1_.push(this.levelTextfield.textChanged);
         _loc1_.complete.addOnce(this.positionTextField);
      }
      
      private function positionLabelText() : void
      {
         this.abilityBar.y = 21;
         this.labelTextfield.x = PetsConstants.PET_ABILITY_BAR_WIDTH - this.labelTextfield.width;
      }
      
      private function positionTextField() : void
      {
         this.positionLabelText();
         this.positioned.dispatch();
      }
      
      private function onAnimatingBar(param1:Boolean) : void
      {
         this.labelTextfield.setColor(param1 ? 1572859 : (this.levelShown >= this.max ? PetsConstants.COLOR_GREEN_TEXT_HIGHLIGHT : 11776947));
         this.levelTextfield.setColor(param1 ? 1572859 : (this.levelShown >= 100 ? PetsConstants.COLOR_GREEN_TEXT_HIGHLIGHT : 11776947));
         if(!param1 && this.levelShown >= 100)
         {
            this.abilityBar.setBarColor(PetsConstants.COLOR_GREEN_TEXT_HIGHLIGHT);
         }
         this.animating.dispatch(this,param1);
      }
      
      public function setShowToolTipSignal(param1:ShowTooltipSignal) : void
      {
         this.tooltipDelegate.setShowToolTipSignal(param1);
      }
      
      public function getShowToolTip() : ShowTooltipSignal
      {
         return this.tooltipDelegate.getShowToolTip();
      }
      
      public function setHideToolTipsSignal(param1:HideTooltipsSignal) : void
      {
         this.tooltipDelegate.setHideToolTipsSignal(param1);
      }
      
      public function getHideToolTips() : HideTooltipsSignal
      {
         return this.tooltipDelegate.getHideToolTips();
      }
   }
}

