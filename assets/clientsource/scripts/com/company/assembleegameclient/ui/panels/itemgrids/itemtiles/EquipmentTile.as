package com.company.assembleegameclient.ui.panels.itemgrids.itemtiles
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.panels.itemgrids.ItemGrid;
   import com.company.util.AssetLibrary;
   import com.company.util.MoreColorUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.filters.ColorMatrixFilter;
   import kabam.rotmg.constants.ItemConstants;
   
   public class EquipmentTile extends InteractiveItemTile
   {
      
      private static const greyColorFilter:ColorMatrixFilter = new ColorMatrixFilter(MoreColorUtil.singleColorFilterMatrix(3552822));
      
      public var backgroundDetail:Bitmap;
      
      public var itemType:int;
      
      private var minManaUsage:int;
      
      public function EquipmentTile(param1:int, param2:ItemGrid, param3:Boolean)
      {
         super(param1,param2,param3);
      }
      
      override public function canHoldItem(param1:int) : Boolean
      {
         return param1 <= 0 || this.itemType == ObjectLibrary.getSlotTypeFromType(param1);
      }
      
      public function setType(param1:int) : void
      {
         var _loc2_:BitmapData = null;
         switch(param1)
         {
            case ItemConstants.SWORD_TYPE:
               _loc2_ = AssetLibrary.getImageFromSet("lofiObj5",48);
               break;
            case ItemConstants.DAGGER_TYPE:
               _loc2_ = AssetLibrary.getImageFromSet("lofiObj5",96);
               break;
            case ItemConstants.BOW_TYPE:
               _loc2_ = AssetLibrary.getImageFromSet("lofiObj5",80);
               break;
            case ItemConstants.TOME_TYPE:
               _loc2_ = AssetLibrary.getImageFromSet("lofiObj6",80);
               break;
            case ItemConstants.SHIELD_TYPE:
               _loc2_ = AssetLibrary.getImageFromSet("lofiObj6",112);
               break;
            case ItemConstants.LEATHER_TYPE:
               _loc2_ = AssetLibrary.getImageFromSet("lofiObj5",0);
               break;
            case ItemConstants.PLATE_TYPE:
               _loc2_ = AssetLibrary.getImageFromSet("lofiObj5",32);
               break;
            case ItemConstants.WAND_TYPE:
               _loc2_ = AssetLibrary.getImageFromSet("lofiObj5",64);
               break;
            case ItemConstants.RING_TYPE:
               _loc2_ = AssetLibrary.getImageFromSet("lofiObj",44);
               break;
            case ItemConstants.SPELL_TYPE:
               _loc2_ = AssetLibrary.getImageFromSet("lofiObj6",64);
               break;
            case ItemConstants.SEAL_TYPE:
               _loc2_ = AssetLibrary.getImageFromSet("lofiObj6",160);
               break;
            case ItemConstants.CLOAK_TYPE:
               _loc2_ = AssetLibrary.getImageFromSet("lofiObj6",32);
               break;
            case ItemConstants.ROBE_TYPE:
               _loc2_ = AssetLibrary.getImageFromSet("lofiObj5",16);
               break;
            case ItemConstants.QUIVER_TYPE:
               _loc2_ = AssetLibrary.getImageFromSet("lofiObj6",48);
               break;
            case ItemConstants.HELM_TYPE:
               _loc2_ = AssetLibrary.getImageFromSet("lofiObj6",96);
               break;
            case ItemConstants.STAFF_TYPE:
               _loc2_ = AssetLibrary.getImageFromSet("lofiObj5",112);
               break;
            case ItemConstants.POISON_TYPE:
               _loc2_ = AssetLibrary.getImageFromSet("lofiObj6",128);
               break;
            case ItemConstants.SKULL_TYPE:
               _loc2_ = AssetLibrary.getImageFromSet("lofiObj6",0);
               break;
            case ItemConstants.TRAP_TYPE:
               _loc2_ = AssetLibrary.getImageFromSet("lofiObj6",16);
               break;
            case ItemConstants.ORB_TYPE:
               _loc2_ = AssetLibrary.getImageFromSet("lofiObj6",144);
               break;
            case ItemConstants.PRISM_TYPE:
               _loc2_ = AssetLibrary.getImageFromSet("lofiObj6",176);
               break;
            case ItemConstants.SCEPTER_TYPE:
               _loc2_ = AssetLibrary.getImageFromSet("lofiObj6",192);
               break;
            case ItemConstants.KATANA_TYPE:
               _loc2_ = AssetLibrary.getImageFromSet("lofiObj3",540);
               break;
            case ItemConstants.SHURIKEN_TYPE:
               _loc2_ = AssetLibrary.getImageFromSet("lofiObj3",555);
         }
         if(_loc2_ != null)
         {
            this.backgroundDetail = new Bitmap(_loc2_);
            this.backgroundDetail.x = BORDER;
            this.backgroundDetail.y = BORDER;
            this.backgroundDetail.scaleX = 4;
            this.backgroundDetail.scaleY = 4;
            this.backgroundDetail.filters = [greyColorFilter];
            addChildAt(this.backgroundDetail,0);
         }
         this.itemType = param1;
      }
      
      override public function setItem(param1:int) : Boolean
      {
         var _loc2_:Boolean = super.setItem(param1);
         if(_loc2_)
         {
            this.backgroundDetail.visible = itemSprite.itemId <= 0;
            this.updateMinMana();
         }
         return _loc2_;
      }
      
      private function updateMinMana() : void
      {
         var _loc1_:XML = null;
         this.minManaUsage = 0;
         if(itemSprite.itemId > 0)
         {
            _loc1_ = ObjectLibrary.xmlLibrary_[itemSprite.itemId];
            if(Boolean(_loc1_) && _loc1_.hasOwnProperty("Usable"))
            {
               if(_loc1_.hasOwnProperty("MultiPhase"))
               {
                  this.minManaUsage = _loc1_.MpEndCost;
               }
               else
               {
                  this.minManaUsage = _loc1_.MpCost;
               }
            }
         }
      }
      
      public function updateDim(param1:Player) : void
      {
         itemSprite.setDim(Boolean(param1) && param1.mp_ < this.minManaUsage);
      }
      
      override protected function beginDragCallback() : void
      {
         this.backgroundDetail.visible = true;
      }
      
      override protected function endDragCallback() : void
      {
         this.backgroundDetail.visible = itemSprite.itemId <= 0;
      }
      
      override protected function getBackgroundColor() : int
      {
         return 4539717;
      }
   }
}

