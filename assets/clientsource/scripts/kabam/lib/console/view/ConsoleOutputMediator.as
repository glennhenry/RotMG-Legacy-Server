package kabam.lib.console.view
{
   import flash.system.System;
   import kabam.lib.console.model.Watch;
   import kabam.lib.console.signals.ClearConsoleSignal;
   import kabam.lib.console.signals.ConsoleLogSignal;
   import kabam.lib.console.signals.ConsoleUnwatchSignal;
   import kabam.lib.console.signals.ConsoleWatchSignal;
   import kabam.lib.console.signals.CopyConsoleTextSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public final class ConsoleOutputMediator extends Mediator
   {
      
      [Inject]
      public var log:ConsoleLogSignal;
      
      [Inject]
      public var watch:ConsoleWatchSignal;
      
      [Inject]
      public var unwatch:ConsoleUnwatchSignal;
      
      [Inject]
      public var clear:ClearConsoleSignal;
      
      [Inject]
      public var copy:CopyConsoleTextSignal;
      
      [Inject]
      public var view:ConsoleOutputView;
      
      public function ConsoleOutputMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.log.add(this.onLog);
         this.watch.add(this.onWatch);
         this.unwatch.add(this.onUnwatch);
         this.clear.add(this.onClear);
         this.copy.add(this.onCopy);
      }
      
      override public function destroy() : void
      {
         this.log.remove(this.onLog);
         this.watch.remove(this.onWatch);
         this.unwatch.remove(this.onUnwatch);
         this.clear.remove(this.onClear);
         this.copy.remove(this.onCopy);
      }
      
      private function onLog(param1:String) : void
      {
         this.view.log(param1);
      }
      
      private function onWatch(param1:Watch) : void
      {
         this.view.watch(param1);
      }
      
      private function onUnwatch(param1:String) : void
      {
         this.view.unwatch(param1);
      }
      
      private function onClear() : void
      {
         this.view.clear();
      }
      
      private function onCopy() : void
      {
         System.setClipboard(this.view.getText());
      }
   }
}

