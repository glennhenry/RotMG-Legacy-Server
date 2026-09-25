package kabam.rotmg.arena.view
{
   import com.company.assembleegameclient.ui.DeprecatedTextButton;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.arena.component.ArenaQueryDialogHost;
   import kabam.rotmg.arena.util.ArenaViewAssetFactory;
   import kabam.rotmg.pets.view.components.PopupWindowBackground;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.ui.view.SignalWaiter;
   import kabam.rotmg.util.graphics.ButtonLayoutHelper;
   import org.osflash.signals.natives.NativeSignal;
   
   public class HostQueryDialog extends Sprite
   {
      
      public static const WIDTH:int = 274;
      
      public static const HEIGHT:int = 338;
      
      public static const TITLE:String = "ArenaQueryPanel.title";
      
      public static const CLOSE:String = "Close.text";
      
      public static const QUERY:String = "ArenaQueryDialog.info";
      
      public static const BACK:String = "Screens.back";
      
      private const layoutWaiter:SignalWaiter = this.makeDeferredLayout();
      
      private const container:DisplayObjectContainer = this.makeContainer();
      
      private const background:PopupWindowBackground = this.makeBackground();
      
      private const host:ArenaQueryDialogHost = this.makeHost();
      
      private const title:TextFieldDisplayConcrete = this.makeTitle();
      
      private const backButton:DeprecatedTextButton = this.makeBackButton();
      
      public const backClick:NativeSignal = new NativeSignal(this.backButton,MouseEvent.CLICK);
      
      public function HostQueryDialog()
      {
         super();
      }
      
      private function makeDeferredLayout() : SignalWaiter
      {
         var _loc1_:SignalWaiter = new SignalWaiter();
         _loc1_.complete.addOnce(this.onLayout);
         return _loc1_;
      }
      
      private function onLayout() : void
      {
         var _loc1_:ButtonLayoutHelper = new ButtonLayoutHelper();
         _loc1_.layout(WIDTH,this.backButton);
      }
      
      private function makeContainer() : DisplayObjectContainer
      {
         var _loc1_:Sprite = null;
         _loc1_ = new Sprite();
         _loc1_.x = (800 - WIDTH) / 2;
         _loc1_.y = (600 - HEIGHT) / 2;
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeBackground() : PopupWindowBackground
      {
         var _loc1_:PopupWindowBackground = new PopupWindowBackground();
         _loc1_.draw(WIDTH,HEIGHT);
         _loc1_.divide(PopupWindowBackground.HORIZONTAL_DIVISION,34);
         this.container.addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeHost() : ArenaQueryDialogHost
      {
         var _loc1_:ArenaQueryDialogHost = null;
         _loc1_ = new ArenaQueryDialogHost();
         _loc1_.x = 20;
         _loc1_.y = 50;
         this.container.addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeTitle() : TextFieldDisplayConcrete
      {
         var _loc1_:TextFieldDisplayConcrete = null;
         _loc1_ = ArenaViewAssetFactory.returnTextfield(16777215,18,true);
         _loc1_.setStringBuilder(new LineBuilder().setParams(TITLE));
         _loc1_.setAutoSize(TextFieldAutoSize.CENTER);
         _loc1_.x = WIDTH / 2;
         _loc1_.y = 24;
         this.container.addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeBackButton() : DeprecatedTextButton
      {
         var _loc1_:DeprecatedTextButton = null;
         _loc1_ = new DeprecatedTextButton(16,BACK,80);
         this.container.addChild(_loc1_);
         this.layoutWaiter.push(_loc1_.textChanged);
         _loc1_.y = 292;
         return _loc1_;
      }
      
      private function makeCloseButton() : DeprecatedTextButton
      {
         var _loc1_:DeprecatedTextButton = null;
         _loc1_ = new DeprecatedTextButton(16,CLOSE,110);
         _loc1_.y = 292;
         this.container.addChild(_loc1_);
         this.layoutWaiter.push(_loc1_.textChanged);
         return _loc1_;
      }
      
      public function setHostIcon(param1:BitmapData) : void
      {
         this.host.setHostIcon(param1);
      }
   }
}

