package kabam.rotmg.mysterybox.components
{
   import com.company.assembleegameclient.util.Currency;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   import flash.utils.getTimer;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.mysterybox.model.MysteryBoxInfo;
   import kabam.rotmg.pets.view.components.PopupWindowBackground;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   import kabam.rotmg.util.components.LegacyBuyButton;
   import kabam.rotmg.util.components.UIAssetsHelper;
   
   public class MysteryBoxSelectEntry extends Sprite
   {
      
      public static var redBarEmbed:Class = MysteryBoxSelectEntry_redBarEmbed;
      
      public var mbi:MysteryBoxInfo;
      
      private const buyButton:LegacyBuyButton = new LegacyBuyButton("",16,0,Currency.INVALID);
      
      private var leftNavSprite:Sprite;
      
      private var rightNavSprite:Sprite;
      
      private var iconImage:DisplayObject;
      
      private var infoImageBorder:PopupWindowBackground;
      
      private var infoImage:DisplayObject;
      
      private var newText:TextFieldDisplayConcrete;
      
      private var sale:TextFieldDisplayConcrete;
      
      private var hoverState:Boolean = false;
      
      private var descriptionShowing:Boolean = false;
      
      private var redbar:DisplayObject;
      
      private const newString:String = "MysteryBoxSelectEntry.newString";
      
      private const onSaleString:String = "MysteryBoxSelectEntry.onSaleString";
      
      private const saleEndString:String = "MysteryBoxSelectEntry.saleEndString";
      
      private var quantity_:int;
      
      public function MysteryBoxSelectEntry(param1:MysteryBoxInfo)
      {
         super();
         this.redbar = new redBarEmbed();
         this.redbar.y = -5;
         this.redbar.width = MysteryBoxSelectModal.modalWidth - 5;
         this.redbar.height = MysteryBoxSelectModal.aMysteryBoxHeight - 8;
         addChild(this.redbar);
         var _loc2_:DisplayObject = new redBarEmbed();
         _loc2_.y = 0;
         _loc2_.width = MysteryBoxSelectModal.modalWidth - 5;
         _loc2_.height = MysteryBoxSelectModal.aMysteryBoxHeight - 8 + 5;
         _loc2_.alpha = 0;
         addChild(_loc2_);
         this.mbi = param1;
         this.quantity_ = 1;
         var _loc3_:TextFieldDisplayConcrete = this.getText(this.mbi.title,74,18,20,true);
         addChild(_loc3_);
         this.addNewText();
         this.addSaleText();
         if(this.mbi.isOnSale())
         {
            this.buyButton.setPrice(this.mbi.saleAmount,this.mbi.saleCurrency);
         }
         else
         {
            this.buyButton.setPrice(this.mbi.priceAmount,this.mbi.priceCurrency);
         }
         this.buyButton.x = MysteryBoxSelectModal.modalWidth - 120;
         this.buyButton.y = 16;
         this.buyButton._width = 70;
         this.buyButton.addEventListener(MouseEvent.CLICK,this.onBoxBuy);
         addChild(this.buyButton);
         this.iconImage = this.mbi.iconImage;
         this.infoImage = this.mbi.infoImage;
         if(this.iconImage == null)
         {
            this.mbi.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onImageLoadComplete);
         }
         else
         {
            this.addIconImageChild();
         }
         if(this.infoImage == null)
         {
            this.mbi.infoImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onInfoLoadComplete);
         }
         else
         {
            this.addInfoImageChild();
         }
         this.mbi.quantity = this.quantity_.toString();
         this.leftNavSprite = UIAssetsHelper.createLeftNevigatorIcon(UIAssetsHelper.LEFT_NEVIGATOR,3);
         this.leftNavSprite.x = this.buyButton.x + this.buyButton.width + 45;
         this.leftNavSprite.y = this.buyButton.y + this.buyButton.height / 2 - 2;
         this.leftNavSprite.addEventListener(MouseEvent.CLICK,this.onClick);
         addChild(this.leftNavSprite);
         this.rightNavSprite = UIAssetsHelper.createLeftNevigatorIcon(UIAssetsHelper.RIGHT_NEVIGATOR,3);
         this.rightNavSprite.x = this.buyButton.x + this.buyButton.width + 45;
         this.rightNavSprite.y = this.buyButton.y + this.buyButton.height / 2 - 16;
         this.rightNavSprite.addEventListener(MouseEvent.CLICK,this.onClick);
         addChild(this.rightNavSprite);
         addEventListener(MouseEvent.ROLL_OVER,this.onHover);
         addEventListener(MouseEvent.ROLL_OUT,this.onRemoveHover);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onHover(param1:MouseEvent) : void
      {
         this.hoverState = true;
         this.addInfoImageChild();
      }
      
      private function onRemoveHover(param1:MouseEvent) : void
      {
         this.hoverState = false;
         this.removeInfoImageChild();
      }
      
      private function onClick(param1:MouseEvent) : *
      {
         switch(param1.currentTarget)
         {
            case this.rightNavSprite:
               if(this.quantity_ == 1)
               {
                  this.quantity_ += 4;
                  break;
               }
               if(this.quantity_ < 10)
               {
                  this.quantity_ += 5;
               }
               break;
            case this.leftNavSprite:
               if(this.quantity_ == 10)
               {
                  this.quantity_ -= 5;
                  break;
               }
               if(this.quantity_ > 1)
               {
                  this.quantity_ -= 4;
               }
         }
         this.mbi.quantity = this.quantity_.toString();
         if(this.mbi.isOnSale())
         {
            this.buyButton.setPrice(this.mbi.saleAmount * this.quantity_,this.mbi.saleCurrency);
         }
         else
         {
            this.buyButton.setPrice(this.mbi.priceAmount * this.quantity_,this.mbi.priceCurrency);
         }
      }
      
      private function addNewText() : void
      {
         if(this.mbi.isNew())
         {
            this.newText = this.getText(this.newString,74,0).setColor(16768512);
            addChild(this.newText);
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:Number = 1.05 + 0.05 * Math.sin(getTimer() / 200);
         if(this.newText)
         {
            this.newText.scaleX = _loc2_;
            this.newText.scaleY = _loc2_;
         }
         if(this.sale)
         {
            this.sale.scaleX = _loc2_;
            this.sale.scaleY = _loc2_;
         }
      }
      
      private function addSaleText() : void
      {
         var _loc1_:LineBuilder = null;
         var _loc2_:TextFieldDisplayConcrete = null;
         if(this.mbi.isOnSale())
         {
            this.sale = this.getText(this.onSaleString,int(320 * MysteryBoxSelectModal.modalWidth / 415),0).setColor(65280);
            addChild(this.sale);
            _loc1_ = this.mbi.getSaleTimeLeftStringBuilder();
            _loc2_ = this.getText("",int(250 * MysteryBoxSelectModal.modalWidth / 415) - 32,46).setColor(16711680);
            _loc2_.setStringBuilder(_loc1_);
            addChild(_loc2_);
         }
      }
      
      private function onImageLoadComplete(param1:Event) : void
      {
         this.mbi.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onImageLoadComplete);
         this.iconImage = DisplayObject(this.mbi.loader);
         this.addIconImageChild();
      }
      
      private function onInfoLoadComplete(param1:Event) : void
      {
         this.mbi.infoImageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onInfoLoadComplete);
         this.infoImage = DisplayObject(this.mbi.infoImageLoader);
         this.addInfoImageChild();
      }
      
      public function getText(param1:String, param2:int, param3:int, param4:int = 12, param5:Boolean = false) : TextFieldDisplayConcrete
      {
         var _loc6_:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(param4).setColor(16777215).setTextWidth(MysteryBoxSelectModal.modalWidth - 185);
         _loc6_.setBold(true);
         if(param5)
         {
            _loc6_.setStringBuilder(new StaticStringBuilder(param1));
         }
         else
         {
            _loc6_.setStringBuilder(new LineBuilder().setParams(param1));
         }
         _loc6_.setWordWrap(true);
         _loc6_.setMultiLine(true);
         _loc6_.setAutoSize(TextFieldAutoSize.LEFT);
         _loc6_.setHorizontalAlign(TextFormatAlign.LEFT);
         _loc6_.filters = [new DropShadowFilter(0,0,0)];
         _loc6_.x = param2;
         _loc6_.y = param3;
         return _loc6_;
      }
      
      private function addIconImageChild() : void
      {
         if(this.iconImage == null)
         {
            return;
         }
         this.iconImage.width = 48;
         this.iconImage.height = 48;
         this.iconImage.x = 14;
         this.iconImage.y = 6;
         addChild(this.iconImage);
      }
      
      private function addInfoImageChild() : void
      {
         var _loc3_:Array = null;
         var _loc4_:ColorMatrixFilter = null;
         if(this.infoImage == null)
         {
            return;
         }
         this.infoImage.width = 291 - 8;
         this.infoImage.height = 598 - 8 * 2 - 2;
         var _loc2_:Point = this.globalToLocal(new Point(MysteryBoxSelectModal.getRightBorderX() + 1 + 14,2 + 8));
         this.infoImage.x = _loc2_.x;
         this.infoImage.y = _loc2_.y;
         if(this.hoverState && !this.descriptionShowing)
         {
            this.descriptionShowing = true;
            addChild(this.infoImage);
            this.infoImageBorder = new PopupWindowBackground();
            this.infoImageBorder.draw(this.infoImage.width,this.infoImage.height + 2,PopupWindowBackground.TYPE_TRANSPARENT_WITHOUT_HEADER);
            this.infoImageBorder.x = this.infoImage.x;
            --this.infoImage.y;
            addChild(this.infoImageBorder);
            _loc3_ = [3.0742000000000003,-1.8282000000000003,-0.246,0,50,-0.9258,2.1717999999999997,-0.246,0,49.999999999999986,-0.9258,-1.8282000000000003,3.754,0,49.99999999999997,0,0,0,1,0];
            _loc4_ = new ColorMatrixFilter(_loc3_);
            this.redbar.filters = [_loc4_];
         }
      }
      
      private function removeInfoImageChild() : void
      {
         if(this.descriptionShowing)
         {
            removeChild(this.infoImageBorder);
            removeChild(this.infoImage);
            this.descriptionShowing = false;
            this.redbar.filters = [];
         }
      }
      
      private function onBoxBuy(param1:MouseEvent) : void
      {
         var _loc4_:OpenDialogSignal = null;
         var _loc2_:MysteryBoxRollModal = new MysteryBoxRollModal(this.mbi,this.quantity_);
         var _loc3_:Boolean = _loc2_.moneyCheckPass();
         if(_loc3_)
         {
            _loc2_.parentSelectModal = MysteryBoxSelectModal(parent.parent);
            _loc4_ = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);
            _loc4_.dispatch(_loc2_);
         }
      }
   }
}

