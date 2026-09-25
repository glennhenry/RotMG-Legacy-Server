package com.company.assembleegameclient.ui.panels
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.objects.Party;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.GameObjectListItem;
   import com.company.assembleegameclient.ui.PlayerGameObjectListItem;
   import com.company.assembleegameclient.ui.menu.PlayerMenu;
   import com.company.util.MoreColorUtil;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.utils.getTimer;
   
   public class PartyPanel extends Panel
   {
      
      public var menuLayer:DisplayObjectContainer;
      
      public var memberPanels:Vector.<PlayerGameObjectListItem> = new Vector.<PlayerGameObjectListItem>(Party.NUM_MEMBERS,true);
      
      public var mouseOver_:Boolean;
      
      public var menu:PlayerMenu;
      
      public function PartyPanel(param1:GameSprite)
      {
         super(param1);
         this.memberPanels[0] = this.createPartyMemberPanel(0,0);
         this.memberPanels[1] = this.createPartyMemberPanel(100,0);
         this.memberPanels[2] = this.createPartyMemberPanel(0,32);
         this.memberPanels[3] = this.createPartyMemberPanel(100,32);
         this.memberPanels[4] = this.createPartyMemberPanel(0,64);
         this.memberPanels[5] = this.createPartyMemberPanel(100,64);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function createPartyMemberPanel(param1:int, param2:int) : PlayerGameObjectListItem
      {
         var _loc3_:PlayerGameObjectListItem = new PlayerGameObjectListItem(16777215,false,null);
         addChild(_loc3_);
         _loc3_.x = param1;
         _loc3_.y = param2;
         return _loc3_;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         var _loc2_:PlayerGameObjectListItem = null;
         for each(_loc2_ in this.memberPanels)
         {
            _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
            _loc2_.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         }
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         var _loc2_:PlayerGameObjectListItem = null;
         this.removeMenu();
         for each(_loc2_ in this.memberPanels)
         {
            _loc2_.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            _loc2_.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
            _loc2_.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         }
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         if(this.menu != null && this.menu.parent != null)
         {
            return;
         }
         var _loc2_:PlayerGameObjectListItem = param1.currentTarget as PlayerGameObjectListItem;
         var _loc3_:Player = _loc2_.go as Player;
         if(_loc3_ == null || _loc3_.texture_ == null)
         {
            return;
         }
         this.mouseOver_ = true;
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         this.mouseOver_ = false;
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         this.removeMenu();
         var _loc2_:PlayerGameObjectListItem = param1.currentTarget as PlayerGameObjectListItem;
         _loc2_.setEnabled(false);
         this.menu = new PlayerMenu();
         this.menu.init(gs_,_loc2_.go as Player);
         this.menuLayer.addChild(this.menu);
         this.menu.addEventListener(Event.REMOVED_FROM_STAGE,this.onMenuRemoved);
      }
      
      private function onMenuRemoved(param1:Event) : void
      {
         var _loc2_:GameObjectListItem = null;
         var _loc3_:PlayerGameObjectListItem = null;
         for each(_loc2_ in this.memberPanels)
         {
            _loc3_ = _loc2_ as PlayerGameObjectListItem;
            if(_loc3_)
            {
               _loc3_.setEnabled(true);
            }
         }
         param1.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE,this.onMenuRemoved);
      }
      
      private function removeMenu() : void
      {
         if(this.menu != null)
         {
            this.menu.remove();
            this.menu = null;
         }
      }
      
      override public function draw() : void
      {
         var _loc4_:GameObjectListItem = null;
         var _loc5_:Player = null;
         var _loc6_:ColorTransform = null;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc1_:Party = gs_.map.party_;
         if(_loc1_ == null)
         {
            for each(_loc4_ in this.memberPanels)
            {
               _loc4_.clear();
            }
            return;
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < Party.NUM_MEMBERS)
         {
            if(this.mouseOver_ || this.menu != null && this.menu.parent != null)
            {
               _loc5_ = this.memberPanels[_loc3_].go as Player;
            }
            else
            {
               _loc5_ = _loc1_.members_[_loc3_];
            }
            if(_loc5_ != null && _loc5_.map_ == null)
            {
               _loc5_ = null;
            }
            _loc6_ = null;
            if(_loc5_ != null)
            {
               if(_loc5_.hp_ < _loc5_.maxHP_ * 0.2)
               {
                  if(_loc2_ == 0)
                  {
                     _loc2_ = getTimer();
                  }
                  _loc7_ = int(Math.abs(Math.sin(_loc2_ / 200)) * 10) / 10;
                  _loc8_ = 128;
                  _loc6_ = new ColorTransform(1,1,1,1,_loc7_ * _loc8_,-_loc7_ * _loc8_,-_loc7_ * _loc8_);
               }
               if(!_loc5_.starred_)
               {
                  if(_loc6_ != null)
                  {
                     _loc6_.concat(MoreColorUtil.darkCT);
                  }
                  else
                  {
                     _loc6_ = MoreColorUtil.darkCT;
                  }
               }
            }
            this.memberPanels[_loc3_].draw(_loc5_,_loc6_);
            _loc3_++;
         }
      }
   }
}

