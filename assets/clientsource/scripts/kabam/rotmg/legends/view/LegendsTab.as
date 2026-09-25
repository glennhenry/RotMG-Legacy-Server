package kabam.rotmg.legends.view
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import kabam.rotmg.legends.model.Timespan;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import org.osflash.signals.Signal;
   
   public class LegendsTab extends Sprite
   {
      
      private static const OVER_COLOR:int = 16567065;
      
      private static const DOWN_COLOR:int = 16777215;
      
      private static const OUT_COLOR:int = 11711154;
      
      public const selected:Signal = new Signal(LegendsTab);
      
      private var timespan:Timespan;
      
      private var label:TextFieldDisplayConcrete;
      
      private var isOver:Boolean;
      
      private var isDown:Boolean;
      
      private var isSelected:Boolean;
      
      public function LegendsTab(param1:Timespan)
      {
         super();
         this.timespan = param1;
         this.makeLabel(param1);
         this.addMouseListeners();
         this.redraw();
      }
      
      public function getTimespan() : Timespan
      {
         return this.timespan;
      }
      
      private function makeLabel(param1:Timespan) : void
      {
         this.label = new TextFieldDisplayConcrete().setSize(20).setColor(16777215);
         this.label.setBold(true);
         this.label.setStringBuilder(new LineBuilder().setParams(param1.getName()));
         this.label.x = 2;
         addChild(this.label);
      }
      
      private function addMouseListeners() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         this.selected.dispatch(this);
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
      
      public function setIsSelected(param1:Boolean) : void
      {
         this.isSelected = param1;
         this.redraw();
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         this.isOver = true;
         this.redraw();
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         this.isOver = false;
         this.isDown = false;
         this.redraw();
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         this.isDown = true;
         this.redraw();
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         this.isDown = false;
         this.redraw();
      }
   }
}

