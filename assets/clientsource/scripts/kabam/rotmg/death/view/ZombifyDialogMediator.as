package kabam.rotmg.death.view
{
   import flash.display.BitmapData;
   import kabam.rotmg.death.control.HandleNormalDeathSignal;
   import kabam.rotmg.death.model.DeathModel;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.messaging.impl.incoming.Death;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class ZombifyDialogMediator extends Mediator
   {
      
      [Inject]
      public var view:ZombifyDialog;
      
      [Inject]
      public var closeDialogs:CloseDialogsSignal;
      
      [Inject]
      public var handleDeath:HandleNormalDeathSignal;
      
      [Inject]
      public var death:DeathModel;
      
      public function ZombifyDialogMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.closed.addOnce(this.onClosed);
      }
      
      private function onClosed() : void
      {
         var _loc1_:Death = null;
         _loc1_ = this.death.getLastDeath();
         var _loc2_:BitmapData = new BitmapDataSpy(this.view.stage.width,this.view.stage.height);
         _loc2_.draw(this.view.stage);
         _loc1_.background = _loc2_;
         this.closeDialogs.dispatch();
         this.handleDeath.dispatch(_loc1_);
      }
   }
}

