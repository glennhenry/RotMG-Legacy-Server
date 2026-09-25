package kabam.rotmg.util.components
{
   import com.company.assembleegameclient.util.Currency;
   import com.company.util.GraphicsUtil;
   import com.company.util.MoreColorUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.IGraphicsData;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   import kabam.rotmg.assets.services.IconFactory;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   import kabam.rotmg.text.view.stringBuilder.StringBuilder;
   import kabam.rotmg.ui.view.SignalWaiter;
   
   public class SpriteBackground extends Sprite
   {
      
      private static const BEVEL:int = 4;
      
      private static const PADDING:int = 2;
      
      public static const coin:BitmapData = IconFactory.makeCoin();
      
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
      
      private var sizeX:Number = 100;
      
      private var sizeY:Number = 100;
      
      public function SpriteBackground(param1:Number, param2:Number)
      {
         super();
         this.prefix = "   ";
         this.sizeX = param1;
         this.sizeY = param2;
         this.price = 1;
         this.currency = Currency.GOLD;
         this.text = new TextFieldDisplayConcrete().setSize(param1).setColor(3552822).setBold(true);
         this.waiter.push(this.text.textChanged);
         var _loc3_:StringBuilder = this.prefix != "" ? this.lineBuilder.setParams(this.prefix,{"cost":this.price.toString()}) : this.staticStringBuilder.setString(this.price.toString());
         this.text.setStringBuilder(_loc3_);
         this.waiter.complete.add(this.updateUI);
         addChild(this.text);
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         if(param1 != mouseEnabled)
         {
            mouseEnabled = param1;
            filters = param1 ? [] : [grayfilter];
            this.draw();
         }
      }
      
      private function updateUI() : void
      {
         this.updateBackground();
         this.draw();
      }
      
      private function updateBackground() : void
      {
         GraphicsUtil.clearPath(this.graphicsPath);
         GraphicsUtil.drawCutEdgeRect(0,0,this.getWidth(),this.getHeight(),BEVEL,[1,1,1,1],this.graphicsPath);
      }
      
      private function draw() : void
      {
         this.graphicsData[0] = mouseEnabled ? this.enabledFill : this.disabledFill;
         graphics.clear();
         graphics.drawGraphicsData(this.graphicsData);
      }
      
      private function getWidth() : int
      {
         return this.sizeX;
      }
      
      private function getHeight() : int
      {
         return this.sizeY;
      }
   }
}

