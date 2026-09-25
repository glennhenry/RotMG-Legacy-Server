package robotlegs.bender.extensions.eventCommandMap.impl
{
   import flash.events.IEventDispatcher;
   import flash.utils.describeType;
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
   import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
   import robotlegs.bender.extensions.commandCenter.impl.CommandMappingList;
   
   public class EventCommandTrigger implements ICommandTrigger
   {
      
      private const _mappings:Vector.<ICommandMapping> = new Vector.<ICommandMapping>();
      
      private const _mappingList:CommandMappingList = new CommandMappingList();
      
      private var _dispatcher:IEventDispatcher;
      
      private var _type:String;
      
      private var _executor:EventCommandExecutor;
      
      public function EventCommandTrigger(param1:Injector, param2:IEventDispatcher, param3:String, param4:Class = null)
      {
         super();
         this._dispatcher = param2;
         this._type = param3;
         this._executor = new EventCommandExecutor(this,this._mappingList,param1,param4);
      }
      
      public function addMapping(param1:ICommandMapping) : void
      {
         this.verifyCommandClass(param1);
         if(this._mappingList.tail)
         {
            this._mappingList.tail.next = param1;
         }
         else
         {
            this._mappingList.head = param1;
            this.addListener();
         }
      }
      
      public function removeMapping(param1:ICommandMapping) : void
      {
         this._mappingList.remove(param1);
         if(!this._mappingList.head)
         {
            this.removeListener();
         }
      }
      
      private function verifyCommandClass(param1:ICommandMapping) : void
      {
         var mapping:ICommandMapping = param1;
         if(describeType(mapping.commandClass).factory.method.(@name == "execute").length() == 0)
         {
            throw new Error("Command Class must expose an execute method");
         }
      }
      
      private function addListener() : void
      {
         this._dispatcher.addEventListener(this._type,this._executor.execute);
      }
      
      private function removeListener() : void
      {
         this._dispatcher.removeEventListener(this._type,this._executor.execute);
      }
   }
}

