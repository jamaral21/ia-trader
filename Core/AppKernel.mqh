#pragma once

#include "Logger.mqh"
#include "StateStore.mqh"
#include "..\SignalEA_v1.inputs.mqh"
#include "..\Market\BarClock.mqh"
#include "..\Indicators\IndicatorHub.mqh"
#include "..\Signal\SignalEngine.mqh"
#include "..\Trading\PositionService.mqh"
#include "..\Trading\TradeExecutor.mqh"
#include "..\Risk\RiskPolicy.mqh"
#include "..\Management\TrailingService.mqh"

class AppKernel
{
private:
   Logger m_logger;
   StateStore m_state;
   BarClock m_barClock;
   IndicatorHub m_indicatorHub;
   SignalEngine m_signalEngine;
   PositionService m_positionService;
   TradeExecutor m_tradeExecutor;
   RiskPolicy m_riskPolicy;
   TrailingService m_trailingService;

public:
   bool Initialize(void);
   void ProcessTick(void);
   void Shutdown(const int reason);

private:
   void ManagePosition(void);
   bool ProcessNewH1Bar(const datetime barTime);
};

bool AppKernel::Initialize(void)
{
   m_logger.SetLevel(InpLogLevel);
   m_state.SetEAState(EA_STATE_BOOT);

   bool indicatorReady = m_indicatorHub.Initialize(_Symbol, InpSignalTf, InpDonchianPeriod);
   if(!indicatorReady)
   {
      m_state.SetEAState(EA_STATE_DEGRADED);
      return false;
   }

   m_state.SetEAState(EA_STATE_RUNNING);
   return true;
}

void AppKernel::ProcessTick(void)
{
   if(m_state.GetEAState() != EA_STATE_RUNNING)
      return;

   ManagePosition();

   datetime barTime = 0;
   if(!m_barClock.IsNewBar(_Symbol, InpSignalTf, barTime))
      return;

   ProcessNewH1Bar(barTime);
}

void AppKernel::ManagePosition(void)
{
   // Architecture placeholder: position management runs on every tick.
   // Real trailing/exit logic will be implemented in a later phase.
}

bool AppKernel::ProcessNewH1Bar(const datetime barTime)
{
   SIndicatorSnapshot ind;

   if(!m_indicatorHub.BuildSnapshot(ind))
   {
      ind.isValid = false;
      m_logger.Error("[SNAPSHOT] Failed to build indicator snapshot.");
      return false;
   }

   string snapshotTime = TimeToString(ind.barTime, TIME_DATE | TIME_MINUTES);
   if(ind.barTime != barTime && barTime > 0)
      snapshotTime = TimeToString(barTime, TIME_DATE | TIME_MINUTES);

   Print("[SNAPSHOT]");
   Print("Time: ", snapshotTime);
   Print("EMA50: ", DoubleToString(ind.emaFast, 6));
   Print("EMA200: ", DoubleToString(ind.emaSlow, 6));
   Print("ATR: ", DoubleToString(ind.atr, 6));
   Print("DonchianHigh: ", DoubleToString(ind.donchianHigh, 6));
   Print("DonchianLow: ", DoubleToString(ind.donchianLow, 6));
   Print("Valid: ", ind.isValid ? "true" : "false");

   return ind.isValid;
}

void AppKernel::Shutdown(const int reason)
{
   m_state.SetEAState(EA_STATE_STOPPING);
   m_indicatorHub.Release();
   m_state.SetEAState(EA_STATE_STOPPED);
}
