package kabam.rotmg.death.view
{
   import com.company.assembleegameclient.ui.dialogs.Dialog;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.ColorMatrixFilter;
   import kabam.rotmg.text.model.TextKey;
   import org.osflash.signals.Signal;
   
   public class ResurrectionView extends Sprite
   {
      
      public const showDialog:Signal = new Signal(Sprite);
      
      public const closed:Signal = new Signal();
      
      private const POPUP_BACKGROUND_COLOR:Number = 0;
      
      private const POPUP_LINE_COLOR:Number = 3881787;
      
      private const POPUP_WIDTH:Number = 300;
      
      private const POPUP_HEIGHT:Number = 400;
      
      private var popup:Dialog;
      
      public function ResurrectionView()
      {
         super();
      }
      
      public function init(param1:BitmapData) : void
      {
         this.createBackground(param1);
         this.createPopup();
      }
      
      private function createBackground(param1:BitmapData) : void
      {
         var _loc4_:Bitmap = null;
         var _loc2_:Array = [0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0.33,0.33,0.33,1,0];
         var _loc3_:ColorMatrixFilter = new ColorMatrixFilter(_loc2_);
         _loc4_ = new Bitmap(param1);
         _loc4_.filters = [_loc3_];
         addChild(_loc4_);
      }
      
      public function createPopup() : void
      {
         this.popup = new Dialog(TextKey.RESURRECTION_VIEW_YOU_DIED,TextKey.RESURRECTION_VIEW_DEATH_TEXT,TextKey.RESURRECTION_VIEW_SAVE_ME,null,null);
         this.popup.addEventListener(Dialog.LEFT_BUTTON,this.onButtonClick);
         this.showDialog.dispatch(this.popup);
      }
      
      private function onButtonClick(param1:Event) : void
      {
         this.closed.dispatch();
      }
   }
}

