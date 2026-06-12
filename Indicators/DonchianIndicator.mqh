#pragma once

class DonchianIndicator
{
public:
   bool GetHighestHighClosed(const string symbol, const ENUM_TIMEFRAMES tf, const int period, double &outValue) const;
   bool GetLowestLowClosed(const string symbol, const ENUM_TIMEFRAMES tf, const int period, double &outValue) const;
};

bool DonchianIndicator::GetHighestHighClosed(const string symbol, const ENUM_TIMEFRAMES tf, const int period, double &outValue) const
{
   outValue = 0.0;
   if(period <= 0)
   {
      Print("[ERROR] Donchian highest invalid period: ", period);
      return false;
   }

   double highs[];
   ArraySetAsSeries(highs, true);

   // Start at shift=1 to use only closed candles.
   int copied = CopyHigh(symbol, tf, 1, period, highs);
   if(copied != period)
   {
      Print("[ERROR] CopyHigh failed for Donchian. requested=", period, " copied=", copied, " symbol=", symbol);
      return false;
   }

   int idx = ArrayMaximum(highs, 0, period);
   if(idx < 0)
   {
      Print("[ERROR] ArrayMaximum failed for Donchian high.");
      return false;
   }

   outValue = highs[idx];
   return true;
}

bool DonchianIndicator::GetLowestLowClosed(const string symbol, const ENUM_TIMEFRAMES tf, const int period, double &outValue) const
{
   outValue = 0.0;
   if(period <= 0)
   {
      Print("[ERROR] Donchian lowest invalid period: ", period);
      return false;
   }

   double lows[];
   ArraySetAsSeries(lows, true);

   // Start at shift=1 to use only closed candles.
   int copied = CopyLow(symbol, tf, 1, period, lows);
   if(copied != period)
   {
      Print("[ERROR] CopyLow failed for Donchian. requested=", period, " copied=", copied, " symbol=", symbol);
      return false;
   }

   int idx = ArrayMinimum(lows, 0, period);
   if(idx < 0)
   {
      Print("[ERROR] ArrayMinimum failed for Donchian low.");
      return false;
   }

   outValue = lows[idx];
   return true;
}
