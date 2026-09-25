package kabam.rotmg.packages.view
{
   import com.company.assembleegameclient.ui.DeprecatedTextButton;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFormatAlign;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.util.graphics.ButtonLayoutHelper;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class PackageInfoDialog extends Sprite
   {
      
      private static const TITLE_Y:int = 8;
      
      private static const BUTTON_WIDTH:int = 120;
      
      private static const BUTTON_FONT:int = 16;
      
      private static const DIALOG_WIDTH:int = 546;
      
      private static const INNER_WIDTH:int = 416;
      
      private static const BUTTON_Y:int = 368;
      
      private static const MESSAGE_TITLE_Y:int = 164;
      
      private static const MESSAGE_BODY_Y:int = 210;
      
      private const background:DisplayObject = this.makeBackground();
      
      private const title:TextFieldDisplayConcrete = this.makeTitle();
      
      private const messageTitle:TextFieldDisplayConcrete = this.makeMessageTitle();
      
      private const messageBody:TextFieldDisplayConcrete = this.makeMessageBody();
      
      private const close:DeprecatedTextButton = this.makeCloseButton();
      
      public const closed:Signal = new NativeMappedSignal(this.close,MouseEvent.CLICK);
      
      public function PackageInfoDialog()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         x = (stage.stageWidth - width) / 2;
         y = (stage.stageHeight - height) / 2;
      }
      
      public function setTitle(param1:String) : PackageInfoDialog
      {
         this.title.setStringBuilder(new LineBuilder().setParams(param1));
         return this;
      }
      
      public function setBody(param1:String, param2:String) : PackageInfoDialog
      {
         this.messageTitle.setStringBuilder(new LineBuilder().setParams(param1));
         this.messageBody.setStringBuilder(new LineBuilder().setParams(param2));
         return this;
      }
      
      private function makeBackground() : DisplayObject
      {
         var _loc1_:PackageBackground = new PackageBackground();
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeTitle() : TextFieldDisplayConcrete
      {
         var _loc1_:TextFieldDisplayConcrete = null;
         _loc1_ = new TextFieldDisplayConcrete().setSize(18).setColor(11974326).setTextWidth(DIALOG_WIDTH).setAutoSize(TextFormatAlign.CENTER).setBold(true);
         _loc1_.y = TITLE_Y;
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeMessageTitle() : TextFieldDisplayConcrete
      {
         var _loc1_:TextFieldDisplayConcrete = null;
         _loc1_ = new TextFieldDisplayConcrete().setSize(14).setColor(14864077).setTextWidth(INNER_WIDTH).setAutoSize(TextFormatAlign.CENTER).setBold(true);
         _loc1_.x = (DIALOG_WIDTH - INNER_WIDTH) * 0.5;
         _loc1_.y = MESSAGE_TITLE_Y;
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeMessageBody() : TextFieldDisplayConcrete
      {
         var _loc1_:TextFieldDisplayConcrete = null;
         _loc1_ = new TextFieldDisplayConcrete().setSize(14).setColor(10914439).setTextWidth(INNER_WIDTH).setAutoSize(TextFormatAlign.CENTER);
         _loc1_.x = (DIALOG_WIDTH - INNER_WIDTH) * 0.5;
         _loc1_.y = MESSAGE_BODY_Y;
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeCloseButton() : DeprecatedTextButton
      {
         var _loc1_:DeprecatedTextButton = null;
         _loc1_ = new DeprecatedTextButton(BUTTON_FONT,TextKey.CLOSE,BUTTON_WIDTH);
         _loc1_.textChanged.addOnce(this.layoutButton);
         _loc1_.y = BUTTON_Y;
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function layoutButton() : void
      {
         new ButtonLayoutHelper().layout(DIALOG_WIDTH,this.close);
      }
   }
}

