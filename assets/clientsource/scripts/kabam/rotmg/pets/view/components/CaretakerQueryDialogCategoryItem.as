package kabam.rotmg.pets.view.components
{
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.pets.view.dialogs.CaretakerQueryDialog;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.util.graphics.BevelRect;
   import kabam.rotmg.util.graphics.GraphicsHelper;
   import org.osflash.signals.Signal;
   
   public class CaretakerQueryDialogCategoryItem extends Sprite
   {
      
      private static const WIDTH:int = CaretakerQueryDialog.WIDTH - 40;
      
      private static const HEIGHT:int = 40;
      
      private static const BEVEL:int = 2;
      
      private static const OUT:uint = 6052956;
      
      private static const OVER:uint = 8355711;
      
      public var info:String;
      
      private const helper:GraphicsHelper = new GraphicsHelper();
      
      private const rect:BevelRect = new BevelRect(WIDTH,HEIGHT,BEVEL);
      
      private const background:Shape = this.makeBackground();
      
      private const textfield:TextFieldDisplayConcrete = this.makeTextfield();
      
      public const textChanged:Signal = this.textfield.textChanged;
      
      public function CaretakerQueryDialogCategoryItem(param1:String, param2:String)
      {
         super();
         this.info = param2;
         this.textfield.setStringBuilder(new LineBuilder().setParams(param1));
         this.makeInteractive();
      }
      
      private function makeBackground() : Shape
      {
         var _loc1_:Shape = new Shape();
         this.drawBackground(_loc1_,OUT);
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function drawBackground(param1:Shape, param2:uint) : void
      {
         param1.graphics.clear();
         param1.graphics.beginFill(param2);
         this.helper.drawBevelRect(0,0,this.rect,param1.graphics);
         param1.graphics.endFill();
      }
      
      private function makeTextfield() : TextFieldDisplayConcrete
      {
         var _loc1_:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setColor(16777215).setBold(true).setAutoSize(TextFieldAutoSize.CENTER).setVerticalAlign(TextFieldDisplayConcrete.MIDDLE).setPosition(WIDTH / 2,HEIGHT / 2);
         _loc1_.mouseEnabled = false;
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeInteractive() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         this.drawBackground(this.background,OVER);
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         this.drawBackground(this.background,OUT);
      }
   }
}

