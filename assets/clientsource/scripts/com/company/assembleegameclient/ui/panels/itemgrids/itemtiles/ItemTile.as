package com.company.assembleegameclient.ui.panels.itemgrids.itemtiles
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.panels.itemgrids.ItemGrid;
   import com.company.util.GraphicsUtil;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.IGraphicsData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import kabam.rotmg.constants.ItemConstants;
   
   public class ItemTile extends Sprite
   {
      
      public static const TILE_DOUBLE_CLICK:String = "TILE_DOUBLE_CLICK";
      
      public static const TILE_SINGLE_CLICK:String = "TILE_SINGLE_CLICK";
      
      public static const WIDTH:int = 40;
      
      public static const HEIGHT:int = 40;
      
      public static const BORDER:int = 4;
      
      private var fill_:GraphicsSolidFill = new GraphicsSolidFill(this.getBackgroundColor(),1);
      
      private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      private var graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[this.fill_,this.path_,GraphicsUtil.END_FILL];
      
      private var restrictedUseIndicator:Shape;
      
      public var itemSprite:ItemTileSprite;
      
      public var tileId:int;
      
      public var ownerGrid:ItemGrid;
      
      public var blockingItemUpdates:Boolean;
      
      public function ItemTile(param1:int, param2:ItemGrid)
      {
         super();
         this.tileId = param1;
         this.ownerGrid = param2;
         this.restrictedUseIndicator = new Shape();
         addChild(this.restrictedUseIndicator);
         this.setItemSprite(new ItemTileSprite());
      }
      
      public function drawBackground(param1:Array) : void
      {
         GraphicsUtil.clearPath(this.path_);
         GraphicsUtil.drawCutEdgeRect(0,0,WIDTH,HEIGHT,4,param1,this.path_);
         graphics.clear();
         graphics.drawGraphicsData(this.graphicsData_);
         var _loc2_:GraphicsSolidFill = new GraphicsSolidFill(6036765,1);
         GraphicsUtil.clearPath(this.path_);
         var _loc3_:Vector.<IGraphicsData> = new <IGraphicsData>[_loc2_,this.path_,GraphicsUtil.END_FILL];
         GraphicsUtil.drawCutEdgeRect(0,0,WIDTH,HEIGHT,4,param1,this.path_);
         this.restrictedUseIndicator.graphics.drawGraphicsData(_loc3_);
         this.restrictedUseIndicator.cacheAsBitmap = true;
         this.restrictedUseIndicator.visible = false;
      }
      
      public function setItem(param1:int) : Boolean
      {
         if(param1 == this.itemSprite.itemId)
         {
            return false;
         }
         if(this.blockingItemUpdates)
         {
            return true;
         }
         this.itemSprite.setType(param1);
         this.updateUseability(this.ownerGrid.curPlayer);
         return true;
      }
      
      public function setItemSprite(param1:ItemTileSprite) : void
      {
         this.itemSprite = param1;
         this.itemSprite.x = WIDTH / 2;
         this.itemSprite.y = HEIGHT / 2;
         addChild(this.itemSprite);
      }
      
      public function updateUseability(param1:Player) : void
      {
         if(this.itemSprite.itemId != ItemConstants.NO_ITEM)
         {
            this.restrictedUseIndicator.visible = !ObjectLibrary.isUsableByPlayer(this.itemSprite.itemId,param1);
         }
         else
         {
            this.restrictedUseIndicator.visible = false;
         }
      }
      
      public function canHoldItem(param1:int) : Boolean
      {
         return true;
      }
      
      public function resetItemPosition() : void
      {
         this.setItemSprite(this.itemSprite);
      }
      
      public function getItemId() : int
      {
         return this.itemSprite.itemId;
      }
      
      protected function getBackgroundColor() : int
      {
         return 5526612;
      }
   }
}

