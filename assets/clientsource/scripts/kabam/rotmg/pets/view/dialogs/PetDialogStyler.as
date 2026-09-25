package kabam.rotmg.pets.view.dialogs
{
   import com.company.assembleegameclient.ui.dialogs.Dialog;
   import flash.text.TextFormatAlign;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   
   public class PetDialogStyler
   {
      
      private static const lineToTextSpace:int = 14;
      
      private var dialog:Dialog;
      
      public function PetDialogStyler(param1:Dialog)
      {
         super();
         this.dialog = param1;
      }
      
      public function stylizePetDialog() : void
      {
         this.dialog.titleText_.setColor(Dialog.GREY);
         this.dialog.textText_.setHorizontalAlign(TextFormatAlign.CENTER);
         this.dialog.titleYPosition = 4;
         this.dialog.buttonSpace = 18;
         this.dialog.bottomSpace = 18;
      }
      
      public function drawGraphics() : void
      {
         var _loc1_:TextFieldDisplayConcrete = this.dialog.titleText_;
         var _loc2_:Number = _loc1_.getBounds(this.dialog.rect_).bottom + this.dialog.titleYPosition;
         this.drawLine(_loc2_);
      }
      
      public function drawLine(param1:Number) : void
      {
         this.dialog.rect_.graphics.moveTo(0,param1);
         this.dialog.rect_.graphics.beginFill(6710886,1);
         this.dialog.rect_.graphics.drawRect(0,param1,this.dialog.dialogWidth - 1,2);
      }
      
      public function positionText() : void
      {
         var _loc1_:TextFieldDisplayConcrete = this.dialog.titleText_;
         this.dialog.textText_.y = _loc1_.getBounds(this.dialog.rect_).bottom + this.dialog.titleYPosition + lineToTextSpace;
      }
   }
}

