package com.company.assembleegameclient.ui.panels
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.parameters.Parameters;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import kabam.rotmg.text.model.TextKey;
   
   public class CharacterChangerPanel extends ButtonPanel
   {
      
      public function CharacterChangerPanel(param1:GameSprite)
      {
         super(param1,TextKey.CHARACTER_CHANGER_TITLE,TextKey.CHARACTER_CHANGER_BUTTON);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      override protected function onButtonClick(param1:MouseEvent) : void
      {
         gs_.closed.dispatch();
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Parameters.data_.interact && stage.focus == null)
         {
            gs_.closed.dispatch();
         }
      }
   }
}

