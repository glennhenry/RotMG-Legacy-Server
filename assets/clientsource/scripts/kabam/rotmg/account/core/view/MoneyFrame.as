package kabam.rotmg.account.core.view
{
   import com.company.assembleegameclient.account.ui.Frame;
   import com.company.assembleegameclient.account.ui.OfferRadioButtons;
   import com.company.assembleegameclient.account.ui.PaymentMethodRadioButtons;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.DeprecatedClickableText;
   import com.company.assembleegameclient.ui.DeprecatedTextButton;
   import com.company.assembleegameclient.util.PaymentMethod;
   import com.company.assembleegameclient.util.offer.Offer;
   import com.company.assembleegameclient.util.offer.Offers;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.account.core.model.MoneyConfig;
   import kabam.rotmg.text.model.TextKey;
   import org.osflash.signals.Signal;
   
   public class MoneyFrame extends Sprite
   {
      
      private static const TITLE:String = TextKey.MONEY_FRAME_TITLE;
      
      private static const TRACKING:String = "/money";
      
      private static const PAYMENT_SUBTITLE:String = TextKey.MONEY_FRAME_PAYMENT;
      
      private static const GOLD_SUBTITLE:String = TextKey.MONEY_FRAME_GOLD;
      
      private static const BUY_NOW:String = TextKey.MONEY_FRAME_BUY;
      
      private static const WIDTH:int = 550;
      
      public var buyNow:Signal;
      
      public var cancel:Signal;
      
      private var offers:Offers;
      
      private var config:MoneyConfig;
      
      private var frame:Frame;
      
      private var paymentMethodButtons:PaymentMethodRadioButtons;
      
      private var offerButtons:OfferRadioButtons;
      
      public var buyNowButton:DeprecatedTextButton;
      
      public var cancelButton:DeprecatedClickableText;
      
      public function MoneyFrame()
      {
         super();
         this.buyNow = new Signal(Offer,String);
         this.cancel = new Signal();
      }
      
      public function initialize(param1:Offers, param2:MoneyConfig) : void
      {
         this.offers = param1;
         this.config = param2;
         this.frame = new Frame(TITLE,"","",TRACKING,WIDTH);
         param2.showPaymentMethods() && this.addPaymentMethods();
         this.addOffers();
         this.addBuyNowButton();
         addChild(this.frame);
         this.addCancelButton(TextKey.MONEY_FRAME_RIGHT_BUTTON);
         this.cancelButton.addEventListener(MouseEvent.CLICK,this.onCancel);
      }
      
      public function addPaymentMethods() : void
      {
         this.makePaymentMethodRadioButtons();
         this.frame.addTitle(PAYMENT_SUBTITLE);
         this.frame.addRadioBox(this.paymentMethodButtons);
         this.frame.addSpace(14);
         this.addLine(8355711,536,2,10);
         this.frame.addSpace(6);
      }
      
      private function makePaymentMethodRadioButtons() : void
      {
         var _loc1_:Vector.<String> = this.makePaymentMethodLabels();
         this.paymentMethodButtons = new PaymentMethodRadioButtons(_loc1_);
         this.paymentMethodButtons.setSelected(Parameters.data_.paymentMethod);
      }
      
      private function makePaymentMethodLabels() : Vector.<String>
      {
         var _loc2_:PaymentMethod = null;
         var _loc1_:Vector.<String> = new Vector.<String>();
         for each(_loc2_ in PaymentMethod.PAYMENT_METHODS)
         {
            _loc1_.push(_loc2_.label_);
         }
         return _loc1_;
      }
      
      private function addLine(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:Shape = new Shape();
         _loc5_.graphics.beginFill(param1);
         _loc5_.graphics.drawRect(param4,0,param2 - param4 * 2,param3);
         _loc5_.graphics.endFill();
         this.frame.addComponent(_loc5_,0);
      }
      
      private function addOffers() : void
      {
         this.offerButtons = new OfferRadioButtons(this.offers,this.config);
         this.offerButtons.showBonuses(this.config.showBonuses());
         this.frame.addTitle(GOLD_SUBTITLE);
         this.frame.addComponent(this.offerButtons);
      }
      
      public function addBuyNowButton() : void
      {
         this.buyNowButton = new DeprecatedTextButton(16,BUY_NOW);
         this.buyNowButton.addEventListener(MouseEvent.CLICK,this.onBuyNowClick);
         this.buyNowButton.x = 8;
         this.buyNowButton.y = this.frame.h_ - 52;
         this.frame.addChild(this.buyNowButton);
      }
      
      public function addCancelButton(param1:String) : void
      {
         this.cancelButton = new DeprecatedClickableText(18,true,param1);
         if(param1 != "")
         {
            this.cancelButton.buttonMode = true;
            this.cancelButton.x = 800 / 2 + this.frame.w_ / 2 - this.cancelButton.width - 26;
            this.cancelButton.y = 600 / 2 + this.frame.h_ / 2 - 52;
            this.cancelButton.setAutoSize(TextFieldAutoSize.RIGHT);
            addChild(this.cancelButton);
         }
      }
      
      protected function onBuyNowClick(param1:MouseEvent) : void
      {
         this.disable();
         var _loc2_:Offer = this.offerButtons.getChoice().offer;
         var _loc3_:String = this.paymentMethodButtons ? this.paymentMethodButtons.getSelected() : null;
         this.buyNow.dispatch(_loc2_,_loc3_ || "");
      }
      
      public function disable() : void
      {
         this.frame.disable();
         this.cancelButton.setDefaultColor(11776947);
         this.cancelButton.mouseEnabled = false;
         this.cancelButton.mouseChildren = false;
      }
      
      public function enableOnlyCancel() : void
      {
         this.cancelButton.removeOnHoverEvents();
         this.cancelButton.mouseEnabled = true;
         this.cancelButton.mouseChildren = true;
      }
      
      protected function onCancel(param1:MouseEvent) : void
      {
         stage.focus = stage;
         this.cancel.dispatch();
      }
   }
}

