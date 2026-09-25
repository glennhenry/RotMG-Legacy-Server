package kabam.rotmg.fortune.components
{
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.AssetLibrary;
   import com.company.util.MoreColorUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.ColorMatrixFilter;
   
   public class CrystalMain extends Sprite
   {
      
      public static const ANIMATION_STAGE_PULSE:int = 0;
      
      public static const ANIMATION_STAGE_BUZZING:int = 1;
      
      public static const ANIMATION_STAGE_INNERROTATION:int = 2;
      
      public static const ANIMATION_STAGE_FLASH:int = 3;
      
      public static const ANIMATION_STAGE_WAITING:int = 4;
      
      public static const GLOW_COLOR:int = 0;
      
      public var bigCrystal:Bitmap;
      
      private var crystalFrames:Vector.<Bitmap>;
      
      private const STARTING_FRAME_INDEX:Number = 176;
      
      private var animationDuration_:Number = 210;
      
      private var startFrame_:Number = 0;
      
      private var numFramesofLoop_:Number;
      
      public var size_:int = 150;
      
      public function CrystalMain()
      {
         var _loc1_:BitmapData = null;
         var _loc2_:uint = 0;
         var _loc3_:Bitmap = null;
         super();
         this.crystalFrames = new Vector.<Bitmap>();
         _loc2_ = 0;
         while(_loc2_ < 3)
         {
            _loc1_ = AssetLibrary.getImageFromSet("lofiCharBig",this.STARTING_FRAME_INDEX + _loc2_);
            _loc1_ = TextureRedrawer.redraw(_loc1_,this.size_,true,GLOW_COLOR,false);
            _loc3_ = new Bitmap(_loc1_);
            _loc3_.filters = [new ColorMatrixFilter(MoreColorUtil.greyscaleFilterMatrix)];
            this.crystalFrames.push(_loc3_);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 3)
         {
            _loc1_ = AssetLibrary.getImageFromSet("lofiCharBig",this.STARTING_FRAME_INDEX + 16 + _loc2_);
            _loc1_ = TextureRedrawer.redraw(_loc1_,this.size_,true,GLOW_COLOR,false);
            this.crystalFrames.push(new Bitmap(_loc1_));
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 7)
         {
            _loc1_ = AssetLibrary.getImageFromSet("lofiCharBig",this.STARTING_FRAME_INDEX + 32 + _loc2_);
            _loc1_ = TextureRedrawer.redraw(_loc1_,this.size_,true,GLOW_COLOR,false);
            this.crystalFrames.push(new Bitmap(_loc1_));
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 7)
         {
            _loc1_ = AssetLibrary.getImageFromSet("lofiCharBig",this.STARTING_FRAME_INDEX + 48 + _loc2_);
            _loc1_ = TextureRedrawer.redraw(_loc1_,this.size_,true,GLOW_COLOR,false);
            this.crystalFrames.push(new Bitmap(_loc1_));
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 5)
         {
            _loc1_ = AssetLibrary.getImageFromSet("lofiCharBig",this.STARTING_FRAME_INDEX + 64 + _loc2_);
            _loc1_ = TextureRedrawer.redraw(_loc1_,this.size_,true,GLOW_COLOR,false);
            this.crystalFrames.push(new Bitmap(_loc1_));
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 8)
         {
            _loc1_ = AssetLibrary.getImageFromSet("lofiCharBig",this.STARTING_FRAME_INDEX + 80 + _loc2_);
            _loc1_ = TextureRedrawer.redraw(_loc1_,this.size_,true,GLOW_COLOR,false);
            this.crystalFrames.push(new Bitmap(_loc1_));
            _loc2_++;
         }
         this.reset();
         _loc1_ = AssetLibrary.getImageFromSet("lofiCharBig",32);
         _loc1_ = TextureRedrawer.redraw(_loc1_,this.size_,true,GLOW_COLOR,false);
         this.bigCrystal = new Bitmap(_loc1_);
         addChild(this.bigCrystal);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function reset() : void
      {
         this.setAnimationStage(ANIMATION_STAGE_FLASH);
      }
      
      public function setXPos(param1:Number) : void
      {
         this.x = param1 - this.width / 2;
      }
      
      public function setYPos(param1:Number) : void
      {
         this.y = param1 - this.height / 2;
      }
      
      public function getCenterX() : Number
      {
         return this.x + this.width / 2;
      }
      
      public function getCenterY() : Number
      {
         return this.y + this.height / 2;
      }
      
      public function drawAnimation(param1:int, param2:int) : void
      {
         removeChild(this.bigCrystal);
         this.bigCrystal = this.crystalFrames[this.startFrame_ + uint(param1 / this.animationDuration_ % this.numFramesofLoop_)];
         addChild(this.bigCrystal);
      }
      
      public function setAnimationDuration(param1:Number) : void
      {
         this.animationDuration_ = param1;
      }
      
      public function setAnimation(param1:Number, param2:Number) : void
      {
         this.startFrame_ = param1;
         this.numFramesofLoop_ = param2;
      }
      
      public function setAnimationStage(param1:int) : void
      {
         switch(param1)
         {
            case ANIMATION_STAGE_PULSE:
               this.setAnimation(0,0);
               this.setAnimationDuration(250);
               break;
            case ANIMATION_STAGE_BUZZING:
               this.setAnimation(3,3);
               this.setAnimationDuration(10);
               break;
            case ANIMATION_STAGE_INNERROTATION:
               this.setAnimation(6,7);
               this.setAnimationDuration(80);
               break;
            case ANIMATION_STAGE_FLASH:
               this.setAnimation(13,7);
               this.setAnimationDuration(210);
               break;
            case ANIMATION_STAGE_WAITING:
               this.setAnimation(20,13);
               this.setAnimationDuration(120);
               break;
            default:
               this.setAnimation(13,7);
         }
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.bigCrystal = null;
         this.crystalFrames = null;
      }
   }
}

