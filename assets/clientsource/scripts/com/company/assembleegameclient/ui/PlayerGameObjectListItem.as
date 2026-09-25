package com.company.assembleegameclient.ui
{
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.tooltip.PlayerToolTip;
   import com.company.util.MoreColorUtil;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import kabam.rotmg.core.signals.HideTooltipsSignal;
   import kabam.rotmg.core.signals.ShowTooltipSignal;
   import kabam.rotmg.tooltips.HoverTooltipDelegate;
   import kabam.rotmg.tooltips.TooltipAble;
   
   public class PlayerGameObjectListItem extends GameObjectListItem implements TooltipAble
   {
      
      public const hoverTooltipDelegate:HoverTooltipDelegate = new HoverTooltipDelegate();
      
      private var enabled:Boolean = true;
      
      private var starred:Boolean = false;
      
      public function PlayerGameObjectListItem(param1:uint, param2:Boolean, param3:GameObject)
      {
         super(param1,param2,param3);
         var _loc4_:Player = param3 as Player;
         if(_loc4_)
         {
            this.starred = _loc4_.starred_;
         }
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.hoverTooltipDelegate.setDisplayObject(this);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         this.hoverTooltipDelegate.tooltip = this.enabled ? new PlayerToolTip(Player(go)) : null;
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         if(this.enabled != param1 && Player(go) != null)
         {
            this.enabled = param1;
            this.hoverTooltipDelegate.tooltip = this.enabled ? new PlayerToolTip(Player(go)) : null;
            if(!this.enabled)
            {
               this.hoverTooltipDelegate.getShowToolTip().dispatch(this.hoverTooltipDelegate.tooltip);
            }
         }
      }
      
      override public function draw(param1:GameObject, param2:ColorTransform = null) : void
      {
         var _loc3_:Player = param1 as Player;
         if(Boolean(_loc3_) && this.starred != _loc3_.starred_)
         {
            transform.colorTransform = param2 || MoreColorUtil.identity;
            this.starred = _loc3_.starred_;
         }
         super.draw(param1,param2);
      }
      
      public function setShowToolTipSignal(param1:ShowTooltipSignal) : void
      {
         this.hoverTooltipDelegate.setShowToolTipSignal(param1);
      }
      
      public function getShowToolTip() : ShowTooltipSignal
      {
         return this.hoverTooltipDelegate.getShowToolTip();
      }
      
      public function setHideToolTipsSignal(param1:HideTooltipsSignal) : void
      {
         this.hoverTooltipDelegate.setHideToolTipsSignal(param1);
      }
      
      public function getHideToolTips() : HideTooltipsSignal
      {
         return this.hoverTooltipDelegate.getHideToolTips();
      }
   }
}

