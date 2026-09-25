package com.company.assembleegameclient.ui.menu
{
   import com.company.assembleegameclient.objects.Player;
   import com.company.util.AssetLibrary;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class TeleportMenuOption extends MenuOption
   {
      
      private static const inactiveCT:ColorTransform = new ColorTransform(84 / 255,84 / 255,84 / 255);
      
      private var player_:Player;
      
      private var mouseOver_:Boolean = false;
      
      private var barText_:TextFieldDisplayConcrete;
      
      private var barTextOrigWidth_:int;
      
      private var barMask:Shape = new Shape();
      
      public function TeleportMenuOption(param1:Player)
      {
         super(AssetLibrary.getImageFromSet("lofiInterface2",3),16777215,TextKey.TELEPORTMENUOPTION_TITLE);
         this.player_ = param1;
         this.barText_ = new TextFieldDisplayConcrete().setSize(18).setColor(16777215);
         this.barText_.setBold(true);
         this.barText_.setStringBuilder(new LineBuilder().setParams(TextKey.TELEPORTMENUOPTION_TITLE));
         this.barText_.x = this.barMask.x = text_.x;
         this.barText_.y = this.barMask.y = text_.y;
         this.barText_.textChanged.add(this.onTextChanged);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onTextChanged() : void
      {
         this.barTextOrigWidth_ = this.barText_.textField.width;
         this.barMask.graphics.beginFill(16711935);
         this.barMask.graphics.drawRect(0,0,this.barText_.textField.width,this.barText_.textField.height);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:int = this.player_.msUtilTeleport();
         if(_loc2_ > 0)
         {
            if(!contains(this.barText_))
            {
               addChild(this.barText_);
               addChild(this.barMask);
               this.barText_.mask = this.barMask;
            }
            _loc3_ = this.barTextOrigWidth_ * (1 - _loc2_ / Player.MS_BETWEEN_TELEPORT);
            this.barMask.width = _loc3_;
            setColorTransform(inactiveCT);
         }
         else
         {
            if(contains(this.barText_))
            {
               removeChild(this.barText_);
            }
            if(this.mouseOver_)
            {
               setColorTransform(mouseOverCT);
            }
            else
            {
               setColorTransform(null);
            }
         }
      }
      
      override protected function onMouseOver(param1:MouseEvent) : void
      {
         this.mouseOver_ = true;
      }
      
      override protected function onMouseOut(param1:MouseEvent) : void
      {
         this.mouseOver_ = false;
      }
   }
}

