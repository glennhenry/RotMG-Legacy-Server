package kabam.rotmg.arena.view
{
   import com.company.assembleegameclient.screens.TitleMenuOption;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.rotmg.graphics.ScreenGraphic;
   import com.company.util.AssetLibrary;
   import com.company.util.BitmapUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.arena.component.LeaderboardWeeklyResetTimer;
   import kabam.rotmg.arena.model.ArenaLeaderboardEntry;
   import kabam.rotmg.arena.model.ArenaLeaderboardFilter;
   import kabam.rotmg.arena.model.ArenaLeaderboardModel;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.StaticTextDisplay;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.ui.view.SignalWaiter;
   import org.osflash.signals.Signal;
   
   public class ArenaLeaderboard extends Sprite
   {
      
      public const requestData:Signal = new Signal(ArenaLeaderboardFilter);
      
      public const close:Signal = new Signal();
      
      private var list:ArenaLeaderboardList = this.makeList();
      
      private var title:StaticTextDisplay = this.makeTitle();
      
      private var leftSword:Bitmap = this.makeSword(false);
      
      private var rightSword:Bitmap = this.makeSword(true);
      
      private var tabs:Vector.<ArenaLeaderboardTab> = this.makeTabs();
      
      private var selected:ArenaLeaderboardTab;
      
      private var closeButton:TitleMenuOption;
      
      private var weeklyCountdownClock:LeaderboardWeeklyResetTimer = this.makeResetTimer();
      
      public function ArenaLeaderboard()
      {
         super();
         addChild(this.list);
         addChild(new ScreenGraphic());
         addChild(this.leftSword);
         addChild(this.rightSword);
         addChild(this.title);
         this.makeCloseButton();
         this.makeLines();
         addChild(this.weeklyCountdownClock);
      }
      
      public function init() : void
      {
         var _loc1_:ArenaLeaderboardTab = this.tabs[0];
         this.selected = _loc1_;
         _loc1_.setSelected(true);
         _loc1_.selected.dispatch(_loc1_);
      }
      
      public function destroy() : void
      {
         var _loc1_:ArenaLeaderboardTab = null;
         for each(_loc1_ in this.tabs)
         {
            _loc1_.selected.remove(this.onSelected);
            _loc1_.destroy();
         }
      }
      
      public function reloadList() : void
      {
         this.setList(this.selected.getFilter().getEntries());
      }
      
      private function onCloseClick(param1:MouseEvent) : void
      {
         this.close.dispatch();
      }
      
      private function onSelected(param1:ArenaLeaderboardTab) : void
      {
         this.selected.setSelected(false);
         this.selected = param1;
         this.selected.setSelected(true);
         this.weeklyCountdownClock.visible = param1.getFilter().getKey() == "weekly";
         if(param1.getFilter().hasEntries())
         {
            this.list.setItems(param1.getFilter().getEntries(),true);
         }
         else
         {
            this.requestData.dispatch(param1.getFilter());
         }
      }
      
      public function setList(param1:Vector.<ArenaLeaderboardEntry>) : void
      {
         this.list.setItems(param1,true);
      }
      
      private function makeTabs() : Vector.<ArenaLeaderboardTab>
      {
         var _loc3_:ArenaLeaderboardFilter = null;
         var _loc4_:ArenaLeaderboardTab = null;
         var _loc1_:SignalWaiter = new SignalWaiter();
         var _loc2_:Vector.<ArenaLeaderboardTab> = new Vector.<ArenaLeaderboardTab>();
         for each(_loc3_ in ArenaLeaderboardModel.FILTERS)
         {
            _loc4_ = new ArenaLeaderboardTab(_loc3_);
            _loc4_.y = 70;
            _loc4_.selected.add(this.onSelected);
            _loc2_.push(_loc4_);
            _loc1_.push(_loc4_.readyToAlign);
            addChild(_loc4_);
         }
         _loc1_.complete.addOnce(this.alignTabs);
         return _loc2_;
      }
      
      private function makeSword(param1:Boolean) : Bitmap
      {
         var _loc2_:BitmapData = TextureRedrawer.redraw(AssetLibrary.getImageFromSet("lofiInterface2",8),64,true,0,true);
         if(param1)
         {
            _loc2_ = BitmapUtil.mirror(_loc2_);
         }
         return new Bitmap(_loc2_);
      }
      
      private function makeTitle() : StaticTextDisplay
      {
         var _loc1_:StaticTextDisplay = null;
         _loc1_ = new StaticTextDisplay();
         _loc1_.setBold(true).setColor(11776947).setSize(32);
         _loc1_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         _loc1_.setStringBuilder(new LineBuilder().setParams(TextKey.ARENA_LEADERBOARD_TITLE));
         _loc1_.setAutoSize(TextFieldAutoSize.CENTER);
         _loc1_.y = 25;
         _loc1_.textChanged.addOnce(this.onAlignTitle);
         return _loc1_;
      }
      
      private function makeCloseButton() : void
      {
         this.closeButton = new TitleMenuOption(TextKey.DONE_TEXT,36,false);
         this.closeButton.setAutoSize(TextFieldAutoSize.CENTER);
         this.closeButton.setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
         this.closeButton.x = 400;
         this.closeButton.y = 553;
         addChild(this.closeButton);
         this.closeButton.addEventListener(MouseEvent.CLICK,this.onCloseClick);
      }
      
      private function makeLines() : void
      {
         var _loc1_:Shape = new Shape();
         addChild(_loc1_);
         var _loc2_:Graphics = _loc1_.graphics;
         _loc2_.lineStyle(2,5526612);
         _loc2_.moveTo(0,100);
         _loc2_.lineTo(800,100);
      }
      
      private function makeList() : ArenaLeaderboardList
      {
         var _loc1_:ArenaLeaderboardList = new ArenaLeaderboardList();
         _loc1_.x = 15;
         _loc1_.y = 115;
         return _loc1_;
      }
      
      private function alignTabs() : void
      {
         var _loc2_:ArenaLeaderboardTab = null;
         var _loc1_:int = 20;
         for each(_loc2_ in this.tabs)
         {
            _loc2_.x = _loc1_;
            _loc1_ += _loc2_.width + 20;
         }
      }
      
      private function makeResetTimer() : LeaderboardWeeklyResetTimer
      {
         var _loc1_:LeaderboardWeeklyResetTimer = null;
         _loc1_ = new LeaderboardWeeklyResetTimer();
         _loc1_.y = 72;
         _loc1_.x = 440;
         return _loc1_;
      }
      
      private function onAlignTitle() : void
      {
         this.title.x = stage.stageWidth / 2;
         this.leftSword.x = stage.stageWidth / 2 - this.title.width / 2 - this.leftSword.width + 10;
         this.leftSword.y = 15;
         this.rightSword.x = stage.stageWidth / 2 + this.title.width / 2 - 10;
         this.rightSword.y = 15;
      }
   }
}

