package kabam.rotmg.packages.view
{
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.AssetLibrary;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   
   public class GoldDisplay extends Sprite
   {
      
      internal var graphic:DisplayObject;
      
      internal var text:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(18).setColor(16777215);
      
      public function GoldDisplay()
      {
         super();
      }
      
      public function init() : void
      {
         var _loc1_:BitmapData = AssetLibrary.getImageFromSet("lofiObj3",225);
         _loc1_ = TextureRedrawer.redraw(_loc1_,40,true,0);
         this.graphic = new Bitmap(_loc1_);
         addChild(this.graphic);
         addChild(this.text);
         this.graphic.x = -this.graphic.width - 8;
         this.graphic.y = -this.graphic.height / 2 - 6;
         this.text.textChanged.add(this.onTextChanged);
      }
      
      private function onTextChanged() : void
      {
         this.text.x = this.graphic.x - this.text.width + 4;
         this.text.y = -this.text.height / 2 - 6;
      }
      
      public function setGold(param1:int) : void
      {
         this.text.setStringBuilder(new StaticStringBuilder(String(param1)));
      }
   }
}

