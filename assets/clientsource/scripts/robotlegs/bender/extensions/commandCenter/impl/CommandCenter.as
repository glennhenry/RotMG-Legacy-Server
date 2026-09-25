package robotlegs.bender.extensions.commandCenter.impl
{
   import flash.utils.Dictionary;
   import robotlegs.bender.extensions.commandCenter.api.ICommandCenter;
   import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
   import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
   import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;
   
   public class CommandCenter implements ICommandCenter
   {
      
      private const _mappers:Dictionary = new Dictionary();
      
      private const NULL_UNMAPPER:ICommandUnmapper = new NullCommandUnmapper();
      
      public function CommandCenter()
      {
         super();
      }
      
      public function map(param1:ICommandTrigger) : ICommandMapper
      {
         return this._mappers[param1] = this._mappers[param1] || new CommandMapper(param1);
      }
      
      public function unmap(param1:ICommandTrigger) : ICommandUnmapper
      {
         return this._mappers[param1] || this.NULL_UNMAPPER;
      }
   }
}

