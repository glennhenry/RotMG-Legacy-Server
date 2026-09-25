package kabam.rotmg.assets.services
{
   import com.company.assembleegameclient.util.AnimatedChar;
   import com.company.assembleegameclient.util.AnimatedChars;
   import com.company.assembleegameclient.util.MaskedImage;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
   import com.company.util.BitmapUtil;
   import flash.display.BitmapData;
   import kabam.rotmg.assets.model.Animation;
   import kabam.rotmg.assets.model.CharacterTemplate;
   
   public class CharacterFactory
   {
      
      private var texture1:int;
      
      private var texture2:int;
      
      private var size:int;
      
      public function CharacterFactory()
      {
         super();
      }
      
      public function makeCharacter(param1:CharacterTemplate) : AnimatedChar
      {
         return AnimatedChars.getAnimatedChar(param1.file,param1.index);
      }
      
      public function makeIcon(param1:CharacterTemplate, param2:int = 100, param3:int = 0, param4:int = 0) : BitmapData
      {
         this.texture1 = param3;
         this.texture2 = param4;
         this.size = param2;
         var _loc5_:AnimatedChar = this.makeCharacter(param1);
         var _loc6_:BitmapData = this.makeFrame(_loc5_,AnimatedChar.STAND,0);
         _loc6_ = GlowRedrawer.outlineGlow(_loc6_,0);
         return BitmapUtil.cropToBitmapData(_loc6_,6,6,_loc6_.width - 12,_loc6_.height - 6);
      }
      
      public function makeWalkingIcon(param1:CharacterTemplate, param2:int = 100, param3:int = 0, param4:int = 0) : Animation
      {
         this.texture1 = param3;
         this.texture2 = param4;
         this.size = param2;
         var _loc5_:AnimatedChar = this.makeCharacter(param1);
         var _loc6_:BitmapData = this.makeFrame(_loc5_,AnimatedChar.WALK,0.5);
         _loc6_ = GlowRedrawer.outlineGlow(_loc6_,0);
         var _loc7_:BitmapData = this.makeFrame(_loc5_,AnimatedChar.WALK,0);
         _loc7_ = GlowRedrawer.outlineGlow(_loc7_,0);
         var _loc8_:Animation = new Animation();
         _loc8_.setFrames(_loc6_,_loc7_);
         return _loc8_;
      }
      
      private function makeFrame(param1:AnimatedChar, param2:int, param3:Number) : BitmapData
      {
         var _loc4_:MaskedImage = param1.imageFromDir(AnimatedChar.RIGHT,param2,param3);
         return TextureRedrawer.resize(_loc4_.image_,_loc4_.mask_,this.size,false,this.texture1,this.texture2);
      }
   }
}

