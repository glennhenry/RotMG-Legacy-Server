package kabam.rotmg.core.commands
{
   import kabam.rotmg.chat.control.SpamFilter;
   import robotlegs.bender.bundles.mvcs.Command;
   
   public class ConfigureSpamFilterCommand extends Command
   {
      
      [Inject]
      public var data:XML;
      
      [Inject]
      public var spamFilter:SpamFilter;
      
      public function ConfigureSpamFilterCommand()
      {
         super();
      }
      
      override public function execute() : void
      {
         this.spamFilter.setPatterns(this.data.FilterList.split(/\n/g));
      }
   }
}

