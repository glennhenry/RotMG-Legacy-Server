package com.company.assembleegameclient.screens
{
   import com.company.assembleegameclient.ui.tooltip.TextToolTip;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import flash.utils.getTimer;
   import kabam.rotmg.core.signals.HideTooltipsSignal;
   import kabam.rotmg.core.signals.ShowTooltipSignal;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   import kabam.rotmg.text.view.stringBuilder.StringBuilder;
   import kabam.rotmg.tooltips.HoverTooltipDelegate;
   import kabam.rotmg.tooltips.TooltipAble;
   
   public class ScoreTextLine extends Sprite implements TooltipAble
   {
      
      public static var textTooltip_:TextToolTip = new TextToolTip(3552822,10197915,null,"",150);
      
      public var hoverTooltipDelegate:HoverTooltipDelegate = new HoverTooltipDelegate();
      
      public var description:String;
      
      public var level:int;
      
      public var number_:int;
      
      public var numberPrefix_:String;
      
      public var unit_:String;
      
      private var startTime_:int = 0;
      
      private var nameText_:TextFieldDisplayConcrete;
      
      private var numberText_:TextFieldDisplayConcrete;
      
      private var unitIcon_:DisplayObject;
      
      public function ScoreTextLine(param1:int, param2:uint, param3:uint, param4:String, param5:String, param6:int, param7:int, param8:String, param9:String, param10:DisplayObject)
      {
         super();
         this.name = param4;
         this.description = param5;
         this.level = param6;
         this.number_ = param7;
         this.numberPrefix_ = param8;
         this.unit_ = param9;
         this.nameText_ = new TextFieldDisplayConcrete().setSize(param1).setColor(param2);
         this.nameText_.setBold(true);
         this.nameText_.setAutoSize(TextFieldAutoSize.RIGHT);
         this.nameText_.setStringBuilder(new LineBuilder().setParams(param4));
         this.nameText_.x = 410;
         this.nameText_.filters = [new DropShadowFilter(0,0,0,1,4,4,2)];
         addChild(this.nameText_);
         if(this.number_ != -1)
         {
            this.numberText_ = new TextFieldDisplayConcrete().setSize(param1).setColor(param3);
            this.numberText_.setBold(true);
            this.numberText_.setStringBuilder(new StaticStringBuilder(param8 + "0" + " " + param9));
            this.numberText_.x = 450;
            this.numberText_.filters = [new DropShadowFilter(0,0,0,1,4,4,2)];
            addChild(this.numberText_);
         }
         if(param10 != null)
         {
            this.unitIcon_ = param10;
            this.nameText_.textChanged.addOnce(this.onTextChanged);
            addChild(this.unitIcon_);
         }
         this.hoverTooltipDelegate.setDisplayObject(this);
         if(param5)
         {
            this.hoverTooltipDelegate.tooltip = textTooltip_;
         }
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onTextChanged() : void
      {
         if(this.numberText_ != null)
         {
            this.unitIcon_.x = this.numberText_.x + this.numberText_.width - 4;
            this.unitIcon_.y = this.numberText_.height / 2 - this.unitIcon_.height / 2 + 2;
         }
         else
         {
            this.unitIcon_.x = 450;
            this.unitIcon_.y = this.nameText_.height / 2 - this.unitIcon_.height / 2 + 2;
         }
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
      
      public function skip() : void
      {
         this.startTime_ = -1000000;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         if(this.startTime_ == 0)
         {
            this.startTime_ = getTimer();
         }
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
      }
      
      public function onEnterFrame(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Number = Math.min(1,(getTimer() - this.startTime_) / 500);
         if(this.numberText_ != null)
         {
            _loc3_ = this.number_ * _loc2_;
            this.numberText_.setStringBuilder(new StaticStringBuilder(this.numberPrefix_ + _loc3_.toString() + " " + this.unit_));
            if(this.unitIcon_ != null)
            {
               this.unitIcon_.x = this.numberText_.x + this.numberText_.width - 4;
               this.unitIcon_.y = this.numberText_.height / 2 - this.unitIcon_.height / 2 + 2;
            }
         }
         if(_loc2_ == 1)
         {
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      public function onMouseOver(param1:Event) : void
      {
         if(this.description != null)
         {
            textTooltip_.setText(this.makeDescription());
            stage.addChild(textTooltip_);
         }
      }
      
      private function makeDescription() : StringBuilder
      {
         var _loc1_:AppendingLineBuilder = new AppendingLineBuilder();
         _loc1_.setDelimiter("");
         _loc1_.pushParams(this.description);
         if(this.level > 1)
         {
            _loc1_.pushParams(TextKey.BLANK,{"data":" ("});
            _loc1_.pushParams("FameBonus.LevelRequirement",{"level":this.level});
            _loc1_.pushParams(TextKey.BLANK,{"data":")"});
         }
         return _loc1_;
      }
   }
}

