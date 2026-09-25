package kabam.rotmg.chat.view
{
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.AssetLibrary;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import kabam.rotmg.chat.model.ChatModel;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class ChatInputNotAllowed extends Sprite
   {
      
      public static const IMAGE_NAME:String = "lofiInterfaceBig";
      
      public static const IMADE_ID:int = 21;
      
      public function ChatInputNotAllowed()
      {
         super();
         this.makeTextField();
         this.makeSpeechBubble();
      }
      
      public function setup(param1:ChatModel) : void
      {
         x = 0;
         y = param1.bounds.height - param1.lineHeight;
      }
      
      private function makeTextField() : TextFieldDisplayConcrete
      {
         var _loc2_:TextFieldDisplayConcrete = null;
         var _loc1_:LineBuilder = new LineBuilder().setParams(TextKey.CHAT_REGISTER_TO_CHAT);
         _loc2_ = new TextFieldDisplayConcrete();
         _loc2_.setStringBuilder(_loc1_);
         _loc2_.x = 29;
         addChild(_loc2_);
         return _loc2_;
      }
      
      private function makeSpeechBubble() : Bitmap
      {
         var _loc2_:Bitmap = null;
         var _loc1_:BitmapData = AssetLibrary.getImageFromSet(IMAGE_NAME,IMADE_ID);
         _loc1_ = TextureRedrawer.redraw(_loc1_,20,true,0,false);
         _loc2_ = new Bitmap(_loc1_);
         _loc2_.x = -5;
         _loc2_.y = -10;
         addChild(_loc2_);
         return _loc2_;
      }
   }
}

