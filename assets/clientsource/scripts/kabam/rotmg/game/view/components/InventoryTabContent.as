package kabam.rotmg.game.view.components
{
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.panels.itemgrids.InventoryGrid;
   import flash.display.Sprite;
   import kabam.rotmg.ui.model.TabStripModel;
   import kabam.rotmg.ui.view.PotionInventoryView;
   
   public class InventoryTabContent extends Sprite
   {
      
      private var storageContent:Sprite = new Sprite();
      
      private var storage:InventoryGrid;
      
      private var potionsInventory:PotionInventoryView = new PotionInventoryView();
      
      public function InventoryTabContent(param1:Player)
      {
         super();
         this.init(param1);
         this.addChildren();
         this.positionChildren();
      }
      
      private function init(param1:Player) : void
      {
         this.storage = new InventoryGrid(param1,param1,4);
         this.storageContent.name = TabStripModel.MAIN_INVENTORY;
      }
      
      private function addChildren() : void
      {
         this.storageContent.addChild(this.storage);
         this.storageContent.addChild(this.potionsInventory);
         addChild(this.storageContent);
      }
      
      private function positionChildren() : void
      {
         this.storageContent.x = 7;
         this.storageContent.y = 7;
         this.potionsInventory.y = this.storage.height + 4;
      }
   }
}

