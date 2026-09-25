package com.company.assembleegameclient.map.partyoverlay
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.map.Map;
   import com.company.assembleegameclient.map.Quest;
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.tooltip.PortraitToolTip;
   import com.company.assembleegameclient.ui.tooltip.QuestToolTip;
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   
   public class QuestArrow extends GameObjectArrow
   {
      
      public var map_:Map;
      
      public function QuestArrow(param1:Map)
      {
         super(16352321,12919330,true);
         this.map_ = param1;
      }
      
      public function refreshToolTip() : void
      {
         setToolTip(this.getToolTip(go_,getTimer()));
      }
      
      override protected function onMouseOver(param1:MouseEvent) : void
      {
         super.onMouseOver(param1);
         this.refreshToolTip();
      }
      
      override protected function onMouseOut(param1:MouseEvent) : void
      {
         super.onMouseOut(param1);
         this.refreshToolTip();
      }
      
      private function getToolTip(param1:GameObject, param2:int) : ToolTip
      {
         if(param1 == null || param1.texture_ == null)
         {
            return null;
         }
         if(this.shouldShowFullQuest(param2))
         {
            return new QuestToolTip(go_);
         }
         if(Parameters.data_.showQuestPortraits)
         {
            return new PortraitToolTip(param1);
         }
         return null;
      }
      
      private function shouldShowFullQuest(param1:int) : Boolean
      {
         var _loc2_:Quest = this.map_.quest_;
         return mouseOver_ || _loc2_.isNew(param1);
      }
      
      override public function draw(param1:int, param2:Camera) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc3_:GameObject = this.map_.quest_.getObject(param1);
         if(_loc3_ != go_)
         {
            setGameObject(_loc3_);
            setToolTip(this.getToolTip(_loc3_,param1));
         }
         else if(go_ != null)
         {
            _loc4_ = tooltip_ is QuestToolTip;
            _loc5_ = this.shouldShowFullQuest(param1);
            if(_loc4_ != _loc5_)
            {
               setToolTip(this.getToolTip(_loc3_,param1));
            }
         }
         super.draw(param1,param2);
      }
   }
}

