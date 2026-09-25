package kabam.rotmg.util.components
{
   import flash.display.Sprite;
   import kabam.lib.ui.api.Scrollbar;
   import org.osflash.signals.Signal;
   
   public class VerticalScrollbar extends Sprite implements Scrollbar
   {
      
      public static const WIDTH:int = 20;
      
      public static const BEVEL:int = 4;
      
      public static const PADDING:int = 0;
      
      private var _positionChanged:Signal;
      
      public const groove:VerticalScrollbarGroove = new VerticalScrollbarGroove();
      
      public const bar:VerticalScrollbarBar = new VerticalScrollbarBar();
      
      private var position:Number = 0;
      
      private var range:int;
      
      private var invRange:Number;
      
      private var isEnabled:Boolean = true;
      
      public function VerticalScrollbar()
      {
         super();
         addChild(this.groove);
         addChild(this.bar);
         this.addMouseListeners();
      }
      
      public function get positionChanged() : Signal
      {
         return this._positionChanged = this._positionChanged || new Signal(Number);
      }
      
      public function getIsEnabled() : Boolean
      {
         return this.isEnabled;
      }
      
      public function setIsEnabled(param1:Boolean) : void
      {
         if(this.isEnabled != param1)
         {
            this.isEnabled = param1;
            if(param1)
            {
               this.addMouseListeners();
            }
            else
            {
               this.removeMouseListeners();
            }
         }
      }
      
      private function addMouseListeners() : void
      {
         this.groove.addMouseListeners();
         this.groove.clicked.add(this.onGrooveClicked);
         this.bar.addMouseListeners();
         this.bar.dragging.add(this.onBarDrag);
         this.bar.scrolling.add(this.scrollPosition);
      }
      
      private function removeMouseListeners() : void
      {
         this.groove.removeMouseListeners();
         this.groove.clicked.remove(this.onGrooveClicked);
         this.bar.removeMouseListeners();
         this.bar.dragging.remove(this.onBarDrag);
         this.bar.scrolling.remove(this.scrollPosition);
      }
      
      public function setSize(param1:int, param2:int) : void
      {
         this.bar.rect.height = param1;
         this.groove.rect.height = param2;
         this.range = param2 - param1 - PADDING * 2;
         this.invRange = 1 / this.range;
         this.groove.redraw();
         this.bar.redraw();
         this.setPosition(this.getPosition());
      }
      
      public function getBarSize() : int
      {
         return this.bar.rect.height;
      }
      
      public function getGrooveSize() : int
      {
         return this.groove.rect.height;
      }
      
      public function getPosition() : Number
      {
         return this.position;
      }
      
      public function setPosition(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         else if(param1 > 1)
         {
            param1 = 1;
         }
         this.position = param1;
         this.bar.y = PADDING + this.range * this.position;
         this._positionChanged && this._positionChanged.dispatch(this.position);
      }
      
      public function scrollPosition(param1:Number) : void
      {
         var _loc2_:Number = this.position + param1;
         this.setPosition(_loc2_);
      }
      
      private function onBarDrag(param1:int) : void
      {
         this.setPosition((param1 - PADDING) * this.invRange);
      }
      
      private function onGrooveClicked(param1:int) : void
      {
         var _loc2_:int = this.bar.rect.height;
         var _loc3_:int = param1 - _loc2_ * 0.5;
         var _loc4_:int = this.groove.rect.height - _loc2_;
         this.setPosition(_loc3_ / _loc4_);
      }
   }
}

