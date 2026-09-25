package com.company.assembleegameclient.appengine
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.dialogs.TOSPopup;
   import flash.events.Event;
   import kabam.rotmg.account.core.*;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.promotions.model.BeginnersPackageModel;
   import kabam.rotmg.servers.api.LatLong;
   import org.swiftsuspenders.Injector;
   
   public class SavedCharactersList extends Event
   {
      
      public static const SAVED_CHARS_LIST:String = "SAVED_CHARS_LIST";
      
      public static const AVAILABLE:String = "available";
      
      public static const UNAVAILABLE:String = "unavailable";
      
      public static const UNRESTRICTED:String = "unrestricted";
      
      private static const DEFAULT_LATLONG:LatLong = new LatLong(37.4436,-122.412);
      
      private static const DEFAULT_SALESFORCE:String = "unavailable";
      
      private var origData_:String;
      
      private var charsXML_:XML;
      
      public var accountId_:String;
      
      public var nextCharId_:int;
      
      public var maxNumChars_:int;
      
      public var numChars_:int = 0;
      
      public var savedChars_:Vector.<SavedCharacter>;
      
      public var charStats_:Object;
      
      public var totalFame_:int = 0;
      
      public var fame_:int = 0;
      
      public var credits_:int = 0;
      
      public var tokens_:int = 0;
      
      public var numStars_:int = 0;
      
      public var nextCharSlotPrice_:int;
      
      public var guildName_:String;
      
      public var guildRank_:int;
      
      public var name_:String = null;
      
      public var nameChosen_:Boolean;
      
      public var converted_:Boolean;
      
      public var isAdmin_:Boolean;
      
      public var news_:Vector.<SavedNewsItem>;
      
      public var myPos_:LatLong;
      
      public var salesForceData_:String = "unavailable";
      
      public var hasPlayerDied:Boolean = false;
      
      public var classAvailability:Object;
      
      public var isAgeVerified:Boolean;
      
      private var account:Account;
      
      public function SavedCharactersList(param1:String)
      {
         var _loc4_:* = undefined;
         var _loc5_:Account = null;
         this.savedChars_ = new Vector.<SavedCharacter>();
         this.charStats_ = {};
         this.news_ = new Vector.<SavedNewsItem>();
         super(SAVED_CHARS_LIST);
         this.origData_ = param1;
         this.charsXML_ = new XML(this.origData_);
         var _loc2_:XML = XML(this.charsXML_.Account);
         this.parseUserData(_loc2_);
         this.parseBeginnersPackageData(_loc2_);
         this.parseGuildData(_loc2_);
         this.parseCharacterData();
         this.parseCharacterStatsData();
         this.parseNewsData();
         this.parseGeoPositioningData();
         this.parseSalesForceData();
         this.parseTOSPopup();
         this.reportUnlocked();
         var _loc3_:Injector = StaticInjectorContext.getInjector();
         if(_loc3_)
         {
            _loc5_ = _loc3_.getInstance(Account);
            _loc5_.reportIntStat("BestLevel",this.bestOverallLevel());
            _loc5_.reportIntStat("BestFame",this.bestOverallFame());
            _loc5_.reportIntStat("NumStars",this.numStars_);
            _loc5_.verify(_loc2_.hasOwnProperty("VerifiedEmail"));
         }
         this.classAvailability = new Object();
         for each(_loc4_ in this.charsXML_.ClassAvailabilityList.ClassAvailability)
         {
            this.classAvailability[_loc4_.@id.toString()] = _loc4_.toString();
         }
      }
      
      public function getCharById(param1:int) : SavedCharacter
      {
         var _loc2_:SavedCharacter = null;
         for each(_loc2_ in this.savedChars_)
         {
            if(_loc2_.charId() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function parseUserData(param1:XML) : void
      {
         this.accountId_ = param1.AccountId;
         this.name_ = param1.Name;
         this.nameChosen_ = param1.hasOwnProperty("NameChosen");
         this.converted_ = param1.hasOwnProperty("Converted");
         this.isAdmin_ = param1.hasOwnProperty("Admin");
         Player.isAdmin = this.isAdmin_;
         this.totalFame_ = int(param1.Stats.TotalFame);
         this.fame_ = int(param1.Stats.Fame);
         this.credits_ = int(param1.Credits);
         this.tokens_ = int(param1.FortuneToken);
         this.nextCharSlotPrice_ = int(param1.NextCharSlotPrice);
         this.isAgeVerified = this.accountId_ != "" && param1.IsAgeVerified == 1;
         this.hasPlayerDied = true;
      }
      
      private function parseBeginnersPackageData(param1:XML) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:BeginnersPackageModel = null;
         if(param1.hasOwnProperty("BeginnerPackageTimeLeft"))
         {
            _loc2_ = Number(param1.BeginnerPackageTimeLeft);
            _loc3_ = this.getBeginnerModel();
            _loc3_.setBeginnersOfferSecondsLeft(_loc2_);
         }
      }
      
      private function getBeginnerModel() : BeginnersPackageModel
      {
         var _loc1_:Injector = StaticInjectorContext.getInjector();
         return _loc1_.getInstance(BeginnersPackageModel);
      }
      
      private function parseGuildData(param1:XML) : void
      {
         var _loc2_:XML = null;
         if(param1.hasOwnProperty("Guild"))
         {
            _loc2_ = XML(param1.Guild);
            this.guildName_ = _loc2_.Name;
            this.guildRank_ = int(_loc2_.Rank);
         }
      }
      
      private function parseCharacterData() : void
      {
         var _loc1_:XML = null;
         this.nextCharId_ = int(this.charsXML_.@nextCharId);
         this.maxNumChars_ = int(this.charsXML_.@maxNumChars);
         for each(_loc1_ in this.charsXML_.Char)
         {
            this.savedChars_.push(new SavedCharacter(_loc1_,this.name_));
            ++this.numChars_;
         }
         this.savedChars_.sort(SavedCharacter.compare);
      }
      
      private function parseCharacterStatsData() : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:CharacterStats = null;
         var _loc1_:XML = XML(this.charsXML_.Account.Stats);
         for each(_loc2_ in _loc1_.ClassStats)
         {
            _loc3_ = int(_loc2_.@objectType);
            _loc4_ = new CharacterStats(_loc2_);
            this.numStars_ += _loc4_.numStars();
            this.charStats_[_loc3_] = _loc4_;
         }
      }
      
      private function parseNewsData() : void
      {
         var _loc2_:XML = null;
         var _loc1_:XML = XML(this.charsXML_.News);
         for each(_loc2_ in _loc1_.Item)
         {
            this.news_.push(new SavedNewsItem(_loc2_.Icon,_loc2_.Title,_loc2_.TagLine,_loc2_.Link,int(_loc2_.Date)));
         }
      }
      
      private function parseGeoPositioningData() : void
      {
         if(this.charsXML_.hasOwnProperty("Lat") && this.charsXML_.hasOwnProperty("Long"))
         {
            this.myPos_ = new LatLong(Number(this.charsXML_.Lat),Number(this.charsXML_.Long));
         }
         else
         {
            this.myPos_ = DEFAULT_LATLONG;
         }
      }
      
      private function parseSalesForceData() : void
      {
         if(this.charsXML_.hasOwnProperty("SalesForce") && this.charsXML_.hasOwnProperty("SalesForce"))
         {
            this.salesForceData_ = String(this.charsXML_.SalesForce);
         }
      }
      
      private function parseTOSPopup() : void
      {
         if(this.charsXML_.hasOwnProperty("TOSPopup"))
         {
            StaticInjectorContext.getInjector().getInstance(OpenDialogSignal).dispatch(new TOSPopup());
         }
      }
      
      public function bestLevel(param1:int) : int
      {
         var _loc2_:CharacterStats = this.charStats_[param1];
         return _loc2_ == null ? 0 : _loc2_.bestLevel();
      }
      
      public function bestOverallLevel() : int
      {
         var _loc2_:CharacterStats = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.charStats_)
         {
            if(_loc2_.bestLevel() > _loc1_)
            {
               _loc1_ = _loc2_.bestLevel();
            }
         }
         return _loc1_;
      }
      
      public function bestFame(param1:int) : int
      {
         var _loc2_:CharacterStats = this.charStats_[param1];
         return _loc2_ == null ? 0 : _loc2_.bestFame();
      }
      
      public function bestOverallFame() : int
      {
         var _loc2_:CharacterStats = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.charStats_)
         {
            if(_loc2_.bestFame() > _loc1_)
            {
               _loc1_ = _loc2_.bestFame();
            }
         }
         return _loc1_;
      }
      
      public function levelRequirementsMet(param1:int) : Boolean
      {
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         var _loc2_:XML = ObjectLibrary.xmlLibrary_[param1];
         for each(_loc3_ in _loc2_.UnlockLevel)
         {
            _loc4_ = int(ObjectLibrary.idToType_[_loc3_.toString()]);
            if(this.bestLevel(_loc4_) < int(_loc3_.@level))
            {
               return false;
            }
         }
         return true;
      }
      
      public function availableCharSlots() : int
      {
         return this.maxNumChars_ - this.numChars_;
      }
      
      public function hasAvailableCharSlot() : Boolean
      {
         return this.numChars_ < this.maxNumChars_;
      }
      
      public function newUnlocks(param1:int, param2:int) : Array
      {
         var _loc5_:XML = null;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:XML = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < ObjectLibrary.playerChars_.length)
         {
            _loc5_ = ObjectLibrary.playerChars_[_loc4_];
            _loc6_ = int(_loc5_.@type);
            if(!this.levelRequirementsMet(_loc6_))
            {
               _loc7_ = true;
               _loc8_ = false;
               for each(_loc9_ in _loc5_.UnlockLevel)
               {
                  _loc10_ = int(ObjectLibrary.idToType_[_loc9_.toString()]);
                  _loc11_ = int(_loc9_.@level);
                  if(this.bestLevel(_loc10_) < _loc11_)
                  {
                     if(_loc10_ != param1 || _loc11_ != param2)
                     {
                        _loc7_ = false;
                        break;
                     }
                     _loc8_ = true;
                  }
               }
               if(_loc7_ && _loc8_)
               {
                  _loc3_.push(_loc6_);
               }
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      override public function clone() : Event
      {
         return new SavedCharactersList(this.origData_);
      }
      
      override public function toString() : String
      {
         return "[" + " numChars: " + this.numChars_ + " maxNumChars: " + this.maxNumChars_ + " ]";
      }
      
      private function reportUnlocked() : void
      {
         var _loc1_:Injector = StaticInjectorContext.getInjector();
         if(_loc1_)
         {
            this.account = _loc1_.getInstance(Account);
            this.account && this.updateAccount();
         }
      }
      
      private function updateAccount() : void
      {
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < ObjectLibrary.playerChars_.length)
         {
            _loc3_ = ObjectLibrary.playerChars_[_loc2_];
            _loc4_ = int(_loc3_.@type);
            if(this.levelRequirementsMet(_loc4_))
            {
               this.account.reportIntStat(_loc3_.@id + "Unlocked",1);
               _loc1_++;
            }
            _loc2_++;
         }
         this.account.reportIntStat("ClassesUnlocked",_loc1_);
      }
   }
}

