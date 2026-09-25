package com.company.assembleegameclient.ui.tooltip
{
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.GameObjectListItem;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class PlayerGroupToolTip extends ToolTip
   {
      
      public var players_:Vector.<Player> = null;
      
      private var playerPanels_:Vector.<GameObjectListItem> = new Vector.<GameObjectListItem>();
      
      private var clickMessage_:TextFieldDisplayConcrete;
      
      public function PlayerGroupToolTip(param1:Vector.<Player>, param2:Boolean = true)
      {
         super(3552822,0.5,16777215,1,param2);
         this.clickMessage_ = new TextFieldDisplayConcrete().setSize(12).setColor(11776947);
         this.clickMessage_.setStringBuilder(new LineBuilder().setParams(TextKey.PLAYER_TOOL_TIP_CLICK_MESSAGE));
         this.clickMessage_.filters = [new DropShadowFilter(0,0,0)];
         addChild(this.clickMessage_);
         this.setPlayers(param1);
         if(!param2)
         {
            filters = [];
         }
         waiter.push(this.clickMessage_.textChanged);
      }
      
      public function setPlayers(param1:Vector.<Player>) : void
      {
         var _loc3_:Player = null;
         var _loc4_:GameObjectListItem = null;
         this.clear();
         this.players_ = param1.slice();
         if(this.players_ == null || this.players_.length == 0)
         {
            return;
         }
         var _loc2_:int = 0;
         for each(_loc3_ in param1)
         {
            _loc4_ = new GameObjectListItem(11776947,true,_loc3_);
            _loc4_.x = 0;
            _loc4_.y = _loc2_;
            addChild(_loc4_);
            this.playerPanels_.push(_loc4_);
            _loc2_ += 32;
         }
         this.clickMessage_.x = width / 2 - this.clickMessage_.width / 2;
         this.clickMessage_.y = _loc2_;
         draw();
      }
      
      private function clear() : void
      {
         var _loc1_:GameObjectListItem = null;
         graphics.clear();
         for each(_loc1_ in this.playerPanels_)
         {
            removeChild(_loc1_);
         }
         this.playerPanels_.length = 0;
      }
   }
}

