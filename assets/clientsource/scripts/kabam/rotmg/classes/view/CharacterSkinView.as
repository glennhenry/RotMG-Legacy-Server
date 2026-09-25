package kabam.rotmg.classes.view
{
   import com.company.assembleegameclient.constants.ScreenTypes;
   import com.company.assembleegameclient.screens.AccountScreen;
   import com.company.assembleegameclient.screens.TitleMenuOption;
   import com.company.rotmg.graphics.ScreenGraphic;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.game.view.CreditDisplay;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.ui.view.SignalWaiter;
   import kabam.rotmg.ui.view.components.ScreenBase;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class CharacterSkinView extends Sprite
   {
      
      private const base:ScreenBase = this.makeScreenBase();
      
      private const account:AccountScreen = this.makeAccountScreen();
      
      private const lines:Shape = this.makeLines();
      
      private const creditsDisplay:CreditDisplay = this.makeCreditDisplay();
      
      private const graphic:ScreenGraphic = this.makeScreenGraphic();
      
      private const playBtn:TitleMenuOption = this.makePlayButton();
      
      private const backBtn:TitleMenuOption = this.makeBackButton();
      
      private const list:CharacterSkinListView = this.makeListView();
      
      private const detail:ClassDetailView = this.makeClassDetailView();
      
      public const play:Signal = new NativeMappedSignal(this.playBtn,MouseEvent.CLICK);
      
      public const back:Signal = new NativeMappedSignal(this.backBtn,MouseEvent.CLICK);
      
      public const waiter:SignalWaiter = this.makeSignalWaiter();
      
      public function CharacterSkinView()
      {
         super();
      }
      
      private function makeScreenBase() : ScreenBase
      {
         var _loc1_:ScreenBase = new ScreenBase();
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeAccountScreen() : AccountScreen
      {
         var _loc1_:AccountScreen = new AccountScreen();
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeCreditDisplay() : CreditDisplay
      {
         var _loc1_:CreditDisplay = null;
         _loc1_ = new CreditDisplay(null,true,true);
         var _loc2_:PlayerModel = StaticInjectorContext.getInjector().getInstance(PlayerModel);
         if(_loc2_ != null)
         {
            _loc1_.draw(_loc2_.getCredits(),_loc2_.getFame(),_loc2_.getTokens());
         }
         _loc1_.x = 800;
         _loc1_.y = 20;
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeLines() : Shape
      {
         var _loc1_:Shape = new Shape();
         _loc1_.graphics.clear();
         _loc1_.graphics.lineStyle(2,5526612);
         _loc1_.graphics.moveTo(0,105);
         _loc1_.graphics.lineTo(800,105);
         _loc1_.graphics.moveTo(346,105);
         _loc1_.graphics.lineTo(346,526);
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeScreenGraphic() : ScreenGraphic
      {
         var _loc1_:ScreenGraphic = new ScreenGraphic();
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makePlayButton() : TitleMenuOption
      {
         var _loc1_:TitleMenuOption = null;
         _loc1_ = new TitleMenuOption(ScreenTypes.PLAY,36,false);
         _loc1_.setAutoSize(TextFieldAutoSize.CENTER);
         _loc1_.setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
         _loc1_.x = 400 - _loc1_.width / 2;
         _loc1_.y = 550;
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeBackButton() : TitleMenuOption
      {
         var _loc1_:TitleMenuOption = null;
         _loc1_ = new TitleMenuOption(ScreenTypes.BACK,22,false);
         _loc1_.setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
         _loc1_.x = 30;
         _loc1_.y = 550;
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeListView() : CharacterSkinListView
      {
         var _loc1_:CharacterSkinListView = null;
         _loc1_ = new CharacterSkinListView();
         _loc1_.x = 351;
         _loc1_.y = 110;
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeClassDetailView() : ClassDetailView
      {
         var _loc1_:ClassDetailView = null;
         _loc1_ = new ClassDetailView();
         _loc1_.x = 5;
         _loc1_.y = 110;
         addChild(_loc1_);
         return _loc1_;
      }
      
      public function setPlayButtonEnabled(param1:Boolean) : void
      {
         if(!param1)
         {
            this.playBtn.deactivate();
         }
      }
      
      private function makeSignalWaiter() : SignalWaiter
      {
         var _loc1_:SignalWaiter = new SignalWaiter();
         _loc1_.push(this.playBtn.changed);
         _loc1_.complete.add(this.positionOptions);
         return _loc1_;
      }
      
      private function positionOptions() : void
      {
         this.playBtn.x = stage.stageWidth / 2;
      }
   }
}

