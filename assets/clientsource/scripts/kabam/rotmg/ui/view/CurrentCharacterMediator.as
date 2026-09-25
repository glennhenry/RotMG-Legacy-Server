package kabam.rotmg.ui.view
{
   import com.company.assembleegameclient.appengine.SavedCharacter;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.screens.CharacterSelectionAndNewsScreen;
   import com.company.assembleegameclient.screens.NewCharacterScreen;
   import com.company.util.MoreDateUtil;
   import kabam.rotmg.classes.model.CharacterClass;
   import kabam.rotmg.classes.model.ClassesModel;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.core.service.TrackingData;
   import kabam.rotmg.core.signals.SetScreenSignal;
   import kabam.rotmg.core.signals.TrackEventSignal;
   import kabam.rotmg.core.signals.TrackPageViewSignal;
   import kabam.rotmg.game.model.GameInitData;
   import kabam.rotmg.game.signals.PlayGameSignal;
   import kabam.rotmg.packages.control.BeginnersPackageAvailableSignal;
   import kabam.rotmg.packages.control.InitPackagesSignal;
   import kabam.rotmg.packages.control.PackageAvailableSignal;
   import kabam.rotmg.promotions.model.BeginnersPackageModel;
   import kabam.rotmg.ui.signals.ChooseNameSignal;
   import kabam.rotmg.ui.signals.NameChangedSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class CurrentCharacterMediator extends Mediator
   {
      
      [Inject]
      public var view:CharacterSelectionAndNewsScreen;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var classesModel:ClassesModel;
      
      [Inject]
      public var track:TrackEventSignal;
      
      [Inject]
      public var setScreen:SetScreenSignal;
      
      [Inject]
      public var playGame:PlayGameSignal;
      
      [Inject]
      public var chooseName:ChooseNameSignal;
      
      [Inject]
      public var nameChanged:NameChangedSignal;
      
      [Inject]
      public var trackPage:TrackPageViewSignal;
      
      [Inject]
      public var initPackages:InitPackagesSignal;
      
      [Inject]
      public var beginnersPackageAvailable:BeginnersPackageAvailableSignal;
      
      [Inject]
      public var packageAvailable:PackageAvailableSignal;
      
      [Inject]
      public var beginnerModel:BeginnersPackageModel;
      
      public function CurrentCharacterMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.trackSomething();
         this.view.initialize(this.playerModel);
         this.view.close.add(this.onClose);
         this.view.newCharacter.add(this.onNewCharacter);
         this.view.showClasses.add(this.onNewCharacter);
         this.view.chooseName.add(this.onChooseName);
         this.view.playGame.add(this.onPlayGame);
         this.trackPage.dispatch("/currentCharScreen");
         this.nameChanged.add(this.onNameChanged);
         this.beginnersPackageAvailable.add(this.onBeginner);
         this.packageAvailable.add(this.onPackage);
         this.initPackages.dispatch();
      }
      
      private function onPackage() : void
      {
         this.view.showPackageButton();
      }
      
      private function onBeginner() : void
      {
         this.view.showBeginnersOfferButton();
      }
      
      override public function destroy() : void
      {
         this.nameChanged.remove(this.onNameChanged);
         this.beginnersPackageAvailable.remove(this.onBeginner);
         this.view.close.remove(this.onClose);
         this.view.newCharacter.remove(this.onNewCharacter);
         this.view.chooseName.remove(this.onChooseName);
         this.view.showClasses.remove(this.onNewCharacter);
         this.view.playGame.remove(this.onPlayGame);
      }
      
      private function onNameChanged(param1:String) : void
      {
         this.view.setName(param1);
      }
      
      private function trackSomething() : void
      {
         var _loc2_:TrackingData = null;
         var _loc1_:String = MoreDateUtil.getDayStringInPT();
         if(Parameters.data_.lastDailyAnalytics != _loc1_)
         {
            _loc2_ = new TrackingData();
            _loc2_.category = "joinDate";
            _loc2_.action = Parameters.data_.joinDate;
            this.track.dispatch(_loc2_);
            Parameters.data_.lastDailyAnalytics = _loc1_;
            Parameters.save();
         }
      }
      
      private function onNewCharacter() : void
      {
         this.setScreen.dispatch(new NewCharacterScreen());
      }
      
      private function onClose() : void
      {
         this.setScreen.dispatch(new TitleView());
      }
      
      private function onChooseName() : void
      {
         this.chooseName.dispatch();
      }
      
      private function onPlayGame() : void
      {
         var _loc1_:SavedCharacter = this.playerModel.getCharacterByIndex(0);
         this.playerModel.currentCharId = _loc1_.charId();
         var _loc2_:CharacterClass = this.classesModel.getCharacterClass(_loc1_.objectType());
         _loc2_.setIsSelected(true);
         _loc2_.skins.getSkin(_loc1_.skinType()).setIsSelected(true);
         var _loc3_:TrackingData = new TrackingData();
         _loc3_.category = "character";
         _loc3_.action = "select";
         _loc3_.label = _loc1_.displayId();
         _loc3_.value = _loc1_.level();
         this.track.dispatch(_loc3_);
         var _loc4_:GameInitData = new GameInitData();
         _loc4_.createCharacter = false;
         _loc4_.charId = _loc1_.charId();
         _loc4_.isNewGame = true;
         this.playGame.dispatch(_loc4_);
      }
   }
}

