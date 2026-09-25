package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.ui.panels.Panel;
   import com.company.assembleegameclient.ui.tooltip.TextToolTip;
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.game.signals.TextPanelMessageUpdateSignal;
   import kabam.rotmg.game.view.TextPanel;
   import kabam.rotmg.text.model.TextKey;
   
   public class ClosedGiftChest extends GameObject implements IInteractiveObject
   {
      
      private var textPanelUpdateSignal:TextPanelMessageUpdateSignal;
      
      public function ClosedGiftChest(param1:XML)
      {
         super(param1);
         isInteractive_ = true;
         this.textPanelUpdateSignal = StaticInjectorContext.getInjector().getInstance(TextPanelMessageUpdateSignal);
      }
      
      public function getTooltip() : ToolTip
      {
         return new TextToolTip(3552822,10197915,TextKey.CLOSEDGIFTCHEST_TITLE,TextKey.TEXTPANEL_GIFTCHESTISEMPTY,200);
      }
      
      public function getPanel(param1:GameSprite) : Panel
      {
         this.textPanelUpdateSignal.dispatch(TextKey.TEXTPANEL_GIFTCHESTISEMPTY);
         return new TextPanel(param1);
      }
   }
}

