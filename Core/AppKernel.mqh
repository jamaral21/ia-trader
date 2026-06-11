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

   bool indicatorReady = m_indicatorHub.Initialize(_Symbol, InpSignalTf);
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
   SPositionSnapshot pos;

   if(!m_indicatorHub.Refresh())
      return false;

   if(!m_indicatorHub.GetSnapshot(ind))
      return false;

   if(!m_positionService.GetCurrent(_Symbol, InpMagicNumber, pos))
      return false;

   SSignalDecision decision = m_signalEngine.Evaluate(ind, pos);
   if(!m_riskPolicy.CanOpen(decision, pos))
      return true;

   STradeRequestPlan plan;
   plan.action = TRADE_ACTION_NONE;
   plan.volume = 0.0;
   plan.sl = 0.0;
   plan.tp = 0.0;
   plan.comment = "ARCH_PLACEHOLDER";

   return m_tradeExecutor.ExecutePlan(plan);
}

void AppKernel::Shutdown(const int reason)
{
   m_state.SetEAState(EA_STATE_STOPPING);
   m_indicatorHub.Release();
   m_state.SetEAState(EA_STATE_STOPPED);
}
