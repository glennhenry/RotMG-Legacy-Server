package kabam.rotmg.legends.model
{
   public class LegendsModel
   {
      
      private var timespan:Timespan = Timespan.WEEK;
      
      private const map:Object = {};
      
      public function LegendsModel()
      {
         super();
      }
      
      public function getTimespan() : Timespan
      {
         return this.timespan;
      }
      
      public function setTimespan(param1:Timespan) : void
      {
         this.timespan = param1;
      }
      
      public function hasLegendList() : Boolean
      {
         return this.map[this.timespan.getId()] != null;
      }
      
      public function getLegendList() : Vector.<Legend>
      {
         return this.map[this.timespan.getId()];
      }
      
      public function setLegendList(param1:Vector.<Legend>) : void
      {
         this.map[this.timespan.getId()] = param1;
      }
      
      public function clear() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in this.map)
         {
            this.dispose(this.map[_loc1_]);
            delete this.map[_loc1_];
         }
      }
      
      private function dispose(param1:Vector.<Legend>) : void
      {
         var _loc2_:Legend = null;
         for each(_loc2_ in param1)
         {
            _loc2_.character && this.removeLegendCharacter(_loc2_);
         }
      }
      
      private function removeLegendCharacter(param1:Legend) : void
      {
         param1.character.dispose();
         param1.character = null;
      }
   }
}

