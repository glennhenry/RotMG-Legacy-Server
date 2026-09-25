package kabam.rotmg.arena.component
{
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.StaticTextDisplay;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   
   public class BattleSummaryText extends Sprite
   {
      
      private var titleText:StaticTextDisplay = this.makeTitleText();
      
      private var waveText:StaticTextDisplay = this.makeSubtitleText();
      
      private var timeText:StaticTextDisplay = this.makeSubtitleText();
      
      public function BattleSummaryText(param1:String, param2:int, param3:int)
      {
         super();
         this.titleText.setStringBuilder(new LineBuilder().setParams(param1));
         this.waveText.setStringBuilder(new LineBuilder().setParams(TextKey.BATTLE_SUMMARY_WAVENUMBER,{"waveNumber":param2 - 1}));
         this.timeText.setStringBuilder(new StaticStringBuilder(this.createTimerString(param3)));
         this.align();
      }
      
      private function align() : void
      {
         this.titleText.x = width / 2 - this.titleText.width / 2;
         this.waveText.y = this.titleText.height + 10;
         this.waveText.x = width / 2 - this.waveText.width / 2;
         this.timeText.y = this.waveText.y + this.waveText.height + 5;
         this.timeText.x = width / 2 - this.timeText.width / 2;
      }
      
      private function createTimerString(param1:int) : String
      {
         var _loc2_:int = param1 / 60;
         var _loc3_:int = param1 % 60;
         var _loc4_:String = _loc2_ < 10 ? "0" : "";
         _loc4_ = _loc4_ + (_loc2_ + ":");
         _loc4_ = _loc4_ + (_loc3_ < 10 ? "0" : "");
         return _loc4_ + _loc3_;
      }
      
      private function makeTitleText() : StaticTextDisplay
      {
         var _loc1_:StaticTextDisplay = null;
         _loc1_ = new StaticTextDisplay();
         _loc1_.setSize(16).setBold(true).setColor(16777215);
         _loc1_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeSubtitleText() : StaticTextDisplay
      {
         var _loc1_:StaticTextDisplay = new StaticTextDisplay();
         _loc1_.setSize(14).setBold(true).setColor(11776947);
         _loc1_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         addChild(_loc1_);
         return _loc1_;
      }
   }
}

