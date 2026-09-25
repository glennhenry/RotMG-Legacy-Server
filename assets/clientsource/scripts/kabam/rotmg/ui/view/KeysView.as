package kabam.rotmg.ui.view
{
   import flash.display.Sprite;
   import kabam.rotmg.ui.model.Key;
   import mx.core.BitmapAsset;
   
   public class KeysView extends Sprite
   {
      
      private static var keyBackgroundPng:Class = KeysView_keyBackgroundPng;
      
      private static var greenKeyPng:Class = KeysView_greenKeyPng;
      
      private static var redKeyPng:Class = KeysView_redKeyPng;
      
      private static var yellowKeyPng:Class = KeysView_yellowKeyPng;
      
      private static var purpleKeyPng:Class = KeysView_purpleKeyPng;
      
      private var base:BitmapAsset;
      
      private var keys:Vector.<BitmapAsset>;
      
      public function KeysView()
      {
         super();
         this.base = new keyBackgroundPng();
         addChild(this.base);
         this.keys = new Vector.<BitmapAsset>(4,true);
         this.keys[0] = new purpleKeyPng();
         this.keys[1] = new greenKeyPng();
         this.keys[2] = new redKeyPng();
         this.keys[3] = new yellowKeyPng();
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            this.keys[_loc1_].x = 12 + 40 * _loc1_;
            this.keys[_loc1_].y = 12;
            _loc1_++;
         }
      }
      
      public function showKey(param1:Key) : void
      {
         var _loc2_:BitmapAsset = this.keys[param1.position];
         if(!contains(_loc2_))
         {
            addChild(_loc2_);
         }
      }
      
      public function hideKey(param1:Key) : void
      {
         var _loc2_:BitmapAsset = this.keys[param1.position];
         if(contains(_loc2_))
         {
            removeChild(_loc2_);
         }
      }
   }
}

