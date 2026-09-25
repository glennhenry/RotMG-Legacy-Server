package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.ui.panels.Panel;
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import flash.display.BitmapData;
   import kabam.rotmg.game.view.SellableObjectPanel;
   
   public class SellableObject extends GameObject implements IInteractiveObject
   {
      
      public var price_:int = 0;
      
      public var currency_:int = -1;
      
      public var rankReq_:int = 0;
      
      public var guildRankReq_:int = -1;
      
      public var quantity_:int = 1;
      
      public function SellableObject(param1:XML)
      {
         super(param1);
         isInteractive_ = true;
      }
      
      public function setPrice(param1:int) : void
      {
         this.price_ = param1;
      }
      
      public function setCurrency(param1:int) : void
      {
         this.currency_ = param1;
      }
      
      public function setRankReq(param1:int) : void
      {
         this.rankReq_ = param1;
      }
      
      public function soldObjectName() : String
      {
         return null;
      }
      
      public function soldObjectInternalName() : String
      {
         return null;
      }
      
      public function getTooltip() : ToolTip
      {
         return null;
      }
      
      public function getIcon() : BitmapData
      {
         return null;
      }
      
      public function getSellableType() : int
      {
         return -1;
      }
      
      public function getQuantity() : int
      {
         return this.quantity_;
      }
      
      public function getPanel(param1:GameSprite) : Panel
      {
         return new SellableObjectPanel(param1,this);
      }
   }
}

