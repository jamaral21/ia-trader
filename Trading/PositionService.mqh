#pragma once

#include "..\SignalEA_v1.types.mqh"
#include "..\SignalEA_v1.constants.mqh"

class PositionService
{
public:
   bool GetCurrent(const string symbol, const long magic, SPositionSnapshot &outPos) const;
   bool HasOpenPosition(const string symbol, const long magic) const;
};

bool PositionService::GetCurrent(const string symbol, const long magic, SPositionSnapshot &outPos) const
{
   outPos.hasPosition = false;
   outPos.ticket = INVALID_TICKET;
   outPos.type = POSITION_TYPE_BUY;
   outPos.volume = 0.0;
   outPos.priceOpen = 0.0;
   outPos.sl = 0.0;
   outPos.tp = 0.0;
   outPos.profit = 0.0;
   return true;
}

bool PositionService::HasOpenPosition(const string symbol, const long magic) const
{
   SPositionSnapshot pos;
   if(!GetCurrent(symbol, magic, pos))
      return false;

   return pos.hasPosition;
}
