package kabam.rotmg.mysterybox.components
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.mysterybox.model.MysteryBoxInfo;
   import kabam.rotmg.mysterybox.services.MysteryBoxModel;
   import kabam.rotmg.pets.util.PetsViewAssetFactory;
   import kabam.rotmg.pets.view.components.DialogCloseButton;
   import kabam.rotmg.pets.view.components.PopupWindowBackground;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import org.swiftsuspenders.Injector;
   
   public class MysteryBoxSelectModal extends Sprite
   {
      
      public static var modalWidth:int;
      
      public static var modalHeight:int;
      
      public static var aMysteryBoxHeight:int;
      
      public static var open:Boolean;
      
      public static const TEXT_MARGIN:int = 20;
      
      public static var backgroundImageEmbed:Class = MysteryBoxSelectModal_backgroundImageEmbed;
      
      private var closeButton:DialogCloseButton;
      
      private var box_:Sprite = new Sprite();
      
      private var mysteryData:Object;
      
      private var titleString:String = "MysteryBoxSelectModal.titleString";
      
      public function MysteryBoxSelectModal()
      {
         super();
         modalWidth = 385;
         modalHeight = 60;
         aMysteryBoxHeight = 77;
         var _loc1_:Injector = StaticInjectorContext.getInjector();
         var _loc2_:MysteryBoxModel = _loc1_.getInstance(MysteryBoxModel);
         this.mysteryData = _loc2_.getBoxesOrderByWeight();
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         addChild(this.box_);
         this.addBoxChildren();
         this.positionAndStuff();
         open = true;
      }
      
      public static function getRightBorderX() : int
      {
         return 300 + modalWidth / 2;
      }
      
      private static function makeModalBackground(param1:int, param2:int) : PopupWindowBackground
      {
         var _loc3_:PopupWindowBackground = new PopupWindowBackground();
         _loc3_.draw(param1,param2,PopupWindowBackground.TYPE_TRANSPARENT_WITH_HEADER);
         return _loc3_;
      }
      
      public function getText(param1:String, param2:int, param3:int) : TextFieldDisplayConcrete
      {
         var _loc4_:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(16).setColor(16777215).setTextWidth(modalWidth - TEXT_MARGIN * 2);
         _loc4_.setBold(true);
         _loc4_.setStringBuilder(new LineBuilder().setParams(param1));
         _loc4_.setWordWrap(true);
         _loc4_.setMultiLine(true);
         _loc4_.setAutoSize(TextFieldAutoSize.CENTER);
         _loc4_.setHorizontalAlign(TextFormatAlign.CENTER);
         _loc4_.filters = [new DropShadowFilter(0,0,0)];
         _loc4_.x = param2;
         _loc4_.y = param3;
         return _loc4_;
      }
      
      private function positionAndStuff() : void
      {
         this.box_.x = 600 / 2 - modalWidth / 2;
         this.box_.y = WebMain.STAGE.stageHeight / 2 - modalHeight / 2;
      }
      
      private function addBoxChildren() : void
      {
         var _loc1_:MysteryBoxInfo = null;
         var _loc2_:DisplayObject = null;
         var _loc5_:int = 0;
         var _loc6_:MysteryBoxSelectEntry = null;
         for each(_loc1_ in this.mysteryData)
         {
            modalHeight += aMysteryBoxHeight;
         }
         _loc2_ = new backgroundImageEmbed();
         _loc2_.width = modalWidth + 1;
         _loc2_.height = modalHeight - 25;
         _loc2_.y = 27;
         _loc2_.alpha = 0.95;
         this.box_.addChild(_loc2_);
         this.box_.addChild(makeModalBackground(modalWidth,modalHeight));
         this.closeButton = PetsViewAssetFactory.returnCloseButton(modalWidth);
         this.box_.addChild(this.closeButton);
         this.box_.addChild(this.getText(this.titleString,TEXT_MARGIN,6).setSize(18));
         var _loc4_:Number = 50;
         _loc5_ = 0;
         for each(_loc1_ in this.mysteryData)
         {
            if(_loc5_ == 6)
            {
               break;
            }
            _loc6_ = new MysteryBoxSelectEntry(_loc1_);
            _loc6_.x = x + 20;
            _loc6_.y = y + _loc4_;
            _loc4_ += aMysteryBoxHeight;
            this.box_.addChild(_loc6_);
            _loc5_++;
         }
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         open = false;
      }
   }
}

