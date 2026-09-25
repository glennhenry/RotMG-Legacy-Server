package kabam.rotmg.arena.view
{
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.filters.DropShadowFilter;
   import flash.utils.Timer;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.StaticTextDisplay;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   import org.osflash.signals.Signal;
   
   public class ImminentWaveCountdownClock extends Sprite
   {
      
      private var WaveAsset:Class = ImminentWaveCountdownClock_WaveAsset;
      
      public const close:Signal = new Signal();
      
      private const countDownContainer:Sprite = new Sprite();
      
      private var count:int = 5;
      
      private const nextWaveText:StaticTextDisplay = this.makeNextWaveText();
      
      private const countdownStringBuilder:StaticStringBuilder = new StaticStringBuilder();
      
      private const countdownText:StaticTextDisplay = this.makeCountdownText();
      
      private const waveTimer:Timer = new Timer(1000);
      
      private const waveStartContainer:Sprite = new Sprite();
      
      private var waveNumber:int = -1;
      
      private const waveAsset:* = this.makeWaveAsset();
      
      private const waveText:StaticTextDisplay = this.makeWaveText();
      
      private const waveNumberText:StaticTextDisplay = this.makeWaveNumberText();
      
      private const startText:StaticTextDisplay = this.makeStartText();
      
      private const waveStartTimer:Timer = new Timer(1500,1);
      
      public function ImminentWaveCountdownClock()
      {
         super();
      }
      
      public function init() : void
      {
         mouseChildren = false;
         mouseEnabled = false;
         this.waveTimer.addEventListener(TimerEvent.TIMER,this.updateCountdownClock);
         this.waveTimer.start();
      }
      
      public function destroy() : void
      {
         this.waveTimer.stop();
         this.waveTimer.removeEventListener(TimerEvent.TIMER,this.updateCountdownClock);
         this.waveStartTimer.stop();
         this.waveStartTimer.removeEventListener(TimerEvent.TIMER,this.cleanup);
      }
      
      public function show() : void
      {
         addChild(this.countDownContainer);
         this.center();
      }
      
      public function setWaveNumber(param1:int) : void
      {
         this.waveNumber = param1;
         this.waveNumberText.setStringBuilder(new StaticStringBuilder(this.waveNumber.toString()));
         this.waveNumberText.x = this.waveAsset.width / 2 - this.waveNumberText.width / 2;
      }
      
      private function center() : void
      {
         x = 300 - width / 2;
         y = contains(this.countDownContainer) ? 138 : 87.5;
      }
      
      private function updateCountdownClock(param1:TimerEvent) : void
      {
         if(this.count > 1)
         {
            --this.count;
            this.countdownText.setStringBuilder(this.countdownStringBuilder.setString(this.count.toString()));
            this.countdownText.x = this.nextWaveText.width / 2 - this.countdownText.width / 2;
         }
         else
         {
            removeChild(this.countDownContainer);
            addChild(this.waveStartContainer);
            this.waveTimer.removeEventListener(TimerEvent.TIMER,this.updateCountdownClock);
            this.waveStartTimer.addEventListener(TimerEvent.TIMER,this.cleanup);
            this.waveStartTimer.start();
            this.center();
         }
      }
      
      private function cleanup(param1:TimerEvent) : void
      {
         this.waveStartTimer.removeEventListener(TimerEvent.TIMER,this.cleanup);
         this.close.dispatch();
      }
      
      private function makeNextWaveText() : StaticTextDisplay
      {
         var _loc1_:StaticTextDisplay = new StaticTextDisplay();
         _loc1_.setSize(20).setBold(true).setColor(13421772);
         _loc1_.setStringBuilder(new LineBuilder().setParams(TextKey.ARENA_COUNTDOWN_CLOCK_NEXT_WAVE));
         _loc1_.filters = [new DropShadowFilter(0,0,0,1,8,8,2)];
         this.countDownContainer.addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeCountdownText() : StaticTextDisplay
      {
         var _loc1_:StaticTextDisplay = null;
         _loc1_ = new StaticTextDisplay();
         _loc1_.setSize(42).setBold(true).setColor(13421772);
         _loc1_.setStringBuilder(this.countdownStringBuilder.setString(this.count.toString()));
         _loc1_.y = this.nextWaveText.height;
         _loc1_.x = this.nextWaveText.width / 2 - _loc1_.width / 2;
         _loc1_.filters = [new DropShadowFilter(0,0,0,1,8,8,2)];
         this.countDownContainer.addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeWaveText() : StaticTextDisplay
      {
         var _loc1_:StaticTextDisplay = new StaticTextDisplay();
         _loc1_.setSize(18).setBold(true).setColor(16567065);
         _loc1_.setStringBuilder(new LineBuilder().setParams(TextKey.ARENA_COUNTDOWN_CLOCK_WAVE));
         _loc1_.filters = [new DropShadowFilter(0,0,0,1,8,8,2)];
         _loc1_.x = this.waveAsset.width / 2 - _loc1_.width / 2;
         _loc1_.y = this.waveAsset.height / 2 - _loc1_.height / 2 - 15;
         this.waveStartContainer.addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeWaveNumberText() : StaticTextDisplay
      {
         var _loc1_:StaticTextDisplay = new StaticTextDisplay();
         _loc1_.setSize(40).setBold(true).setColor(16567065);
         _loc1_.y = this.waveText.y + this.waveText.height - 5;
         _loc1_.filters = [new DropShadowFilter(0,0,0,1,8,8,2)];
         this.waveStartContainer.addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeWaveAsset() : *
      {
         var _loc1_:* = new this.WaveAsset();
         this.waveStartContainer.addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeStartText() : StaticTextDisplay
      {
         var _loc1_:StaticTextDisplay = new StaticTextDisplay();
         _loc1_.setSize(32).setBold(true).setColor(11776947);
         _loc1_.setStringBuilder(new LineBuilder().setParams(TextKey.ARENA_COUNTDOWN_CLOCK_START));
         _loc1_.y = this.waveAsset.y + this.waveAsset.height - 5;
         _loc1_.x = this.waveAsset.width / 2 - _loc1_.width / 2;
         _loc1_.filters = [new DropShadowFilter(0,0,0,1,8,8,2)];
         this.waveStartContainer.addChild(_loc1_);
         return _loc1_;
      }
   }
}

