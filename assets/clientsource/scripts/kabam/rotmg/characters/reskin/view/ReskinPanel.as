package kabam.rotmg.characters.reskin.view
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.DeprecatedTextButton;
   import com.company.assembleegameclient.ui.panels.Panel;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class ReskinPanel extends Panel
   {
      
      private const title:TextFieldDisplayConcrete = this.makeTitle();
      
      private const button:DeprecatedTextButton = this.makeButton();
      
      private const click:Signal = new NativeMappedSignal(this.button,MouseEvent.CLICK);
      
      public const reskin:Signal = new Signal();
      
      public function ReskinPanel(param1:GameSprite = null)
      {
         super(param1);
         this.click.add(this.onClick);
      }
      
      private function onClick() : void
      {
         this.reskin.dispatch();
      }
      
      private function makeTitle() : TextFieldDisplayConcrete
      {
         var _loc1_:TextFieldDisplayConcrete = null;
         _loc1_ = new TextFieldDisplayConcrete().setSize(18).setColor(16777215).setAutoSize(TextFieldAutoSize.CENTER);
         _loc1_.x = WIDTH / 2;
         _loc1_.setBold(true);
         _loc1_.filters = [new DropShadowFilter(0,0,0)];
         _loc1_.setStringBuilder(new LineBuilder().setParams(TextKey.RESKINPANEL_CHANGESKIN));
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeButton() : DeprecatedTextButton
      {
         var _loc1_:DeprecatedTextButton = new DeprecatedTextButton(16,TextKey.RESKINPANEL_CHOOSE);
         _loc1_.textChanged.addOnce(this.onTextSet);
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function onTextSet() : void
      {
         this.button.x = WIDTH / 2 - this.button.width / 2;
         this.button.y = HEIGHT - this.button.height - 4;
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Parameters.data_.interact && stage.focus == null)
         {
            this.reskin.dispatch();
         }
      }
   }
}

