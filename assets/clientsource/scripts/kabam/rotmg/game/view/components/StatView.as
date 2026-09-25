package kabam.rotmg.game.view.components
{
   import com.company.assembleegameclient.ui.tooltip.TextToolTip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   import org.osflash.signals.natives.NativeSignal;
   
   public class StatView extends Sprite
   {
      
      public var fullName_:String;
      
      public var description_:String;
      
      public var nameText_:TextFieldDisplayConcrete;
      
      public var valText_:TextFieldDisplayConcrete;
      
      public var redOnZero_:Boolean;
      
      public var val_:int = -1;
      
      public var boost_:int = -1;
      
      public var valColor_:uint = 11776947;
      
      public var toolTip_:TextToolTip = new TextToolTip(3552822,10197915,"","",200);
      
      public var mouseOver:NativeSignal;
      
      public var mouseOut:NativeSignal;
      
      public function StatView(param1:String, param2:String, param3:String, param4:Boolean)
      {
         super();
         this.fullName_ = param2;
         this.description_ = param3;
         this.nameText_ = new TextFieldDisplayConcrete().setSize(13).setColor(11776947);
         this.nameText_.setStringBuilder(new LineBuilder().setParams(param1));
         this.configureTextAndAdd(this.nameText_);
         this.valText_ = new TextFieldDisplayConcrete().setSize(13).setColor(this.valColor_).setBold(true);
         this.valText_.setStringBuilder(new StaticStringBuilder("-"));
         this.configureTextAndAdd(this.valText_);
         this.redOnZero_ = param4;
         this.mouseOver = new NativeSignal(this,MouseEvent.MOUSE_OVER,MouseEvent);
         this.mouseOut = new NativeSignal(this,MouseEvent.MOUSE_OUT,MouseEvent);
      }
      
      public function configureTextAndAdd(param1:TextFieldDisplayConcrete) : void
      {
         param1.setAutoSize(TextFieldAutoSize.LEFT);
         param1.filters = [new DropShadowFilter(0,0,0)];
         addChild(param1);
      }
      
      public function addTooltip() : void
      {
         this.toolTip_.setTitle(new LineBuilder().setParams(this.fullName_));
         this.toolTip_.setText(new LineBuilder().setParams(this.description_));
         if(!stage.contains(this.toolTip_))
         {
            stage.addChild(this.toolTip_);
         }
      }
      
      public function removeTooltip() : void
      {
         if(this.toolTip_.parent != null)
         {
            this.toolTip_.parent.removeChild(this.toolTip_);
         }
      }
      
      public function draw(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:uint = 0;
         if(param1 == this.val_ && param2 == this.boost_)
         {
            return;
         }
         this.val_ = param1;
         this.boost_ = param2;
         if(param1 - param2 >= param3)
         {
            _loc4_ = 16572160;
         }
         else if(this.redOnZero_ && this.val_ <= 0 || this.boost_ < 0)
         {
            _loc4_ = 16726072;
         }
         else if(this.boost_ > 0)
         {
            _loc4_ = 6206769;
         }
         else
         {
            _loc4_ = 11776947;
         }
         if(this.valColor_ != _loc4_)
         {
            this.valColor_ = _loc4_;
            this.valText_.setColor(this.valColor_);
         }
         var _loc5_:String = this.val_.toString();
         if(this.boost_ != 0)
         {
            _loc5_ += " (" + (this.boost_ > 0 ? "+" : "") + this.boost_.toString() + ")";
         }
         this.valText_.setStringBuilder(new StaticStringBuilder(_loc5_));
         this.valText_.x = this.nameText_.getBounds(this).right;
      }
   }
}

