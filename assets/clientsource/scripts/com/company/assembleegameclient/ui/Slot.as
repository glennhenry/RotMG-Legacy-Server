package com.company.assembleegameclient.ui
{
   import com.company.util.AssetLibrary;
   import com.company.util.GraphicsUtil;
   import com.company.util.MoreColorUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.IGraphicsData;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.text.view.BitmapTextFactory;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   
   public class Slot extends Sprite
   {
      
      public static const IDENTITY_MATRIX:Matrix = new Matrix();
      
      public static const ALL_TYPE:int = 0;
      
      public static const SWORD_TYPE:int = 1;
      
      public static const DAGGER_TYPE:int = 2;
      
      public static const BOW_TYPE:int = 3;
      
      public static const TOME_TYPE:int = 4;
      
      public static const SHIELD_TYPE:int = 5;
      
      public static const LEATHER_TYPE:int = 6;
      
      public static const PLATE_TYPE:int = 7;
      
      public static const WAND_TYPE:int = 8;
      
      public static const RING_TYPE:int = 9;
      
      public static const POTION_TYPE:int = 10;
      
      public static const SPELL_TYPE:int = 11;
      
      public static const SEAL_TYPE:int = 12;
      
      public static const CLOAK_TYPE:int = 13;
      
      public static const ROBE_TYPE:int = 14;
      
      public static const QUIVER_TYPE:int = 15;
      
      public static const HELM_TYPE:int = 16;
      
      public static const STAFF_TYPE:int = 17;
      
      public static const POISON_TYPE:int = 18;
      
      public static const SKULL_TYPE:int = 19;
      
      public static const TRAP_TYPE:int = 20;
      
      public static const ORB_TYPE:int = 21;
      
      public static const PRISM_TYPE:int = 22;
      
      public static const SCEPTER_TYPE:int = 23;
      
      public static const SHURIKEN_TYPE:int = 24;
      
      public static const WIDTH:int = 40;
      
      public static const HEIGHT:int = 40;
      
      public static const BORDER:int = 4;
      
      private static const greyColorFilter:ColorMatrixFilter = new ColorMatrixFilter(MoreColorUtil.singleColorFilterMatrix(3552822));
      
      public var type_:int;
      
      public var hotkey_:int;
      
      public var cuts_:Array;
      
      public var backgroundImage_:Bitmap;
      
      protected var fill_:GraphicsSolidFill = new GraphicsSolidFill(5526612,1);
      
      protected var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      private var graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[this.fill_,this.path_,GraphicsUtil.END_FILL];
      
      public function Slot(param1:int, param2:int, param3:Array)
      {
         super();
         this.type_ = param1;
         this.hotkey_ = param2;
         this.cuts_ = param3;
         this.drawBackground();
      }
      
      public static function slotTypeToName(param1:int) : String
      {
         switch(param1)
         {
            case ALL_TYPE:
               return "Any";
            case SWORD_TYPE:
               return "Sword";
            case DAGGER_TYPE:
               return "Dagger";
            case BOW_TYPE:
               return "Bow";
            case TOME_TYPE:
               return "Tome";
            case SHIELD_TYPE:
               return "Shield";
            case LEATHER_TYPE:
               return "Leather Armor";
            case PLATE_TYPE:
               return "Armor";
            case WAND_TYPE:
               return "Wand";
            case RING_TYPE:
               return "Accessory";
            case POTION_TYPE:
               return "Potion";
            case SPELL_TYPE:
               return "Spell";
            case SEAL_TYPE:
               return "Holy Seal";
            case CLOAK_TYPE:
               return "Cloak";
            case ROBE_TYPE:
               return "Robe";
            case QUIVER_TYPE:
               return "Quiver";
            case HELM_TYPE:
               return "Helm";
            case STAFF_TYPE:
               return "Staff";
            case POISON_TYPE:
               return "Poison";
            case SKULL_TYPE:
               return "Skull";
            case TRAP_TYPE:
               return "Trap";
            case ORB_TYPE:
               return "Orb";
            case PRISM_TYPE:
               return "Prism";
            case SCEPTER_TYPE:
               return "Scepter";
            case SHURIKEN_TYPE:
               return "Shuriken";
            default:
               return "Invalid Type!";
         }
      }
      
      protected function offsets(param1:int, param2:int, param3:Boolean) : Point
      {
         var _loc4_:Point = new Point();
         switch(param2)
         {
            case RING_TYPE:
               _loc4_.x = param1 == 2878 ? 0 : -2;
               _loc4_.y = param3 ? -2 : 0;
               break;
            case SPELL_TYPE:
               _loc4_.y = -2;
         }
         return _loc4_;
      }
      
      protected function drawBackground() : void
      {
         var _loc4_:Point = null;
         var _loc5_:BitmapTextFactory = null;
         GraphicsUtil.clearPath(this.path_);
         GraphicsUtil.drawCutEdgeRect(0,0,WIDTH,HEIGHT,4,this.cuts_,this.path_);
         graphics.clear();
         graphics.drawGraphicsData(this.graphicsData_);
         var _loc1_:BitmapData = null;
         switch(this.type_)
         {
            case SWORD_TYPE:
               _loc1_ = AssetLibrary.getImageFromSet("lofiObj5",48);
               break;
            case DAGGER_TYPE:
               _loc1_ = AssetLibrary.getImageFromSet("lofiObj5",96);
               break;
            case BOW_TYPE:
               _loc1_ = AssetLibrary.getImageFromSet("lofiObj5",80);
               break;
            case TOME_TYPE:
               _loc1_ = AssetLibrary.getImageFromSet("lofiObj6",80);
               break;
            case SHIELD_TYPE:
               _loc1_ = AssetLibrary.getImageFromSet("lofiObj6",112);
               break;
            case LEATHER_TYPE:
               _loc1_ = AssetLibrary.getImageFromSet("lofiObj5",0);
               break;
            case PLATE_TYPE:
               _loc1_ = AssetLibrary.getImageFromSet("lofiObj5",32);
               break;
            case WAND_TYPE:
               _loc1_ = AssetLibrary.getImageFromSet("lofiObj5",64);
               break;
            case RING_TYPE:
               _loc1_ = AssetLibrary.getImageFromSet("lofiObj",44);
               break;
            case SPELL_TYPE:
               _loc1_ = AssetLibrary.getImageFromSet("lofiObj6",64);
               break;
            case SEAL_TYPE:
               _loc1_ = AssetLibrary.getImageFromSet("lofiObj6",160);
               break;
            case CLOAK_TYPE:
               _loc1_ = AssetLibrary.getImageFromSet("lofiObj6",32);
               break;
            case ROBE_TYPE:
               _loc1_ = AssetLibrary.getImageFromSet("lofiObj5",16);
               break;
            case QUIVER_TYPE:
               _loc1_ = AssetLibrary.getImageFromSet("lofiObj6",48);
               break;
            case HELM_TYPE:
               _loc1_ = AssetLibrary.getImageFromSet("lofiObj6",96);
               break;
            case STAFF_TYPE:
               _loc1_ = AssetLibrary.getImageFromSet("lofiObj5",112);
               break;
            case POISON_TYPE:
               _loc1_ = AssetLibrary.getImageFromSet("lofiObj6",128);
               break;
            case SKULL_TYPE:
               _loc1_ = AssetLibrary.getImageFromSet("lofiObj6",0);
               break;
            case TRAP_TYPE:
               _loc1_ = AssetLibrary.getImageFromSet("lofiObj6",16);
               break;
            case ORB_TYPE:
               _loc1_ = AssetLibrary.getImageFromSet("lofiObj6",144);
               break;
            case PRISM_TYPE:
               _loc1_ = AssetLibrary.getImageFromSet("lofiObj6",176);
               break;
            case SCEPTER_TYPE:
               _loc1_ = AssetLibrary.getImageFromSet("lofiObj6",192);
         }
         if(this.backgroundImage_ == null)
         {
            if(_loc1_ != null)
            {
               _loc4_ = this.offsets(-1,this.type_,true);
               this.backgroundImage_ = new Bitmap(_loc1_);
               this.backgroundImage_.x = BORDER + _loc4_.x;
               this.backgroundImage_.y = BORDER + _loc4_.y;
               this.backgroundImage_.scaleX = 4;
               this.backgroundImage_.scaleY = 4;
               this.backgroundImage_.filters = [greyColorFilter];
               addChild(this.backgroundImage_);
            }
            else if(this.hotkey_ > 0)
            {
               _loc5_ = StaticInjectorContext.getInjector().getInstance(BitmapTextFactory);
               _loc1_ = _loc5_.make(new StaticStringBuilder(String(this.hotkey_)),26,3552822,true,IDENTITY_MATRIX,false);
               this.backgroundImage_ = new Bitmap(_loc1_);
               this.backgroundImage_.x = WIDTH / 2 - _loc1_.width / 2;
               this.backgroundImage_.y = HEIGHT / 2 - 18;
               addChild(this.backgroundImage_);
            }
         }
      }
   }
}

