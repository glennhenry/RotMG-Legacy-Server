package com.company.assembleegameclient.account.ui
{
   import com.company.assembleegameclient.game.AGameSprite;
   import flash.events.MouseEvent;
   import kabam.rotmg.text.model.TextKey;
   import org.osflash.signals.Signal;
   
   public class ChooseNameFrame extends Frame
   {
      
      public const cancel:Signal = new Signal();
      
      public const choose:Signal = new Signal(String);
      
      public var gameSprite:AGameSprite;
      
      public var isPurchase:Boolean;
      
      private var nameInput:TextInputField;
      
      public function ChooseNameFrame(param1:AGameSprite, param2:Boolean)
      {
         super(TextKey.CHOOSE_NAME_TITLE,TextKey.FRAME_CANCEL,TextKey.CHOOSE_NAME_CHOOSE,"/chooseName");
         this.gameSprite = param1;
         this.isPurchase = param2;
         this.nameInput = new TextInputField(TextKey.CHOOSE_NAME_NAME,false);
         this.nameInput.inputText_.restrict = "A-Za-z";
         this.nameInput.inputText_.maxChars = 10;
         addTextInputField(this.nameInput);
         addPlainText(TextKey.FRAME_MAX_CHAR,{"maxChars":10});
         addPlainText(TextKey.FRAME_RESTRICT_CHAR);
         addPlainText(TextKey.CHOOSE_NAME_WARNING);
         leftButton_.addEventListener(MouseEvent.CLICK,this.onCancel);
         rightButton_.addEventListener(MouseEvent.CLICK,this.onChoose);
      }
      
      private function onCancel(param1:MouseEvent) : void
      {
         this.cancel.dispatch();
      }
      
      private function onChoose(param1:MouseEvent) : void
      {
         this.choose.dispatch(this.nameInput.text());
         disable();
      }
      
      public function setError(param1:String) : void
      {
         this.nameInput.setError(param1);
      }
   }
}

