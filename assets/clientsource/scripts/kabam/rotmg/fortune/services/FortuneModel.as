package kabam.rotmg.fortune.services
{
   import kabam.rotmg.fortune.model.FortuneInfo;
   import org.osflash.signals.Signal;
   
   public class FortuneModel
   {
      
      public static var HAS_FORTUNES:Boolean = false;
      
      private var fortune:FortuneInfo;
      
      private var initialized:Boolean = false;
      
      private var _isNew:Boolean = false;
      
      public var initializedSignal:Signal = new Signal();
      
      public function FortuneModel()
      {
         super();
      }
      
      public function getFortune() : FortuneInfo
      {
         return this.fortune;
      }
      
      public function setFortune(param1:FortuneInfo) : void
      {
         this.fortune = param1;
         this.initialized = true;
         HAS_FORTUNES = true;
         this.initializedSignal.dispatch();
      }
      
      public function isInitialized() : Boolean
      {
         return this.initialized;
      }
      
      public function setInitialized(param1:Boolean) : void
      {
         this.initialized = param1;
      }
      
      public function get isNew() : Boolean
      {
         return this._isNew;
      }
      
      public function set isNew(param1:Boolean) : void
      {
         this._isNew = param1;
      }
   }
}

