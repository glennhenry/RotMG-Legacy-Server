package kabam.rotmg.packages.view
{
   import com.company.assembleegameclient.ui.DeprecatedTextButton;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.text.TextFieldAutoSize;
   import kabam.display.Loader.LoaderProxy;
   import kabam.display.Loader.LoaderProxyConcrete;
   import kabam.lib.resizing.view.Resizable;
   import kabam.rotmg.packages.model.PackageInfo;
   import kabam.rotmg.pets.view.components.DialogCloseButton;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   import org.osflash.signals.Signal;
   
   public class PackageOfferDialog extends Sprite implements Resizable
   {
      
      public var ready:Signal = new Signal();
      
      public var buy:Signal = new Signal();
      
      public var close:Signal = new Signal();
      
      internal var loader:LoaderProxy = new LoaderProxyConcrete();
      
      internal var goldDisplay:GoldDisplay = new GoldDisplay();
      
      internal var image:DisplayObject;
      
      internal const paddingTop:Number = 6;
      
      internal const paddingRight:Number = 6;
      
      internal const paddingBottom:Number = 16;
      
      internal const fontSize:int = 27;
      
      private const busyIndicator:DisplayObject = this.makeBusyIndicator();
      
      private const buyNow:Sprite = this.makeBuyNow();
      
      private const title:TextFieldDisplayConcrete = this.makeTitle();
      
      private const closeButton:Sprite = this.makeCloseButton();
      
      private var packageInfo:PackageInfo;
      
      private var spaceAvailable:Rectangle = new Rectangle();
      
      public function PackageOfferDialog()
      {
         super();
      }
      
      private function makeBusyIndicator() : DisplayObject
      {
         var _loc1_:DisplayObject = new BusyIndicator();
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeCloseButton() : Sprite
      {
         return new DialogCloseButton();
      }
      
      private function makeBuyNow() : DeprecatedTextButton
      {
         return new DeprecatedTextButton(16,TextKey.PACKAGE_OFFER_DIALOG_BUY_NOW);
      }
      
      private function makeTitle() : TextFieldDisplayConcrete
      {
         var _loc1_:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(this.fontSize).setColor(11776947);
         _loc1_.y = this.paddingTop + 5;
         _loc1_.setAutoSize(TextFieldAutoSize.CENTER);
         return _loc1_;
      }
      
      public function setPackage(param1:PackageInfo) : PackageOfferDialog
      {
         removeChild(this.busyIndicator);
         this.packageInfo = param1;
         this.setImageURL(this.packageInfo.imageURL);
         return this;
      }
      
      public function getPackage() : PackageInfo
      {
         return this.packageInfo;
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         this.closeButton.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         this.close.dispatch();
      }
      
      private function setImageURL(param1:String) : void
      {
         this.loader && this.loader.unload();
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete);
         this.loader.load(new URLRequest(param1));
      }
      
      public function destroy() : void
      {
         this.loader.unload();
      }
      
      private function onIOError(param1:IOErrorEvent) : void
      {
         this.removeListeners();
         this.populateDialog(new PackageBackground());
         this.ready.dispatch();
      }
      
      private function onComplete(param1:Event) : void
      {
         this.removeListeners();
         this.populateDialog(this.loader);
         this.ready.dispatch();
      }
      
      private function populateDialog(param1:DisplayObject) : void
      {
         this.setImage(param1);
         addChild(this.title);
         this.handleCloseButton();
         this.handleBuyNow();
         this.handleGold();
         this.setTitle(this.packageInfo.name);
         this.setGold(this.packageInfo.price);
      }
      
      private function removeListeners() : void
      {
         this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
      }
      
      private function handleGold() : void
      {
         this.goldDisplay.init();
         addChild(this.goldDisplay);
         this.goldDisplay.x = this.buyNow.x - 16;
         this.goldDisplay.y = this.buyNow.y + this.buyNow.height / 2;
      }
      
      private function handleBuyNow() : void
      {
         addChild(this.buyNow);
         this.buyNow.x = this.image.width / 2 - this.buyNow.width / 2;
         this.buyNow.y = this.image.height - this.buyNow.height - this.paddingBottom - 4;
         this.buyNow.addEventListener(MouseEvent.MOUSE_UP,this.onBuyNow);
      }
      
      private function onBuyNow(param1:Event) : void
      {
         this.buyNow.removeEventListener(MouseEvent.MOUSE_UP,this.onBuyNow);
         this.buy.dispatch();
      }
      
      private function handleCloseButton() : void
      {
         addChild(this.closeButton);
         this.closeButton.x = this.image.width - this.closeButton.width * 2 - this.paddingRight;
         this.closeButton.y = this.paddingTop + 5;
         this.closeButton.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
      }
      
      private function setImage(param1:DisplayObject) : void
      {
         this.image && removeChild(this.image);
         this.image = param1;
         this.image && addChild(this.image);
         this.center();
      }
      
      private function center() : void
      {
         x = (this.spaceAvailable.width - width) / 2;
         y = (this.spaceAvailable.height - height) / 2;
      }
      
      private function setTitle(param1:String) : void
      {
         this.title.setStringBuilder(new StaticStringBuilder(param1));
         this.title.x = this.image.width / 2;
      }
      
      private function setGold(param1:int) : void
      {
         this.goldDisplay.setGold(param1);
      }
      
      public function resize(param1:Rectangle) : void
      {
         this.spaceAvailable = param1;
         this.center();
      }
   }
}

