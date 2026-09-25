package kabam.rotmg.pets.view.components
{
   import com.gskinner.motion.GTween;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import org.osflash.signals.Signal;
   
   public class AnimatedAbilityBar extends Sprite
   {
      
      public const animating:Signal = new Signal(Boolean);
      
      public const filledUp:Signal = new Signal();
      
      private const NORMAL_BAR_COLOR:uint = 11776947;
      
      private const FILLING_BAR_COLOR:uint = 1572859;
      
      private const BACKGROUND_BAR_COLOR:uint = 5658198;
      
      private var animatedBar:Shape = new Shape();
      
      private var backgroundBar:Shape = new Shape();
      
      private var maxPoints:int = 0;
      
      public var currentPoints:int = -1;
      
      private var maxWidth:int = 0;
      
      private var barHeight:int = 0;
      
      public function AnimatedAbilityBar(param1:int, param2:int)
      {
         super();
         this.maxWidth = param1;
         this.barHeight = param2;
         this.backgroundBar.graphics.beginFill(this.BACKGROUND_BAR_COLOR,1);
         this.backgroundBar.graphics.drawRect(0,0,param1,param2);
         addChild(this.backgroundBar);
         addChild(this.animatedBar);
      }
      
      public function reset() : void
      {
         this.currentPoints = 0;
         this.animatedBar.graphics.clear();
         this.animatedBar.graphics.beginFill(this.NORMAL_BAR_COLOR,1);
         this.animatedBar.graphics.drawRect(0,0,1,this.barHeight);
         this.animatedBar.width = 1;
      }
      
      public function fill() : void
      {
         if(this.currentPoints == this.maxPoints)
         {
            this.reset();
            this.filledUp.dispatch();
            return;
         }
         var _loc1_:Number = this.maxWidth;
         this.setBarColor(this.FILLING_BAR_COLOR);
         var _loc2_:GTween = new GTween(this.animatedBar,1,{"width":_loc1_});
         _loc2_.onComplete = this.filled;
      }
      
      private function filled(param1:GTween) : void
      {
         this.filledUp.dispatch();
      }
      
      public function setBarColor(param1:uint) : void
      {
         var _loc2_:ColorTransform = this.animatedBar.transform.colorTransform;
         _loc2_.color = param1;
         this.animatedBar.transform.colorTransform = _loc2_;
      }
      
      public function setMaxPointValue(param1:int) : void
      {
         this.maxPoints = param1;
         this.adjustFilledBar();
      }
      
      public function setCurrentPointValue(param1:int) : void
      {
         var _loc2_:Number = NaN;
         if(this.currentPoints == -1)
         {
            this.currentPoints = param1;
            _loc2_ = this.getBarWidth();
            this.animatedBar.graphics.beginFill(this.NORMAL_BAR_COLOR,1);
            this.animatedBar.graphics.drawRect(0,0,_loc2_,this.barHeight);
         }
         this.currentPoints = param1;
         this.adjustFilledBar();
      }
      
      private function adjustFilledBar() : void
      {
         var _loc2_:GTween = null;
         var _loc1_:int = this.getBarWidth();
         if(this.currentPoints != -1 && this.currentPoints != 0 && _loc1_ != Math.round(this.animatedBar.width))
         {
            this.animating.dispatch(true);
            this.setBarColor(this.FILLING_BAR_COLOR);
            _loc2_ = new GTween(this.animatedBar,2,{"width":_loc1_});
            _loc2_.onComplete = this.handleTweenComplete;
         }
      }
      
      private function getBarWidth() : int
      {
         var _loc1_:int = this.currentPoints * this.maxWidth / this.maxPoints;
         return isNaN(_loc1_) ? 1 : int(Math.round(Math.max(1,Math.min(this.maxWidth,_loc1_))));
      }
      
      public function handleTweenComplete(param1:GTween) : void
      {
         this.setBarColor(this.NORMAL_BAR_COLOR);
         this.animating.dispatch(false);
      }
   }
}

