#pragma once

class BarClock
{
private:
   datetime m_lastProcessedBarTime;
   string m_lastSymbol;
   ENUM_TIMEFRAMES m_lastTf;

public:
   BarClock(void) : m_lastProcessedBarTime(0), m_lastSymbol(""), m_lastTf(PERIOD_CURRENT) {}

   bool IsNewBar(const string symbol, const ENUM_TIMEFRAMES tf, datetime &outBarTime);
   datetime GetLastClosedBarTime(const string symbol, const ENUM_TIMEFRAMES tf);
};

bool BarClock::IsNewBar(const string symbol, const ENUM_TIMEFRAMES tf, datetime &outBarTime)
{
   datetime lastClosed = GetLastClosedBarTime(symbol, tf);
   outBarTime = 0;

   if(lastClosed <= 0)
      return false;

   // Symbol/timeframe context changed: sync baseline and avoid false triggers.
   if(m_lastSymbol != symbol || m_lastTf != tf)
   {
      m_lastSymbol = symbol;
      m_lastTf = tf;
      m_lastProcessedBarTime = lastClosed;
      return false;
   }

   // First valid sample after startup: initialize baseline only.
   if(m_lastProcessedBarTime <= 0)
   {
      m_lastProcessedBarTime = lastClosed;
      return false;
   }

   if(lastClosed > m_lastProcessedBarTime)
   {
      m_lastProcessedBarTime = lastClosed;
      outBarTime = lastClosed;
      return true;
   }

   return false;
}

datetime BarClock::GetLastClosedBarTime(const string symbol, const ENUM_TIMEFRAMES tf)
{
   datetime times[];
   ArraySetAsSeries(times, true);
   int copied = CopyTime(symbol, tf, 1, 1, times);
   if(copied < 1)
      return 0;

   return times[0];
}
