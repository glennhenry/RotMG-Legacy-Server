package kabam.rotmg.ui.view
{
   import flash.display.Sprite;
   import kabam.rotmg.ui.view.components.PotionSlotView;
   
   public class PotionInventoryView extends Sprite
   {
      
      private static const LEFT_BUTTON_CUTS:Array = [1,0,0,1];
      
      private static const RIGHT_BUTTON_CUTS:Array = [0,1,1,0];
      
      private static const BUTTON_SPACE:int = 4;
      
      private const cuts:Array;
      
      public function PotionInventoryView()
      {
         var _loc2_:PotionSlotView = null;
         this.cuts = [LEFT_BUTTON_CUTS,RIGHT_BUTTON_CUTS];
         super();
         var _loc1_:int = 0;
         while(_loc1_ < 2)
         {
            _loc2_ = new PotionSlotView(this.cuts[_loc1_],_loc1_);
            _loc2_.x = _loc1_ * (PotionSlotView.BUTTON_WIDTH + BUTTON_SPACE);
            addChild(_loc2_);
            _loc1_++;
         }
      }
   }
}

