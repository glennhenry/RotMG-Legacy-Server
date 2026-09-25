package kabam.lib.console.view
{
   import kabam.lib.console.model.Console;
   import kabam.lib.console.signals.ConsoleLogSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public final class ConsoleInputMediator extends Mediator
   {
      
      private static const ERROR_PATTERN:String = "[0xFF3333:error - \"${value}\" not found]";
      
      private static const ACTION_PATTERN:String = "[0xFFEE00:${value}]";
      
      [Inject]
      public var view:ConsoleInputView;
      
      [Inject]
      public var console:Console;
      
      [Inject]
      public var log:ConsoleLogSignal;
      
      public function ConsoleInputMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         addViewListener(ConsoleEvent.INPUT,this.onInput,ConsoleEvent);
         addViewListener(ConsoleEvent.GET_PREVIOUS,this.onGetPrevious,ConsoleEvent);
         addViewListener(ConsoleEvent.GET_NEXT,this.onGetNext,ConsoleEvent);
      }
      
      override public function destroy() : void
      {
         removeViewListener(ConsoleEvent.INPUT,this.onInput,ConsoleEvent);
         removeViewListener(ConsoleEvent.GET_PREVIOUS,this.onGetPrevious,ConsoleEvent);
         removeViewListener(ConsoleEvent.GET_NEXT,this.onGetNext,ConsoleEvent);
      }
      
      private function onInput(param1:ConsoleEvent) : void
      {
         var _loc2_:String = param1.data;
         this.logInput(_loc2_);
         this.console.execute(_loc2_);
      }
      
      private function logInput(param1:String) : void
      {
         if(this.console.hasAction(param1))
         {
            this.logAction(param1);
         }
         else
         {
            this.logError(param1);
         }
      }
      
      private function logAction(param1:String) : void
      {
         var _loc2_:Array = param1.split(" ");
         _loc2_[0] = ACTION_PATTERN.replace("${value}",_loc2_[0]);
         this.log.dispatch(_loc2_.join(" "));
      }
      
      private function logError(param1:String) : void
      {
         var _loc2_:String = ERROR_PATTERN.replace("${value}",param1);
         this.log.dispatch(_loc2_);
      }
      
      private function onGetPrevious(param1:ConsoleEvent) : void
      {
         this.view.text = this.console.getPreviousAction();
      }
      
      private function onGetNext(param1:ConsoleEvent) : void
      {
         this.view.text = this.console.getNextAction();
      }
   }
}

