package com.company.assembleegameclient.ui.dialogs
{
   import flash.events.Event;
   import org.osflash.signals.Signal;
   
   public class CloseDialogComponent
   {
      
      private const closeSignal:Signal = new Signal();
      
      private var dialog:DialogCloser;
      
      private var types:Vector.<String> = new Vector.<String>();
      
      public function CloseDialogComponent()
      {
         super();
      }
      
      public function add(param1:DialogCloser, param2:String) : void
      {
         this.dialog = param1;
         this.types.push(param2);
         param1.addEventListener(param2,this.onButtonType);
      }
      
      private function onButtonType(param1:Event) : void
      {
         var _loc2_:String = null;
         for each(_loc2_ in this.types)
         {
            this.dialog.removeEventListener(_loc2_,this.onButtonType);
         }
         this.dialog.getCloseSignal().dispatch();
      }
      
      public function getCloseSignal() : Signal
      {
         return this.closeSignal;
      }
   }
}

