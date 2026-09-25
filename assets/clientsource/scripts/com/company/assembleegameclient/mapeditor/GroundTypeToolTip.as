package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import com.company.ui.BaseSimpleText;
   import flash.filters.DropShadowFilter;
   
   public class GroundTypeToolTip extends ToolTip
   {
      
      private static const MAX_WIDTH:int = 180;
      
      private var titleText_:BaseSimpleText;
      
      private var descText_:BaseSimpleText;
      
      public function GroundTypeToolTip(param1:XML)
      {
         super(3552822,1,10197915,1,true);
         this.titleText_ = new BaseSimpleText(16,16777215,false,MAX_WIDTH - 4,0);
         this.titleText_.setBold(true);
         this.titleText_.wordWrap = true;
         this.titleText_.text = String(param1.@id);
         this.titleText_.useTextDimensions();
         this.titleText_.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         this.titleText_.x = 0;
         this.titleText_.y = 0;
         addChild(this.titleText_);
         var _loc2_:String = "";
         if(param1.hasOwnProperty("Speed"))
         {
            _loc2_ += "Speed: " + Number(param1.Speed).toFixed(2) + "\n";
         }
         else
         {
            _loc2_ += "Speed: 1.00\n";
         }
         if(param1.hasOwnProperty("NoWalk"))
         {
            _loc2_ += "Unwalkable\n";
         }
         if(param1.hasOwnProperty("Push"))
         {
            _loc2_ += "Push\n";
         }
         if(param1.hasOwnProperty("Sink"))
         {
            _loc2_ += "Sink\n";
         }
         if(param1.hasOwnProperty("Sinking"))
         {
            _loc2_ += "Sinking\n";
         }
         if(param1.hasOwnProperty("Animate"))
         {
            _loc2_ += "Animated\n";
         }
         if(param1.hasOwnProperty("RandomOffset"))
         {
            _loc2_ += "Randomized\n";
         }
         this.descText_ = new BaseSimpleText(14,11776947,false,MAX_WIDTH,0);
         this.descText_.wordWrap = true;
         this.descText_.text = String(_loc2_);
         this.descText_.useTextDimensions();
         this.descText_.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         this.descText_.x = 0;
         this.descText_.y = this.titleText_.height + 2;
         addChild(this.descText_);
      }
   }
}

