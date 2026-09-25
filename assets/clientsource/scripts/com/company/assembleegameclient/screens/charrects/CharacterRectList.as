package com.company.assembleegameclient.screens.charrects
{
   import com.company.assembleegameclient.appengine.CharacterStats;
   import com.company.assembleegameclient.appengine.SavedCharacter;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import kabam.rotmg.assets.services.CharacterFactory;
   import kabam.rotmg.classes.model.CharacterClass;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.classes.model.ClassesModel;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.core.model.PlayerModel;
   import org.osflash.signals.Signal;
   import org.swiftsuspenders.Injector;
   
   public class CharacterRectList extends Sprite
   {
      
      private var classes:ClassesModel;
      
      private var model:PlayerModel;
      
      private var assetFactory:CharacterFactory;
      
      public var newCharacter:Signal;
      
      public var buyCharacterSlot:Signal;
      
      public function CharacterRectList()
      {
         var _loc5_:SavedCharacter = null;
         var _loc6_:BuyCharacterRect = null;
         var _loc7_:CharacterClass = null;
         var _loc8_:CharacterStats = null;
         var _loc9_:CurrentCharacterRect = null;
         var _loc10_:int = 0;
         var _loc11_:CreateNewCharacterRect = null;
         super();
         var _loc1_:Injector = StaticInjectorContext.getInjector();
         this.classes = _loc1_.getInstance(ClassesModel);
         this.model = _loc1_.getInstance(PlayerModel);
         this.assetFactory = _loc1_.getInstance(CharacterFactory);
         this.newCharacter = new Signal();
         this.buyCharacterSlot = new Signal();
         var _loc2_:String = this.model.getName();
         var _loc3_:int = 4;
         var _loc4_:Vector.<SavedCharacter> = this.model.getSavedCharacters();
         for each(_loc5_ in _loc4_)
         {
            _loc7_ = this.classes.getCharacterClass(_loc5_.objectType());
            _loc8_ = this.model.getCharStats()[_loc5_.objectType()];
            _loc9_ = new CurrentCharacterRect(_loc2_,_loc7_,_loc5_,_loc8_);
            _loc9_.setIcon(this.getIcon(_loc5_));
            _loc9_.y = _loc3_;
            addChild(_loc9_);
            _loc3_ += CharacterRect.HEIGHT + 4;
         }
         if(this.model.hasAvailableCharSlot())
         {
            _loc10_ = 0;
            while(_loc10_ < this.model.getAvailableCharSlots())
            {
               _loc11_ = new CreateNewCharacterRect(this.model);
               _loc11_.addEventListener(MouseEvent.MOUSE_DOWN,this.onNewChar);
               _loc11_.y = _loc3_;
               addChild(_loc11_);
               _loc3_ += CharacterRect.HEIGHT + 4;
               _loc10_++;
            }
         }
         _loc6_ = new BuyCharacterRect(this.model);
         _loc6_.addEventListener(MouseEvent.MOUSE_DOWN,this.onBuyCharSlot);
         _loc6_.y = _loc3_;
         addChild(_loc6_);
      }
      
      private function getIcon(param1:SavedCharacter) : DisplayObject
      {
         var _loc2_:CharacterClass = this.classes.getCharacterClass(param1.objectType());
         var _loc3_:CharacterSkin = _loc2_.skins.getSkin(param1.skinType()) || _loc2_.skins.getDefaultSkin();
         var _loc4_:BitmapData = this.assetFactory.makeIcon(_loc3_.template,100,param1.tex1(),param1.tex2());
         return new Bitmap(_loc4_);
      }
      
      private function onNewChar(param1:Event) : void
      {
         this.newCharacter.dispatch();
      }
      
      private function onBuyCharSlot(param1:Event) : void
      {
         this.buyCharacterSlot.dispatch(this.model.getNextCharSlotPrice());
      }
   }
}

