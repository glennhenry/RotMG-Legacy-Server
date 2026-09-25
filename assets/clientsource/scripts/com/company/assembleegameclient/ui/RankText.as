package com.company.assembleegameclient.ui
{
   import com.company.assembleegameclient.util.FameUtil;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   import kabam.rotmg.ui.view.SignalWaiter;
   
   public class RankText extends Sprite
   {
      
      public var background:Sprite = null;
      
      public var largeText_:Boolean;
      
      private var numStars_:int = -1;
      
      private var prefix_:TextFieldDisplayConcrete = null;
      
      private var waiter:SignalWaiter = new SignalWaiter();
      
      private var icon:Sprite;
      
      public function RankText(param1:int, param2:Boolean, param3:Boolean)
      {
         super();
         this.largeText_ = param2;
         if(param3)
         {
            this.prefix_ = this.makeText();
            this.prefix_.setStringBuilder(new LineBuilder().setParams(TextKey.RANK_TEXT_RANK));
            this.prefix_.filters = [new DropShadowFilter(0,0,0)];
            this.prefix_.textChanged.addOnce(this.position);
            addChild(this.prefix_);
         }
         mouseEnabled = false;
         mouseChildren = false;
         this.draw(param1);
      }
      
      public function makeText() : TextFieldDisplayConcrete
      {
         var _loc1_:int = this.largeText_ ? 18 : 16;
         var _loc2_:TextFieldDisplayConcrete = new TextFieldDisplayConcrete();
         _loc2_.setSize(_loc1_).setColor(11776947);
         _loc2_.setBold(this.largeText_);
         return _loc2_;
      }
      
      public function draw(param1:int) : void
      {
         var text:TextFieldDisplayConcrete = null;
         var onTextChanged:Function = null;
         var numStars:int = param1;
         onTextChanged = function():void
         {
            text.y = text.height;
            icon.x = text.width + 2;
            icon.y = text.y - icon.height;
            var _loc1_:int = icon.x + icon.width;
            background.graphics.clear();
            background.graphics.beginFill(0,0.4);
            var _loc2_:Number = icon.height + 8;
            background.graphics.drawRoundRect(-2,icon.y - 3,_loc1_ + 6,_loc2_,12,12);
            background.graphics.endFill();
            position();
         };
         if(numStars == this.numStars_)
         {
            return;
         }
         this.numStars_ = numStars;
         if(this.background != null && contains(this.background))
         {
            removeChild(this.background);
         }
         if(this.numStars_ < 0)
         {
            return;
         }
         this.background = new Sprite();
         text = this.makeText();
         text.setVerticalAlign(TextFieldDisplayConcrete.BOTTOM);
         text.setStringBuilder(new StaticStringBuilder(this.numStars_.toString()));
         text.filters = [new DropShadowFilter(0,0,0,1,4,4,2)];
         this.background.addChild(text);
         this.icon = this.largeText_ ? FameUtil.numStarsToBigImage(this.numStars_) : FameUtil.numStarsToImage(this.numStars_);
         this.background.addChild(this.icon);
         text.textChanged.addOnce(onTextChanged);
         addChild(this.background);
         if(this.prefix_ != null)
         {
            this.positionWhenTextIsReady();
         }
      }
      
      private function positionWhenTextIsReady() : void
      {
         if(this.waiter.isEmpty())
         {
            this.position();
         }
         else
         {
            this.waiter.complete.addOnce(this.position);
         }
      }
      
      private function position() : void
      {
         if(this.prefix_)
         {
            this.background.x = this.prefix_.width;
            this.prefix_.y = this.icon.y - 3;
         }
      }
   }
}

