package kabam.rotmg.fortune.components
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.AssetLibrary;
   import com.company.util.MoreColorUtil;
   import com.gskinner.motion.GTween;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.ui.Mouse;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class CrystalSmall extends Sprite
   {
      
      public static const ANIM_PULSE:int = 1;
      
      public static const ANIM_HOVER:int = 2;
      
      public static const ANIM_CLICKED:int = 3;
      
      private static const ITEM_SIZE:int = 100;
      
      public static const GLOW_STATE_FADE:int = 1;
      
      public static const GLOW_STATE_PULSE:int = 2;
      
      private static const MAX_SHAKE:Number = 5;
      
      public var crystal:Bitmap;
      
      public var crystalGrey:Bitmap;
      
      private var item:ItemWithTooltip;
      
      private var returnX:Number;
      
      private var returnY:Number;
      
      private var crystalFrames:Vector.<Bitmap>;
      
      private const ANIMATION_FRAMES:Number = 3;
      
      private const STARTING_FRAME_INDEX:Number = 80;
      
      private var animationDuration_:Number = 50;
      
      private var isTrackingMouse_:Boolean = false;
      
      private var isExcitingMode_:Boolean = false;
      
      private const EXCITING_MODE_SQUARE_RANGE:int = 3500;
      
      public var active:Boolean = false;
      
      private var startFrame_:Number = 0;
      
      private var frameOffset_:Number = 0;
      
      private var dtBuildup_:Number = 0;
      
      private var numFramesofLoop_:Number;
      
      public var currentAnimation:int;
      
      public var size_:int = 100;
      
      private var itemNameField:TextField;
      
      private var originX:Number = 0;
      
      private var originY:Number = 0;
      
      private var shake:Boolean = false;
      
      private var shakeCount:int = 0;
      
      private var glowState:int = -1;
      
      private var pulsePolarity:Boolean = false;
      
      private var glowFilter:GlowFilter;
      
      public function CrystalSmall()
      {
         var _loc1_:BitmapData = null;
         var _loc2_:uint = 0;
         this.itemNameField = new TextField();
         super();
         this.crystalFrames = new Vector.<Bitmap>();
         _loc2_ = 0;
         while(_loc2_ < 3)
         {
            _loc1_ = AssetLibrary.getImageFromSet("lofiCharBig",this.STARTING_FRAME_INDEX + _loc2_);
            _loc1_ = TextureRedrawer.redraw(_loc1_,this.size_,true,16777215,true);
            this.crystalFrames.push(new Bitmap(_loc1_));
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 3)
         {
            _loc1_ = AssetLibrary.getImageFromSet("lofiCharBig",this.STARTING_FRAME_INDEX + 16 + _loc2_);
            _loc1_ = TextureRedrawer.redraw(_loc1_,this.size_,true,16777215,true);
            this.crystalFrames.push(new Bitmap(_loc1_));
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 7)
         {
            _loc1_ = AssetLibrary.getImageFromSet("lofiCharBig",this.STARTING_FRAME_INDEX + 32 + _loc2_);
            _loc1_ = TextureRedrawer.redraw(_loc1_,this.size_,true,16777215,true);
            this.crystalFrames.push(new Bitmap(_loc1_));
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 7)
         {
            _loc1_ = AssetLibrary.getImageFromSet("lofiCharBig",this.STARTING_FRAME_INDEX + 48 + _loc2_);
            _loc1_ = TextureRedrawer.redraw(_loc1_,this.size_,true,16777215,true);
            this.crystalFrames.push(new Bitmap(_loc1_));
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 5)
         {
            _loc1_ = AssetLibrary.getImageFromSet("lofiCharBig",this.STARTING_FRAME_INDEX + 64 + _loc2_);
            _loc1_ = TextureRedrawer.redraw(_loc1_,this.size_,true,16777215,true);
            this.crystalFrames.push(new Bitmap(_loc1_));
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 8)
         {
            _loc1_ = AssetLibrary.getImageFromSet("lofiCharBig",this.STARTING_FRAME_INDEX + 80 + _loc2_);
            _loc1_ = TextureRedrawer.redraw(_loc1_,this.size_,true,16777215,true);
            this.crystalFrames.push(new Bitmap(_loc1_));
            _loc2_++;
         }
         _loc1_ = AssetLibrary.getImageFromSet("lofiCharBig",256);
         _loc1_ = TextureRedrawer.redraw(_loc1_,this.size_,true,0,true);
         this.crystal = new Bitmap(_loc1_);
         this.crystal.alpha = 0;
         addChild(this.crystal);
         this.crystalGrey = new Bitmap(_loc1_);
         this.crystalGrey.filters = [new ColorMatrixFilter(MoreColorUtil.greyscaleFilterMatrix)];
         this.crystalGrey.alpha = 1;
         this.active = false;
         addChild(this.crystalGrey);
         this.glowFilter = new GlowFilter(49151,1,45,45,1.5);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver,false,0,true);
         addEventListener(MouseEvent.ROLL_OUT,this.onMouseOutClip,false,0,true);
         this.setInactive();
      }
      
      public function setXPos(param1:Number) : void
      {
         this.x = param1 - this.width / 2;
      }
      
      public function setYPos(param1:Number) : void
      {
         this.y = param1 - this.height / 2;
      }
      
      private function calculateXPos(param1:Number) : Number
      {
         return param1 - this.width / 2;
      }
      
      private function calculateYPos(param1:Number) : Number
      {
         return param1 - this.height / 2;
      }
      
      public function getCenterX() : Number
      {
         return this.x + this.width / 2;
      }
      
      public function getCenterY() : Number
      {
         return this.y + this.height / 2;
      }
      
      public function returnCenterX() : Number
      {
         return this.returnX + this.width / 2;
      }
      
      public function returnCenterY() : Number
      {
         return this.returnY + this.width / 2;
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.removeItemReveal();
         this.crystal = null;
         this.crystalGrey = null;
         this.item = null;
         this.crystalFrames = null;
      }
      
      public function setGlowState(param1:int) : void
      {
         this.glowState = param1;
         if(this.glowState == GLOW_STATE_PULSE)
         {
            this.glowFilter.alpha = 1;
         }
      }
      
      public function doItemReveal(param1:int) : void
      {
         if(this.parent == null || this.parent.parent == null)
         {
            return;
         }
         this.removeItemReveal();
         this.item = new ItemWithTooltip(param1);
         this.item.itemBitmap.alpha = 1;
         parent.addChild(this.item);
         this.item.setXPos(this.getCenterX());
         this.item.setYPos(this.getCenterY());
         FortuneModal.doEaseOutInAnimation(this.item,{
            "scaleX":1.25,
            "scaleY":1.25
         },{
            "scaleX":1,
            "scaleY":1
         });
         this.setInactive();
      }
      
      public function removeItemReveal() : void
      {
         if(this.item != null && Boolean(this.item.parent))
         {
            parent.removeChild(this.item);
         }
         if(this.itemNameField != null && Boolean(this.itemNameField.parent))
         {
            parent.removeChild(this.itemNameField);
         }
      }
      
      public function doItemShow(param1:int) : void
      {
         if(this.parent == null || this.parent.parent == null)
         {
            return;
         }
         this.removeItemReveal();
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.size = 18;
         _loc2_.font = "Myriad Pro";
         _loc2_.bold = false;
         _loc2_.align = TextFormatAlign.LEFT;
         _loc2_.leftMargin = 0;
         _loc2_.indent = 0;
         _loc2_.leading = 0;
         this.itemNameField.text = LineBuilder.getLocalizedStringFromKey(ObjectLibrary.typeToDisplayId_[param1]);
         this.itemNameField.textColor = 16777215;
         this.itemNameField.autoSize = TextFieldAutoSize.CENTER;
         this.itemNameField.selectable = false;
         this.itemNameField.defaultTextFormat = _loc2_;
         this.itemNameField.setTextFormat(_loc2_);
         this.item = new ItemWithTooltip(param1,ITEM_SIZE);
         this.item.itemBitmap.alpha = 1;
         parent.addChild(this.item);
         this.item.alpha = 0;
         this.item.setXPos(this.getCenterX());
         this.item.setYPos(this.getCenterY());
         this.itemNameField.x = this.item.getCenterX() - this.itemNameField.width / 2;
         this.itemNameField.y = this.item.y + 80;
         parent.addChild(this.itemNameField);
         var _loc3_:GTween = new GTween(this.item,1,{"alpha":1});
         FortuneModal.doEaseOutInAnimation(this.item,{
            "scaleX":1.25,
            "scaleY":1.25
         },{
            "scaleX":1,
            "scaleY":1
         });
         this.setActive();
      }
      
      public function doItemCenter(param1:Number, param2:Number) : void
      {
         this.returnX = this.x;
         this.returnY = this.y;
         var _loc3_:Number = this.calculateXPos(param1);
         var _loc4_:Number = this.calculateYPos(param2);
         var _loc5_:GTween = new GTween(this,0.5,{
            "x":_loc3_,
            "y":_loc4_
         });
      }
      
      public function saveReturnPotion() : void
      {
         this.returnX = this.x;
         this.returnY = this.y;
         this.originX = this.returnCenterX();
         this.originY = this.returnCenterY();
      }
      
      public function doItemReturn() : void
      {
         var _loc1_:GTween = new GTween(this,0.12,{
            "x":this.returnX,
            "y":this.returnY
         });
         this.filters = [this.glowFilter];
         this.setGlowState(GLOW_STATE_PULSE);
      }
      
      public function setActive() : void
      {
         if(!this.active)
         {
            this.crystal.alpha = 0;
            this.crystalGrey.alpha = 1;
            this.setAnimation(0,3);
            this.setAnimationDuration(100);
         }
         this.active = true;
      }
      
      public function setActive2() : void
      {
      }
      
      public function setInactive() : void
      {
         if(this.active)
         {
            if(this.crystal != null)
            {
               this.crystal.alpha = 1;
            }
            if(this.crystalGrey != null)
            {
               this.crystalGrey.alpha = 0;
            }
         }
         this.active = false;
      }
      
      public function update(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         if(this.active)
         {
            if(this.crystal.alpha < 1 && this.crystalGrey.alpha > 0)
            {
               this.crystalGrey.alpha -= 0.03;
               this.crystal.alpha += 0.03;
            }
            else
            {
               this.crystalGrey.alpha = 0;
               this.crystal.alpha = 1;
            }
         }
         else if(this.crystal.alpha > 0 && this.crystalGrey.alpha < 1)
         {
            this.crystalGrey.alpha += 0.03;
            this.crystal.alpha -= 0.03;
         }
         else
         {
            this.crystalGrey.alpha = 1;
            this.crystal.alpha = 0;
         }
         if(this.glowState == GLOW_STATE_FADE)
         {
            this.glowFilter.alpha -= 0.07;
            this.filters = [this.glowFilter];
            if(this.glowFilter.alpha <= 0.03)
            {
               this.filters = [];
            }
         }
         else if(this.glowState == GLOW_STATE_PULSE)
         {
            if(this.glowFilter.alpha >= 0.95 && this.pulsePolarity)
            {
               this.pulsePolarity = false;
            }
            else if(this.glowFilter.alpha <= 0.5 && !this.pulsePolarity)
            {
               this.pulsePolarity = true;
            }
            _loc3_ = this.pulsePolarity ? 1 : -1;
            this.glowFilter.alpha += 0.01 * _loc3_;
            this.filters = [this.glowFilter];
         }
         if(this.isTrackingMouse_)
         {
            _loc4_ = this.squareDistanceTo(FortuneModal.fMouseX,FortuneModal.fMouseY);
            if(_loc4_ <= this.EXCITING_MODE_SQUARE_RANGE)
            {
               if(this.currentAnimation != ANIM_HOVER)
               {
                  this.setAnimationHover();
               }
               this.animationDuration_ = Math.max(_loc4_ / 8,70);
               this.animationDuration_ = Math.min(this.animationDuration_,170);
            }
            else if(this.currentAnimation != ANIM_PULSE)
            {
               this.setAnimationPulse();
            }
         }
         if(this.shake)
         {
            this.setXPos(this.originX + (Math.random() * 6 - 3));
            this.setYPos(this.originY + (Math.random() * 6 - 3));
            ++this.shakeCount;
            if(this.shakeCount == MAX_SHAKE)
            {
               this.shake = false;
               this.shakeCount = 0;
            }
         }
         this.drawAnimation(param1,param2);
      }
      
      public function setShake(param1:Boolean) : void
      {
         this.shake = param1;
      }
      
      public function drawAnimation(param1:int, param2:int) : void
      {
         if(this.active)
         {
            removeChild(this.crystal);
            this.dtBuildup_ += param2;
            if(this.dtBuildup_ > this.animationDuration_)
            {
               this.frameOffset_ = (this.frameOffset_ + 1) % this.numFramesofLoop_;
               this.dtBuildup_ = 0;
            }
            else if(this.frameOffset_ > this.numFramesofLoop_)
            {
               this.frameOffset_ = 0;
            }
            this.crystal = this.crystalFrames[this.startFrame_ + this.frameOffset_];
            if(this.currentAnimation == ANIM_CLICKED)
            {
               if(this.scaleX > 0.01)
               {
                  this.scaleX -= param2 * 0.002;
                  this.scaleY -= param2 * 0.002;
                  this.setXPos(this.originX + Math.random() * 5);
                  this.setYPos(this.originY + Math.random() * 5);
               }
               else
               {
                  this.scaleX = 0.01;
                  this.scaleY = 0.01;
               }
            }
            addChild(this.crystal);
         }
      }
      
      public function setAnimationDuration(param1:Number) : void
      {
         this.animationDuration_ = param1;
      }
      
      public function onMouseOver(param1:MouseEvent) : void
      {
         Mouse.cursor = "hand";
      }
      
      private function onMouseOutClip(param1:MouseEvent) : void
      {
         Mouse.cursor = Parameters.data_.cursorSelect;
      }
      
      public function setMouseTracking(param1:Boolean) : void
      {
         this.isTrackingMouse_ = param1;
      }
      
      private function squareDistanceTo(param1:Number, param2:Number) : Number
      {
         return (this.getCenterX() - param1) * (this.getCenterX() - param1) + (this.getCenterY() - param2) * (this.getCenterY() - param2);
      }
      
      public function reset() : void
      {
         this.active = false;
         this.animationDuration_ = 50;
         this.isTrackingMouse_ = false;
      }
      
      public function setAnimation(param1:Number, param2:Number) : void
      {
         this.startFrame_ = param1;
         this.frameOffset_ = 0;
         this.dtBuildup_ = 0;
         this.numFramesofLoop_ = param2;
         this.currentAnimation = -1;
      }
      
      public function setAnimationPulse() : void
      {
         this.setAnimation(0,3);
         this.animationDuration_ = 250;
         this.currentAnimation = ANIM_PULSE;
      }
      
      public function setAnimationHover() : void
      {
         this.setAnimation(20,13);
         this.currentAnimation = ANIM_HOVER;
      }
      
      public function setAnimationClicked() : void
      {
         this.setAnimation(3,3);
         this.animationDuration_ = 20;
         this.currentAnimation = ANIM_CLICKED;
         this.setMouseTracking(false);
      }
      
      public function resetVars() : void
      {
         this.active = false;
         this.frameOffset_ = 0;
         this.currentAnimation = -1;
         this.animationDuration_ = 50;
         this.isTrackingMouse_ = false;
         this.dtBuildup_ = 0;
         this.startFrame_ = 0;
         this.scaleX = 1;
         this.scaleY = 1;
      }
   }
}

