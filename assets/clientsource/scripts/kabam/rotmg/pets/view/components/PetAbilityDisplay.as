package kabam.rotmg.pets.view.components
{
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import kabam.rotmg.pets.data.AbilityVO;
   import kabam.rotmg.pets.util.PetsConstants;
   import kabam.rotmg.pets.util.PetsViewAssetFactory;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.ui.view.SignalWaiter;
   import org.osflash.signals.ISlot;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeSignal;
   
   public class PetAbilityDisplay extends Sprite
   {
      
      public const addToolTip:Signal = new Signal(ToolTip);
      
      public var valueTextField:TextFieldDisplayConcrete;
      
      private var rollOver:ISlot;
      
      private var labelTextField:TextFieldDisplayConcrete;
      
      private var vo:AbilityVO;
      
      private var spacing:int;
      
      private var textColor:int;
      
      private var tooltip:PetAbilityTooltip;
      
      public function PetAbilityDisplay(param1:AbilityVO, param2:int)
      {
         super();
         this.vo = param1;
         this.spacing = param2;
         this.rollOver = new NativeSignal(this,MouseEvent.MOUSE_OVER).add(this.onRollOver);
         this.textColor = param1.getUnlocked() ? 11776947 : 6710886;
         this.updateTextFields();
         this.makeBullet();
         param1.updated.add(this.onUpdated);
      }
      
      public function destroy() : void
      {
         this.vo.updated.remove(this.onUpdated);
      }
      
      private function onUpdated(param1:AbilityVO) : void
      {
         this.setLevelText();
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         this.tooltip = new PetAbilityTooltip(this.vo);
         this.tooltip.attachToTarget(this);
         this.addToolTip.dispatch(this.tooltip);
      }
      
      private function makeBullet() : void
      {
         graphics.beginFill(this.textColor);
         graphics.drawCircle(0,-5,1.5);
      }
      
      private function updateTextFields() : void
      {
         this.makeLabelTextfield();
         if(this.vo.getUnlocked())
         {
            this.makeValueTextField();
         }
      }
      
      private function makeValueTextField() : void
      {
         this.valueTextField = PetsViewAssetFactory.returnTextfield(this.textColor,13,true);
         addChild(this.valueTextField);
         this.waitForTextChanged();
         this.setLevelText();
         this.vo.level >= PetsConstants.MAX_LEVEL && this.valueTextField.setColor(PetsConstants.COLOR_GREEN_TEXT_HIGHLIGHT);
      }
      
      private function setLevelText() : void
      {
         if(this.valueTextField)
         {
            this.valueTextField.setStringBuilder(new LineBuilder().setParams(this.getLevelKey(this.vo),{"level":this.vo.level}));
         }
      }
      
      private function makeLabelTextfield() : void
      {
         this.labelTextField = PetsViewAssetFactory.returnTextfield(this.textColor,13,true);
         this.labelTextField.setStringBuilder(new LineBuilder().setParams(this.vo.name));
         this.labelTextField.x = 3;
         addChild(this.labelTextField);
      }
      
      private function getLevelKey(param1:AbilityVO) : String
      {
         return param1.level < PetsConstants.MAX_LEVEL ? TextKey.PET_ABILITY_LEVEL : TextKey.PET_ABILITY_LEVEL_MAX;
      }
      
      private function waitForTextChanged() : void
      {
         var _loc1_:SignalWaiter = new SignalWaiter();
         _loc1_.push(this.valueTextField.textChanged);
         _loc1_.complete.addOnce(this.positionTextField);
      }
      
      private function positionTextField() : void
      {
         this.valueTextField.x = this.spacing - this.valueTextField.width;
      }
   }
}

