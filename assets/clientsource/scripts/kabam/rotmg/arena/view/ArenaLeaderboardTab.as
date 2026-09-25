package kabam.rotmg.arena.view
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.arena.model.ArenaLeaderboardFilter;
   import kabam.rotmg.text.view.StaticTextDisplay;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import org.osflash.signals.Signal;
   
   public class ArenaLeaderboardTab extends Sprite
   {
      
      private static const OVER_COLOR:int = 16567065;
      
      private static const DOWN_COLOR:int = 16777215;
      
      private static const OUT_COLOR:int = 11711154;
      
      public var label:StaticTextDisplay = this.makeLabel();
      
      public const readyToAlign:Signal = this.label.textChanged;
      
      public const selected:Signal = new Signal(ArenaLeaderboardTab);
      
      private var filter:ArenaLeaderboardFilter;
      
      private var isOver:Boolean;
      
      private var isDown:Boolean;
      
      private var isSelected:Boolean = false;
      
      public function ArenaLeaderboardTab(param1:ArenaLeaderboardFilter)
      {
         super();
         this.filter = param1;
         this.label.setStringBuilder(new LineBuilder().setParams(param1.getName()));
         addChild(this.label);
         this.addMouseListeners();
      }
      
      public function destroy() : void
      {
         this.removeMouseListeners();
      }
      
      public function getFilter() : ArenaLeaderboardFilter
      {
         return this.filter;
      }
      
      public function setSelected(param1:Boolean) : void
      {
         this.isSelected = param1;
         this.redraw();
      }
      
      private function addMouseListeners() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function removeMouseListeners() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(!this.isSelected)
         {
            this.selected.dispatch(this);
         }
      }
      
      private function redraw() : void
      {
         if(this.isOver)
         {
            this.label.setColor(OVER_COLOR);
         }
         else if(this.isSelected || this.isDown)
         {
            this.label.setColor(DOWN_COLOR);
         }
         else
         {
            this.label.setColor(OUT_COLOR);
         }
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         this.isDown = false;
         this.redraw();
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         this.isDown = true;
         this.redraw();
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         this.isOver = false;
         this.isDown = false;
         this.redraw();
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         this.isOver = true;
         this.redraw();
      }
      
      private function makeLabel() : StaticTextDisplay
      {
         var _loc1_:StaticTextDisplay = null;
         _loc1_ = new StaticTextDisplay();
         _loc1_.setBold(true).setColor(11776947).setSize(20);
         _loc1_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         return _loc1_;
      }
   }
}

