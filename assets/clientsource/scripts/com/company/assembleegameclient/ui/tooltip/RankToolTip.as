package com.company.assembleegameclient.ui.tooltip
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.ui.LineBreakDesign;
   import com.company.assembleegameclient.util.FameUtil;
   import com.company.rotmg.graphics.StarGraphic;
   import flash.filters.DropShadowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Rectangle;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.ui.view.SignalWaiter;
   
   public class RankToolTip extends ToolTip
   {
      
      private static const PADDING_LEFT:int = 6;
      
      private var earnedText_:TextFieldDisplayConcrete;
      
      private var star_:StarGraphic;
      
      private var howToText_:TextFieldDisplayConcrete;
      
      private var lineBreak_:LineBreakDesign = new LineBreakDesign(100,1842204);
      
      public function RankToolTip(param1:int)
      {
         super(3552822,1,16777215,1);
         this.earnedText_ = new TextFieldDisplayConcrete().setSize(13).setColor(11776947).setBold(true);
         this.earnedText_.setVerticalAlign(TextFieldDisplayConcrete.BOTTOM);
         this.earnedText_.setStringBuilder(new LineBuilder().setParams(TextKey.RANK_TOOL_TIP_EARNED,{"numStars":param1}));
         this.earnedText_.filters = [new DropShadowFilter(0,0,0)];
         this.earnedText_.x = PADDING_LEFT;
         addChild(this.earnedText_);
         this.howToText_ = new TextFieldDisplayConcrete().setSize(13).setColor(11776947);
         this.howToText_.setTextWidth(174);
         this.howToText_.setMultiLine(true).setWordWrap(true);
         this.howToText_.setStringBuilder(new LineBuilder().setParams(TextKey.RANK_TOOL_TIP_COMPLETING_CLASS_QUESTS));
         this.howToText_.filters = [new DropShadowFilter(0,0,0)];
         this.howToText_.x = PADDING_LEFT;
         this.howToText_.y = 30;
         addChild(this.howToText_);
         var _loc2_:SignalWaiter = new SignalWaiter().push(this.earnedText_.textChanged).push(this.howToText_.textChanged);
         _loc2_.complete.addOnce(this.textAdded);
      }
      
      private function textAdded() : void
      {
         var _loc2_:LegendLine = null;
         var _loc3_:int = 0;
         this.earnedText_.y = this.earnedText_.height + 2;
         this.star_ = new StarGraphic();
         this.star_.transform.colorTransform = new ColorTransform(179 / 255,179 / 255,179 / 255);
         var _loc1_:Rectangle = this.earnedText_.getBounds(this);
         this.star_.x = _loc1_.right + 7;
         this.star_.y = this.earnedText_.y - this.star_.height;
         addChild(this.star_);
         this.lineBreak_.x = PADDING_LEFT;
         this.lineBreak_.y = height + 10;
         addChild(this.lineBreak_);
         _loc3_ = this.lineBreak_.y + 4;
         var _loc4_:int = 0;
         while(_loc4_ < FameUtil.COLORS.length)
         {
            _loc2_ = new LegendLine(_loc4_ * ObjectLibrary.playerChars_.length,(_loc4_ + 1) * ObjectLibrary.playerChars_.length - 1,FameUtil.COLORS[_loc4_]);
            _loc2_.x = PADDING_LEFT;
            _loc2_.y = _loc3_;
            addChild(_loc2_);
            _loc3_ += _loc2_.height;
            _loc4_++;
         }
         _loc2_ = new LegendLine(FameUtil.maxStars(),FameUtil.maxStars(),new ColorTransform());
         _loc2_.x = PADDING_LEFT;
         _loc2_.y = _loc3_;
         addChild(_loc2_);
         this.draw();
      }
      
      override public function draw() : void
      {
         this.lineBreak_.setWidthColor(width - 10,1842204);
         super.draw();
      }
   }
}

import com.company.rotmg.graphics.StarGraphic;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

class LegendLine extends Sprite
{
   
   private var coloredStar_:StarGraphic;
   
   private var rangeText_:TextFieldDisplayConcrete;
   
   private var star_:StarGraphic;
   
   public function LegendLine(param1:int, param2:int, param3:ColorTransform)
   {
      super();
      this.addColoredStar(param3);
      this.addRangeText(param1,param2);
      this.addGreyStar();
   }
   
   public function addGreyStar() : void
   {
      this.star_ = new StarGraphic();
      this.star_.transform.colorTransform = new ColorTransform(179 / 255,179 / 255,179 / 255);
      addChild(this.star_);
   }
   
   public function addRangeText(param1:int, param2:int) : void
   {
      this.rangeText_ = new TextFieldDisplayConcrete().setSize(13).setColor(11776947);
      this.rangeText_.setVerticalAlign(TextFieldDisplayConcrete.BOTTOM);
      this.rangeText_.setStringBuilder(new StaticStringBuilder(": " + (param1 == param2 ? param1.toString() : param1 + " - " + param2)));
      this.rangeText_.setBold(true);
      filters = [new DropShadowFilter(0,0,0)];
      this.rangeText_.x = this.coloredStar_.width;
      this.rangeText_.y = this.coloredStar_.getBounds(this).bottom;
      this.rangeText_.textChanged.addOnce(this.positionGreyStar);
      addChild(this.rangeText_);
   }
   
   public function addColoredStar(param1:ColorTransform) : void
   {
      this.coloredStar_ = new StarGraphic();
      this.coloredStar_.transform.colorTransform = param1;
      this.coloredStar_.y = 4;
      addChild(this.coloredStar_);
   }
   
   private function positionGreyStar() : void
   {
      this.star_.x = this.rangeText_.getBounds(this).right + 2;
      this.star_.y = 4;
   }
}
