package kabam.rotmg.classes.view
{
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import org.osflash.signals.Signal;
   
   public class CharacterSkinLimitedBanner extends Sprite
   {
      
      private var LimitedBanner:Class = CharacterSkinLimitedBanner_LimitedBanner;
      
      private const limitedText:TextFieldDisplayConcrete = this.makeText();
      
      private const limitedBanner:* = this.makeLimitedBanner();
      
      public const readyForPositioning:Signal = new Signal();
      
      public function CharacterSkinLimitedBanner()
      {
         super();
      }
      
      private function makeText() : TextFieldDisplayConcrete
      {
         var _loc1_:TextFieldDisplayConcrete = null;
         _loc1_ = new TextFieldDisplayConcrete().setSize(16).setColor(11776947).setBold(true);
         _loc1_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         _loc1_.setStringBuilder(new LineBuilder().setParams(TextKey.CHARACTER_SKIN_LIMITED));
         _loc1_.textChanged.addOnce(this.layout);
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeLimitedBanner() : *
      {
         var _loc1_:* = new this.LimitedBanner();
         addChild(_loc1_);
         return _loc1_;
      }
      
      public function layout() : void
      {
         this.limitedText.y = height / 2 - this.limitedText.height / 2 + 1;
         this.limitedBanner.x = this.limitedText.x + this.limitedText.width;
         this.readyForPositioning.dispatch();
      }
   }
}

