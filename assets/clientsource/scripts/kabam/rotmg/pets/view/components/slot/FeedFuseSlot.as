package kabam.rotmg.pets.view.components.slot
{
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import kabam.rotmg.pets.util.PetsViewAssetFactory;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.AppendingLineBuilder;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class FeedFuseSlot extends Sprite
   {
      
      protected var outerSlot:Shape = PetsViewAssetFactory.returnPetSlotShape(46,5526612,0,false,true);
      
      protected var innerSlot:Shape = PetsViewAssetFactory.returnPetSlotShape(40,5526612,3,false,true);
      
      protected var bg:Shape = PetsViewAssetFactory.returnPetSlotShape(46,5526612,0,true,false);
      
      private var titleField:TextFieldDisplayConcrete = PetsViewAssetFactory.returnPetSlotTitle();
      
      private var titleStringBuilder:LineBuilder = new LineBuilder();
      
      private var subtitleField:TextFieldDisplayConcrete = PetsViewAssetFactory.returnMediumCenteredTextfield(16777103,100);
      
      private var subtitleStringBuilder:AppendingLineBuilder = new AppendingLineBuilder();
      
      protected var itemSprite:Sprite = new Sprite();
      
      protected var itemBitmap:Bitmap = new Bitmap();
      
      protected var icon:Sprite;
      
      public var itemId:int = -1;
      
      public var slotId:int = -1;
      
      public var objectId:int = -1;
      
      public function FeedFuseSlot()
      {
         super();
         this.addChildren();
         this.subtitleField.textChanged.add(this.positionSubtitleText);
         this.titleField.textChanged.add(this.positionSubtitleText);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function setTitle(param1:String, param2:Object) : void
      {
         this.titleStringBuilder.setParams(param1,param2);
         this.titleField.setStringBuilder(this.titleStringBuilder);
      }
      
      public function setSubtitle(param1:String, param2:Object) : void
      {
         this.subtitleStringBuilder.clear();
         this.subtitleStringBuilder.pushParams(param1,param2);
         this.subtitleField.setStringBuilder(this.subtitleStringBuilder);
      }
      
      public function hideOuterSlot(param1:Boolean) : void
      {
         this.outerSlot.visible = !param1;
         var _loc2_:int = param1 ? 40 : 46;
         var _loc3_:int = param1 ? 3 : 0;
         this.bg.graphics.clear();
         this.bg.graphics.beginFill(4605510);
         this.bg.graphics.drawRoundRect(0,_loc3_,_loc2_,_loc2_,16,16);
         this.bg.x = (100 - _loc2_) * 0.5;
      }
      
      public function highlight(param1:Boolean, param2:int = 16777103, param3:Boolean = false) : void
      {
         var _loc5_:ColorTransform = null;
         var _loc4_:ColorTransform = this.innerSlot.transform.colorTransform;
         _loc4_.color = param1 ? uint(param2) : 5526612;
         this.innerSlot.transform.colorTransform = _loc4_;
         if(this.outerSlot.visible)
         {
            _loc5_ = this.outerSlot.transform.colorTransform;
            _loc5_.color = param3 ? uint(param2) : 5526612;
            this.outerSlot.transform.colorTransform = _loc5_;
         }
      }
      
      protected function alignBitmapInBox() : void
      {
         this.itemSprite.x = 0;
         this.itemSprite.y = 0;
         this.itemBitmap.x = (100 - this.itemBitmap.width) * 0.5;
         this.itemBitmap.y = (46 - this.itemBitmap.height) * 0.5;
      }
      
      public function setIcon(param1:Sprite) : void
      {
         this.icon && removeChild(this.icon);
         this.icon = param1;
         addChild(this.icon);
         this.alignIcon();
      }
      
      public function getIcon() : Sprite
      {
         return this.icon;
      }
      
      protected function alignIcon() : void
      {
         this.icon.x = (100 - this.icon.width) * 0.5;
         this.icon.y = (46 - this.icon.height) * 0.5;
      }
      
      protected function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.subtitleField.textChanged.remove(this.positionSubtitleText);
         this.titleField.textChanged.remove(this.positionSubtitleText);
      }
      
      private function addChildren() : void
      {
         this.itemSprite.addChild(this.itemBitmap);
         addChild(this.bg);
         addChild(this.innerSlot);
         addChild(this.outerSlot);
         addChild(this.titleField);
         addChild(this.subtitleField);
         addChild(this.itemSprite);
      }
      
      private function positionSubtitleText() : void
      {
         this.subtitleField.y = this.titleField.y + this.titleField.height - 1;
      }
   }
}

