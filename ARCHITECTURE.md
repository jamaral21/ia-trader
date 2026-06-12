# SignalEA_v1 - Arquitectura Tecnica

## Objetivo
Base mantenible y extensible para implementar SignalEA_v1 por etapas, sin acoplar logica de estrategia, riesgo y ejecucion.

## Estructura de carpetas
- Core: orquestacion, estado, logging
- Market: tiempo de barras y acceso a series
- Indicators: capa de indicadores y snapshots
- Signal: evaluacion de senales y filtros
- Trading: ejecucion y servicios de posicion
- Risk: politicas e interfaces de lotaje
- Management: trailing, salidas y sesiones
- Integration: evolucion Maestro-Esclavo
- Debug: diagnostico y telemetria

## Contratos clave
- SIndicatorSnapshot: contrato unico de indicadores para motor de senales.
- SSignalDecision: intencion de negocio desacoplada de ejecucion.
- STradeRequestPlan: plan ejecutable y serializable para modo local o replicado.
- ENUM_BREAKOUT_STATE + API de StateStore: control explicito para regla "una operacion por breakout".

## Flujo OnInit
1. Crear kernel y logger.
2. Validar contexto operativo.
3. Inicializar IndicatorHub y estado RUNNING.
4. Exponer estado inicial global.

## Flujo OnTick
1. Guard clause de estado.
2. Ejecutar ManagePosition() en TODOS los ticks.
3. Detectar nueva vela H1 con BarClock.
4. Si no hay nueva vela, salir.
5. Si hay nueva vela, ejecutar ProcessNewH1Bar() una sola vez por vela cerrada.
6. Actualizar snapshot de indicadores.
7. Leer posicion actual.
8. Evaluar senal y politicas de riesgo.
9. Construir plan de trade y delegar a TradeExecutor.
10. Registrar resultado en estado global.

## Flujo OnDeinit
1. Cambiar a estado STOPPING.
2. Liberar recursos de indicadores.
3. Liberar kernel.
4. Cerrar estado en STOPPED.

## Maquina de estados
- EA_STATE_BOOT
- EA_STATE_READY
- EA_STATE_RUNNING
- EA_STATE_DEGRADED
- EA_STATE_STOPPING
- EA_STATE_STOPPED

## Estado de breakout
- BREAKOUT_READY
- BREAKOUT_LOCKED

API en StateStore:
- LockBreakout()
- UnlockBreakout()
- IsBreakoutLocked()

Nota: solo se define el estado y sus accesores. La logica de transicion se implementara en fases posteriores.

## Estrategia de nueva vela H1 (BarClock)
- BarClock mantiene estado interno persistente:
	- m_lastProcessedBarTime
	- m_lastSymbol
	- m_lastTf
- IsNewBar() solo devuelve true cuando existe una vela cerrada mas nueva que la ultima procesada en el mismo contexto simbolo/timeframe.
- En primer muestreo, reinicio de EA o cambio de simbolo/timeframe, BarClock sincroniza baseline y devuelve false para evitar disparos falsos.
- ProcessNewH1Bar() nunca debe ejecutarse mas de una vez por vela cerrada.

## Dependencias (texto)
SignalEA_v1.mq5
-> AppKernel
-> StateStore
-> Logger

AppKernel
-> BarClock
-> ManagePosition (flujo por tick)
-> IndicatorHub
-> SignalEngine
-> PositionService
-> RiskPolicy
-> TradeExecutor
-> TrailingService

Integration (futuro)
-> ReplicationService
-> MessageBus
-> MasterSlaveProtocol

## Funciones intencionalmente no implementadas en esta fase
- TradeExecutor::OpenLong
- TradeExecutor::OpenShort
- LotModel::CalculateLotSize
- TrailingService::ManageTrailing

## Correcciones arquitectonicas recientes
- Se corrigio BarClock::IsNewBar para no disparar en todos los ticks.
- Se agrego estado dedicado de breakout en StateStore.
- Se separo flujo OnTick entre gestion por tick (ManagePosition) y evaluacion por nueva vela (ProcessNewH1Bar).
