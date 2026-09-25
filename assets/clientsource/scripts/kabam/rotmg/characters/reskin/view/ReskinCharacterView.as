package kabam.rotmg.characters.reskin.view
{
   import com.company.assembleegameclient.ui.DeprecatedTextButton;
   import flash.display.CapsStyle;
   import flash.display.DisplayObject;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.classes.view.CharacterSkinListView;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.ui.view.SignalWaiter;
   import kabam.rotmg.util.components.DialogBackground;
   import kabam.rotmg.util.graphics.ButtonLayoutHelper;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class ReskinCharacterView extends Sprite
   {
      
      private static const MARGIN:int = 10;
      
      private static const DIALOG_WIDTH:int = CharacterSkinListView.WIDTH + MARGIN * 2;
      
      private static const BUTTON_WIDTH:int = 120;
      
      private static const BUTTON_FONT:int = 16;
      
      private static const BUTTONS_HEIGHT:int = 40;
      
      private static const TITLE_OFFSET:int = 27;
      
      private const layoutListener:SignalWaiter = this.makeLayoutWaiter();
      
      private const background:DialogBackground = this.makeBackground();
      
      private const title:TextFieldDisplayConcrete = this.makeTitle();
      
      private const list:CharacterSkinListView = this.makeListView();
      
      private const cancel:DeprecatedTextButton = this.makeCancelButton();
      
      private const select:DeprecatedTextButton = this.makeSelectButton();
      
      public const cancelled:Signal = new NativeMappedSignal(this.cancel,MouseEvent.CLICK);
      
      public const selected:Signal = new NativeMappedSignal(this.select,MouseEvent.CLICK);
      
      public var viewHeight:int;
      
      public function ReskinCharacterView()
      {
         super();
      }
      
      private function makeLayoutWaiter() : SignalWaiter
      {
         var _loc1_:SignalWaiter = new SignalWaiter();
         _loc1_.complete.add(this.positionButtons);
         return _loc1_;
      }
      
      private function makeBackground() : DialogBackground
      {
         var _loc1_:DialogBackground = new DialogBackground();
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeTitle() : TextFieldDisplayConcrete
      {
         var _loc1_:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(18).setColor(11974326).setTextWidth(DIALOG_WIDTH);
         _loc1_.setAutoSize(TextFieldAutoSize.CENTER).setBold(true);
         _loc1_.setStringBuilder(new LineBuilder().setParams(TextKey.RESKINCHARACTERVIEW_TITLE));
         _loc1_.y = MARGIN * 0.5;
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeListView() : CharacterSkinListView
      {
         var _loc1_:CharacterSkinListView = null;
         _loc1_ = new CharacterSkinListView();
         _loc1_.x = MARGIN;
         _loc1_.y = MARGIN + TITLE_OFFSET;
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeCancelButton() : DeprecatedTextButton
      {
         var _loc1_:DeprecatedTextButton = new DeprecatedTextButton(BUTTON_FONT,TextKey.RESKINCHARACTERVIEW_CANCEL,BUTTON_WIDTH);
         addChild(_loc1_);
         this.layoutListener.push(_loc1_.textChanged);
         return _loc1_;
      }
      
      private function makeSelectButton() : DeprecatedTextButton
      {
         var _loc1_:DeprecatedTextButton = new DeprecatedTextButton(BUTTON_FONT,TextKey.RESKINCHARACTERVIEW_SELECT,BUTTON_WIDTH);
         addChild(_loc1_);
         this.layoutListener.push(_loc1_.textChanged);
         return _loc1_;
      }
      
      public function setList(param1:Vector.<DisplayObject>) : void
      {
         this.list.setItems(param1);
         this.getDialogHeight();
         this.resizeBackground();
         this.positionButtons();
      }
      
      private function getDialogHeight() : void
      {
         this.viewHeight = Math.min(CharacterSkinListView.HEIGHT + MARGIN,this.list.getListHeight());
         this.viewHeight += BUTTONS_HEIGHT + MARGIN * 2 + TITLE_OFFSET;
      }
      
      private function resizeBackground() : void
      {
         this.background.draw(DIALOG_WIDTH,this.viewHeight);
         this.background.graphics.lineStyle(2,5987163,1,false,LineScaleMode.NONE,CapsStyle.NONE,JointStyle.BEVEL);
         this.background.graphics.moveTo(1,TITLE_OFFSET);
         this.background.graphics.lineTo(DIALOG_WIDTH - 1,TITLE_OFFSET);
      }
      
      private function positionButtons() : void
      {
         var _loc1_:ButtonLayoutHelper = new ButtonLayoutHelper();
         _loc1_.layout(DIALOG_WIDTH,this.cancel,this.select);
         this.cancel.y = this.select.y = this.viewHeight - BUTTONS_HEIGHT;
      }
   }
}

