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

## Flujo OnInit
1. Crear kernel y logger.
2. Validar contexto operativo.
3. Inicializar IndicatorHub y estado RUNNING.
4. Exponer estado inicial global.

## Flujo OnTick
1. Guard clause de estado.
2. Detectar nueva vela H1 con BarClock.
3. Si no hay nueva vela, salir.
4. Actualizar snapshot de indicadores.
5. Leer posicion actual.
6. Evaluar senal y politicas de riesgo.
7. Construir plan de trade y delegar a TradeExecutor.
8. Registrar resultado en estado global.

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

## Dependencias (texto)
SignalEA_v1.mq5
-> AppKernel
-> StateStore
-> Logger

AppKernel
-> BarClock
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
