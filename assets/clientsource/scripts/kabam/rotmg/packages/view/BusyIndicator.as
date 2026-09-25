package kabam.rotmg.packages.view
{
   import flash.display.BlendMode;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class BusyIndicator extends Sprite
   {
      
      private const pinwheel:Sprite = this.makePinWheel();
      
      private const innerCircleMask:Sprite = this.makeInner();
      
      private const quarterCircleMask:Sprite = this.makeQuarter();
      
      private const timer:Timer = new Timer(25);
      
      private const radius:int = 22;
      
      private const color:uint = 16777215;
      
      public function BusyIndicator()
      {
         super();
         x = y = this.radius;
         this.addChildren();
         addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
      }
      
      private function makePinWheel() : Sprite
      {
         var _loc1_:Sprite = null;
         _loc1_ = new Sprite();
         _loc1_.blendMode = BlendMode.LAYER;
         _loc1_.graphics.beginFill(this.color);
         _loc1_.graphics.drawCircle(0,0,this.radius);
         _loc1_.graphics.endFill();
         return _loc1_;
      }
      
      private function makeInner() : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.blendMode = BlendMode.ERASE;
         _loc1_.graphics.beginFill(16777215 * 0.6);
         _loc1_.graphics.drawCircle(0,0,this.radius / 2);
         _loc1_.graphics.endFill();
         return _loc1_;
      }
      
      private function makeQuarter() : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215);
         _loc1_.graphics.drawRect(0,0,this.radius,this.radius);
         _loc1_.graphics.endFill();
         return _loc1_;
      }
      
      private function addChildren() : void
      {
         this.pinwheel.addChild(this.innerCircleMask);
         this.pinwheel.addChild(this.quarterCircleMask);
         this.pinwheel.mask = this.quarterCircleMask;
         addChild(this.pinwheel);
      }
      
      private function onAdded(param1:Event) : void
      {
         this.timer.addEventListener(TimerEvent.TIMER,this.updatePinwheel);
         this.timer.start();
      }
      
      private function onRemoved(param1:Event) : void
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.updatePinwheel);
      }
      
      private function updatePinwheel(param1:TimerEvent) : void
      {
         this.quarterCircleMask.rotation += 20;
      }
   }
}

