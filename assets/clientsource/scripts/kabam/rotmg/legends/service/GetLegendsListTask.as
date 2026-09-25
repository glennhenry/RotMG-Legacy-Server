package kabam.rotmg.legends.service
{
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.legends.model.Legend;
   import kabam.rotmg.legends.model.LegendFactory;
   import kabam.rotmg.legends.model.LegendsModel;
   import kabam.rotmg.legends.model.Timespan;
   
   public class GetLegendsListTask extends BaseTask
   {
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var player:PlayerModel;
      
      [Inject]
      public var model:LegendsModel;
      
      [Inject]
      public var factory:LegendFactory;
      
      [Inject]
      public var timespan:Timespan;
      
      public var charId:int;
      
      public function GetLegendsListTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/fame/list",this.makeRequestObject());
      }
      
      private function onComplete(param1:Boolean, param2:*) : void
      {
         param1 && this.updateFameListData(param2);
         completeTask(param1,param2);
      }
      
      private function updateFameListData(param1:String) : void
      {
         var _loc2_:Vector.<Legend> = this.factory.makeLegends(XML(param1));
         this.model.setLegendList(_loc2_);
      }
      
      private function makeRequestObject() : Object
      {
         var _loc1_:Object = {};
         _loc1_.timespan = this.timespan.getId();
         _loc1_.accountId = this.player.getAccountId();
         _loc1_.charId = this.charId;
         return _loc1_;
      }
   }
}

