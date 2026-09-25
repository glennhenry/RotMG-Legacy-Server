package kabam.rotmg.news.view
{
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.sound.SoundEffectLibrary;
   import com.company.util.AssetLibrary;
   import com.company.util.KeyCodes;
   import com.company.util.MoreColorUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   import kabam.rotmg.account.core.view.EmptyFrame;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.news.model.NewsModel;
   import kabam.rotmg.pets.view.components.PopupWindowBackground;
   import kabam.rotmg.text.model.FontModel;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   import kabam.rotmg.ui.model.HUDModel;
   
   public class NewsModal extends EmptyFrame
   {
      
      public static var backgroundImageEmbed:Class = NewsModal_backgroundImageEmbed;
      
      public static var foregroundImageEmbed:Class = NewsModal_foregroundImageEmbed;
      
      public static const MODAL_WIDTH:int = 440;
      
      public static const MODAL_HEIGHT:int = 400;
      
      public static var modalWidth:int = MODAL_WIDTH;
      
      public static var modalHeight:int = MODAL_HEIGHT;
      
      private static const OVER_COLOR_TRANSFORM:ColorTransform = new ColorTransform(1,220 / 255,133 / 255);
      
      private static const DROP_SHADOW_FILTER:DropShadowFilter = new DropShadowFilter(0,0,0);
      
      private static const GLOW_FILTER:GlowFilter = new GlowFilter(16711680,1,11,5);
      
      private static const filterWithGlow:Array = [DROP_SHADOW_FILTER,GLOW_FILTER];
      
      private static const filterNoGlow:Array = [DROP_SHADOW_FILTER];
      
      private var currentPage:NewsModalPage;
      
      private var currentPageNum:int = -1;
      
      private var pageOneNav:TextField;
      
      private var pageTwoNav:TextField;
      
      private var pageThreeNav:TextField;
      
      private var pageFourNav:TextField;
      
      private var pageNavs:Vector.<TextField>;
      
      private var leftNavSprite:Sprite;
      
      private var rightNavSprite:Sprite;
      
      public function NewsModal(param1:int = 1)
      {
         modalWidth = MODAL_WIDTH;
         modalHeight = MODAL_HEIGHT;
         super(modalWidth,modalHeight);
         this.setCloseButton(true);
         this.initNavButtons();
         this.setPage(param1);
         WebMain.STAGE.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownListener);
         addEventListener(Event.REMOVED_FROM_STAGE,this.destroy);
      }
      
      public static function refreshNewsButton() : void
      {
         var _loc1_:HUDModel = StaticInjectorContext.getInjector().getInstance(HUDModel);
         if(_loc1_ != null && _loc1_.gameSprite != null)
         {
            _loc1_.gameSprite.refreshNewsUpdateButton();
         }
      }
      
      public static function hasUpdates() : Boolean
      {
         var _loc1_:int = 1;
         while(_loc1_ <= NewsModel.MODAL_PAGE_COUNT)
         {
            if(Parameters.data_["hasNewsUpdate" + _loc1_] != null && Parameters.data_["hasNewsUpdate" + _loc1_] == true)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public static function getText(param1:String, param2:int, param3:int, param4:Boolean) : TextFieldDisplayConcrete
      {
         var _loc5_:TextFieldDisplayConcrete = null;
         _loc5_ = new TextFieldDisplayConcrete().setSize(18).setColor(16777215).setTextWidth(NewsModal.modalWidth - TEXT_MARGIN * 2);
         _loc5_.setBold(true);
         if(param4)
         {
            _loc5_.setStringBuilder(new StaticStringBuilder(param1));
         }
         else
         {
            _loc5_.setStringBuilder(new LineBuilder().setParams(param1));
         }
         _loc5_.setWordWrap(true);
         _loc5_.setMultiLine(true);
         _loc5_.setAutoSize(TextFieldAutoSize.CENTER);
         _loc5_.setHorizontalAlign(TextFormatAlign.CENTER);
         _loc5_.filters = [new DropShadowFilter(0,0,0)];
         _loc5_.x = param2;
         _loc5_.y = param3;
         return _loc5_;
      }
      
      private function initNavButtons() : void
      {
         var _loc4_:TextField = null;
         var _loc1_:int = NewsModel.MODAL_PAGE_COUNT;
         this.pageNavs = new Vector.<TextField>(_loc1_,true);
         this.pageOneNav = new TextField();
         this.pageTwoNav = new TextField();
         this.pageThreeNav = new TextField();
         this.pageFourNav = new TextField();
         this.pageNavs[0] = this.pageOneNav;
         this.pageNavs[1] = this.pageTwoNav;
         this.pageNavs[2] = this.pageThreeNav;
         this.pageNavs[3] = this.pageFourNav;
         var _loc2_:FontModel = StaticInjectorContext.getInjector().getInstance(FontModel);
         var _loc3_:int = 1;
         for each(_loc4_ in this.pageNavs)
         {
            _loc2_.apply(_loc4_,20,16777215,true);
            _loc4_.filters = filterNoGlow;
            if(_loc3_ > 0 && _loc3_ <= NewsModel.MODAL_PAGE_COUNT)
            {
               _loc4_.text = "  " + _loc3_ + "  ";
               _loc4_.width = _loc4_.textWidth;
               _loc4_.x = modalWidth * (_loc3_ + 3) / 11 - _loc4_.textWidth / 2;
               _loc4_.addEventListener(MouseEvent.ROLL_OVER,this.onNavHover);
               _loc4_.addEventListener(MouseEvent.ROLL_OUT,this.onNavHoverOut);
            }
            _loc4_.height = _loc4_.textHeight;
            _loc4_.y = modalHeight - 33;
            _loc4_.selectable = false;
            _loc4_.addEventListener(MouseEvent.CLICK,this.onClick);
            addChild(_loc4_);
            _loc3_++;
         }
         this.leftNavSprite = this.makeLeftNav();
         this.rightNavSprite = this.makeRightNav();
         this.leftNavSprite.x = modalWidth * 3 / 11 - this.rightNavSprite.width / 2;
         this.leftNavSprite.y = modalHeight - 4;
         addChild(this.leftNavSprite);
         this.rightNavSprite.x = modalWidth * 8 / 11 - this.rightNavSprite.width / 2;
         this.rightNavSprite.y = modalHeight - 4;
         addChild(this.rightNavSprite);
      }
      
      public function onNavHover(param1:MouseEvent) : void
      {
         var _loc2_:TextField = param1.currentTarget as TextField;
         _loc2_.textColor = 16701832;
      }
      
      public function onNavHoverOut(param1:MouseEvent) : void
      {
         var _loc2_:TextField = param1.currentTarget as TextField;
         _loc2_.textColor = 16777215;
      }
      
      public function onClick(param1:MouseEvent) : void
      {
         switch(param1.currentTarget)
         {
            case this.rightNavSprite:
               if(this.currentPageNum + 1 <= NewsModel.MODAL_PAGE_COUNT)
               {
                  this.setPage(this.currentPageNum + 1);
               }
               break;
            case this.leftNavSprite:
               if(this.currentPageNum - 1 >= 1)
               {
                  this.setPage(this.currentPageNum - 1);
               }
               break;
            case this.pageOneNav:
               this.setPage(1);
               break;
            case this.pageTwoNav:
               this.setPage(2);
               break;
            case this.pageThreeNav:
               this.setPage(3);
               break;
            case this.pageFourNav:
               this.setPage(4);
         }
      }
      
      private function getPageNavForGlow(param1:int) : TextField
      {
         if(param1 >= 0 < NewsModel.MODAL_PAGE_COUNT)
         {
            return this.pageNavs[param1 - 1];
         }
         return null;
      }
      
      private function destroy(param1:Event) : void
      {
         var _loc2_:TextField = null;
         WebMain.STAGE.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDownListener);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.destroy);
         if(this.pageNavs != null)
         {
            for each(_loc2_ in this.pageNavs)
            {
               _loc2_.removeEventListener(MouseEvent.CLICK,this.onClick);
               _loc2_.removeEventListener(MouseEvent.ROLL_OVER,this.onNavHover);
               _loc2_.removeEventListener(MouseEvent.ROLL_OUT,this.onNavHoverOut);
            }
         }
         this.leftNavSprite.removeEventListener(MouseEvent.CLICK,this.onClick);
         this.leftNavSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.onArrowHover);
         this.leftNavSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.onArrowHoverOut);
         this.rightNavSprite.removeEventListener(MouseEvent.CLICK,this.onClick);
         this.rightNavSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.onArrowHover);
         this.rightNavSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.onArrowHoverOut);
      }
      
      private function setPage(param1:int) : void
      {
         var _loc3_:TextField = null;
         var _loc2_:Boolean = hasUpdates();
         if(param1 < 1 || param1 > NewsModel.MODAL_PAGE_COUNT)
         {
            return;
         }
         if(this.currentPageNum != -1)
         {
            removeChild(this.currentPage);
            _loc3_ = this.getPageNavForGlow(this.currentPageNum);
            if(_loc3_ != null)
            {
               _loc3_.filters = filterNoGlow;
            }
            SoundEffectLibrary.play("button_click");
         }
         this.currentPageNum = param1;
         var _loc4_:NewsModel = StaticInjectorContext.getInjector().getInstance(NewsModel);
         this.currentPage = _loc4_.getModalPage(param1);
         addChild(this.currentPage);
         _loc3_ = this.getPageNavForGlow(this.currentPageNum);
         if(_loc3_ != null)
         {
            _loc3_.filters = filterWithGlow;
         }
         Parameters.data_["hasNewsUpdate" + param1] = false;
         var _loc5_:Boolean = hasUpdates();
         if(_loc2_ != _loc5_)
         {
            refreshNewsButton();
         }
      }
      
      override protected function makeModalBackground() : Sprite
      {
         var _loc3_:DisplayObject = null;
         var _loc1_:Sprite = new Sprite();
         var _loc2_:DisplayObject = new backgroundImageEmbed();
         _loc2_.width = modalWidth + 1;
         _loc2_.height = modalHeight - 25;
         _loc2_.y = 27;
         _loc2_.alpha = 0.95;
         _loc3_ = new foregroundImageEmbed();
         _loc3_.width = modalWidth + 1;
         _loc3_.height = modalHeight - 67;
         _loc3_.y = 27;
         _loc3_.alpha = 1;
         var _loc4_:PopupWindowBackground = new PopupWindowBackground();
         _loc4_.draw(modalWidth,modalHeight,PopupWindowBackground.TYPE_TRANSPARENT_WITH_HEADER);
         _loc1_.addChild(_loc2_);
         _loc1_.addChild(_loc3_);
         _loc1_.addChild(_loc4_);
         return _loc1_;
      }
      
      private function keyDownListener(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == KeyCodes.RIGHT)
         {
            if(this.currentPageNum + 1 <= NewsModel.MODAL_PAGE_COUNT)
            {
               this.setPage(this.currentPageNum + 1);
            }
         }
         else if(param1.keyCode == KeyCodes.LEFT)
         {
            if(this.currentPageNum - 1 >= 1)
            {
               this.setPage(this.currentPageNum - 1);
            }
         }
      }
      
      private function makeLeftNav() : Sprite
      {
         var _loc1_:BitmapData = AssetLibrary.getImageFromSet("lofiInterface",54);
         var _loc2_:Bitmap = new Bitmap(_loc1_);
         _loc2_.scaleX = 4;
         _loc2_.scaleY = 4;
         _loc2_.rotation = -90;
         var _loc3_:Sprite = new Sprite();
         _loc3_.addChild(_loc2_);
         _loc3_.addEventListener(MouseEvent.MOUSE_OVER,this.onArrowHover);
         _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.onArrowHoverOut);
         _loc3_.addEventListener(MouseEvent.CLICK,this.onClick);
         return _loc3_;
      }
      
      private function makeRightNav() : Sprite
      {
         var _loc1_:BitmapData = AssetLibrary.getImageFromSet("lofiInterface",55);
         var _loc2_:Bitmap = new Bitmap(_loc1_);
         _loc2_.scaleX = 4;
         _loc2_.scaleY = 4;
         _loc2_.rotation = -90;
         var _loc3_:Sprite = new Sprite();
         _loc3_.addChild(_loc2_);
         _loc3_.addEventListener(MouseEvent.MOUSE_OVER,this.onArrowHover);
         _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.onArrowHoverOut);
         _loc3_.addEventListener(MouseEvent.CLICK,this.onClick);
         return _loc3_;
      }
      
      private function onArrowHover(param1:MouseEvent) : void
      {
         param1.currentTarget.transform.colorTransform = OVER_COLOR_TRANSFORM;
      }
      
      private function onArrowHoverOut(param1:MouseEvent) : void
      {
         param1.currentTarget.transform.colorTransform = MoreColorUtil.identity;
      }
      
      override public function onCloseClick(param1:MouseEvent) : void
      {
         SoundEffectLibrary.play("button_click");
      }
   }
}

