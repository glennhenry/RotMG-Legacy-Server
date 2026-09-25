package kabam.rotmg.pets.view.dialogs
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.util.AnimatedChar;
   import com.company.assembleegameclient.util.AnimatedChars;
   import com.company.assembleegameclient.util.MaskedImage;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.pets.data.PetsModel;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class EggHatchedDialogMediator extends Mediator
   {
      
      [Inject]
      public var view:EggHatchedDialog;
      
      [Inject]
      public var petsModel:PetsModel;
      
      [Inject]
      public var closeDialog:CloseDialogsSignal;
      
      public function EggHatchedDialogMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         var _loc1_:Bitmap = this.getTypeBitmap();
         this.view.init(_loc1_);
         this.view.closed.add(this.onClosed);
      }
      
      private function onClosed() : void
      {
         this.closeDialog.dispatch();
      }
      
      private function getTypeBitmap() : Bitmap
      {
         var _loc1_:String = ObjectLibrary.getIdFromType(this.view.skinType);
         var _loc2_:XML = ObjectLibrary.getXMLfromId(_loc1_);
         var _loc3_:String = _loc2_.AnimatedTexture.File;
         var _loc4_:int = int(_loc2_.AnimatedTexture.Index);
         var _loc5_:AnimatedChar = AnimatedChars.getAnimatedChar(_loc3_,_loc4_);
         var _loc6_:MaskedImage = _loc5_.imageFromAngle(0,AnimatedChar.STAND,0);
         var _loc7_:BitmapData = TextureRedrawer.resize(_loc6_.image_,_loc6_.mask_,160,true,0,0);
         _loc7_ = GlowRedrawer.outlineGlow(_loc7_,0,6);
         return new Bitmap(_loc7_);
      }
   }
}

