package kabam.rotmg.legends.model
{
   import com.company.util.ConversionUtil;
   import kabam.rotmg.assets.services.CharacterFactory;
   import kabam.rotmg.classes.model.CharacterClass;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.classes.model.ClassesModel;
   import kabam.rotmg.core.model.PlayerModel;
   
   public class LegendFactory
   {
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var classesModel:ClassesModel;
      
      [Inject]
      public var factory:CharacterFactory;
      
      private var ownAccountId:String;
      
      private var legends:Vector.<Legend>;
      
      public function LegendFactory()
      {
         super();
      }
      
      public function makeLegends(param1:XML) : Vector.<Legend>
      {
         this.ownAccountId = this.playerModel.getAccountId();
         this.legends = new Vector.<Legend>(0);
         this.makeLegendsFromList(param1.FameListElem,false);
         this.makeLegendsFromList(param1.MyFameListElem,true);
         return this.legends;
      }
      
      private function makeLegendsFromList(param1:XMLList, param2:Boolean) : void
      {
         var _loc3_:XML = null;
         var _loc4_:Legend = null;
         for each(_loc3_ in param1)
         {
            if(!this.legendsContains(_loc3_))
            {
               _loc4_ = this.makeLegend(_loc3_);
               _loc4_.isOwnLegend = _loc3_.@accountId == this.ownAccountId;
               _loc4_.isFocus = param2;
               this.legends.push(_loc4_);
            }
         }
      }
      
      private function legendsContains(param1:XML) : Boolean
      {
         var _loc2_:Legend = null;
         for each(_loc2_ in this.legends)
         {
            if(_loc2_.accountId == param1.@accountId && _loc2_.charId == param1.@charId)
            {
               return true;
            }
         }
         return false;
      }
      
      public function makeLegend(param1:XML) : Legend
      {
         var _loc2_:int = int(param1.ObjectType);
         var _loc3_:int = int(param1.Texture);
         var _loc4_:CharacterClass = this.classesModel.getCharacterClass(_loc2_);
         var _loc5_:CharacterSkin = _loc4_.skins.getSkin(_loc3_);
         var _loc6_:int = param1.hasOwnProperty("Tex1") ? int(param1.Tex1) : 0;
         var _loc7_:int = param1.hasOwnProperty("Tex2") ? int(param1.Tex2) : 0;
         var _loc8_:Legend = new Legend();
         _loc8_.accountId = param1.@accountId;
         _loc8_.charId = param1.@charId;
         _loc8_.name = param1.Name;
         _loc8_.totalFame = param1.TotalFame;
         _loc8_.character = this.factory.makeIcon(_loc5_.template,100,_loc6_,_loc7_);
         _loc8_.equipmentSlots = _loc4_.slotTypes;
         _loc8_.equipment = ConversionUtil.toIntVector(param1.Equipment);
         return _loc8_;
      }
   }
}

