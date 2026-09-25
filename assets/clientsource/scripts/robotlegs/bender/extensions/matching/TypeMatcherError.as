package robotlegs.bender.extensions.matching
{
   public class TypeMatcherError extends Error
   {
      
      public static const EMPTY_MATCHER:String = "An empty matcher will create a filter which matches nothing. You should specify at least one condition for the filter.";
      
      public function TypeMatcherError(param1:String)
      {
         super(param1);
      }
   }
}

