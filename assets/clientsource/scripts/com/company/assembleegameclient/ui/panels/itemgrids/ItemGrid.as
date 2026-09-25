package com.company.assembleegameclient.ui.panels.itemgrids
{
   import com.company.assembleegameclient.constants.InventoryOwnerTypes;
   import com.company.assembleegameclient.objects.Container;
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.panels.Panel;
   import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.EquipmentTile;
   import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.ItemTile;
   import com.company.assembleegameclient.ui.tooltip.EquipmentToolTip;
   import com.company.assembleegameclient.ui.tooltip.TextToolTip;
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import flash.events.MouseEvent;
   import kabam.rotmg.constants.ItemConstants;
   import kabam.rotmg.text.model.TextKey;
   import org.osflash.signals.Signal;
   
   public class ItemGrid extends Panel
   {
      
      private static const NO_CUT:Array = [0,0,0,0];
      
      private static const CutsByNum:Object = {
         1:[[1,0,0,1],NO_CUT,NO_CUT,[0,1,1,0]],
         2:[[1,0,0,0],NO_CUT,NO_CUT,[0,1,0,0],[0,0,0,1],NO_CUT,NO_CUT,[0,0,1,0]],
         3:[[1,0,0,1],NO_CUT,NO_CUT,[0,1,1,0],[1,0,0,0],NO_CUT,NO_CUT,[0,1,0,0],[0,0,0,1],NO_CUT,NO_CUT,[0,0,1,0]]
      };
      
      private const padding:uint = 4;
      
      private const rowLength:uint = 4;
      
      public var owner:GameObject;
      
      private var tooltip:ToolTip;
      
      private var tooltipFocusTile:ItemTile;
      
      public var curPlayer:Player;
      
      protected var indexOffset:int;
      
      public var interactive:Boolean;
      
      public const addToolTip:Signal = new Signal(ToolTip);
      
      public function ItemGrid(param1:GameObject, param2:Player, param3:int)
      {
         super(null);
         this.owner = param1;
         this.curPlayer = param2;
         this.indexOffset = param3;
         var _loc4_:Container = param1 as Container;
         if(param1 == param2 || Boolean(_loc4_))
         {
            this.interactive = true;
         }
      }
      
      public function hideTooltip() : void
      {
         if(this.tooltip)
         {
            this.tooltip.detachFromTarget();
            this.tooltip = null;
            this.tooltipFocusTile = null;
         }
      }
      
      public function refreshTooltip() : void
      {
         if(!stage || !this.tooltip || !this.tooltip.stage)
         {
            return;
         }
         if(this.tooltipFocusTile)
         {
            this.tooltip.detachFromTarget();
            this.tooltip = null;
            this.addToolTipToTile(this.tooltipFocusTile);
         }
      }
      
      private function onTileHover(param1:MouseEvent) : void
      {
         if(!stage)
         {
            return;
         }
         var _loc2_:ItemTile = param1.currentTarget as ItemTile;
         this.addToolTipToTile(_loc2_);
         this.tooltipFocusTile = _loc2_;
      }
      
      private function addToolTipToTile(param1:ItemTile) : void
      {
         var _loc2_:String = null;
         if(param1.itemSprite.itemId > 0)
         {
            this.tooltip = new EquipmentToolTip(param1.itemSprite.itemId,this.curPlayer,this.owner ? this.owner.objectType_ : -1,this.getCharacterType());
         }
         else
         {
            if(param1 is EquipmentTile)
            {
               _loc2_ = ItemConstants.itemTypeToName((param1 as EquipmentTile).itemType);
            }
            else
            {
               _loc2_ = TextKey.ITEM;
            }
            this.tooltip = new TextToolTip(3552822,10197915,null,TextKey.ITEM_EMPTY_SLOT,200,{"itemType":TextKey.wrapForTokenResolution(_loc2_)});
         }
         this.tooltip.attachToTarget(param1);
         this.addToolTip.dispatch(this.tooltip);
      }
      
      private function getCharacterType() : String
      {
         if(this.owner == this.curPlayer)
         {
            return InventoryOwnerTypes.CURRENT_PLAYER;
         }
         if(this.owner is Player)
         {
            return InventoryOwnerTypes.OTHER_PLAYER;
         }
         return InventoryOwnerTypes.NPC;
      }
      
      protected function addToGrid(param1:ItemTile, param2:uint, param3:uint) : void
      {
         param1.drawBackground(CutsByNum[param2][param3]);
         param1.addEventListener(MouseEvent.ROLL_OVER,this.onTileHover);
         param1.x = int(param3 % this.rowLength) * (ItemTile.WIDTH + this.padding);
         param1.y = int(param3 / this.rowLength) * (ItemTile.HEIGHT + this.padding);
         addChild(param1);
      }
      
      public function setItems(param1:Vector.<int>, param2:int = 0) : void
      {
      }
      
      public function enableInteraction(param1:Boolean) : void
      {
         mouseEnabled = param1;
      }
      
      override public function draw() : void
      {
         this.setItems(this.owner.equipment_,this.indexOffset);
      }
   }
}

