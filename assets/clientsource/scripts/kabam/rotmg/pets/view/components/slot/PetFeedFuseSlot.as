package kabam.rotmg.pets.view.components.slot
{
   import com.company.util.MoreColorUtil;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.ColorTransform;
   import kabam.rotmg.pets.data.PetFamilyKeys;
   import kabam.rotmg.pets.data.PetVO;
   import kabam.rotmg.pets.view.components.PetIcon;
   import kabam.rotmg.pets.view.components.PetIconFactory;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
   import org.osflash.signals.Signal;
   
   public class PetFeedFuseSlot extends FeedFuseSlot
   {
      
      public const openPetPicker:Signal = new Signal();
      
      public var showFamily:Boolean = false;
      
      public var processing:Boolean = false;
      
      private var petIconFactory:PetIconFactory = new PetIconFactory();
      
      private var grayscaleMatrix:ColorMatrixFilter = new ColorMatrixFilter(MoreColorUtil.greyscaleFilterMatrix);
      
      public function PetFeedFuseSlot()
      {
         super();
         addEventListener(MouseEvent.CLICK,this.onOpenPetPicker);
         this.updateTitle();
      }
      
      public function updateTitle() : void
      {
         if(!icon || contains(icon))
         {
            setTitle(TextKey.PETORFOODSLOT_FUSE_PET_TITLE,{});
         }
      }
      
      private function onOpenPetPicker(param1:MouseEvent) : void
      {
         if(!this.processing)
         {
            this.openPetPicker.dispatch();
         }
      }
      
      public function setPetIcon(param1:PetVO) : void
      {
         var _loc2_:PetIcon = this.petIconFactory.create(param1,48);
         setIcon(_loc2_);
      }
      
      public function setPet(param1:PetVO) : void
      {
         var _loc2_:AppendingLineBuilder = null;
         if(param1)
         {
            this.setPetIcon(param1);
            setTitle(TextKey.BLANK,{"data":param1.getName()});
            _loc2_ = new AppendingLineBuilder();
            _loc2_.pushParams(param1.getRarity());
            this.showFamily && _loc2_.pushParams(PetFamilyKeys.getTranslationKey(param1.getFamily()));
            setSubtitle(TextKey.BLANK,{"data":_loc2_});
         }
      }
      
      public function setProcessing(param1:Boolean) : void
      {
         var _loc2_:ColorTransform = null;
         if(this.processing != param1)
         {
            this.processing = param1;
            icon.filters = param1 ? [this.grayscaleMatrix] : [];
            _loc2_ = param1 ? MoreColorUtil.darkCT : new ColorTransform();
            icon.transform.colorTransform = _loc2_;
         }
      }
   }
}

