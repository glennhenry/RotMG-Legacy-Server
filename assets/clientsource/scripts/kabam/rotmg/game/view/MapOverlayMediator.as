package kabam.rotmg.game.view
{
   import com.company.assembleegameclient.map.mapoverlay.MapOverlay;
   import com.company.assembleegameclient.map.mapoverlay.SpeechBalloon;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.game.model.AddSpeechBalloonVO;
   import kabam.rotmg.game.model.ChatFilter;
   import kabam.rotmg.game.signals.AddSpeechBalloonSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class MapOverlayMediator extends Mediator
   {
      
      [Inject]
      public var view:MapOverlay;
      
      [Inject]
      public var addSpeechBalloon:AddSpeechBalloonSignal;
      
      [Inject]
      public var chatFilter:ChatFilter;
      
      [Inject]
      public var account:Account;
      
      public function MapOverlayMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.addSpeechBalloon.add(this.onAddSpeechBalloon);
      }
      
      override public function destroy() : void
      {
         this.addSpeechBalloon.remove(this.onAddSpeechBalloon);
      }
      
      private function onAddSpeechBalloon(param1:AddSpeechBalloonVO) : void
      {
         var _loc2_:String = this.account.isRegistered() || this.chatFilter.guestChatFilter(param1.go.name_) ? param1.text : ". . .";
         var _loc3_:* = new SpeechBalloon(param1.go,_loc2_,param1.name,param1.isTrade,param1.isGuild,param1.background,param1.backgroundAlpha,param1.outline,param1.outlineAlpha,param1.textColor,param1.lifetime,param1.bold,param1.hideable);
         this.view.addSpeechBalloon(_loc3_);
      }
   }
}

