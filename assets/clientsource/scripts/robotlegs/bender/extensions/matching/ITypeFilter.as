package robotlegs.bender.extensions.matching
{
   public interface ITypeFilter
   {
      
      function get allOfTypes() : Vector.<Class>;
      
      function get anyOfTypes() : Vector.<Class>;
      
      function get descriptor() : String;
      
      function get noneOfTypes() : Vector.<Class>;
      
      function matches(param1:*) : Boolean;
   }
}

