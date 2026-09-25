package kabam.rotmg.arena.service
{
   import com.company.util.ConversionUtil;
   import kabam.rotmg.arena.model.ArenaLeaderboardEntry;
   import kabam.rotmg.arena.model.CurrentArenaRunModel;
   import kabam.rotmg.assets.services.CharacterFactory;
   import kabam.rotmg.classes.model.CharacterClass;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.classes.model.ClassesModel;
   import kabam.rotmg.pets.data.PetVO;
   
   public class ArenaLeaderboardFactory
   {
      
      [Inject]
      public var classesModel:ClassesModel;
      
      [Inject]
      public var factory:CharacterFactory;
      
      [Inject]
      public var currentRunModel:CurrentArenaRunModel;
      
      public function ArenaLeaderboardFactory()
      {
         super();
      }
      
      public function makeEntries(param1:XMLList) : Vector.<ArenaLeaderboardEntry>
      {
         var _loc4_:XML = null;
         var _loc2_:Vector.<ArenaLeaderboardEntry> = new Vector.<ArenaLeaderboardEntry>();
         var _loc3_:int = 1;
         for each(_loc4_ in param1)
         {
            _loc2_.push(this.makeArenaEntry(_loc4_,_loc3_));
            _loc3_++;
         }
         _loc2_ = this.removeDuplicateUser(_loc2_);
         return this.addCurrentRun(_loc2_);
      }
      
      private function addCurrentRun(param1:Vector.<ArenaLeaderboardEntry>) : Vector.<ArenaLeaderboardEntry>
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:ArenaLeaderboardEntry = null;
         var _loc2_:Vector.<ArenaLeaderboardEntry> = new Vector.<ArenaLeaderboardEntry>();
         if(this.currentRunModel.hasEntry())
         {
            _loc3_ = false;
            _loc4_ = false;
            for each(_loc5_ in param1)
            {
               if(!_loc3_ && this.currentRunModel.entry.isBetterThan(_loc5_))
               {
                  this.currentRunModel.entry.rank = _loc5_.rank;
                  _loc2_.push(this.currentRunModel.entry);
                  _loc3_ = true;
               }
               if(_loc5_.isPersonalRecord)
               {
                  _loc4_ = true;
               }
               if(_loc3_)
               {
                  ++_loc5_.rank;
               }
               _loc2_.push(_loc5_);
            }
            if(_loc2_.length < 20 && !_loc3_ && !_loc4_)
            {
               this.currentRunModel.entry.rank = _loc2_.length + 1;
               _loc2_.push(this.currentRunModel.entry);
            }
         }
         return _loc2_.length > 0 ? _loc2_ : param1;
      }
      
      private function removeDuplicateUser(param1:Vector.<ArenaLeaderboardEntry>) : Vector.<ArenaLeaderboardEntry>
      {
         var _loc3_:Boolean = false;
         var _loc4_:ArenaLeaderboardEntry = null;
         var _loc5_:ArenaLeaderboardEntry = null;
         var _loc2_:int = -1;
         if(this.currentRunModel.hasEntry())
         {
            _loc3_ = false;
            _loc4_ = this.currentRunModel.entry;
            for each(_loc5_ in param1)
            {
               if(_loc5_.isPersonalRecord && _loc4_.isBetterThan(_loc5_))
               {
                  _loc2_ = _loc5_.rank - 1;
                  _loc3_ = true;
               }
               else if(_loc3_)
               {
                  --_loc5_.rank;
               }
            }
         }
         if(_loc2_ != -1)
         {
            param1.splice(_loc2_,1);
         }
         return param1;
      }
      
      private function makeArenaEntry(param1:XML, param2:int) : ArenaLeaderboardEntry
      {
         var _loc10_:PetVO = null;
         var _loc11_:XML = null;
         var _loc3_:ArenaLeaderboardEntry = new ArenaLeaderboardEntry();
         _loc3_.isPersonalRecord = param1.hasOwnProperty("IsPersonalRecord");
         _loc3_.runtime = param1.Time;
         _loc3_.name = param1.PlayData.CharacterData.Name;
         _loc3_.rank = param1.hasOwnProperty("Rank") ? int(param1.Rank) : param2;
         var _loc4_:int = int(param1.PlayData.CharacterData.Texture);
         var _loc5_:int = int(param1.PlayData.CharacterData.Class);
         var _loc6_:CharacterClass = this.classesModel.getCharacterClass(_loc5_);
         var _loc7_:CharacterSkin = _loc6_.skins.getSkin(_loc4_);
         var _loc8_:int = param1.PlayData.CharacterData.hasOwnProperty("Tex1") ? int(param1.PlayData.CharacterData.Tex1) : 0;
         var _loc9_:int = param1.PlayData.CharacterData.hasOwnProperty("Tex2") ? int(param1.PlayData.CharacterData.Tex2) : 0;
         _loc3_.playerBitmap = this.factory.makeIcon(_loc7_.template,100,_loc8_,_loc9_);
         _loc3_.equipment = ConversionUtil.toIntVector(param1.PlayData.CharacterData.Inventory);
         _loc3_.slotTypes = _loc6_.slotTypes;
         _loc3_.guildName = param1.PlayData.CharacterData.GuildName;
         _loc3_.guildRank = param1.PlayData.CharacterData.GuildRank;
         _loc3_.currentWave = param1.WaveNumber;
         if(param1.PlayData.hasOwnProperty("Pet"))
         {
            _loc10_ = new PetVO();
            _loc11_ = new XML(param1.PlayData.Pet);
            _loc10_.apply(_loc11_);
            _loc3_.pet = _loc10_;
         }
         return _loc3_;
      }
   }
}

