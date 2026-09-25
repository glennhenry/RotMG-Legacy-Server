package kabam.rotmg.game.view
{
   import com.company.assembleegameclient.ui.tooltip.TextToolTip;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.AssetLibrary;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.geom.Rectangle;
   import kabam.rotmg.core.signals.HideTooltipsSignal;
   import kabam.rotmg.core.signals.ShowTooltipSignal;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.tooltips.HoverTooltipDelegate;
   import kabam.rotmg.tooltips.TooltipAble;
   import kabam.rotmg.ui.UIUtils;
   
   public class GiftStatusDisplay extends Sprite implements TooltipAble
   {
      
      public static const IMAGE_NAME:String = "lofiObj2";
      
      public static const IMAGE_ID:int = 127;
      
      public static const NOTIFICATION_BACKGROUND_WIDTH:Number = 110;
      
      public static const NOTIFICATION_BACKGROUND_HEIGHT:Number = 25;
      
      public static const NOTIFICATION_BACKGROUND_ALPHA:Number = 0.4;
      
      public static const NOTIFICATION_BACKGROUND_COLOR:Number = 0;
      
      public var hoverTooltipDelegate:HoverTooltipDelegate = new HoverTooltipDelegate();
      
      private var bitmap:Bitmap;
      
      private var background:Sprite;
      
      private var giftOpenProcessedTexture:BitmapData;
      
      private var text:TextFieldDisplayConcrete;
      
      private var tooltip:TextToolTip = new TextToolTip(3552822,10197915,null,TextKey.BUYPACKAGETASK_NEWGIFTS,200);
      
      public function GiftStatusDisplay()
      {
         super();
         mouseChildren = false;
         this.giftOpenProcessedTexture = TextureRedrawer.redraw(AssetLibrary.getImageFromSet(IMAGE_NAME,IMAGE_ID),40,true,0);
         this.background = UIUtils.makeStaticHUDBackground();
         this.bitmap = new Bitmap(this.giftOpenProcessedTexture);
         this.bitmap.x = -5;
         this.bitmap.y = -8;
         this.text = new TextFieldDisplayConcrete().setSize(16).setColor(16777215);
         this.text.setStringBuilder(new LineBuilder().setParams(TextKey.GIFTSTATUSDISPLAY_TEXT));
         this.text.filters = [new DropShadowFilter(0,0,0,1,4,4,2)];
         this.text.setVerticalAlign(TextFieldDisplayConcrete.BOTTOM);
         this.hoverTooltipDelegate.setDisplayObject(this);
         this.hoverTooltipDelegate.tooltip = this.tooltip;
         this.drawAsOpen();
         var _loc1_:Rectangle = this.bitmap.getBounds(this);
         this.text.x = _loc1_.right - 10;
         this.text.y = _loc1_.bottom - 10;
      }
      
      public function setShowToolTipSignal(param1:ShowTooltipSignal) : void
      {
         this.hoverTooltipDelegate.setShowToolTipSignal(param1);
      }
      
      public function getShowToolTip() : ShowTooltipSignal
      {
         return this.hoverTooltipDelegate.getShowToolTip();
      }
      
      public function setHideToolTipsSignal(param1:HideTooltipsSignal) : void
      {
         this.hoverTooltipDelegate.setHideToolTipsSignal(param1);
      }
      
      public function getHideToolTips() : HideTooltipsSignal
      {
         return this.hoverTooltipDelegate.getHideToolTips();
      }
      
      public function drawAsOpen() : void
      {
         addChild(this.background);
         addChild(this.text);
         addChild(this.bitmap);
      }
      
      public function drawAsClosed() : void
      {
         if(Boolean(this.background) && this.background.parent == this)
         {
            removeChild(this.background);
         }
         if(Boolean(this.text) && this.text.parent == this)
         {
            removeChild(this.text);
         }
         if(Boolean(this.bitmap) && this.bitmap.parent == this)
         {
            removeChild(this.bitmap);
         }
      }
   }
}

