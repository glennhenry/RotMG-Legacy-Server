package com.company.assembleegameclient.screens.charrects
{
   import com.company.assembleegameclient.appengine.SavedCharacter;
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.util.AnimatedChar;
   import com.company.assembleegameclient.util.FameUtil;
   import com.company.util.BitmapUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.text.model.TextKey;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class CreateNewCharacterRect extends CharacterRect
   {
      
      private var bitmap_:Bitmap;
      
      public function CreateNewCharacterRect(param1:PlayerModel)
      {
         var _loc2_:int = 0;
         super();
         super.className = new LineBuilder().setParams(TextKey.CREATE_NEW_CHARACTER_RECT_NEW_CHARACTER);
         super.color = 5526612;
         super.overColor = 7829367;
         super.init();
         this.makeBitmap();
         if(param1.getNumStars() != FameUtil.maxStars())
         {
            _loc2_ = FameUtil.maxStars() - param1.getNumStars();
            super.makeTaglineIcon();
            super.makeTaglineText(new LineBuilder().setParams(TextKey.CREATE_NEW_CHARACTER_RECT_TAGLINE,{"remainingStars":_loc2_}));
            taglineText.x += taglineIcon.width;
         }
      }
      
      public function makeBitmap() : void
      {
         var _loc1_:XML = ObjectLibrary.playerChars_[int(ObjectLibrary.playerChars_.length * Math.random())];
         var _loc2_:BitmapData = SavedCharacter.getImage(null,_loc1_,AnimatedChar.RIGHT,AnimatedChar.STAND,0,false,false);
         _loc2_ = BitmapUtil.cropToBitmapData(_loc2_,6,6,_loc2_.width - 12,_loc2_.height - 6);
         this.bitmap_ = new Bitmap();
         this.bitmap_.bitmapData = _loc2_;
         this.bitmap_.x = CharacterRectConstants.ICON_POS_X;
         this.bitmap_.y = CharacterRectConstants.ICON_POS_Y;
         selectContainer.addChild(this.bitmap_);
      }
   }
}

