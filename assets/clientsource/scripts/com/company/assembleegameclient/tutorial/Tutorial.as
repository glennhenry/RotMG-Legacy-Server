package com.company.assembleegameclient.tutorial
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.util.PointUtil;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.BlurFilter;
   import flash.utils.getTimer;
   import kabam.rotmg.assets.EmbeddedData;
   
   public class Tutorial extends Sprite
   {
      
      public static const NEXT_ACTION:String = "Next";
      
      public static const MOVE_FORWARD_ACTION:String = "MoveForward";
      
      public static const MOVE_BACKWARD_ACTION:String = "MoveBackward";
      
      public static const ROTATE_LEFT_ACTION:String = "RotateLeft";
      
      public static const ROTATE_RIGHT_ACTION:String = "RotateRight";
      
      public static const MOVE_LEFT_ACTION:String = "MoveLeft";
      
      public static const MOVE_RIGHT_ACTION:String = "MoveRight";
      
      public static const UPDATE_ACTION:String = "Update";
      
      public static const ATTACK_ACTION:String = "Attack";
      
      public static const DAMAGE_ACTION:String = "Damage";
      
      public static const KILL_ACTION:String = "Kill";
      
      public static const SHOW_LOOT_ACTION:String = "ShowLoot";
      
      public static const TEXT_ACTION:String = "Text";
      
      public static const SHOW_PORTAL_ACTION:String = "ShowPortal";
      
      public static const ENTER_PORTAL_ACTION:String = "EnterPortal";
      
      public static const NEAR_REQUIREMENT:String = "Near";
      
      public static const EQUIP_REQUIREMENT:String = "Equip";
      
      public var gs_:GameSprite;
      
      public var steps_:Vector.<Step>;
      
      public var currStepId_:int = 0;
      
      private var darkBox_:Sprite;
      
      private var boxesBack_:Shape;
      
      private var boxes_:Shape;
      
      private var tutorialMessage_:TutorialMessage = null;
      
      public function Tutorial(param1:GameSprite)
      {
         var _loc2_:XML = null;
         var _loc3_:Graphics = null;
         this.steps_ = new Vector.<Step>();
         this.darkBox_ = new Sprite();
         this.boxesBack_ = new Shape();
         this.boxes_ = new Shape();
         super();
         this.gs_ = param1;
         for each(_loc2_ in EmbeddedData.tutorialXML.Step)
         {
            this.steps_.push(new Step(_loc2_));
         }
         addChild(this.boxesBack_);
         addChild(this.boxes_);
         _loc3_ = this.darkBox_.graphics;
         _loc3_.clear();
         _loc3_.beginFill(0,0.1);
         _loc3_.drawRect(0,0,800,600);
         _loc3_.endFill();
         Parameters.data_.needsTutorial = false;
         Parameters.save();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.draw();
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc4_:Step = null;
         var _loc5_:Boolean = false;
         var _loc6_:Requirement = null;
         var _loc7_:int = 0;
         var _loc8_:UIDrawBox = null;
         var _loc9_:UIDrawArrow = null;
         var _loc10_:Player = null;
         var _loc11_:Boolean = false;
         var _loc12_:GameObject = null;
         var _loc13_:Number = NaN;
         var _loc2_:Number = Math.abs(Math.sin(getTimer() / 300));
         this.boxesBack_.filters = [new BlurFilter(5 + _loc2_ * 5,5 + _loc2_ * 5)];
         this.boxes_.graphics.clear();
         this.boxesBack_.graphics.clear();
         var _loc3_:int = 0;
         while(_loc3_ < this.steps_.length)
         {
            _loc4_ = this.steps_[_loc3_];
            _loc5_ = true;
            for each(_loc6_ in _loc4_.reqs_)
            {
               _loc10_ = this.gs_.map.player_;
               switch(_loc6_.type_)
               {
                  case NEAR_REQUIREMENT:
                     _loc11_ = false;
                     for each(_loc12_ in this.gs_.map.goDict_)
                     {
                        if(!(_loc12_.objectType_ != _loc6_.objectType_ || _loc6_.objectName_ != "" && _loc12_.name_ != _loc6_.objectName_))
                        {
                           _loc13_ = PointUtil.distanceXY(_loc12_.x_,_loc12_.y_,_loc10_.x_,_loc10_.y_);
                           if(_loc13_ <= _loc6_.radius_)
                           {
                              _loc11_ = true;
                              break;
                           }
                        }
                     }
                     if(!_loc11_)
                     {
                        _loc5_ = false;
                     }
               }
            }
            if(!_loc5_)
            {
               _loc4_.satisfiedSince_ = 0;
            }
            else
            {
               if(_loc4_.satisfiedSince_ == 0)
               {
                  _loc4_.satisfiedSince_ = getTimer();
               }
               _loc7_ = getTimer() - _loc4_.satisfiedSince_;
               for each(_loc8_ in _loc4_.uiDrawBoxes_)
               {
                  _loc8_.draw(5 * _loc2_,this.boxes_.graphics,_loc7_);
                  _loc8_.draw(6 * _loc2_,this.boxesBack_.graphics,_loc7_);
               }
               for each(_loc9_ in _loc4_.uiDrawArrows_)
               {
                  _loc9_.draw(5 * _loc2_,this.boxes_.graphics,_loc7_);
                  _loc9_.draw(6 * _loc2_,this.boxesBack_.graphics,_loc7_);
               }
            }
            _loc3_++;
         }
      }
      
      internal function doneAction(param1:String) : void
      {
         var _loc3_:Requirement = null;
         var _loc4_:Player = null;
         var _loc5_:Boolean = false;
         var _loc6_:GameObject = null;
         var _loc7_:Number = NaN;
         if(this.currStepId_ >= this.steps_.length)
         {
            return;
         }
         var _loc2_:Step = this.steps_[this.currStepId_];
         if(param1 != _loc2_.action_)
         {
            return;
         }
         for each(_loc3_ in _loc2_.reqs_)
         {
            _loc4_ = this.gs_.map.player_;
            switch(_loc3_.type_)
            {
               case NEAR_REQUIREMENT:
                  _loc5_ = false;
                  for each(_loc6_ in this.gs_.map.goDict_)
                  {
                     if(_loc6_.objectType_ == _loc3_.objectType_)
                     {
                        _loc7_ = PointUtil.distanceXY(_loc6_.x_,_loc6_.y_,_loc4_.x_,_loc4_.y_);
                        if(_loc7_ <= _loc3_.radius_)
                        {
                           _loc5_ = true;
                           break;
                        }
                     }
                  }
                  if(!_loc5_)
                  {
                     return;
                  }
                  break;
               case EQUIP_REQUIREMENT:
                  if(_loc4_.equipment_[_loc3_.slot_] != _loc3_.objectType_)
                  {
                     return;
                  }
            }
         }
         ++this.currStepId_;
         this.draw();
      }
      
      private function draw() : void
      {
      }
   }
}

