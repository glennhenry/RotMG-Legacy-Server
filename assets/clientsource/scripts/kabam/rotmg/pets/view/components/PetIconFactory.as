package kabam.rotmg.pets.view.components
{
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import kabam.rotmg.pets.data.PetVO;
   
   public class PetIconFactory
   {
      
      public var outlineSize:Number = 1.4;
      
      public function PetIconFactory()
      {
         super();
      }
      
      public function create(param1:PetVO, param2:int) : PetIcon
      {
         var _loc3_:BitmapData = this.getPetSkinTexture(param1,param2);
         var _loc4_:Bitmap = new Bitmap(_loc3_);
         var _loc5_:PetIcon = new PetIcon(param1);
         _loc5_.setBitmap(_loc4_);
         return _loc5_;
      }
      
      public function getPetSkinTexture(param1:PetVO, param2:int) : BitmapData
      {
         var _loc4_:Number = NaN;
         var _loc5_:BitmapData = null;
         var _loc3_:BitmapData = param1.getSkinMaskedImage() ? param1.getSkinMaskedImage().image_ : null;
         if(_loc3_)
         {
            _loc4_ = (param2 - TextureRedrawer.minSize) / _loc3_.width;
            _loc5_ = TextureRedrawer.resize(_loc3_,param1.getSkinMaskedImage().mask_,100,true,0,0,_loc4_);
            return GlowRedrawer.outlineGlow(_loc5_,0,this.outlineSize);
         }
         return new BitmapDataSpy(param2,param2);
      }
   }
}

