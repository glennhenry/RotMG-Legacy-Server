package com.company.assembleegameclient.editor
{
   import com.company.ui.BaseSimpleText;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CommandMenuItem extends Sprite
   {
      
      private static const WIDTH:int = 80;
      
      private static const HEIGHT:int = 25;
      
      public var callback_:Function;
      
      public var command_:int;
      
      private var over_:Boolean = false;
      
      private var down_:Boolean = false;
      
      private var selected_:Boolean = false;
      
      private var text_:BaseSimpleText;
      
      public function CommandMenuItem(param1:String, param2:Function, param3:int)
      {
         super();
         this.callback_ = param2;
         this.command_ = param3;
         this.text_ = new BaseSimpleText(16,16777215,false,0,0);
         this.text_.setBold(true);
         this.text_.text = param1;
         this.text_.updateMetrics();
         this.text_.x = 2;
         addChild(this.text_);
         this.redraw();
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      public function setSelected(param1:Boolean) : void
      {
         this.selected_ = param1;
         this.redraw();
      }
      
      public function setLabel(param1:String) : void
      {
         this.text_.text = param1;
         this.text_.updateMetrics();
      }
      
      private function redraw() : void
      {
         graphics.clear();
         if(this.selected_ || this.down_)
         {
            graphics.lineStyle(2,16777215);
            graphics.beginFill(8355711,1);
            graphics.drawRect(0,0,WIDTH,HEIGHT);
            graphics.endFill();
            graphics.lineStyle();
         }
         else if(this.over_)
         {
            graphics.lineStyle(2,16777215);
            graphics.beginFill(0,0);
            graphics.drawRect(0,0,WIDTH,HEIGHT);
            graphics.endFill();
            graphics.lineStyle();
         }
         else
         {
            graphics.lineStyle(1,16777215);
            graphics.beginFill(0,0);
            graphics.drawRect(0,0,WIDTH,HEIGHT);
            graphics.endFill();
            graphics.lineStyle();
         }
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         this.over_ = true;
         this.redraw();
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         this.over_ = false;
         this.down_ = false;
         this.redraw();
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         this.down_ = true;
         this.redraw();
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         this.down_ = false;
         this.redraw();
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         this.callback_(this);
      }
   }
}

