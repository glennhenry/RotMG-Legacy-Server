package kabam.rotmg.news.view
{
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.text.model.FontModel;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   
   public class NewsModalPage extends Sprite
   {
      
      public static const TEXT_MARGIN:int = 22;
      
      public static const TEXT_MARGIN_HTML:int = 26;
      
      public function NewsModalPage(param1:String, param2:String)
      {
         var _loc3_:TextField = null;
         super();
         this.doubleClickEnabled = false;
         this.mouseEnabled = false;
         _loc3_ = new TextField();
         var _loc4_:FontModel = StaticInjectorContext.getInjector().getInstance(FontModel);
         _loc4_.apply(_loc3_,16,15792127,false,true);
         _loc3_.width = NewsModal.MODAL_WIDTH - TEXT_MARGIN_HTML * 2;
         _loc3_.height = NewsModal.MODAL_HEIGHT - 101;
         _loc3_.multiline = true;
         _loc3_.wordWrap = true;
         _loc3_.htmlText = param2;
         _loc3_.x = TEXT_MARGIN_HTML;
         _loc3_.y = 53;
         _loc3_.filters = [new DropShadowFilter(0,0,0)];
         disableMouseOnText(_loc3_);
         addChild(_loc3_);
         var _loc5_:TextFieldDisplayConcrete = NewsModal.getText(param1,TEXT_MARGIN,6,true);
         addChild(_loc5_);
      }
      
      private static function disableMouseOnText(param1:TextField) : void
      {
         param1.mouseWheelEnabled = false;
      }
   }
}

