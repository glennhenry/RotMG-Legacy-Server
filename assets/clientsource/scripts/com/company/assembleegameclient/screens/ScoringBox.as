package com.company.assembleegameclient.screens
{
   import com.company.assembleegameclient.ui.Scrollbar;
   import com.company.assembleegameclient.util.FameUtil;
   import com.company.util.BitmapUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   import kabam.rotmg.text.model.TextKey;
   
   public class ScoringBox extends Sprite
   {
      
      private var rect_:Rectangle;
      
      private var mask_:Shape;
      
      private var linesSprite_:Sprite;
      
      private var scoreTextLines_:Vector.<ScoreTextLine>;
      
      private var scrollbar_:Scrollbar;
      
      private var startTime_:int;
      
      public function ScoringBox(param1:Rectangle, param2:XML)
      {
         var _loc4_:XML = null;
         this.mask_ = new Shape();
         this.linesSprite_ = new Sprite();
         this.scoreTextLines_ = new Vector.<ScoreTextLine>();
         super();
         this.rect_ = param1;
         graphics.lineStyle(1,4802889,2);
         graphics.drawRect(this.rect_.x + 1,this.rect_.y + 1,this.rect_.width - 2,this.rect_.height - 2);
         graphics.lineStyle();
         this.scrollbar_ = new Scrollbar(16,this.rect_.height);
         this.scrollbar_.addEventListener(Event.CHANGE,this.onScroll);
         this.mask_.graphics.beginFill(16777215,1);
         this.mask_.graphics.drawRect(this.rect_.x,this.rect_.y,this.rect_.width,this.rect_.height);
         this.mask_.graphics.endFill();
         addChild(this.mask_);
         mask = this.mask_;
         addChild(this.linesSprite_);
         this.addLine(TextKey.FAMEVIEW_SHOTS,null,0,param2.Shots,false,5746018);
         if(int(param2.Shots) != 0)
         {
            this.addLine(TextKey.FAMEVIEW_ACCURACY,null,0,100 * Number(param2.ShotsThatDamage) / Number(param2.Shots),true,5746018,"","%");
         }
         this.addLine(TextKey.FAMEVIEW_TILES_SEEN,null,0,param2.TilesUncovered,false,5746018);
         this.addLine(TextKey.FAMEVIEW_MONSTERKILLS,null,0,param2.MonsterKills,false,5746018);
         this.addLine(TextKey.FAMEVIEW_GODKILLS,null,0,param2.GodKills,false,5746018);
         this.addLine(TextKey.FAMEVIEW_ORYXKILLS,null,0,param2.OryxKills,false,5746018);
         this.addLine(TextKey.FAMEVIEW_QUESTSCOMPLETED,null,0,param2.QuestsCompleted,false,5746018);
         this.addLine(TextKey.FAMEVIEW_DUNGEONSCOMPLETED,null,0,int(param2.PirateCavesCompleted) + int(param2.UndeadLairsCompleted) + int(param2.AbyssOfDemonsCompleted) + int(param2.SnakePitsCompleted) + int(param2.SpiderDensCompleted) + int(param2.SpriteWorldsCompleted) + int(param2.TombsCompleted),false,5746018);
         this.addLine(TextKey.FAMEVIEW_PARTYMEMBERLEVELUPS,null,0,param2.LevelUpAssists,false,5746018);
         var _loc3_:BitmapData = FameUtil.getFameIcon();
         _loc3_ = BitmapUtil.cropToBitmapData(_loc3_,6,6,_loc3_.width - 12,_loc3_.height - 12);
         this.addLine(TextKey.FAMEVIEW_BASEFAMEEARNED,null,0,param2.BaseFame,true,16762880,"","",new Bitmap(_loc3_));
         for each(_loc4_ in param2.Bonus)
         {
            this.addLine(_loc4_.@id,_loc4_.@desc,_loc4_.@level,int(_loc4_),true,16762880,"+","",new Bitmap(_loc3_));
         }
      }
      
      public function showScore() : void
      {
         var _loc1_:ScoreTextLine = null;
         this.animateScore();
         this.startTime_ = -int.MAX_VALUE;
         for each(_loc1_ in this.scoreTextLines_)
         {
            _loc1_.skip();
         }
      }
      
      public function animateScore() : void
      {
         this.startTime_ = getTimer();
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onScroll(param1:Event) : void
      {
         var _loc2_:Number = this.scrollbar_.pos();
         this.linesSprite_.y = _loc2_ * (this.rect_.height - this.linesSprite_.height - 15) + 5;
      }
      
      private function addLine(param1:String, param2:String, param3:int, param4:int, param5:Boolean, param6:uint, param7:String = "", param8:String = "", param9:DisplayObject = null) : void
      {
         if(param4 == 0 && !param5)
         {
            return;
         }
         this.scoreTextLines_.push(new ScoreTextLine(20,11776947,param6,param1,param2,param3,param4,param7,param8,param9));
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc3_:Number = NaN;
         var _loc6_:ScoreTextLine = null;
         var _loc2_:Number = this.startTime_ + 2000 * (this.scoreTextLines_.length - 1) / 2;
         _loc3_ = getTimer();
         var _loc4_:int = Math.min(this.scoreTextLines_.length,2 * (getTimer() - this.startTime_) / 2000 + 1);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = this.scoreTextLines_[_loc5_];
            _loc6_.y = 28 * _loc5_;
            this.linesSprite_.addChild(_loc6_);
            _loc5_++;
         }
         this.linesSprite_.y = this.rect_.height - this.linesSprite_.height - 10;
         if(_loc3_ > _loc2_ + 1000)
         {
            this.addScrollbar();
            dispatchEvent(new Event(Event.COMPLETE));
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function addScrollbar() : void
      {
         graphics.clear();
         graphics.lineStyle(1,4802889,2);
         graphics.drawRect(this.rect_.x + 1,this.rect_.y + 1,this.rect_.width - 26,this.rect_.height - 2);
         graphics.lineStyle();
         this.scrollbar_.x = this.rect_.width - 16;
         this.scrollbar_.setIndicatorSize(this.mask_.height,this.linesSprite_.height);
         this.scrollbar_.setPos(1);
         addChild(this.scrollbar_);
      }
   }
}

