package kabam.rotmg.pets.util
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.ui.LineBreakDesign;
   import com.company.util.BitmapUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFormatAlign;
   import kabam.rotmg.pets.view.components.DialogCloseButton;
   import kabam.rotmg.pets.view.components.FameOrGoldBuyButtons;
   import kabam.rotmg.pets.view.components.FeedFuseArrow;
   import kabam.rotmg.pets.view.components.FusionStrength;
   import kabam.rotmg.pets.view.components.PetAbilityMeter;
   import kabam.rotmg.pets.view.components.PetFeeder;
   import kabam.rotmg.pets.view.components.PetFuser;
   import kabam.rotmg.pets.view.components.PetsButtonBar;
   import kabam.rotmg.pets.view.components.PopupWindowBackground;
   import kabam.rotmg.pets.view.components.slot.FoodFeedFuseSlot;
   import kabam.rotmg.pets.view.components.slot.PetFeedFuseSlot;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class PetsViewAssetFactory
   {
      
      public function PetsViewAssetFactory()
      {
         super();
      }
      
      public static function returnWindowBackground(param1:uint, param2:uint) : PopupWindowBackground
      {
         var _loc3_:PopupWindowBackground = new PopupWindowBackground();
         _loc3_.draw(param1,param2);
         _loc3_.divide(PopupWindowBackground.HORIZONTAL_DIVISION,PetsConstants.WINDOW_LINE_ONE_POS_Y);
         _loc3_.divide(PopupWindowBackground.HORIZONTAL_DIVISION,PetsConstants.WINDOW_LINE_TWO_POS_Y);
         return _loc3_;
      }
      
      public static function returnFuserWindowBackground() : PopupWindowBackground
      {
         var _loc1_:PopupWindowBackground = new PopupWindowBackground();
         _loc1_.draw(PetsConstants.WINDOW_BACKGROUND_WIDTH,PetsConstants.FUSER_WINDOW_BACKGROUND_HEIGHT);
         _loc1_.divide(PopupWindowBackground.HORIZONTAL_DIVISION,PetsConstants.WINDOW_LINE_ONE_POS_Y);
         _loc1_.divide(PopupWindowBackground.HORIZONTAL_DIVISION,PetsConstants.FUSER_WINDOW_LINE_TWO_POS_Y);
         return _loc1_;
      }
      
      public static function returnFameOrGoldButtonBar(param1:String, param2:uint) : FameOrGoldBuyButtons
      {
         var _loc3_:FameOrGoldBuyButtons = new FameOrGoldBuyButtons();
         _loc3_.y = param2;
         _loc3_.setPrefix(param1);
         return _loc3_;
      }
      
      public static function returnButtonBar() : PetsButtonBar
      {
         var _loc1_:PetsButtonBar = null;
         _loc1_ = new PetsButtonBar();
         _loc1_.y = PetsConstants.WINDOW_BACKGROUND_HEIGHT - 35;
         return _loc1_;
      }
      
      private static function returnAbilityMeter() : PetAbilityMeter
      {
         var _loc1_:PetAbilityMeter = null;
         _loc1_ = new PetAbilityMeter();
         _loc1_.y = PetsConstants.METER_START_POSITION_Y;
         return _loc1_;
      }
      
      public static function returnAbilityMeters() : Vector.<PetAbilityMeter>
      {
         return Vector.<PetAbilityMeter>([returnAbilityMeter(),returnAbilityMeter(),returnAbilityMeter()]);
      }
      
      public static function returnFuseDescriptionTextfield() : TextFieldDisplayConcrete
      {
         var _loc1_:TextFieldDisplayConcrete = new TextFieldDisplayConcrete();
         _loc1_.setStringBuilder(new LineBuilder().setParams(TextKey.PET_FUSER_DESCRIPTION));
         _loc1_.setTextWidth(PetsConstants.WINDOW_BACKGROUND_WIDTH - 20).setWordWrap(true).setHorizontalAlign(TextFormatAlign.CENTER).setSize(PetsConstants.MEDIUM_TEXT_SIZE).setColor(11776947);
         _loc1_.y = 42;
         return _loc1_;
      }
      
      public static function returnPetSlotTitle() : TextFieldDisplayConcrete
      {
         var _loc1_:TextFieldDisplayConcrete = null;
         _loc1_ = new TextFieldDisplayConcrete();
         _loc1_.setSize(PetsConstants.MEDIUM_TEXT_SIZE).setColor(11776947).setBold(true).setHorizontalAlign(TextFormatAlign.CENTER).setWordWrap(true).setTextWidth(100);
         _loc1_.filters = [new DropShadowFilter(0,0,0)];
         _loc1_.y = PetsConstants.PET_SLOT_TITLE_Y;
         return _loc1_;
      }
      
      public static function returnMediumCenteredTextfield(param1:uint, param2:uint) : TextFieldDisplayConcrete
      {
         var _loc3_:TextFieldDisplayConcrete = new TextFieldDisplayConcrete();
         _loc3_.setSize(PetsConstants.MEDIUM_TEXT_SIZE).setColor(param1).setBold(true).setHorizontalAlign(TextFormatAlign.CENTER).setWordWrap(true).setTextWidth(param2);
         return _loc3_;
      }
      
      public static function returnPetFeeder() : PetFeeder
      {
         var _loc1_:PetFeeder = new PetFeeder();
         _loc1_.y = PetsConstants.PET_WINDOW_TOOL_Y_POS;
         return _loc1_;
      }
      
      public static function returnPetFuser() : PetFuser
      {
         var _loc1_:PetFuser = new PetFuser();
         _loc1_.y = PetsConstants.PET_WINDOW_TOOL_Y_POS + 50;
         return _loc1_;
      }
      
      public static function returnPetFeederArrow() : FeedFuseArrow
      {
         var _loc1_:FeedFuseArrow = null;
         _loc1_ = new FeedFuseArrow();
         _loc1_.x = PetsConstants.PET_FEEDER_ARROW_X;
         _loc1_.y = PetsConstants.PET_FEEDER_ARROW_Y;
         return _loc1_;
      }
      
      public static function returnPetFeederRightSlot() : FoodFeedFuseSlot
      {
         var _loc1_:FoodFeedFuseSlot = new FoodFeedFuseSlot();
         _loc1_.x = PetsConstants.PET_FEEDER_ARROW_X + 35;
         _loc1_.hideOuterSlot(true);
         return _loc1_;
      }
      
      public static function returnPetFuserRightSlot() : PetFeedFuseSlot
      {
         var _loc1_:PetFeedFuseSlot = null;
         _loc1_ = new PetFeedFuseSlot();
         _loc1_.x = PetsConstants.PET_FEEDER_ARROW_X + 35;
         _loc1_.hideOuterSlot(true);
         _loc1_.showFamily = true;
         return _loc1_;
      }
      
      public static function returnPetSlotShape(param1:uint, param2:uint, param3:int, param4:Boolean, param5:Boolean, param6:int = 2) : Shape
      {
         var _loc7_:Shape = null;
         _loc7_ = new Shape();
         param4 && _loc7_.graphics.beginFill(4605510,1);
         param5 && _loc7_.graphics.lineStyle(param6,param2);
         _loc7_.graphics.drawRoundRect(0,param3,param1,param1,16,16);
         _loc7_.x = (100 - param1) * 0.5;
         return _loc7_;
      }
      
      public static function returnCloseButton(param1:int) : DialogCloseButton
      {
         var _loc2_:DialogCloseButton = new DialogCloseButton();
         _loc2_.y = 4;
         _loc2_.x = param1 - _loc2_.width - 5;
         return _loc2_;
      }
      
      public static function returnTooltipLineBreak() : LineBreakDesign
      {
         var _loc1_:LineBreakDesign = null;
         _loc1_ = new LineBreakDesign(173,0);
         _loc1_.x = 5;
         _loc1_.y = 64;
         return _loc1_;
      }
      
      public static function returnBitmap(param1:uint, param2:uint = 80) : Bitmap
      {
         return new Bitmap(ObjectLibrary.getRedrawnTextureFromType(param1,param2,true));
      }
      
      public static function returnInteractionBitmap() : Bitmap
      {
         return getBitmapForItem(6466);
      }
      
      public static function returnCaretakerBitmap(param1:uint) : Bitmap
      {
         return new Bitmap(ObjectLibrary.getRedrawnTextureFromType(param1,80,true));
      }
      
      private static function getBitmapForItem(param1:uint) : Bitmap
      {
         var _loc2_:Bitmap = new Bitmap();
         var _loc3_:XML = ObjectLibrary.xmlLibrary_[param1];
         var _loc4_:int = 5;
         if(_loc3_.hasOwnProperty("ScaleValue"))
         {
            _loc4_ = int(_loc3_.ScaleValue);
         }
         var _loc5_:BitmapData = ObjectLibrary.getRedrawnTextureFromType(param1,80,true,true,_loc4_);
         _loc5_ = BitmapUtil.cropToBitmapData(_loc5_,4,4,_loc5_.width - 8,_loc5_.height - 8);
         return new Bitmap(_loc5_);
      }
      
      public static function returnFusionStrength() : FusionStrength
      {
         var _loc1_:FusionStrength = new FusionStrength();
         _loc1_.y = PetsConstants.FUSION_STRENGTH_Y_POS;
         _loc1_.x = (PetsConstants.WINDOW_BACKGROUND_WIDTH - _loc1_.width) * 0.5;
         return _loc1_;
      }
      
      public static function returnTopAlignedTextfield(param1:int, param2:int, param3:Boolean, param4:Boolean = false) : TextFieldDisplayConcrete
      {
         var _loc5_:TextFieldDisplayConcrete = new TextFieldDisplayConcrete();
         _loc5_.setSize(param2).setColor(param1).setBold(param3);
         _loc5_.filters = param4 ? [new DropShadowFilter(0,0,0)] : [];
         return _loc5_;
      }
      
      public static function returnTextfield(param1:int, param2:int, param3:Boolean, param4:Boolean = false) : TextFieldDisplayConcrete
      {
         var _loc5_:TextFieldDisplayConcrete = new TextFieldDisplayConcrete();
         _loc5_.setSize(param2).setColor(param1).setBold(param3);
         _loc5_.setVerticalAlign(TextFieldDisplayConcrete.BOTTOM);
         _loc5_.filters = param4 ? [new DropShadowFilter(0,0,0)] : [];
         return _loc5_;
      }
      
      public static function returnYardUpgradeWindowBackground(param1:uint, param2:uint) : PopupWindowBackground
      {
         var _loc3_:PopupWindowBackground = new PopupWindowBackground();
         _loc3_.draw(param1,param2);
         _loc3_.divide(PopupWindowBackground.HORIZONTAL_DIVISION,30);
         _loc3_.divide(PopupWindowBackground.HORIZONTAL_DIVISION,212);
         _loc3_.divide(PopupWindowBackground.HORIZONTAL_DIVISION,349);
         return _loc3_;
      }
      
      public static function returnEggHatchWindowBackground(param1:uint, param2:uint) : PopupWindowBackground
      {
         var _loc3_:PopupWindowBackground = new PopupWindowBackground();
         _loc3_.draw(param1,param2);
         _loc3_.divide(PopupWindowBackground.HORIZONTAL_DIVISION,30);
         _loc3_.divide(PopupWindowBackground.HORIZONTAL_DIVISION,206);
         return _loc3_;
      }
   }
}

