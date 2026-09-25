package kabam.rotmg.ui.view
{
   import com.company.assembleegameclient.objects.Player;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import kabam.rotmg.game.view.components.StatsUndockedSignal;
   import kabam.rotmg.game.view.components.StatsView;
   import kabam.rotmg.ui.model.HUDModel;
   import kabam.rotmg.ui.signals.UpdateHUDSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class HUDMediator extends Mediator
   {
      
      [Inject]
      public var view:HUDView;
      
      [Inject]
      public var hudModel:HUDModel;
      
      [Inject]
      public var updateHUD:UpdateHUDSignal;
      
      [Inject]
      public var statsUndocked:StatsUndockedSignal;
      
      [Inject]
      public var statsDocked:StatsDockedSignal;
      
      private var stats:Sprite;
      
      public function HUDMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.updateHUD.addOnce(this.onInitializeHUD);
         this.updateHUD.add(this.onUpdateHUD);
         this.statsUndocked.add(this.onStatsUndocked);
      }
      
      private function onStatsUndocked(param1:StatsView) : void
      {
         this.stats = param1;
         this.view.addChild(param1);
         param1.x = this.view.mouseX - param1.width / 2;
         param1.y = this.view.mouseY - param1.height / 2;
         this.startDraggingStatsAsset(param1);
      }
      
      private function startDraggingStatsAsset(param1:StatsView) : void
      {
         param1.startDrag();
         param1.addEventListener(MouseEvent.MOUSE_UP,this.onStatsMouseUp);
      }
      
      private function onStatsMouseUp(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = StatsView(param1.target);
         this.stopDraggingStatsAsset(_loc2_);
         if(_loc2_.hitTestObject(this.view.tabStrip))
         {
            this.dockStats(_loc2_);
         }
      }
      
      private function dockStats(param1:Sprite) : void
      {
         this.statsDocked.dispatch();
         this.view.removeChild(param1);
         param1.stopDrag();
      }
      
      private function stopDraggingStatsAsset(param1:Sprite) : void
      {
         param1.removeEventListener(MouseEvent.MOUSE_UP,this.onStatsMouseUp);
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.onStatsMouseDown);
         param1.stopDrag();
      }
      
      private function onStatsMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = Sprite(param1.target);
         this.stats = _loc2_;
         _loc2_.removeEventListener(MouseEvent.MOUSE_DOWN,this.onStatsMouseDown);
         _loc2_.addEventListener(MouseEvent.MOUSE_UP,this.onStatsMouseUp);
         _loc2_.startDrag();
      }
      
      override public function destroy() : void
      {
         this.updateHUD.remove(this.onUpdateHUD);
         this.statsUndocked.remove(this.onStatsUndocked);
         if(Boolean(this.stats) && this.stats.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            this.stats.removeEventListener(MouseEvent.MOUSE_DOWN,this.onStatsMouseDown);
         }
      }
      
      private function onUpdateHUD(param1:Player) : void
      {
         this.view.draw();
      }
      
      private function onInitializeHUD(param1:Player) : void
      {
         this.view.setPlayerDependentAssets(this.hudModel.gameSprite);
      }
   }
}

