package kabam.rotmg.news.view
{
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class NewsTickerMediator extends Mediator
   {
      
      [Inject]
      public var view:NewsTicker;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      public function NewsTickerMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
      }
      
      override public function destroy() : void
      {
      }
   }
}

