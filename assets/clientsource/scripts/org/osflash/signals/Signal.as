package org.osflash.signals
{
   public class Signal extends OnceSignal implements ISignal
   {
      
      public function Signal(... rest)
      {
         rest = rest.length == 1 && rest[0] is Array ? rest[0] : rest;
         super(rest);
      }
      
      public function add(param1:Function) : ISlot
      {
         return registerListener(param1);
      }
   }
}

