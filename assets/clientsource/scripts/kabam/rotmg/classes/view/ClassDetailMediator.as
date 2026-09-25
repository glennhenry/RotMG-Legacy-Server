package kabam.rotmg.classes.view
{
   import com.company.assembleegameclient.util.FameUtil;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import kabam.rotmg.assets.model.Animation;
   import kabam.rotmg.assets.services.CharacterFactory;
   import kabam.rotmg.classes.control.FocusCharacterSkinSignal;
   import kabam.rotmg.classes.model.CharacterClass;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.classes.model.ClassesModel;
   import kabam.rotmg.core.model.PlayerModel;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class ClassDetailMediator extends Mediator
   {
      
      [Inject]
      public var view:ClassDetailView;
      
      [Inject]
      public var classesModel:ClassesModel;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var focusSet:FocusCharacterSkinSignal;
      
      [Inject]
      public var factory:CharacterFactory;
      
      private const skins:Object = new Object();
      
      private var character:CharacterClass;
      
      private var nextSkin:CharacterSkin;
      
      private const nextSkinTimer:Timer = new Timer(250,1);
      
      public function ClassDetailMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.character = this.classesModel.getSelected();
         this.nextSkinTimer.addEventListener(TimerEvent.TIMER,this.delayedFocusSet);
         this.focusSet.add(this.onFocusSet);
         this.setCharacterData();
         this.onFocusSet();
      }
      
      override public function destroy() : void
      {
         this.focusSet.remove(this.onFocusSet);
         this.nextSkinTimer.removeEventListener(TimerEvent.TIMER,this.delayedFocusSet);
         this.view.setWalkingAnimation(null);
         this.disposeAnimations();
      }
      
      private function setCharacterData() : void
      {
         var _loc1_:int = this.playerModel.charList.bestFame(this.character.id);
         var _loc2_:int = FameUtil.numStars(_loc1_);
         this.view.setData(this.character.name,this.character.description,_loc2_,this.playerModel.charList.bestLevel(this.character.id),_loc1_);
         var _loc3_:int = FameUtil.nextStarFame(_loc1_,0);
         this.view.setNextGoal(this.character.name,_loc3_);
      }
      
      private function onFocusSet(param1:CharacterSkin = null) : void
      {
         this.nextSkin = param1 = param1 || this.character.skins.getSelectedSkin();
         this.nextSkinTimer.start();
      }
      
      private function delayedFocusSet(param1:TimerEvent) : void
      {
         var _loc2_:Animation = this.skins[this.nextSkin.id] = this.skins[this.nextSkin.id] || this.factory.makeWalkingIcon(this.nextSkin.template,200);
         this.view.setWalkingAnimation(_loc2_);
      }
      
      private function disposeAnimations() : void
      {
         var _loc1_:String = null;
         var _loc2_:Animation = null;
         for(_loc1_ in this.skins)
         {
            _loc2_ = this.skins[_loc1_];
            _loc2_.dispose();
            delete this.skins[_loc1_];
         }
      }
   }
}

