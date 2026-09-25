package com.company.assembleegameclient.screens
{
   import com.company.assembleegameclient.parameters.Parameters;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import kabam.rotmg.servers.api.Server;
   
   public class ServerBoxes extends Sprite
   {
      
      private var boxes_:Vector.<ServerBox>;
      
      public function ServerBoxes(param1:Vector.<Server>)
      {
         var _loc2_:ServerBox = null;
         var _loc3_:int = 0;
         var _loc4_:Server = null;
         this.boxes_ = new Vector.<ServerBox>();
         super();
         _loc2_ = new ServerBox(null);
         _loc2_.setSelected(true);
         _loc2_.x = ServerBox.WIDTH / 2 + 2;
         _loc2_.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addChild(_loc2_);
         this.boxes_.push(_loc2_);
         _loc3_ = 2;
         for each(_loc4_ in param1)
         {
            _loc2_ = new ServerBox(_loc4_);
            if(_loc4_.name == Parameters.data_.preferredServer)
            {
               this.setSelected(_loc2_);
            }
            _loc2_.x = _loc3_ % 2 * (ServerBox.WIDTH + 4);
            _loc2_.y = int(_loc3_ / 2) * (ServerBox.HEIGHT + 4);
            _loc2_.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            addChild(_loc2_);
            this.boxes_.push(_loc2_);
            _loc3_++;
         }
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:ServerBox = param1.currentTarget as ServerBox;
         if(_loc2_ == null)
         {
            return;
         }
         this.setSelected(_loc2_);
         Parameters.data_.preferredServer = _loc2_.value_;
         Parameters.save();
      }
      
      private function setSelected(param1:ServerBox) : void
      {
         var _loc2_:ServerBox = null;
         for each(_loc2_ in this.boxes_)
         {
            _loc2_.setSelected(false);
         }
         param1.setSelected(true);
      }
   }
}

