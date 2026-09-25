package kabam.rotmg.questrewards.components
{
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.getTimer;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.fortune.components.TimerCallback;
   import kabam.rotmg.pets.util.PetsViewAssetFactory;
   import kabam.rotmg.pets.view.components.slot.FoodFeedFuseSlot;
   import kabam.rotmg.text.model.FontModel;
   import kabam.rotmg.util.components.LegacyBuyButton;
   
   public class ModalItemSlot extends FoodFeedFuseSlot
   {
      
      public var interactable:Boolean = false;
      
      private var usageText:TextField;
      
      private var actionButton:LegacyBuyButton = null;
      
      private var animatedOutlines:Vector.<Shape>;
      
      private var curOutline:int = 0;
      
      private var animationDir:int = 1;
      
      private var animationStartIndex:int = 0;
      
      private var marking:TextField;
      
      private var embeddedImage_:Bitmap;
      
      private var embeddedSprite_:Sprite;
      
      private var embeddedSpriteCopy_:Sprite;
      
      private var dir:Number = 0.018;
      
      private var hovering:Boolean = false;
      
      public function ModalItemSlot(param1:Boolean = false, param2:Boolean = false)
      {
         var _loc3_:Shape = null;
         var _loc4_:int = 0;
         this.animatedOutlines = new Vector.<Shape>();
         super();
         if(param1)
         {
            this.interactable = param1;
            addEventListener(MouseEvent.ROLL_OVER,this.onMouseOverGoalSlot);
         }
         highlight(true,16689154,true);
         if(param2)
         {
            _loc4_ = 0;
            while(_loc4_ < 3)
            {
               _loc3_ = PetsViewAssetFactory.returnPetSlotShape(56 + _loc4_ * 10,5526612,-5 + -5 * _loc4_,false,true,4);
               addChild(_loc3_);
               this.animatedOutlines.push(_loc3_);
               _loc4_++;
            }
            this.animationStartIndex = this.animatedOutlines.length - 1;
            addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      override public function updateTitle() : void
      {
         if(!empty)
         {
            this.highLightAll(196098);
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            if(this.actionButton)
            {
               this.actionButton.setOutLineColor(196098);
               this.actionButton.draw();
            }
            if(this.embeddedSprite_ != null && this.embeddedSprite_.parent != null)
            {
               this.embeddedSpriteCopy_.visible = false;
               this.embeddedSpriteCopy_.alpha = 0;
               this.embeddedSprite_.alpha = 1;
            }
         }
         else
         {
            if(this.animatedOutlines.length > 0)
            {
               addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            }
            if(this.embeddedSprite_ != null && this.embeddedSprite_.parent != null)
            {
               this.embeddedSpriteCopy_.visible = true;
            }
            if(this.actionButton)
            {
               this.actionButton.setOutLineColor(5526612);
               this.actionButton.draw();
            }
         }
      }
      
      public function makeRedTemporarily() : void
      {
         this.highLightAll(16711680);
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         new TimerCallback(1.25,addEventListener,Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      public function setCheckMark() : void
      {
         if(this.marking == null)
         {
            this.marking = this.buildTextField();
            this.marking.text = "✓";
            this.marking.textColor = 65280;
            addChild(this.marking);
            this.marking.y = Math.round((height / 2 - this.marking.textHeight / 2) / 7);
         }
      }
      
      public function setQuestionMark() : void
      {
         if(this.marking == null)
         {
            this.marking = this.buildTextField();
            this.marking.text = "?";
            this.marking.textColor = 16711680;
            addChild(this.marking);
            this.marking.y = Math.round((height / 2 - this.marking.textHeight / 2) / 7);
         }
      }
      
      public function removeMarking() : void
      {
         if(this.marking != null && this.marking.parent != null)
         {
            removeChild(this.marking);
         }
      }
      
      private function buildTextField() : TextField
      {
         var _loc1_:FontModel = new FontModel();
         var _loc2_:TextField = new TextField();
         var _loc3_:TextFormat = _loc2_.defaultTextFormat;
         _loc3_.size = 36;
         _loc3_.font = _loc1_.getFont().getName();
         _loc3_.bold = true;
         _loc3_.align = "center";
         _loc2_.defaultTextFormat = _loc3_;
         _loc2_.alpha = 0.8;
         _loc2_.width = width;
         _loc2_.selectable = false;
         return _loc2_;
      }
      
      private function onMouseOverGoalSlot(param1:Event) : void
      {
         if(empty)
         {
            this.hovering = true;
            if(this.usageText != null && this.usageText.parent == null)
            {
               addChild(this.usageText);
            }
            removeEventListener(MouseEvent.ROLL_OVER,this.onMouseOverGoalSlot);
            addEventListener(MouseEvent.ROLL_OUT,this.onMouseOutsideGoalSlot);
         }
      }
      
      private function onMouseOutsideGoalSlot(param1:Event) : void
      {
         if(empty)
         {
            this.hovering = false;
            new TimerCallback(0.5,this.removeIfStillOutside);
            addEventListener(MouseEvent.ROLL_OVER,this.onMouseOverGoalSlot);
            removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOutsideGoalSlot);
         }
      }
      
      private function removeIfStillOutside() : void
      {
         if(this.hovering == false && this.usageText != null && this.usageText.parent != null)
         {
            removeChild(this.usageText);
         }
      }
      
      public function setUsageText(param1:String, param2:int, param3:int) : void
      {
         this.usageText = new TextField();
         this.usageText.text = param1;
         this.usageText.autoSize = TextFieldAutoSize.LEFT;
         var _loc4_:FontModel = StaticInjectorContext.getInjector().getInstance(FontModel);
         _loc4_.apply(this.usageText,param2,param3,false,true);
         this.usageText.y = this.y + this.height;
         this.usageText.x = this.x + this.width / 2 - this.usageText.width / 2;
      }
      
      public function setActionButton(param1:LegacyBuyButton) : void
      {
         this.actionButton = param1;
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc3_:ColorTransform = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:int = int(uint(getTimer() / 500 % 3));
         if(_loc2_ != this.curOutline)
         {
            this.curOutline = _loc2_;
            _loc4_ = 0;
            while(_loc4_ < this.animatedOutlines.length)
            {
               _loc3_ = this.animatedOutlines[_loc4_].transform.colorTransform;
               _loc3_.color = 5526612;
               _loc3_.alphaMultiplier = 1 - _loc4_ * 0.3;
               this.animatedOutlines[_loc4_].transform.colorTransform = _loc3_;
               _loc4_++;
            }
            _loc5_ = this.animationStartIndex - this.curOutline * this.animationDir;
            _loc3_ = this.animatedOutlines[_loc5_].transform.colorTransform;
            _loc3_.color = 196098;
            this.animatedOutlines[_loc5_].transform.colorTransform = _loc3_;
         }
         if(this.embeddedImage_)
         {
            if(this.embeddedSprite_.alpha == 1 || this.embeddedSprite_.alpha == 0)
            {
               this.dir *= -1;
            }
            this.embeddedSprite_.alpha += this.dir;
            this.embeddedSpriteCopy_.alpha -= this.dir;
            if(this.embeddedSprite_.alpha >= 1)
            {
               this.embeddedSprite_.alpha = 1;
               this.embeddedSpriteCopy_.alpha = 0;
            }
            else if(this.embeddedSprite_.alpha <= 0)
            {
               this.embeddedSprite_.alpha = 0;
               this.embeddedSpriteCopy_.alpha = 1;
            }
         }
      }
      
      public function highLightAll(param1:int) : void
      {
         var _loc3_:ColorTransform = null;
         var _loc2_:* = int(this.animatedOutlines.length - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = this.animatedOutlines[_loc2_].transform.colorTransform;
            _loc3_.color = param1;
            _loc3_.alphaMultiplier = 1 - _loc2_ * 0.3;
            this.animatedOutlines[_loc2_].transform.colorTransform = _loc3_;
            _loc2_--;
         }
      }
      
      public function playOutLineAnimation(param1:int) : void
      {
         this.animationDir = param1;
         if(param1 == -1)
         {
            this.animationStartIndex = 0;
         }
         else if(param1 == 1)
         {
            this.animationStartIndex = this.animatedOutlines.length - 1;
         }
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      public function stopOutLineAnimation() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      public function setEmbeddedImage(param1:Bitmap) : void
      {
         this.embeddedImage_ = param1;
         var _loc2_:Bitmap = new Bitmap(param1.bitmapData);
         this.embeddedSprite_ = new Sprite();
         this.embeddedSpriteCopy_ = new Sprite();
         this.embeddedSprite_.x = (100 - this.embeddedImage_.width) * 0.5;
         this.embeddedSprite_.y = (46 - this.embeddedImage_.height) * 0.5;
         this.embeddedSpriteCopy_.x = this.embeddedSprite_.x;
         this.embeddedSpriteCopy_.y = this.embeddedSprite_.y;
         this.embeddedSprite_.addChild(this.embeddedImage_);
         this.embeddedSpriteCopy_.addChild(_loc2_);
         addChild(this.embeddedSpriteCopy_);
         addChild(this.embeddedSprite_);
         if(itemSprite != null && getChildIndex(itemSprite) != -1)
         {
            removeChild(itemSprite);
            addChild(itemSprite);
         }
         this.embeddedSprite_.filters = [grayscaleMatrix];
         var _loc3_:ColorTransform = new ColorTransform();
         _loc3_.color = 2697513;
         this.embeddedSprite_.transform.colorTransform = _loc3_;
         this.embeddedSpriteCopy_.alpha = 0;
      }
   }
}

