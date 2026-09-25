package kabam.rotmg.protip.model
{
   public class EmbeddedProTipModel implements IProTipModel
   {
      
      public static var protipsXML:Class = EmbeddedProTipModel_protipsXML;
      
      private var tips:Vector.<String>;
      
      private var indices:Vector.<int>;
      
      private var index:int;
      
      private var count:int;
      
      public function EmbeddedProTipModel()
      {
         super();
         this.index = 0;
         this.makeTipsVector();
         this.count = this.tips.length;
         this.makeRandomizedIndexVector();
      }
      
      public function getTip() : String
      {
         var _loc1_:int = this.indices[this.index++ % this.count];
         return this.tips[_loc1_];
      }
      
      private function makeTipsVector() : void
      {
         var _loc2_:XML = null;
         var _loc1_:XML = XML(new protipsXML());
         this.tips = new Vector.<String>(0);
         for each(_loc2_ in _loc1_.Protip)
         {
            this.tips.push(_loc2_.toString());
         }
         this.count = this.tips.length;
      }
      
      private function makeRandomizedIndexVector() : void
      {
         var _loc1_:Vector.<int> = new Vector.<int>(0);
         var _loc2_:* = 0;
         while(_loc2_ < this.count)
         {
            _loc1_.push(_loc2_);
            _loc2_++;
         }
         this.indices = new Vector.<int>(0);
         while(_loc2_ > 0)
         {
            this.indices.push(_loc1_.splice(Math.floor(Math.random() * _loc2_--),1)[0]);
         }
         this.indices.fixed = true;
      }
   }
}

