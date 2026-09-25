package kabam.rotmg.ui.view.components.dropdown
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import org.osflash.signals.Signal;
   
   public class LocalizedDropDownItem extends Sprite
   {
      
      public var w_:int;
      
      public var h_:int;
      
      private var name_:String;
      
      private var nameText_:TextFieldDisplayConcrete;
      
      private var nameLineBuilder_:LineBuilder = new LineBuilder();
      
      public function LocalizedDropDownItem(param1:String, param2:int, param3:int)
      {
         super();
         this.w_ = param2;
         this.h_ = param3;
         this.name_ = param1;
         mouseChildren = false;
         this.nameText_ = new TextFieldDisplayConcrete().setSize(16).setColor(11776947).setBold(true);
         this.nameText_.setStringBuilder(this.nameLineBuilder_.setParams(param1));
         this.nameText_.filters = [new DropShadowFilter(0,0,0)];
         addChild(this.nameText_);
         this.drawBackground(3552822);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      public function getTextChanged() : Signal
      {
         return this.nameText_.textChanged;
      }
      
      public function getValue() : String
      {
         return this.name_;
      }
      
      public function setValue(param1:String) : void
      {
         this.name_ = param1;
         this.nameText_.setStringBuilder(this.nameLineBuilder_.setParams(param1));
      }
      
      public function setWidth(param1:int) : void
      {
         this.w_ = param1;
         this.nameText_.x = this.w_ / 2 - this.nameText_.width / 2;
         this.nameText_.y = this.h_ / 2 - this.nameText_.height / 2;
         this.drawBackground(3552822);
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         this.drawBackground(5658198);
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         this.drawBackground(3552822);
      }
      
      private function drawBackground(param1:uint) : void
      {
         graphics.clear();
         graphics.lineStyle(2,5526612);
         graphics.beginFill(param1,1);
         graphics.drawRect(0,0,this.w_,this.h_);
         graphics.endFill();
         graphics.lineStyle();
      }
   }
}

