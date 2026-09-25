package com.company.assembleegameclient.ui.options
{
   import com.company.assembleegameclient.ui.tooltip.TextToolTip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StringBuilder;
   
   public class BaseOption extends Option
   {
      
      public var paramName_:String;
      
      private var tooltipText_:String;
      
      protected var tooltip_:TextToolTip;
      
      protected var desc_:TextFieldDisplayConcrete;
      
      public function BaseOption(param1:String, param2:String, param3:String)
      {
         super();
         this.paramName_ = param1;
         this.tooltipText_ = param3;
         this.desc_ = new TextFieldDisplayConcrete().setSize(18).setColor(11776947);
         this.desc_.setStringBuilder(new LineBuilder().setParams(param2));
         this.desc_.filters = [new DropShadowFilter(0,0,0,1,4,4,2)];
         this.desc_.x = KeyCodeBox.WIDTH + 24;
         this.desc_.mouseEnabled = true;
         this.desc_.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.desc_.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         addChild(this.desc_);
         this.tooltip_ = new TextToolTip(2565927,8553090,null,this.tooltipText_,150);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         textChanged = this.desc_.textChanged;
      }
      
      public function setDescription(param1:StringBuilder) : void
      {
         this.desc_.setStringBuilder(param1);
      }
      
      public function setTooltipText(param1:StringBuilder) : void
      {
         this.tooltip_.setText(param1);
      }
      
      public function refresh() : void
      {
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         parent.addChild(this.tooltip_);
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         this.removeToolTip();
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         this.removeToolTip();
      }
      
      private function removeToolTip() : void
      {
         if(this.tooltip_ != null && parent.contains(this.tooltip_))
         {
            parent.removeChild(this.tooltip_);
         }
      }
   }
}

