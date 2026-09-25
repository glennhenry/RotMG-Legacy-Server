package kabam.rotmg.promotions.view
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import kabam.rotmg.promotions.view.components.TransparentButton;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class BeginnersPackageOfferDialog extends Sprite
   {
      
      public static const LANGUAGE_KEY_SINGULAR:String = "BeginnersPackageOfferDialog.dayLeft";
      
      public static const LANGUAGE_KEY_PLURAL:String = "BeginnersPackageOfferDialog.daysLeft";
      
      public static var hifiBeginnerOfferEmbed:Class = BeginnersPackageOfferDialog_hifiBeginnerOfferEmbed;
      
      public var close:Signal;
      
      public var buy:Signal;
      
      private var timeText:TextFieldDisplayConcrete;
      
      public function BeginnersPackageOfferDialog()
      {
         super();
         this.makeBackground();
         this.makeOfferText();
         this.makeCloseButton();
         this.makeBuyButton();
      }
      
      public function setTimeRemaining(param1:int) : void
      {
         var _loc2_:String = param1 > 1 ? LANGUAGE_KEY_PLURAL : LANGUAGE_KEY_SINGULAR;
         this.timeText.setStringBuilder(new LineBuilder().setParams(_loc2_,{"days":param1}));
      }
      
      public function centerOnScreen() : void
      {
         x = (stage.stageWidth - width) * 0.5;
         y = (stage.stageHeight - height) * 0.5;
      }
      
      private function makeBackground() : void
      {
         addChild(new hifiBeginnerOfferEmbed());
      }
      
      private function makeOfferText() : void
      {
         this.timeText = new TextFieldDisplayConcrete().setSize(14).setColor(14928128);
         this.timeText.setBold(true);
         this.timeText.x = 307;
         this.timeText.y = 380;
         addChild(this.timeText);
      }
      
      private function makeBuyButton() : void
      {
         var _loc1_:Sprite = this.makeTransparentTargetButton(270,400,150,40);
         this.buy = new NativeMappedSignal(_loc1_,MouseEvent.CLICK);
      }
      
      private function makeCloseButton() : void
      {
         var _loc1_:Sprite = this.makeTransparentTargetButton(550,30,30,30);
         this.close = new NativeMappedSignal(_loc1_,MouseEvent.CLICK);
      }
      
      private function makeTransparentTargetButton(param1:int, param2:int, param3:int, param4:int) : Sprite
      {
         var _loc5_:TransparentButton = new TransparentButton(param1,param2,param3,param4);
         addChild(_loc5_);
         return _loc5_;
      }
   }
}

