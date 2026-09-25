package com.company.assembleegameclient.ui.dialogs
{
   import flash.events.Event;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   
   public class DebugDialog extends StaticDialog
   {
      
      private var f:Function;
      
      public function DebugDialog(param1:String, param2:String = "Debug", param3:Function = null)
      {
         super(param2,param1,"OK",null,null);
         this.f = param3;
         addEventListener(Dialog.LEFT_BUTTON,this.onDialogComplete);
      }
      
      private function onDialogComplete(param1:Event) : void
      {
         var _loc2_:CloseDialogsSignal = StaticInjectorContext.getInjector().getInstance(CloseDialogsSignal);
         _loc2_.dispatch();
         if(this.parent != null && this.parent.contains(this))
         {
            this.parent.removeChild(this);
         }
         if(this.f != null)
         {
            this.f();
         }
      }
   }
}

