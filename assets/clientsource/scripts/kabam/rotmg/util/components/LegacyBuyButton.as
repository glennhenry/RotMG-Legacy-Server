package kabam.rotmg.util.components
{
   import com.company.assembleegameclient.util.Currency;
   import com.company.util.GraphicsUtil;
   import com.company.util.MoreColorUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.CapsStyle;
   import flash.display.Graphics;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.GraphicsStroke;
   import flash.display.IGraphicsData;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import kabam.rotmg.assets.services.IconFactory;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   import kabam.rotmg.text.view.stringBuilder.StringBuilder;
   import kabam.rotmg.ui.view.SignalWaiter;
   import kabam.rotmg.util.components.api.BuyButton;
   
   public class LegacyBuyButton extends BuyButton
   {
      
      private static const BEVEL:int = 4;
      
      private static const PADDING:int = 2;
      
      public static const coin:BitmapData = IconFactory.makeCoin();
      
      public static const fortune:BitmapData = IconFactory.makeFortune();
      
      public static const fame:BitmapData = IconFactory.makeFame();
      
      public static const guildFame:BitmapData = IconFactory.makeGuildFame();
      
      private static const grayfilter:ColorMatrixFilter = new ColorMatrixFilter(MoreColorUtil.greyscaleFilterMatrix);
      
      public var prefix:String;
      
      public var text:TextFieldDisplayConcrete;
      
      private var staticStringBuilder:StaticStringBuilder = new StaticStringBuilder("");
      
      private var lineBuilder:LineBuilder = new LineBuilder();
      
      public var icon:Bitmap;
      
      public var price:int = -1;
      
      public var currency:int = -1;
      
      public var _width:int = -1;
      
      private const enabledFill:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
      
      private const disabledFill:GraphicsSolidFill = new GraphicsSolidFill(8355711,1);
      
      private const graphicsPath:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      private const graphicsData:Vector.<IGraphicsData> = new <IGraphicsData>[this.enabledFill,this.graphicsPath,GraphicsUtil.END_FILL];
      
      private const waiter:SignalWaiter = new SignalWaiter();
      
      private var withOutLine:Boolean = false;
      
      private var outLineColor:int = 5526612;
      
      private var fixedWidth:int = -1;
      
      private var fixedHeight:int = -1;
      
      private var textVertMargin:int = 4;
      
      public function LegacyBuyButton(param1:String, param2:int, param3:int, param4:int, param5:Boolean = false)
      {
         super();
         this.prefix = param1;
         this.text = new TextFieldDisplayConcrete().setSize(param2).setColor(3552822).setBold(true);
         this.waiter.push(this.text.textChanged);
         var _loc6_:StringBuilder = param1 != "" ? this.lineBuilder.setParams(param1,{"cost":param3.toString()}) : this.staticStringBuilder.setString(param3.toString());
         this.text.setStringBuilder(_loc6_);
         this.waiter.complete.add(this.updateUI);
         this.waiter.complete.addOnce(this.readyForPlacementDispatch);
         addChild(this.text);
         this.icon = new Bitmap();
         addChild(this.icon);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this.setPrice(param3,param4);
         this.withOutLine = param5;
      }
      
      override public function setPrice(param1:int, param2:int) : void
      {
         var _loc3_:StringBuilder = null;
         if(this.price != param1 || this.currency != param2)
         {
            this.price = param1;
            this.currency = param2;
            _loc3_ = this.prefix != "" ? this.lineBuilder.setParams(this.prefix,{"cost":param1.toString()}) : this.staticStringBuilder.setString(param1.toString());
            this.text.setStringBuilder(_loc3_);
            this.updateUI();
         }
      }
      
      public function setStringBuilder(param1:StringBuilder) : *
      {
         this.text.setStringBuilder(param1);
         this.updateUI();
      }
      
      public function getPrice() : int
      {
         return this.price;
      }
      
      public function setText(param1:String) : void
      {
         this.text.setStringBuilder(new StaticStringBuilder(param1));
         this.updateUI();
      }
      
      override public function setEnabled(param1:Boolean) : void
      {
         if(param1 != mouseEnabled)
         {
            mouseEnabled = param1;
            filters = param1 ? [] : [grayfilter];
            this.draw();
         }
      }
      
      override public function setWidth(param1:int) : void
      {
         this._width = param1;
         this.updateUI();
      }
      
      private function updateUI() : void
      {
         this.updateText();
         this.updateIcon();
         this.updateBackground();
         this.draw();
      }
      
      private function readyForPlacementDispatch() : void
      {
         this.updateUI();
         readyForPlacement.dispatch();
      }
      
      private function updateIcon() : void
      {
         switch(this.currency)
         {
            case Currency.GOLD:
               this.icon.bitmapData = coin;
               break;
            case Currency.FAME:
               this.icon.bitmapData = fame;
               break;
            case Currency.GUILD_FAME:
               this.icon.bitmapData = guildFame;
               break;
            case Currency.FORTUNE:
               this.icon.bitmapData = fortune;
               break;
            default:
               this.icon.bitmapData = null;
         }
         this.updateIconPosition();
      }
      
      private function updateBackground() : void
      {
         GraphicsUtil.clearPath(this.graphicsPath);
         GraphicsUtil.drawCutEdgeRect(0,0,this.getWidth(),this.getHeight(),BEVEL,[1,1,1,1],this.graphicsPath);
      }
      
      private function updateText() : void
      {
         this.text.x = (this.getWidth() - this.icon.width - this.text.width - PADDING) * 0.5;
         this.text.y = this.textVertMargin;
      }
      
      private function updateIconPosition() : void
      {
         this.icon.x = this.text.x + this.text.width + PADDING;
         this.icon.y = (this.getHeight() - this.icon.height - 1) * 0.5;
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         this.enabledFill.color = 16768133;
         this.draw();
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         this.enabledFill.color = 16777215;
         this.draw();
      }
      
      public function draw() : void
      {
         this.graphicsData[0] = mouseEnabled ? this.enabledFill : this.disabledFill;
         graphics.clear();
         graphics.drawGraphicsData(this.graphicsData);
         if(this.withOutLine)
         {
            this.drawOutline(graphics);
         }
      }
      
      private function getWidth() : int
      {
         return this.fixedWidth != -1 ? this.fixedWidth : int(Math.max(this._width,this.text.width + this.icon.width + 3 * PADDING));
      }
      
      private function getHeight() : int
      {
         return this.fixedHeight != -1 ? this.fixedHeight : int(this.text.height + this.textVertMargin * 2);
      }
      
      public function freezeSize() : void
      {
         this.fixedHeight = this.getHeight();
         this.fixedWidth = this.getWidth();
      }
      
      public function unfreezeSize() : void
      {
         this.fixedHeight = -1;
         this.fixedWidth = -1;
      }
      
      public function scaleButtonWidth(param1:Number) : void
      {
         this.fixedWidth = this.getWidth() * param1;
         this.updateUI();
      }
      
      public function scaleButtonHeight(param1:Number) : void
      {
         this.textVertMargin *= param1;
         this.updateUI();
      }
      
      public function setOutLineColor(param1:int) : void
      {
         this.outLineColor = param1;
      }
      
      private function drawOutline(param1:Graphics) : void
      {
         var _loc2_:GraphicsSolidFill = new GraphicsSolidFill(0,0.01);
         var _loc3_:GraphicsSolidFill = new GraphicsSolidFill(this.outLineColor,0.6);
         var _loc4_:GraphicsStroke = new GraphicsStroke(4,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,_loc3_);
         var _loc5_:GraphicsPath = new GraphicsPath();
         GraphicsUtil.drawCutEdgeRect(0,0,this.getWidth(),this.getHeight(),4,GraphicsUtil.ALL_CUTS,_loc5_);
         var _loc6_:Vector.<IGraphicsData> = new <IGraphicsData>[_loc4_,_loc2_,_loc5_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
         param1.drawGraphicsData(_loc6_);
      }
   }
}

