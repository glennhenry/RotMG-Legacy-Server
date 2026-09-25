package kabam.rotmg.news.view
{
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.text.model.FontModel;
   
   public class NewsTicker extends Sprite
   {
      
      private static var pendingScrollText:String = "";
      
      private const WIDTH:int = 280;
      
      private const HEIGHT:int = 25;
      
      private const MAX_REPEATS:int = 2;
      
      public var scrollText:TextField;
      
      private var timer:Timer;
      
      private const SCROLL_PREPEND:String = "                                                                               ";
      
      private const SCROLL_APPEND:String = "                                                                                ";
      
      private var currentRepeat:uint = 0;
      
      private var scrollOffset:int = 0;
      
      public function NewsTicker()
      {
         super();
         this.scrollText = this.createScrollText();
         this.timer = new Timer(0.17,0);
         this.drawBackground();
         this.align();
         this.visible = false;
         if(NewsTicker.pendingScrollText != "")
         {
            this.activateNewScrollText(NewsTicker.pendingScrollText);
            NewsTicker.pendingScrollText = "";
         }
      }
      
      public static function setPendingScrollText(param1:String) : void
      {
         NewsTicker.pendingScrollText = param1;
      }
      
      public function activateNewScrollText(param1:String) : void
      {
         if(this.visible == false)
         {
            this.visible = true;
            this.scrollText.text = this.SCROLL_PREPEND + param1 + this.SCROLL_APPEND;
            this.timer.addEventListener(TimerEvent.TIMER,this.scrollAnimation);
            this.currentRepeat = 1;
            this.timer.start();
            return;
         }
      }
      
      private function scrollAnimation(param1:TimerEvent) : void
      {
         this.timer.stop();
         if(this.scrollText.scrollH < this.scrollText.maxScrollH)
         {
            ++this.scrollOffset;
            this.scrollText.scrollH = this.scrollOffset;
            this.timer.start();
         }
         else if(this.currentRepeat >= 1 && this.currentRepeat < this.MAX_REPEATS)
         {
            ++this.currentRepeat;
            this.scrollOffset = 0;
            this.scrollText.scrollH = 0;
            this.timer.start();
         }
         else
         {
            this.currentRepeat = 0;
            this.scrollOffset = 0;
            this.scrollText.scrollH = 0;
            this.timer.removeEventListener(TimerEvent.TIMER,this.scrollAnimation);
            this.visible = false;
         }
      }
      
      private function align() : void
      {
         this.scrollText.x = 5;
         this.scrollText.y = 2;
      }
      
      private function drawBackground() : void
      {
         graphics.beginFill(0,0.4);
         graphics.drawRoundRect(0,0,this.WIDTH,this.HEIGHT,12,12);
         graphics.endFill();
      }
      
      private function createScrollText() : TextField
      {
         var _loc1_:TextField = null;
         _loc1_ = new TextField();
         var _loc2_:FontModel = StaticInjectorContext.getInjector().getInstance(FontModel);
         _loc2_.apply(_loc1_,16,16777215,false);
         _loc1_.selectable = false;
         _loc1_.doubleClickEnabled = false;
         _loc1_.mouseEnabled = false;
         _loc1_.mouseWheelEnabled = false;
         _loc1_.text = "";
         _loc1_.wordWrap = false;
         _loc1_.multiline = false;
         _loc1_.selectable = false;
         _loc1_.width = this.WIDTH - 10;
         _loc1_.height = 25;
         addChild(_loc1_);
         return _loc1_;
      }
   }
}

