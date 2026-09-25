package kabam.rotmg.packages.view
{
   import com.company.assembleegameclient.util.TimeUtil;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.packages.model.PackageInfo;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   import kabam.rotmg.ui.UIUtils;
   import org.osflash.signals.Signal;
   
   public class PackageButton extends BasePackageButton
   {
      
      public var clicked:Signal = new Signal();
      
      private const SHOW_DURATION:String = "showDuration";
      
      private const SHOW_QUANTITY:String = "showQuantity";
      
      private var _state:String = "showDuration";
      
      private var _icon:DisplayObject;
      
      internal var durationText:TextFieldDisplayConcrete = makeText();
      
      internal var quantityText:TextFieldDisplayConcrete = makeText();
      
      internal var quantityStringBuilder:StaticStringBuilder = new StaticStringBuilder("");
      
      internal var durationStringBuilder:LineBuilder = new LineBuilder();
      
      public function PackageButton()
      {
         super();
      }
      
      private static function makeText() : TextFieldDisplayConcrete
      {
         var _loc1_:TextFieldDisplayConcrete = null;
         _loc1_ = new TextFieldDisplayConcrete().setSize(16).setColor(16777215);
         _loc1_.filters = [new DropShadowFilter(0,0,0)];
         return _loc1_;
      }
      
      public function init() : void
      {
         addChild(UIUtils.makeStaticHUDBackground());
         addChild(this.durationText);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         this.setIcon(makeIcon());
      }
      
      private function setState(param1:String) : void
      {
         if(this._state == param1)
         {
            return;
         }
         if(param1 == this.SHOW_DURATION)
         {
            removeChild(this.quantityText);
            addChild(this.durationText);
         }
         else
         {
            if(param1 != this.SHOW_QUANTITY)
            {
               throw new Error("PackageButton.setState: Unexpected state " + param1);
            }
            removeChild(this.durationText);
            addChild(this.quantityText);
         }
         this._state = param1;
      }
      
      public function setQuantity(param1:int) : void
      {
         if(param1 == PackageInfo.INFINITE)
         {
            this.setState(this.SHOW_DURATION);
         }
         else
         {
            this.setState(this.SHOW_QUANTITY);
         }
         this.quantityText.textChanged.addOnce(this.layout);
         this.quantityStringBuilder.setString(param1.toString());
         this.quantityText.setStringBuilder(this.quantityStringBuilder);
      }
      
      public function setDuration(param1:int) : void
      {
         var _loc3_:String = null;
         var _loc2_:int = Math.ceil(param1 / TimeUtil.DAY_IN_MS);
         if(_loc2_ > 1)
         {
            _loc3_ = TextKey.PACKAGE_BUTTON_DAYS;
         }
         else
         {
            _loc3_ = TextKey.PACKAGE_BUTTON_DAY;
         }
         this.durationText.textChanged.addOnce(this.layout);
         this.durationStringBuilder.setParams(_loc3_,{"number":_loc2_});
         this.durationText.setStringBuilder(this.durationStringBuilder);
      }
      
      private function layout() : void
      {
         positionText(this._icon,this.durationText);
         positionText(this._icon,this.quantityText);
      }
      
      public function setIcon(param1:DisplayObject) : void
      {
         this._icon = param1;
         addChild(param1);
      }
      
      public function getIcon() : DisplayObject
      {
         return this._icon;
      }
      
      private function onMouseUp(param1:Event) : void
      {
         this.clicked.dispatch();
      }
   }
}

