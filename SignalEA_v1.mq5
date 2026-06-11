#property strict
#property version   "0.1"
#property description "SignalEA_v1 architecture skeleton"

#include "SignalEA_v1.constants.mqh"
#include "SignalEA_v1.inputs.mqh"
#include "SignalEA_v1.types.mqh"
#include "SignalEA_v1.globals.mqh"
#include "Core/AppKernel.mqh"

bool g_isInitialized = false;
bool g_isTradingEnabled = false;
datetime g_lastProcessedH1BarTime = 0;
datetime g_lastTickTime = 0;
int g_lastErrorCode = 0;
uint g_lastTradeRetcode = 0;
ENUM_SIGNAL_TYPE g_lastSignal = SIGNAL_NONE;

AppKernel *g_kernel = NULL;

int OnInit(void)
{
   g_kernel = new AppKernel();
   if(g_kernel == NULL)
      return INIT_FAILED;

   g_isInitialized = g_kernel.Initialize();
   if(!g_isInitialized)
      return INIT_FAILED;

   return INIT_SUCCEEDED;
}

void OnTick(void)
{
   if(g_kernel == NULL)
      return;

   g_lastTickTime = TimeCurrent();
   g_kernel.ProcessTick();
}

void OnDeinit(const int reason)
{
   if(g_kernel != NULL)
   {
      g_kernel.Shutdown(reason);
      delete g_kernel;
      g_kernel = NULL;
   }

   g_isInitialized = false;
}
