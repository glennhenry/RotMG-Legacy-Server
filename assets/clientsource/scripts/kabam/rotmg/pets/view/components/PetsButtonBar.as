package kabam.rotmg.pets.view.components
{
   import com.company.assembleegameclient.ui.DeprecatedTextButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import kabam.rotmg.pets.util.PetsConstants;
   import kabam.rotmg.ui.view.SignalWaiter;
   import org.osflash.signals.natives.NativeSignal;
   
   public class PetsButtonBar extends Sprite
   {
      
      public var buttonOne:DeprecatedTextButton = new DeprecatedTextButton(14,"buttonOne",70);
      
      public var buttonTwo:DeprecatedTextButton = new DeprecatedTextButton(14,"buttonTwo",70);
      
      public var buttonOneSignal:NativeSignal = new NativeSignal(this.buttonOne,MouseEvent.CLICK);
      
      public var buttonTwoSignal:NativeSignal = new NativeSignal(this.buttonTwo,MouseEvent.CLICK);
      
      public function PetsButtonBar()
      {
         super();
         this.addTextChangedWaiter();
         this.addButtons();
      }
      
      private function addButtons() : void
      {
         addChild(this.buttonOne);
         addChild(this.buttonTwo);
      }
      
      private function addTextChangedWaiter() : void
      {
         var _loc3_:DeprecatedTextButton = null;
         var _loc1_:Array = [this.buttonOne,this.buttonTwo];
         var _loc2_:SignalWaiter = new SignalWaiter();
         for each(_loc3_ in _loc1_)
         {
            _loc2_.push(_loc3_.textChanged);
         }
         _loc2_.complete.addOnce(this.positionButtons);
      }
      
      private function positionButtons() : void
      {
         this.buttonOne.x = PetsConstants.BUTTON_BAR_SPACING;
         this.buttonTwo.x = PetsConstants.WINDOW_BACKGROUND_WIDTH - this.buttonTwo.width - PetsConstants.BUTTON_BAR_SPACING;
      }
   }
}

