package kabam.rotmg.messaging.impl
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import flash.utils.getTimer;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class JitterWatcher extends Sprite
   {
      
      private static const lineBuilder:LineBuilder = new LineBuilder();
      
      private var text_:TextFieldDisplayConcrete = null;
      
      private var lastRecord_:int = -1;
      
      private var ticks_:Vector.<int> = new Vector.<int>();
      
      private var sum_:int;
      
      public function JitterWatcher()
      {
         super();
         this.text_ = new TextFieldDisplayConcrete().setSize(14).setColor(16777215);
         this.text_.setAutoSize(TextFieldAutoSize.LEFT);
         this.text_.filters = [new DropShadowFilter(0,0,0)];
         addChild(this.text_);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function record() : void
      {
         var _loc3_:int = 0;
         var _loc1_:int = getTimer();
         if(this.lastRecord_ == -1)
         {
            this.lastRecord_ = _loc1_;
            return;
         }
         var _loc2_:int = _loc1_ - this.lastRecord_;
         this.ticks_.push(_loc2_);
         this.sum_ += _loc2_;
         if(this.ticks_.length > 50)
         {
            _loc3_ = this.ticks_.shift();
            this.sum_ -= _loc3_;
         }
         this.lastRecord_ = _loc1_;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         stage.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         this.text_.setStringBuilder(lineBuilder.setParams(TextKey.JITTERWATCHER_DESC,{"jitter":this.jitter()}));
      }
      
      private function jitter() : Number
      {
         var _loc4_:int = 0;
         var _loc1_:int = int(this.ticks_.length);
         if(_loc1_ == 0)
         {
            return 0;
         }
         var _loc2_:Number = this.sum_ / _loc1_;
         var _loc3_:Number = 0;
         for each(_loc4_ in this.ticks_)
         {
            _loc3_ += (_loc4_ - _loc2_) * (_loc4_ - _loc2_);
         }
         return Math.sqrt(_loc3_ / _loc1_);
      }
   }
}

