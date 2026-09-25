package kabam.rotmg.game.view.components
{
   import flash.display.Sprite;
   import kabam.rotmg.ui.model.TabStripModel;
   
   public class StatsTabContent extends Sprite
   {
      
      private var stats:StatsView = new StatsView();
      
      public function StatsTabContent(param1:uint)
      {
         super();
         this.init();
         this.positionChildren(param1);
         this.addChildren();
      }
      
      private function addChildren() : void
      {
         addChild(this.stats);
      }
      
      private function positionChildren(param1:uint) : void
      {
         this.stats.y = (param1 - TabConstants.TAB_TOP_OFFSET) / 2 - this.stats.height / 2;
      }
      
      private function init() : void
      {
         this.stats.name = TabStripModel.STATS;
      }
   }
}

